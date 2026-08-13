#!/usr/bin/env ruby
# frozen_string_literal: true
#
# freiburg-friedhof.rb — Grundriss des Freiburger Hauptfriedhofs aus OpenStreetMap
#
# Für Blatt „Nikolais Ort". Das Blatt holt sich die Geometrie im Browser selbst;
# dieses Skript legt sie dauerhaft ab — für QGIS, für den Druck, und damit das
# Blatt auch ohne Netz zeichnet.
#
# Ausgabe:  atlas/geodaten/friedhof-freiburg.geojson  (Fläche, Wege, Bauten)
#           atlas/geodaten/friedhof-freiburg.gpkg     (dasselbe für QGIS)
#
# Braucht:  curl, ogr2ogr (gdal-bin), Ruby >= 3.2
# Aufruf:   ruby freiburg-friedhof.rb
#           ruby freiburg-friedhof.rb --turbo   → nur die Abfrage + Overpass-Turbo-Link,
#                                               nichts wird geholt
#
# Overpass ist ein geteilter, kostenloser Dienst. 504 und 429 heißen nicht, dass die
# Abfrage falsch ist, sondern dass gerade jemand anders dran ist. Das Skript geht
# deshalb die bekannten Spiegel der Reihe nach durch und wartet zwischen den
# Versuchen. Hilft das nichts, bleibt der Weg über die Hand: overpass-turbo.eu.
#
# Was NICHT hier steht: die Lage von Feld 35. OSM kennt die Feldnummern des
# Friedhofs nicht. Die kommt aus dem Feldplan der Friedhofsverwaltung und muss
# von Hand digitalisiert werden — siehe atlas/quellen/Nikolais-Ort.md.

require 'json'
require 'uri'
require 'pathname'
require 'shellwords'
require 'erb'

# Fenster um die Friedhofstraße 8. Großzügig — der Ausschnitt entsteht später
# aus der Geometrie, nicht aus diesen Zahlen.
S, W, N, E = 48.0055, 7.8290, 48.0215, 7.8560

