#!/usr/bin/env bash
# nutzung.sh — Bodennutzung, Gewässer, Orte und Kreiszahlen für Brandenburg
# Liest: Brandenburg-Landwirtschaft.html
# CLC5 (BKG) + OSM (Geofabrik) + two hand-kept CSVs → source.gpkg → *.geojson
# Requirements: apt install osmium-tool gdal-bin wget unzip
#
# Licences — the source note on the sheet must carry both:
#   CLC5 2018   © GeoBasis-DE / BKG 2021, dl-de/by-2-0, Daten verändert
#   OSM         © OpenStreetMap-Mitwirkende, ODbL
#   InVeKoS-Antragsdaten (Hanfschläge, hanf-anbau.csv):
#               © MLEUV, dl-de/by-2-0, Daten geändert
set -euo pipefail
cd "$(dirname "$0")"

CLC=clc5_2018.utm32s.shape.zip
# The BKG delivery is NOT one shapefile: it unpacks to clc5_2018.utm32s.shape/clc5/
# with one file per class group (clc5_class1xx … class5xx). Both the folder layout and
# the class attribute have changed between releases, so both are discovered, not assumed.
CLC_FELD="${CLC_FELD:-}"                  # override on the command line if discovery fails
PBF=brandenburg-latest.osm.pbf
# Berlin+Brandenburg plus a margin — the sheet clips to the state outline itself
BBOX="11.1 51.2 14.9 53.7"

for tool in osmium ogr2ogr wget unzip; do
  command -v "$tool" >/dev/null || { echo "missing: $tool  (apt install osmium-tool gdal-bin wget unzip)"; exit 1; }
done

# 1 · raw data (fetched only when absent; CLC5 is 1.24 GB — one download, then keep it)
[ -f "$PBF" ] || wget "https://download.geofabrik.de/europe/germany/$PBF"

