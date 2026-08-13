#!/usr/bin/env ruby
# frozen_string_literal: true
#
# farben-paletten.rb — farben.js → .gpl-Paletten für QGIS und GIMP
#
# Liegt bewusst neben farben.js und nicht in geodaten/: es rührt keine Geodaten
# an, sondern übersetzt nur das Farbsystem in ein zweites Format.
# Everything is data, one write pass at the end. Ruby >= 3.2, no dependencies.
#
# Input:  ../farben.js — the single source of truth for atlas colors.
#         Line format `key: '#hex', // Display name` is a contract (the file
#         header says "maschinell geparst für .gpl-Export"; this is that export).
# Output: ../paletten/atlas-*.gpl        (one palette per map family, GIMP+QGIS)
#         ../qgis/basis/paletten/sternprodukt-atlas.gpl  (curated base palette)
#
# Never edit the .gpl files by hand — change farben.js and re-run.

require 'pathname'

Dir.chdir(__dir__)

FARBEN = Pathname('farben.js').read.scan(/(\w+):\s*'(#\h{6})',\s*\/\/\s*(.+?)\s*$/)
  .to_h { |k, hex, name| [k, { hex:, name: }] }

abort 'farben.js: no parseable colors found' if FARBEN.empty?

STAND = '2026-08'
HEADER = ->(name, cols, extra = nil) do
  [
    'GIMP Palette',
    "Name: #{name}",
    "Columns: #{cols}",
    "# Sternprodukt-Atlas — gedämpfte Diercke-Systematik. Stand #{STAND}.",
    '# Abgeleitet aus atlas/farben.js (atlas/farben-paletten.rb) — nicht von Hand pflegen.',
    '# QGIS: Einstellungen → Optionen → Farben → Palette importieren.',
    *extra,
  ]
end

# Display-name overrides where the curated palette wants a shorter label.
HOEHEN = { 'h0' => 'Höhe 0–200', 'h200' => 'Höhe 200–500', 'h500' => 'Höhe 500–1000',
           'h1000' => 'Höhe 1000–2000', 'h2000' => 'Höhe 2000–3000', 'h3000' => 'Höhe 3000–5000' }.freeze

PALETTEN = {
  'paletten/atlas-grund.gpl' => {
    name: 'Sternprodukt-Atlas Grund & Akzente', cols: 4, hex_suffix: true,
    keys: %w[papier papierWarm flaecheWarm tinte umriss grauHell dim grauDunkel bleistift
             auswahl konflikt orangeTint orange orangeDeep petrolTint petrol petrolDeep
             olivTint oliv olivDeep pflaumeTint pflaume pflaumeDeep ocker ockerDeep
             wegHell gewaesserFlaeche],
  },
  'paletten/atlas-hypsometrie.gpl' => {
    name: 'Sternprodukt-Atlas Hypsometrie & Bathymetrie', cols: 3, hex_suffix: true,
    keys: %w[gletscher h5000 h3000 h2000 h1000 h500 h200 h0 hSenke
             b0 b200 b2000 b4000 b6000 b8000 wasser],
  },
  'paletten/atlas-landnutzung.gpl' => {
    name: 'Sternprodukt-Atlas Landnutzung & Stadt', cols: 3, hex_suffix: true,
    extra: ['# Texturen (Raster, Kreuzschraffur) liegen nicht hier, sondern als Füllsymbole in qgis/basis/symbole/sternprodukt_atlas.xml.'],
    keys: %w[acker sonderkultur reis gruenland weideExt wald plantage hanf oedland tundra
             bebaut bebautLocker gewerbe],
  },
  'paletten/atlas-klima.gpl' => {
    name: 'Sternprodukt-Atlas Klima & Vegetation', cols: 4, hex_suffix: true,
    keys: %w[kPolar kSubpolar kGemaessigt kSubtrop kTrocken kTropWechsel kTropFeucht
             d1 d2 d3 d4 d5],
  },
  'paletten/atlas-geologie.gpl' => {
    name: 'Sternprodukt-Atlas Geologie (Erdzeitalter)', cols: 4, hex_suffix: true,
    keys: %w[quartaer neogen palaeogen kreide jura trias perm karbon devon silur
             ordovizium kambrium praekambrium],
  },
  'paletten/atlas-bevoelkerung.gpl' => {
    name: 'Sternprodukt-Atlas Bevölkerung (sequentiell)', cols: 5, hex_suffix: true,
    keys: %w[p1 p2 p3 p4 p5],
  },
  'qgis/basis/paletten/sternprodukt-atlas.gpl' => {
    name: 'Sternprodukt Atlas', cols: 4, hex_suffix: false,
    keys: %w[papier flaecheWarm papierWarm tinte grauHell dim grauDunkel bleistift
             orange petrol oliv pflaume konflikt baer schutzgebiet wasser
             h0 h200 h500 h1000 h2000 h3000],
    namen: HOEHEN,
  },
}.freeze

zeile = ->(key, spec) do
  f = FARBEN.fetch(key) { abort "farben.js kennt keinen Schlüssel: #{key}" }
  r, g, b = f[:hex].scan(/\h\h/).map { _1.to_i(16) }
  name = spec.fetch(:namen, {}).fetch(key, f[:name])
  name += " (#{f[:hex]})" if spec[:hex_suffix]
  format("%3d %3d %3d\t%s", r, g, b, name)
end

PALETTEN.each do |pfad, spec|
  lines = HEADER.(spec[:name], spec[:cols], spec[:extra]) + spec[:keys].map { zeile.(_1, spec) }
  Pathname(pfad).write(lines.join("\n") + "\n")
  puts "→ #{pfad}  (#{spec[:keys].size} Farben)"
end

fremd = FARBEN.keys - PALETTEN.values.flat_map { _1[:keys] }.uniq
puts "\nnicht in Paletten (ok, Bildschirm-only oder Reserve): #{fremd.join(', ')}" unless fremd.empty?