# Erst die Fläche holen, dann alles, was darin liegt — `area` statt Rechteck.
# Das spart den halben Stadtteil: die alte Rechteck-Abfrage lieferte 4560 Objekte,
# von denen 4377 außerhalb lagen. Der Zuschnitt unten bleibt trotzdem drin, weil
# Wege über die Grenze hinauslaufen können.
QUERY = <<~OQL
  [out:json][timeout:120];
  ( way["landuse"="cemetery"](#{S},#{W},#{N},#{E});
    relation["landuse"="cemetery"](#{S},#{W},#{N},#{E}); )->.friedhof;
  .friedhof map_to_area -> .flaeche;
  ( .friedhof;
    // Wegenetz und Bauten
    way["highway"~"footway|path|service|track"](area.flaeche);
    way["building"](area.flaeche);
    // Bestand: Gehölze, Hecken, Mauern, Wasser, Rasen
    way["natural"~"tree_row|water|scrub"](area.flaeche);
    way["barrier"~"hedge|wall|fence"](area.flaeche);
    way["landuse"="grass"](area.flaeche);
    way["leisure"="park"](area.flaeche);
    // Einzelobjekte
    node["natural"="tree"](area.flaeche);
    node["historic"~"memorial|monument|tomb"](area.flaeche);
    way["historic"~"memorial|monument|tomb"](area.flaeche);
    node["amenity"~"bench|drinking_water|waste_basket|grave_yard"](area.flaeche);
    node["man_made"="water_tap"](area.flaeche); );
  out geom;
OQL

# Die bekannten Spiegel, nach Verlässlichkeit sortiert. Kumi ist meist der schnellste,
# de.overpass der offizielle, die anderen fangen Lastspitzen ab.
SPIEGEL = %w[
  https://overpass.kumi.systems/api/interpreter
  https://overpass-api.de/api/interpreter
  https://overpass.osm.ch/api/interpreter
  https://overpass.private.coffee/api/interpreter
].freeze

TURBO = "https://overpass-turbo.eu/?Q=#{ERB::Util.url_encode(QUERY)}&R"

OUT_JSON = Pathname(__dir__) / 'friedhof-freiburg.geojson'
OUT_GPKG = Pathname(__dir__) / 'friedhof-freiburg.gpkg'

# Punkt-in-Polygon, Strahlenverfahren. Ohne diesen Schritt bleibt das ganze
# Viertel im Datensatz: die Abfrage kennt nur ein Rechteck, gemeint ist die Fläche.
# Erster Ring außen, weitere sind Löcher.
# Eine Zuordnung für beide Eingangswege — sonst driften sie auseinander.
# Schuhbandformel. d3-geo (und damit das Blatt) rechnet sphärisch und erwartet
# Außenringe im Uhrzeigersinn: ein andersherum gewickelter Ring bedeutet dort
# „alles außer dieser Fläche", und die Karte wird weltgroß. OSM und RFC 7946
# wickeln entgegengesetzt, QGIS und ogr ist es gleich — deshalb wird hier gedreht.
def ring_flaeche(ring)
  a = 0.0
  k = ring.size - 1
  ring.each_with_index do |(x, y), i|
    xk, yk = ring[k]
    a += xk * y - x * yk
    k = i
  end
  a / 2
end

def wickeln(ring, aussen)
  a = ring_flaeche(ring)
  (aussen ? a > 0 : a < 0) ? ring.reverse : ring
end

def geometrie_wickeln(geom)
  case geom['type']
  when 'Polygon'
    geom.merge('coordinates' => geom['coordinates'].each_with_index.map { |r, i| wickeln(r, i.zero?) })
  when 'MultiPolygon'
    geom.merge('coordinates' => geom['coordinates'].map { |p| p.each_with_index.map { |r, i| wickeln(r, i.zero?) } })
  else
    geom
  end
end

def bestimme_art(tags)
  return 'flaeche'   if tags['landuse'] == 'cemetery'
  return 'bau'       if tags['building']
  return 'denkmal'   if tags['historic'] || tags['amenity'] == 'grave_yard'
  return 'baum'      if tags['natural'] == 'tree'
  return 'baumreihe' if tags['natural'] == 'tree_row'
  return 'gehoelz'   if tags['natural'] == 'scrub'
  return 'wasser'    if tags['natural'] == 'water'
  return 'hecke'     if tags['barrier'] == 'hedge'
  return 'mauer'     if %w[wall fence retaining_wall].include?(tags['barrier'])
  return 'rasen'     if tags['landuse'] == 'grass' || tags['leisure'] == 'park'
  return 'weg'       if tags['highway']
  return 'moebel'    if %w[bench drinking_water waste_basket].include?(tags['amenity']) || tags['man_made'] == 'water_tap'
  nil
end

# Die Art des Baums, wenn jemand sie erfasst hat. Für die Flora ist das die
# einzige belastbare Angabe, die aus OSM kommt — alles andere braucht Begehung.
def baumart(tags)
  tags['species'] || tags['species:de'] || tags['genus'] || tags['taxon']
end

def im_ring?(punkt, ring)
  drin = false
  k = ring.size - 1
  ring.each_with_index do |(xi, yi), i|
    xk, yk = ring[k]
    drin = !drin if (yi > punkt[1]) != (yk > punkt[1]) &&
                    punkt[0] < (xk - xi) * (punkt[1] - yi) / (yk - yi) + xi
    k = i
  end
  drin
end

def im_friedhof?(punkt, ringe)
  return false unless im_ring?(punkt, ringe.first)
  ringe.drop(1).none? { im_ring?(punkt, _1) }
end

# Überwiegend innerhalb, nicht schon beim Streifen — sonst kommen die Straßen
# ringsum wieder mit.
ANTEIL = 0.6

if ARGV.include?('--turbo')
  puts QUERY, '', 'In Overpass Turbo öffnen (Abfrage ist im Link enthalten):', TURBO, ''
  puts 'Dort auf „Ausführen", dann „Exportieren → GeoJSON herunterladen".'
  puts "Die Datei hier ablegen als: #{OUT_JSON}"
  puts 'Danach dieses Skript erneut aufrufen — es rechnet die Rohdaten um.'
  exit
end

abort 'ogr2ogr fehlt — apt install gdal-bin' unless system('which ogr2ogr', out: File::NULL)

# Schon vorhandene Rohdaten aus Overpass Turbo? Dann nicht noch einmal fragen.
raw = nil
if OUT_JSON.exist? && !ARGV.include?('--neu')
  warn "#{OUT_JSON.basename} liegt schon da — mit --neu erzwingen, sonst wird nur der GeoPackage-Teil erneuert."
  raw = OUT_JSON.read
end

unless raw
  SPIEGEL.each_with_index do |url, i|
    host = URI.parse(url).host
    warn "Overpass wird gefragt (#{i + 1}/#{SPIEGEL.size}: #{host}) …"
    antwort = `curl -sS --fail --max-time 180 --data-urlencode #{"data=#{QUERY}".shellescape} #{url.shellescape} 2>&1`
    if $?.success?
      raw = antwort
      warn "  geantwortet: #{host}"
      break
    end
    warn "  #{host} antwortet nicht (Exit #{$?.exitstatus}) — 504 und 429 heißen überlastet, nicht falsch."
    sleep(4 * (i + 1)) unless i == SPIEGEL.size - 1
  end
end

unless raw
  abort <<~MSG
    Kein Spiegel hat geantwortet. Zwei Wege weiter:

    1. Später noch einmal. Overpass ist tageszeitabhängig; abends europäischer Zeit
       ist es am schlimmsten.

    2. Über die Hand, mit Overpass Turbo — das ist ohnehin das angenehmere Werkzeug,
       weil man die Abfrage dort sieht, ändert und sofort auf der Karte prüft:

         ruby #{File.basename(__FILE__)} --turbo

       Das druckt die Abfrage und einen Link, der sie schon enthält. In Turbo
       ausführen, „Exportieren → GeoJSON herunterladen", die Datei hier ablegen als
       #{OUT_JSON.basename}, und dieses Skript noch einmal aufrufen.
  MSG
end

geparst = JSON.parse(raw)

# Zwei Eingangsformen: die Rohform der API (`elements`) und das fertige GeoJSON,
# das Overpass Turbo beim Export schreibt (`features`). Turbo hat dann schon
# umgerechnet — in dem Fall bleibt nur noch der GeoPackage-Teil zu tun.
if geparst['type'] == 'FeatureCollection'
  warn "GeoJSON erkannt (#{geparst['features'].size} Objekte) — vermutlich aus Overpass Turbo."
  features = geparst['features'].filter_map do |f|
    tags = f['properties'] || {}
    # Schon umgerechnet? Dann unverändert durchlassen — sonst frisst der zweite
    # Lauf die eigene Ausgabe auf, weil dort keine OSM-Tags mehr stehen.
    next f if tags['art']

    art = bestimme_art(tags)
    next unless art
    f.merge('properties' => {
      'art' => art, 'name' => tags['name'],
      'sorte' => tags['amenity'] || tags['historic'] || tags['barrier'],
      'baumart' => baumart(tags),
      'osm' => f['id']
    }.compact)
  end
  abort "#{OUT_JSON.basename} enthält nichts Brauchbares — mit --neu frisch holen." if features.empty?
  flaeche = features.find { _1.dig('properties', 'art') == 'flaeche' }
  abort 'Keine Friedhofsfläche im Datensatz.' unless flaeche
  ringe = flaeche['geometry']['coordinates']
  ringe = ringe.flatten(1) if flaeche['geometry']['type'] == 'MultiPolygon'

  vorher = features.size
  features = features.select do |f|
    next true if f.dig('properties', 'art') == 'flaeche'
    punkte = case f['geometry']['type']
             when 'Point'   then [f['geometry']['coordinates']]
             when 'Polygon' then f['geometry']['coordinates'].flatten(1)
             else f['geometry']['coordinates']
             end
    next false if punkte.empty?
    punkte.count { im_friedhof?(_1, ringe) }.fdiv(punkte.size) >= ANTEIL
  end
  warn "zugeschnitten: #{vorher} → #{features.size} Objekte"

  features = features.map { _1.merge('geometry' => geometrie_wickeln(_1['geometry'])) }
  OUT_JSON.write(JSON.generate({ 'type' => 'FeatureCollection', 'features' => features }))
  warn "geschrieben: #{OUT_JSON.basename} — #{features.size} Objekte"
  OUT_GPKG.delete if OUT_GPKG.exist?
  system('ogr2ogr', '-f', 'GPKG', OUT_GPKG.to_s, OUT_JSON.to_s, '-nln', 'friedhof', '-a_srs', 'EPSG:4326') \
    or abort 'ogr2ogr ist gescheitert.'
  warn "geschrieben: #{OUT_GPKG.basename}"
  exit
end

elements = geparst.fetch('elements', [])
abort 'Overpass liefert nichts — Fenster prüfen.' if elements.empty?

features = elements.filter_map do |e|
  tags = e['tags'] || {}

  # Knoten tragen lat/lon direkt, Wege eine Stützpunktliste.
  if e['type'] == 'node'
    art = bestimme_art(tags)
    next unless art
    next {
      'type' => 'Feature',
      'properties' => {
        'art' => art, 'name' => tags['name'],
        'sorte' => tags['amenity'] || tags['historic'],
        'baumart' => baumart(tags),
        'osm' => "node/#{e['id']}"
      }.compact,
      'geometry' => { 'type' => 'Point', 'coordinates' => [e['lon'].round(6), e['lat'].round(6)] }
    }
  end

  geom = e['geometry']
  next unless geom&.size&.>= 2
  ring = geom.map { [_1['lon'].round(6), _1['lat'].round(6)] }

  art = bestimme_art(tags)
  next unless art

  # Flächen und Bauten sind geschlossen, Wege nicht.
  polygon = %w[flaeche bau wasser rasen gehoelz denkmal].include?(art) && ring.size > 3
  ring << ring.first if polygon && ring.first != ring.last

  {
    'type' => 'Feature',
    'properties' => {
      'art'  => art,
      'name' => tags['name'],
      'sorte' => tags['amenity'] || tags['historic'] || tags['barrier'],
      'baumart' => baumart(tags),
      'osm'  => "#{e['type']}/#{e['id']}"
    }.compact,
    'geometry' => polygon ?
      { 'type' => 'Polygon',    'coordinates' => [ring] } :
      { 'type' => 'LineString', 'coordinates' => ring }
  }
end

flaeche = features.find { _1.dig('properties', 'art') == 'flaeche' }
abort 'Keine Friedhofsfläche im Fenster gefunden.' unless flaeche

ringe = flaeche['geometry']['coordinates']
ringe = ringe.flatten(1) if flaeche['geometry']['type'] == 'MultiPolygon'

vorher = features.size
features = features.select do |f|
  next true if f.dig('properties', 'art') == 'flaeche'

  punkte = case f['geometry']['type']
           when 'Point'   then [f['geometry']['coordinates']]
           when 'Polygon' then f['geometry']['coordinates'].flatten(1)
           else f['geometry']['coordinates']
           end
  next false if punkte.empty?

  punkte.count { im_friedhof?(_1, ringe) }.fdiv(punkte.size) >= ANTEIL
end
warn "zugeschnitten: #{vorher} → #{features.size} Objekte (#{vorher - features.size} lagen außerhalb der Fläche)"

features = features.map { _1.merge('geometry' => geometrie_wickeln(_1['geometry'])) }
OUT_JSON.write(JSON.generate({ 'type' => 'FeatureCollection', 'features' => features }))

zaehlung = features.group_by { _1.dig('properties', 'art') }.transform_values(&:size)
warn "geschrieben: #{OUT_JSON.basename} — #{zaehlung.map { |k, v| "#{v} #{k}" }.join(', ')}"

benannt = features.select { _1.dig('properties', 'art') == 'bau' && _1.dig('properties', 'name') }
warn "benannte Bauten: #{benannt.map { _1.dig('properties', 'name') }.join(' · ')}" if benannt.any?

baeume = features.select { _1.dig('properties', 'art') == 'baum' }
arten  = baeume.filter_map { _1.dig('properties', 'baumart') }.tally.sort_by { -_2 }
if arten.any?
  warn "Baumarten aus OSM: #{arten.map { |a, n| "#{a} (#{n})" }.join(' · ')}"
else
  warn "Bäume: #{baeume.size}, davon keiner mit Artangabe — die Flora braucht eine Begehung."
end

OUT_GPKG.delete if OUT_GPKG.exist?
system('ogr2ogr', '-f', 'GPKG', OUT_GPKG.to_s, OUT_JSON.to_s, '-nln', 'friedhof', '-a_srs', 'EPSG:4326') \
  or abort 'ogr2ogr ist gescheitert.'
warn "geschrieben: #{OUT_GPKG.basename} — in QGIS auf EPSG:25832 (UTM 32N) umprojizieren, Freiburg liegt in Zone 32."