clc_shps() { find . -maxdepth 5 \( -iname 'clc5*class*.shp' -o -iname 'clc5.shp' \) | sort; }
[ -n "$(clc_shps)" ] || {
  [ -f "$CLC" ] || wget "https://daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/$CLC"
  unzip -o "$CLC"
}
mapfile -t SHPS < <(clc_shps)
[ ${#SHPS[@]} -gt 0 ] || { echo "no CLC5 shapefile found below $(pwd) — check the unpacked folder"; exit 1; }
echo "CLC5: ${#SHPS[@]} Shapefile(s) — $(basename "${SHPS[0]}") …"

# Class attribute: take the first field whose name contains CLC (CLC18, CLC5_CLASS, …)
if [ -z "$CLC_FELD" ]; then
  CLC_FELD=$(ogrinfo -so -al "${SHPS[0]}" \
    | sed -n 's/^\([A-Za-z0-9_]*[Cc][Ll][Cc][A-Za-z0-9_]*\): .*/\1/p' | head -1)
fi
[ -n "$CLC_FELD" ] || {
  echo "class attribute not found. Fields present:"
  ogrinfo -so -al "${SHPS[0]}" | sed -n 's/^\([A-Za-z0-9_]*\): \(Integer\|String\|Real\).*/  \1  (\2)/p'
  echo "Re-run with:  CLC_FELD=<name> bash $(basename "$0")"; exit 1
}
echo "CLC5: Klassenattribut = $CLC_FELD"

# 2 · thematic filtering (OSM)
osmium tags-filter --overwrite "$PBF" w/waterway=river          -o fluesse.osm.pbf
osmium tags-filter --overwrite "$PBF" n/place=city,town         -o orte.osm.pbf
osmium tags-filter --overwrite "$PBF" r/boundary=administrative -o kreise.osm.pbf

# 3 · build source.gpkg (everything metric in EPSG:25832 until export)
# Kept between runs: it takes minutes and never changes unless the raw data does.
# Force a rebuild with:  NEU=1 bash nutzung.sh
if [ -n "${NEU:-}" ] || [ ! -f source.gpkg ]; then
rm -f source.gpkg
for shp in "${SHPS[@]}"; do
  [ -f source.gpkg ] && MODE="-update -append" || MODE=""
  # shellcheck disable=SC2086
  ogr2ogr -f GPKG $MODE source.gpkg "$shp" -nln clc5 -nlt MULTIPOLYGON \
          -spat $BBOX -spat_srs EPSG:4326
done
ogr2ogr -f GPKG -update source.gpkg fluesse.osm.pbf lines       -nln fluesse -nlt MULTILINESTRING
ogr2ogr -f GPKG -update source.gpkg orte.osm.pbf    points      -nln orte
ogr2ogr -f GPKG -update source.gpkg kreise.osm.pbf multipolygons -nln kreise -nlt MULTIPOLYGON \
        -where "other_tags LIKE '%\"admin_level\"=>\"6\"%'"
ogr2ogr -f GPKG -update source.gpkg hanf-anbau.csv   -nln hanf_stat
ogr2ogr -f GPKG -update source.gpkg verarbeitung.csv -nln betriebe \
        -oo X_POSSIBLE_NAMES=lon -oo Y_POSSIBLE_NAMES=lat -a_srs EPSG:4326
else
  echo "source.gpkg vorhanden — Rohaufbau übersprungen (NEU=1 erzwingt ihn)"
fi

# 4 · GeoJSON exports (EPSG:4326, 4 decimal places).
# German target file and property names (klasse, rang, …) are the data
# contract with the atlas sheets — do not rename.
# The GeoJSON driver never overwrites — clear leftovers first
rm -f landnutzung.geojson gewaesser.geojson orte.geojson hanf-kreise.geojson verarbeitung.geojson
EXPORT="-f GeoJSON -dialect SQLITE -t_srs EPSG:4326 -lco COORDINATE_PRECISION=4"

# CLC codes are hierarchical: 211, 2110, 21110 all mean the same top-three digits.
# Comparing the first three as an integer therefore survives a change of key depth,
# and it works whether the field is stored as text or as a number.
CODE="CAST(SUBSTR(TRIM($CLC_FELD),1,3) AS INTEGER)"
echo "— CLC5-Klassen in der Lieferung (die zehn häufigsten) —"
ogrinfo -q -dialect SQLITE source.gpkg -sql "
  SELECT SUBSTR(TRIM($CLC_FELD),1,3) AS code, COUNT(*) AS n
  FROM clc5 GROUP BY code ORDER BY n DESC LIMIT 10"

# Land use: CLC5 classes folded into the eight sheet classes. Order matters and is
# cartographic, not technical: pick the scale first (drop what is smaller than the
# minimum drawable area), simplify in METRES while the data is still in EPSG:25832,
# and only then dissolve per class. Simplifying after the union — the earlier
# version's -simplify 0.002 — hands the tolerance one huge multipolygon in degrees
# and produced a 155 MB file.
#   MINFLAECHE  5 km²  ≈ 2,2 mm im Blattmaßstab 1:1 000 000
#   TOLERANZ  200 m     ≈ 0,2 mm — unter der Strichbreite, also unsichtbar
MINFLAECHE=${MINFLAECHE:-5000000}
TOLERANZ=${TOLERANZ:-200}
echo "— Landnutzung: Mindestfläche ${MINFLAECHE} m², Vereinfachung ${TOLERANZ} m —"
ogr2ogr $EXPORT -nlt MULTIPOLYGON landnutzung.geojson source.gpkg -sql "
  SELECT klasse, ST_Union(geom) AS geom FROM (
    SELECT ST_SimplifyPreserveTopology(ST_Buffer(geom, 0), $TOLERANZ) AS geom,
      CASE
        WHEN $CODE IN (211,212,213,241,242,243) THEN 'acker'
        WHEN $CODE  = 231                       THEN 'gruenland'
        WHEN $CODE IN (411,412)                 THEN 'feucht'
        WHEN $CODE IN (311,312,313,324)         THEN 'wald'
        WHEN $CODE IN (221,223)                 THEN 'sonderkultur'
        WHEN $CODE  = 222                       THEN 'obstbau'
        WHEN $CODE IN (131,132,133)             THEN 'bergbaufolge'
        WHEN $CODE IN (111,112,121,122,123,124,141,142) THEN 'stadt'
        WHEN $CODE IN (511,512)                 THEN 'wasser'
      END AS klasse
    FROM clc5
    WHERE ST_Area(geom) > $MINFLAECHE)
  WHERE klasse IS NOT NULL
  GROUP BY klasse"

# Rivers: only the ones the sheet names; rang 1 = drawn heavier
ogr2ogr $EXPORT -simplify 0.002 gewaesser.geojson source.gpkg -sql "
  SELECT name,
         CASE WHEN name IN ('Elbe','Oder','Havel','Spree','Lausitzer Neiße') THEN 1 ELSE 2 END AS rang,
         ST_LineMerge(ST_Collect(geom)) AS geom
  FROM fluesse
  WHERE name IN ('Elbe','Oder','Havel','Spree','Lausitzer Neiße','Dahme','Nuthe','Schwarze Elster')
  GROUP BY name"

# Places: rang 1 Berlin · 2 Landeshauptstadt · 3 city · 4 town
ogr2ogr $EXPORT orte.geojson source.gpkg -sql "
  SELECT name,
         CASE name WHEN 'Berlin' THEN 1 WHEN 'Potsdam' THEN 2
              ELSE CASE WHEN other_tags LIKE '%\"place\"=>\"city\"%' THEN 3 ELSE 4 END END AS rang,
         CAST(hstore_get_value(other_tags,'population') AS INTEGER) AS einwohner,
         geom
  FROM orte
  WHERE name IS NOT NULL"

# Hemp: no open geometry exists. Acreage per district comes from the InVeKoS
# evaluation (hanf-anbau.csv, kreis;ha;jahr) and is joined onto the OSM district
# outline — that is the honest resolution of the number, and the sheet places its
# hemp signature inside the district polygon rather than pretending to field level.
ogr2ogr $EXPORT -simplify 0.003 -nlt MULTIPOLYGON hanf-kreise.geojson source.gpkg -sql "
  SELECT k.name AS kreis, CAST(h.ha AS REAL) AS ha, CAST(h.jahr AS INTEGER) AS jahr, k.geom AS geom
  FROM kreise k JOIN hanf_stat h ON h.kreis = k.name
  WHERE CAST(h.ha AS REAL) > 0"

# Processing sites: hand-kept, likewise no open source (verarbeitung.csv)
ogr2ogr -f GeoJSON -lco COORDINATE_PRECISION=4 verarbeitung.geojson source.gpkg -sql "
  SELECT name, art, geom FROM betriebe"

echo "— done. target: < 2 MB per file —"
ls -lh landnutzung.geojson gewaesser.geojson orte.geojson hanf-kreise.geojson verarbeitung.geojson

# A file with no features is not a result. Say which one and why, so the gap stays
# visible instead of arriving on the sheet as an empty layer.
for ziel in landnutzung gewaesser orte hanf-kreise verarbeitung; do
  n=$(grep -o '"type": *"Feature"' "$ziel.geojson" 2>/dev/null | wc -l)
  [ "$n" -gt 0 ] || echo "LEER: $ziel.geojson — 0 Objekte. Fehlt die Eingangstabelle (hanf-anbau.csv: Spalte ha; verarbeitung.csv: Zeilen)?"
done

# Which district names in hanf-anbau.csv found no OSM outline — the join is by name,
# and a single spelling difference silently drops a district.
ogrinfo -q -dialect SQLITE source.gpkg -sql "
  SELECT h.kreis AS ohne_umriss FROM hanf_stat h
  WHERE NOT EXISTS (SELECT 1 FROM kreise k WHERE k.name = h.kreis)" 2>/dev/null \
  | grep -q ohne_umriss && echo "^ diese Kreisnamen aus hanf-anbau.csv passen zu keinem OSM-Umriss" || true
