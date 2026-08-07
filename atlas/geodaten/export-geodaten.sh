#!/usr/bin/env bash
# Sternprodukt atlas · Romania geodata pipeline
# OSM (Geofabrik) + Natural Earth → source.gpkg → bahn/strassen/gewaesser.geojson
# Requirements: apt install osmium-tool gdal-bin wget unzip
set -euo pipefail
cd "$(dirname "$0")"

PBF=romania-latest.osm.pbf
NE=ne_10m_rivers_lake_centerlines

for tool in osmium ogr2ogr wget unzip; do
  command -v "$tool" >/dev/null || { echo "missing: $tool  (apt install osmium-tool gdal-bin wget unzip)"; exit 1; }
done

# 1 · raw data (fetched only when absent)
[ -f "$PBF" ] || wget "https://download.geofabrik.de/europe/$PBF"
[ -f "$NE.shp" ] || { wget "https://naciscdn.org/naturalearth/10m/physical/$NE.zip"; unzip -o "$NE.zip"; }

# 2 · thematic filtering
osmium tags-filter --overwrite "$PBF" w/railway=rail            -o rail.osm.pbf
osmium tags-filter --overwrite "$PBF" w/highway=motorway,trunk  -o roads.osm.pbf

# 3 · build source.gpkg
rm -f source.gpkg
ogr2ogr -f GPKG          source.gpkg rail.osm.pbf  lines -nln rail  -nlt MULTILINESTRING
ogr2ogr -f GPKG -update  source.gpkg roads.osm.pbf lines -nln roads -nlt MULTILINESTRING \
        -where "highway IN ('motorway','trunk')"
ogr2ogr -f GPKG -update  source.gpkg "$PBF"        lines -nln roads_construction -nlt MULTILINESTRING \
        -where "highway = 'construction' AND other_tags LIKE '%\"construction\"=>\"motorway\"%'"
ogr2ogr -f GPKG -update  source.gpkg "$NE.shp"           -nln rivers -nlt MULTILINESTRING \
        -clipsrc 19.5 42.7 31.2 49.3

# 4 · GeoJSON exports (EPSG:4326, simplified 0.004° ≈ 400 m, 4 decimal places).
# German target file and property names (rang, klasse, …) are the data
# contract with the atlas sheets — do not rename.
# The GeoJSON driver never overwrites — clear leftovers first
rm -f bahn.geojson strassen.geojson strassen-bau.geojson gewaesser.geojson
EXPORT="-f GeoJSON -dialect SQLITE -simplify 0.004 -lco COORDINATE_PRECISION=4"

ogr2ogr $EXPORT bahn.geojson source.gpkg -sql "
  SELECT name,
         CASE WHEN other_tags LIKE '%\"usage\"=>\"main\"%' THEN 1 ELSE 2 END AS rang,
         CASE WHEN other_tags LIKE '%\"electrified\"=>\"contact_line\"%' THEN 1 ELSE 0 END AS elektr,
         geom
  FROM rail
  WHERE other_tags LIKE '%\"usage\"=>\"main\"%' OR other_tags LIKE '%\"usage\"=>\"branch\"%'"

ogr2ogr $EXPORT strassen.geojson source.gpkg -sql "
  SELECT highway AS klasse, hstore_get_value(other_tags,'ref') AS ref, geom
  FROM roads"

ogr2ogr $EXPORT strassen-bau.geojson source.gpkg -sql "
  SELECT hstore_get_value(other_tags,'ref') AS ref, 'bau' AS status, geom
  FROM roads_construction"

ogr2ogr -f GeoJSON -lco COORDINATE_PRECISION=4 gewaesser.geojson source.gpkg \
        -sql "SELECT name, scalerank AS rang, geom FROM rivers"

echo "— done. target: < 2 MB per file —"
ls -lh bahn.geojson strassen.geojson strassen-bau.geojson gewaesser.geojson
