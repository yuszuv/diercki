#!/usr/bin/env ruby
# frozen_string_literal: true
#
# rumaenien-nutzung.rb — Bodennutzung Rumänien aus CORINE Land Cover 2018
#
# Liest: Rumaenien-Wirtschaft.html (über atlas/geodaten/nutzung-daten.js)
#
# Was es tut, in drei Schritten:
#   1. die Quelle im Copernicus-Paket finden (Verschachtelung, Ebenenname),
#   2. sie EINMAL auf das Blattfenster zuschneiden → corine-ro.gpkg,
#   3. daraus je Atlasklasse eine GeoJSON-Datei erzeugen (neun Stück).
# Schritt 1 und 2 sind teuer und werden gecacht; Schritt 3 ist je Klasse einzeln
# wiederaufnehmbar. Ein Abbruch in der Mitte kostet deshalb nur den Rest.
#
# Input:  CLC2018 vector data next to this script — clc2018.gpkg or clc2018.zip.
#         Die europaweite Lieferung ist verschachtelt (Results/…geoPackage.zip/DATA/…gpkg);
#         das Skript sucht sich das selbst und packt nur aus, was es braucht.
#         Free download after registration:
#         https://land.copernicus.eu/en/products/corine-land-cover/clc2018
# Output: nutzung-<klasse>.geojson — one file per atlas class, generalized
#         to sheet scale. German class names are the data contract with
#         the land-use sheet (atlas/geodaten/nutzung-daten.js); everything else English.
#
# Erneut alles rechnen:  NEU=1 ruby rumaenien-nutzung.rb
# Requirements: apt install gdal-bin

require 'pathname'
require 'shellwords'

Dir.chdir(__dir__)

CLIP = Pathname('corine-ro.gpkg')       # der zugeschnittene Zwischenstand
BBOX = %w[19.5 42.7 31.2 49.3].freeze   # Romania sheet window, EPSG:4326
# -s_srs muss dabeistehen: das Ergebnis einer SQL-Abfrage im SQLITE-Dialekt trägt kein
# Bezugssystem mehr, auch wenn die Eingangsebene eines hatte. Der Zuschnitt ist 4326.
EXPORT = %w[-f GeoJSON -s_srs EPSG:4326 -t_srs EPSG:4326 -simplify 0.015 -lco COORDINATE_PRECISION=4].freeze
NEU = !ENV['NEU'].nil?

%w[ogr2ogr ogrinfo]
  .reject { system("command -v #{_1} >/dev/null") }
  .tap { |t| abort "missing: #{t.join(', ')}  (apt install gdal-bin)" unless t.empty? }

Step = Data.define(:title, :cmd) do
  def run!
    puts "→ #{title}"
    system(*cmd, exception: true)
  end
end
step = ->(title, *cmd) { Step.new(title:, cmd:) }

def ebenen(pfad)
  `ogrinfo -so #{pfad.shellescape} 2>/dev/null`.scan(/^\d+: (\S+)/).flatten
end

# Geometrie- und Klassenspalte heißen nicht überall gleich: das Copernicus-GeoPackage
# nennt die Geometrie `Shape` (nicht `geom`), die Klassenspalte `Code_18`. ogr2ogr
# behält den Namen beim Kopieren — die Spalte wird deshalb erfragt, nicht angenommen.
def spalten(pfad, layer)
  info = `ogrinfo -so #{pfad.shellescape} #{layer.shellescape} 2>/dev/null`
  geom = info[/^Geometry Column\s*=\s*(\S+)/, 1] || 'geom'
  code = info[/^(code_?\d*)\s*:/i, 1] || 'Code_18'
  [geom, code]
end

# ── Schritt 1 · die Quelle im Paket finden ────────────────────────────────────────────
# Listing a 3.7 GB archive takes minutes, so the entry list is cached next to it.
# Delete <archiv>.inhalt to force a fresh listing.
def eintraege(zip)
  cache = Pathname("#{zip}.inhalt")
  unless cache.exist? && cache.size.positive?
    warn "Inhaltsverzeichnis von #{zip} wird gelesen (bei mehreren GB dauert das Minuten) …"
    cache.write(`unzip -Z1 #{zip.shellescape} 2>/dev/null`)
  end
  cache.readlines(chomp: true).reject(&:empty?)
