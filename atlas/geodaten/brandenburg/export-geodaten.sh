#!/usr/bin/env bash
# Sternprodukt atlas · Brandenburg geodata pipeline (sheet 7 — agricultural use)
# CLC5 (BKG) + OSM (Geofabrik) + two hand-kept CSVs → source.gpkg → *.geojson
# Requirements: apt install osmium-tool gdal-bin wget unzip
#
# Licences — the source note on the sheet must carry both:
#   CLC5 2018   © GeoBasis-DE / BKG 2021, dl-de/by-2-0, Daten verändert
#   OSM         © OpenStreetMap-Mitwirkende, ODbL
#   DFBK/InVeKoS-Zahlen in hanf-anbau.csv: © MLEUV, dl-de/by-2-0
set -euo pipefail
cd "$(dirname "$0")"

CLC=clc5_2018.utm32s.shape.zip
CLC_SHP=clc5_2018/utm32s/shape/clc5.shp   # verify with: unzip -l $CLC | grep '\.shp$'
CLC_FELD=CLC18                            # class attribute; verify with: ogrinfo -so -al $CLC_SHP
PBF=brandenburg-latest.osm.pbf
# Berlin+Brandenburg plus a margin — the sheet clips to the state outline itself
BBOX="11.1 51.2 14.9 53.7"

for tool in osmium ogr2ogr wget unzip; do
  command -v "$tool" >/dev/null || { echo "missing: $tool  (apt install osmium-tool gdal-bin wget unzip)"; exit 1; }
done

# 1 · raw data (fetched only when absent; CLC5 is 1.24 GB — one download, then keep it)
[ -f "$PBF" ] || wget "https://download.geofabrik.de/europe/germany/$PBF"
[ -f "$CLC_SHP" ] || {
  [ -f "$CLC" ] || wget "https://daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/$CLC"
  unzip -o "$CLC"
}

# 2 · thematic filtering (OSM)
osmium tags-filter --overwrite "$PBF" w/waterway=river          -o fluesse.osm.pbf
osmium tags-filter --overwrite "$PBF" n/place=city,town         -o orte.osm.pbf
osmium tags-filter --overwrite "$PBF" r/boundary=administrative -o kreise.osm.pbf

# 3 · build source.gpkg (everything metric in EPSG:25832 until export)
rm -f source.gpkg
ogr2ogr -f GPKG source.gpkg "$CLC_SHP" -nln clc5 -nlt MULTIPOLYGON \
        -spat $BBOX -spat_srs EPSG:4326
ogr2ogr -f GPKG -update source.gpkg fluesse.osm.pbf lines       -nln fluesse -nlt MULTILINESTRING
ogr2ogr -f GPKG -update source.gpkg orte.osm.pbf    points      -nln orte
ogr2ogr -f GPKG -update source.gpkg kreise.osm.pbf multipolygons -nln kreise -nlt MULTIPOLYGON \
        -where "other_tags LIKE '%\"admin_level\"=>\"6\"%'"
ogr2ogr -f GPKG -update source.gpkg hanf-anbau.csv   -nln hanf_stat
ogr2ogr -f GPKG -update source.gpkg verarbeitung.csv -nln betriebe \
        -oo X_POSSIBLE_NAMES=lon -oo Y_POSSIBLE_NAMES=lat -a_srs EPSG:4326

# 4 · GeoJSON exports (EPSG:4326, 4 decimal places).
# German target file and property names (klasse, rang, …) are the data
# contract with the atlas sheets — do not rename.
# The GeoJSON driver never overwrites — clear leftovers first
rm -f landnutzung.geojson gewaesser.geojson orte.geojson hanf-kreise.geojson verarbeitung.geojson
EXPORT="-f GeoJSON -dialect SQLITE -t_srs EPSG:4326 -lco COORDINATE_PRECISION=4"

# Land use: CLC5 classes folded into the eight sheet classes, dissolved per class,
# scraps below 5 km² dropped (sheet scale ≈ 1:1 000 000), then simplified to ~200 m.
ogr2ogr $EXPORT -simplify 0.002 -nlt MULTIPOLYGON landnutzung.geojson source.gpkg -sql "
  SELECT klasse, ST_Union(geom) AS geom FROM (
    SELECT ST_Buffer(geom, 0) AS geom,
      CASE
        WHEN $CLC_FELD IN (211,212,213,241,242,243) THEN 'acker'
        WHEN $CLC_FELD  = 231                       THEN 'gruenland'
        WHEN $CLC_FELD IN (411,412)                 THEN 'feucht'
        WHEN $CLC_FELD IN (311,312,313,324)         THEN 'wald'
        WHEN $CLC_FELD IN (221,223)                 THEN 'sonderkultur'
        WHEN $CLC_FELD  = 222                       THEN 'obstbau'
        WHEN $CLC_FELD IN (131,132,133)             THEN 'bergbaufolge'
        WHEN $CLC_FELD IN (111,112,121,122,123,124,141,142) THEN 'stadt'
        WHEN $CLC_FELD IN (511,512)                 THEN 'wasser'
      END AS klasse
    FROM clc5
    WHERE ST_Area(geom) > 5000000)
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
