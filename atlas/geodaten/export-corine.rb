#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Sternprodukt atlas · CORINE pipeline — Bodennutzung für Blatt 18 (Rumänien).
# Same functional flavor as export-geodaten.rb: steps are values, nothing
# runs until the very end. Ruby >= 3.2.
#
# Input:  CLC2018 vector GeoPackage (u2018_clc2018_v2020_20u1_fgdb / gpkg).
#         Free download after registration:
#         https://land.copernicus.eu/en/products/corine-land-cover/clc2018
#         → place the .gpkg next to this script as clc2018.gpkg (once, ~1 GB).
# Output: nutzung-<klasse>.geojson — one file per atlas class, generalized
#         to sheet scale. German class names are the data contract with
#         Blatt 18 (atlas/geodaten/blatt18-daten.js); everything else English.
#
# Requirements: apt install gdal-bin

require 'pathname'

Dir.chdir(__dir__)

CLC    = 'clc2018.gpkg'
LAYER  = ENV.fetch('CLC_LAYER', 'U2018_CLC2018_V2020_20u1')
BBOX   = %w[19.5 42.7 31.2 49.3].freeze # Romania sheet window, EPSG:4326
EXPORT = %w[-f GeoJSON -t_srs EPSG:4326 -simplify 0.015 -lco COORDINATE_PRECISION=4].freeze

abort <<~MSG unless Pathname(CLC).exist?
  missing: #{CLC}
  CORINE is a one-time manual download (free registration):
    https://land.copernicus.eu/en/products/corine-land-cover/clc2018
  Save the vector GeoPackage here as #{CLC}, then re-run.
MSG

Step = Data.define(:title, :cmd) do
  def run!
    puts "→ #{title}"
    system(*cmd, exception: true)
  end
end
step = ->(title, *cmd) { Step.new(title:, cmd:) }

%w[ogr2ogr ogrinfo]
  .reject { system("command -v #{_1} >/dev/null") }
  .tap { |t| abort "missing: #{t.join(', ')}  (apt install gdal-bin)" unless t.empty? }

# ── CLC codes → atlas classes (the nine of Blatt 18) ─────────────────────────
# Ackerland is exported too, although the sheet uses it as base tint — QGIS
# wants it as a layer. Hanf is deliberately absent: CORINE knows the field,
# not the crop (see atlas/GLOSSAR.md → CORINE-Klassen).
CLASSES = {
  'stadt'     => %w[111 112 121],          # continuous/discontinuous urban, industrial units
  'acker'     => %w[211],                  # non-irrigated arable land
  'gemuese'   => %w[212 242],              # irrigated + complex cultivation
  'weinbau'   => %w[221],
  'obstbau'   => %w[222],
  'gruenland' => %w[231],                  # pastures
  'steppe'    => %w[321 333],              # natural grasslands, sparse vegetation
  'wald'      => %w[311 312 313],
  'feucht'    => %w[411 412 421 511],      # marshes, peat bogs, salt marshes, watercourses' floodplain proxy
}.freeze

# Sheet scale is 1:2.5M-ish: drop slivers below ~0.002 deg² (≈ 20 km²) after
# dissolving per class, then simplify. SQLITE dialect gives us the area filter.
sql = ->(klasse, codes) { <<~SQL }
  SELECT '#{klasse}' AS klasse, ST_Union(geom) AS geom
  FROM "#{LAYER}"
  WHERE Code_18 IN (#{codes.map { "'#{_1}'" }.join(', ')})
SQL

clip = step.('clip CLC to sheet window (once)',
  'ogr2ogr', '-f', 'GPKG', 'corine-ro.gpkg', CLC, LAYER,
  '-nln', LAYER, '-t_srs', 'EPSG:4326', '-spat', *BBOX, '-nlt', 'MULTIPOLYGON')

exports = CLASSES.map do |klasse, codes|
  step.("export nutzung-#{klasse}.geojson",
    'ogr2ogr', *EXPORT, "nutzung-#{klasse}.geojson", 'corine-ro.gpkg',
    '-dialect', 'SQLITE', '-sql', sql.(klasse, codes))
end

# ── run ───────────────────────────────────────────────────────────────────────
Pathname.glob('nutzung-*.geojson').each(&:delete)
clip.run! unless Pathname('corine-ro.gpkg').exist?
exports.each(&:run!)

puts "\n— done. Blatt 18 reads these instead of the hand-drawn polygons —"
Pathname.glob('nutzung-*.geojson')
  .map { [_1.to_s, (_1.size / 1024.0 / 1024).round(2)] }
  .sort_by(&:last).reverse
  .each { |name, mb| puts format('%8.2f MB  %s', mb, name) }
