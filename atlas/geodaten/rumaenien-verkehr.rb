#!/usr/bin/env ruby
# frozen_string_literal: true
#
# rumaenien-verkehr.rb — Bahn, Autobahn, Schnellstraße und Flüsse für Rumänien
#
# Eingabe:  OSM-Auszug (Geofabrik) + Natural Earth, beides wird selbst geholt
# Ausgabe:  bahn.geojson · strassen.geojson · strassen-bau.geojson · gewaesser.geojson
# Liest:    Rumaenien-Verkehr.html, Rumaenien-Physisch.html
#
# Pipeline im funktionalen Zuschnitt: Werkzeuge sind Werte, Schritte sind Werte,
# ausgeführt wird erst am Ende. Ruby >= 3.2.
#
# Braucht: apt install osmium-tool gdal-bin wget unzip
# Aufruf:  ruby rumaenien-verkehr.rb

require 'pathname'

Dir.chdir(__dir__)

PBF    = 'romania-latest.osm.pbf'
NE     = 'ne_10m_rivers_lake_centerlines'
EXPORT = %w[-f GeoJSON -dialect SQLITE -simplify 0.004 -lco COORDINATE_PRECISION=4].freeze
BBOX   = %w[19.5 42.7 31.2 49.3].freeze

Step = Data.define(:title, :cmd, :run_if) do
  def due? = run_if.nil? || run_if.call
  def run!
    return puts "· #{title} — already present, skipped" unless due?
    puts "→ #{title}"
    system(*cmd, exception: true)
  end
end

step    = ->(title, *cmd, run_if: nil) { Step.new(title:, cmd:, run_if:) }
missing = ->(file) { -> { !Pathname(file).exist? } }

# ── SQL as data ───────────────────────────────────────────────────────────────
# German target file and property names (rang, klasse, …) are the data
# contract with the atlas sheets — everything else is English.
tag = ->(k, v) { %(other_tags LIKE '%"#{k}"=>"#{v}"%') }

SQL = {
  'bahn.geojson' => <<~SQL,
    SELECT name,
           CASE WHEN #{tag.('usage', 'main')} THEN 1 ELSE 2 END AS rang,
           CASE WHEN #{tag.('electrified', 'contact_line')} THEN 1 ELSE 0 END AS elektr,
           geom
    FROM rail
    WHERE #{tag.('usage', 'main')} OR #{tag.('usage', 'branch')}
  SQL
  'strassen.geojson' => <<~SQL,
    SELECT highway AS klasse, hstore_get_value(other_tags, 'ref') AS ref, geom
    FROM roads
  SQL
  'strassen-bau.geojson' => <<~SQL,
    SELECT hstore_get_value(other_tags, 'ref') AS ref, 'bau' AS status, geom
    FROM roads_construction
  SQL
}.freeze

# ── the pipeline: describe first … ────────────────────────────────────────────
%w[osmium ogr2ogr wget unzip]
  .reject { system("command -v #{_1} >/dev/null") }
  .tap { |t| abort "missing: #{t.join(', ')}  (apt install osmium-tool gdal-bin wget unzip)" unless t.empty? }

raw_data = [
  step.('Geofabrik extract',  'wget', "https://download.geofabrik.de/europe/#{PBF}", run_if: missing.(PBF)),
  step.('Natural Earth zip',  'wget', "https://naciscdn.org/naturalearth/10m/physical/#{NE}.zip", run_if: missing.("#{NE}.zip")),
  step.('unpack NE',          'unzip', '-o', "#{NE}.zip", run_if: missing.("#{NE}.shp")),
]

filters = { rail: 'w/railway=rail', roads: 'w/highway=motorway,trunk' }
  .map { |name, f| step.("osmium #{f}", 'osmium', 'tags-filter', '--overwrite', PBF, f, '-o', "#{name}.osm.pbf") }

gpkg = [
  step.('gpkg: rail',         'ogr2ogr', '-f', 'GPKG', 'source.gpkg', 'rail.osm.pbf', 'lines',
        '-nln', 'rail', '-nlt', 'MULTILINESTRING'),
  step.('gpkg: roads',        'ogr2ogr', '-f', 'GPKG', '-update', 'source.gpkg', 'roads.osm.pbf', 'lines',
        '-nln', 'roads', '-nlt', 'MULTILINESTRING', '-where', "highway IN ('motorway','trunk')"),
  step.('gpkg: construction', 'ogr2ogr', '-f', 'GPKG', '-update', 'source.gpkg', PBF, 'lines',
        '-nln', 'roads_construction', '-nlt', 'MULTILINESTRING',
        '-where', "highway = 'construction' AND #{tag.('construction', 'motorway')}"),
  step.('gpkg: rivers',       'ogr2ogr', '-f', 'GPKG', '-update', 'source.gpkg', "#{NE}.shp",
        '-nln', 'rivers', '-nlt', 'MULTILINESTRING', '-clipsrc', *BBOX),
]

exports = SQL.map { |target, sql| step.("export #{target}", 'ogr2ogr', *EXPORT, target, 'source.gpkg', '-sql', sql) } <<
  step.('export gewaesser.geojson', 'ogr2ogr', '-f', 'GeoJSON', '-lco', 'COORDINATE_PRECISION=4',
        'gewaesser.geojson', 'source.gpkg', '-sql', 'SELECT name, scalerank AS rang, geom FROM rivers')

# ── … then run ────────────────────────────────────────────────────────────────
# The GeoJSON driver never overwrites — clear leftovers first. Only OUR targets:
# a blanket *.geojson sweep would take out the nutzung-*.geojson that
# rumaenien-nutzung.rb produces in this same directory.
TARGETS = [*SQL.keys, 'gewaesser.geojson'].freeze
[Pathname('source.gpkg'), *TARGETS.map { Pathname(_1) }].each { _1.delete if _1.exist? }
[*raw_data, *filters, *gpkg, *exports].each(&:run!)

puts "\n— done. target: < 2 MB per file —"
TARGETS.map { Pathname(_1) }.select(&:exist?)
  .map { [_1.to_s, (_1.size / 1024.0 / 1024).round(2)] }
  .sort_by(&:last).reverse
  .each { |name, mb| puts format('%8.2f MB  %s', mb, name) }