end

def vsi_kandidaten(zip)
  entries = eintraege(zip)
  gdb     = entries.grep(%r{\.gdb/}i).map { _1[%r{\A.*?\.gdb}i] }.uniq
  flach   = entries.grep(/\.gpkg\z/i) + gdb + entries.grep(/\.shp\z/i)
  innen   = entries.grep(/\.zip\z/i)
  ["/vsizip/#{zip}"] +
    flach.map { "/vsizip/#{zip}/#{_1}" } +
    innen.map { "/vsizip/{/vsizip/#{zip}/#{_1}}" }
end

# A zip inside the zip cannot be listed without unpacking it — so unpack exactly that
# one member (a fraction of the whole) and continue the search inside it.
def inneres_archiv(zip)
  inner = eintraege(zip).grep(/\.zip\z/i).first or return nil
  ziel = Pathname(File.basename(inner))
  unless ziel.exist?
    warn "Inneres Archiv wird ausgepackt: #{inner}"
    system('unzip', '-o', '-j', zip, inner, out: File::NULL) or return nil
  end
  ziel.to_s
end

# Der Zuschnitt aus einem verschachtelten Zip heraus dekomprimiert dieselben Gigabyte
# ein zweites Mal. Die eine Datei, die gebraucht wird, wird deshalb einmal ausgepackt.
def entpacken(vsi_pfad)
  m = vsi_pfad.match(%r{\A/vsizip/\{?/?(?:vsizip/)?([^/{}]+\.zip)\}?/(.+)\z}i) or return vsi_pfad
  zip, inner = m[1], m[2]
  ziel = Pathname(File.basename(inner))
  return ziel.to_s if ziel.exist?
  warn "Datensatz wird ausgepackt: #{inner} (#{zip})"
  system('unzip', '-o', '-j', zip, inner, out: File::NULL) ? ziel.to_s : vsi_pfad
end

def quelle_ermitteln
  source = %w[clc2018.gpkg clc2018.zip].find { Pathname(_1).exist? }
  abort <<~MSG unless source
    missing: clc2018.gpkg or clc2018.zip in #{Dir.pwd}
    CORINE ist ein einmaliger Handdownload (kostenlose Registrierung):
      https://land.copernicus.eu/en/products/corine-land-cover/clc2018
  MSG

  return [ENV['CLC_PFAD'], ebenen(ENV['CLC_PFAD'])] if ENV['CLC_PFAD']
  return [source, ebenen(source)] unless source.end_with?('.zip')

  suche = ->(zip) { vsi_kandidaten(zip).lazy.map { [_1, ebenen(_1)] }.find { |_, e| !e.empty? } }
  treffer = suche.(source)
  treffer ||= (innen = inneres_archiv(source)) && (warn("Suche im inneren Archiv: #{innen}") || suche.(innen))
  unless treffer
    warn 'Im Archiv gefunden (erste 25 Einträge):'
    warn(eintraege(source).first(25).map { "  #{_1}" }.join("\n"))
    abort <<~MSG
      Keine lesbare Ebene in #{source}.
      Den Pfad selbst setzen — im Archiv oder auf eine entpackte Datei:
        CLC_PFAD=/vsizip/#{source}/<Pfad im Zip> ruby #{File.basename(__FILE__)}
        CLC_PFAD=<entpackte>.gpkg              ruby #{File.basename(__FILE__)}
    MSG
  end
  [entpacken(treffer.first), treffer.last]
end

# ── CLC codes → atlas classes (the nine of the land-use sheet) ─────────────────────────
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

# ── Schritt 2 · einmal zuschneiden ────────────────────────────────────────────────────
if NEU || !CLIP.exist?
  CLIP.delete if CLIP.exist?
  clc, ebenen_dort = quelle_ermitteln
  layer = ENV.fetch('CLC_LAYER') { ebenen_dort.grep(/clc/i).first || ebenen_dort.first }
  puts "CLC-Quelle: #{clc}\nCLC-Ebene:  #{layer}"
  # -spat_srs ist Pflicht: ohne es liest ogr2ogr die Fensterwerte im Bezugssystem der
  # Quelle, und CORINE liegt in EPSG:3035 (LAEA, Meter). 19,5 / 42,7 wären dann Meter.
  step.('clip CLC to sheet window (once)',
        'ogr2ogr', '-f', 'GPKG', CLIP.to_s, clc, layer,
        '-nln', layer, '-t_srs', 'EPSG:4326',
        '-spat', *BBOX, '-spat_srs', 'EPSG:4326', '-nlt', 'MULTIPOLYGON').run!
else
  puts "#{CLIP} liegt vor — Zuschnitt übersprungen (NEU=1 erzwingt ihn)"
end

LAYER = ebenen(CLIP.to_s).first or abort "#{CLIP} enthält keine Ebene — mit NEU=1 neu zuschneiden."
GEOM, CODE = spalten(CLIP.to_s, LAYER)
puts "Ebene #{LAYER} · Geometrie #{GEOM} · Klassenspalte #{CODE}"

# Was steckt wirklich drin? Eine leere Auswahl liefert stillschweigend ein Objekt mit
# geometry:null — deshalb wird vor dem Export gezählt und die Schlüsselverteilung gezeigt.
bestand = `ogrinfo -q -dialect SQLITE #{CLIP.to_s.shellescape} -sql #{"SELECT COUNT(*) AS n FROM \"#{LAYER}\"".shellescape} 2>&1`
anzahl  = bestand[/n \(Integer\w*\) = (\d+)/, 1]&.to_i
abort <<~MSG if anzahl&.zero?
  #{CLIP} ist leer — der Zuschnitt hat nichts getroffen.
  Fenster prüfen (#{BBOX.join(' ')}) und mit NEU=1 erneut zuschneiden.
MSG
puts "Objekte im Zuschnitt: #{anzahl || '?'}"
puts '— Schlüsselverteilung (die 15 häufigsten) —'
system('ogrinfo', '-q', '-dialect', 'SQLITE', CLIP.to_s, '-sql',
       "SELECT #{CODE} AS code, COUNT(*) AS n FROM \"#{LAYER}\" GROUP BY code ORDER BY n DESC LIMIT 15")

# ── Schritt 3 · je Klasse eine Datei ──────────────────────────────────────────────────
# Sheet scale is 1:2.5M-ish: dissolve per class, then simplify to ~0.015° (≈ 1,5 km).
sql = lambda do |klasse, codes|
  <<~SQL
    SELECT '#{klasse}' AS klasse, ST_Union("#{GEOM}") AS geom
    FROM "#{LAYER}"
    WHERE #{CODE} IN (#{codes.map { "'#{_1}'" }.join(', ')})
  SQL
end

CLASSES.each do |klasse, codes|
  ziel = Pathname("nutzung-#{klasse}.geojson")
  if ziel.exist? && ziel.size > 200 && !NEU
    puts "· nutzung-#{klasse}.geojson liegt vor — übersprungen"
    next
  end
  ziel.delete if ziel.exist?   # der GeoJSON-Treiber überschreibt nicht
  step.("export nutzung-#{klasse}.geojson",
        'ogr2ogr', *EXPORT, ziel.to_s, CLIP.to_s,
        '-dialect', 'SQLITE', '-sql', sql.(klasse, codes)).run!
  # Eine Datei mit geometry:null ist kein Ergebnis, sondern eine leere Auswahl.
  if ziel.exist? && ziel.read.include?('"geometry":null')
    ziel.delete
    abort <<~MSG
      nutzung-#{klasse}.geojson wäre leer geblieben (geometry:null) — kein Objekt mit
      #{CODE} in #{codes.join(', ')}. Die Schlüsselverteilung oben sagt, welche Werte
      wirklich vorkommen; CLASSES im Skript daran anpassen.
    MSG
  end
end

puts "\n— done. the land-use sheet reads these instead of the hand-drawn polygons —"
Pathname.glob('nutzung-*.geojson')
  .map { [_1.to_s, (_1.size / 1024.0 / 1024).round(2)] }
  .sort_by(&:last).reverse
  .each { |name, mb| puts format('%8.2f MB  %s', mb, name) }
fehlend = CLASSES.keys.reject { Pathname("nutzung-#{_1}.geojson").exist? }
puts "fehlen noch: #{fehlend.join(', ')} — Skript erneut aufrufen, es setzt fort." if fehlend.any?
