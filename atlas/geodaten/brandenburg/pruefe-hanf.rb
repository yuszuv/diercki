#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Sternprodukt atlas · hemp check — prüft sorten.csv gegen den Schlagauszug hanf-<jahr>.geojsonl.
#
# Erzeugt NICHTS. Die Sortenzuordnung ist bewusst kein Build-Schritt: das
# Kartenblatt liest hanf-<jahr>.geojsonl und sorten.csv zur Laufzeit, QGIS
# verknüpft dieselbe CSV als Attributverknüpfung. Eine abgeleitete Datei gäbe es
# nur, damit sie still veralten kann.
#
# Dieses Skript beantwortet drei Fragen, wenn man sie stellen will:
#   1. Welche Sorten stehen in den Daten, aber nicht in sorten.csv?
#   2. Welche Zeilen in sorten.csv sind tote Fracht?
#   3. Wie viel Fläche hängt an ungeklärten Zeilen — lohnt die Recherche?
#
#     ruby pruefe-hanf.rb
#
# Ruby >= 3.2, keine Abhängigkeiten.

require 'json'
require 'csv'
require 'pathname'

Dir.chdir(__dir__)

JAHRE  = Pathname.glob('hanf-*.geojsonl').sort
SORTEN = Pathname('sorten.csv')

abort "fehlt: sorten.csv in #{__dir__}" unless SORTEN.exist?
abort "fehlt: hanf-<jahr>.geojsonl in #{__dir__}" if JAHRE.empty?

utf8 = ->(s) { s.encode('UTF-8', 'Windows-1252', invalid: :replace, undef: :replace) }

katalog = CSV.read(SORTEN, headers: true, col_sep: ';', encoding: 'UTF-8')
  .to_h { |r| [r['sorte'], { gruppe: r['gruppe'].to_s.strip, status: r['status'].to_s.strip }] }

schlaege = JAHRE.flat_map do |pfad|
  pfad.each_line.reject { _1.strip.empty? }.map do |zeile|
    p = JSON.parse(utf8.(zeile))['properties']
    { jahr: p['antragjahr'], sorte: p['sorte_bez'].to_s, ha: p['groesse'].to_f }
  end
end

fehlend = schlaege.reject { katalog.key?(_1[:sorte]) }
tot     = katalog.keys - schlaege.map { _1[:sorte] }.uniq
offen   = schlaege.select { katalog[_1[:sorte]]&.dig(:gruppe).to_s.empty? }

puts "#{schlaege.size} Schläge, #{format('%.1f', schlaege.sum { _1[:ha] })} ha " \
     "aus #{JAHRE.map(&:basename).join(', ')}"

schlaege.group_by { _1[:jahr] }.sort.each do |jahr, fs|
  puts "\n#{jahr}:"
  fs.group_by { katalog[_1[:sorte]]&.dig(:gruppe).to_s }
    .sort_by { |g, _| g.empty? ? 'zzz' : g }
    .each do |g, gs|
      puts format('  %-14s %2d Schläge, %6.1f ha   %s', g.empty? ? '(ungeklärt)' : g,
                  gs.size, gs.sum { _1[:ha] }, gs.map { _1[:sorte] }.uniq.sort.join(', '))
    end
end

unless fehlend.empty?
  puts "\n⚠ nicht in sorten.csv — werden als ungeklärt gezeichnet, Zeile ergänzen:"
  fehlend.group_by { _1[:sorte] }.sort_by { -_2.sum { |s| s[:ha] } }
    .each { |s, fs| puts format('    %-16s %2d Schläge, %6.1f ha', s, fs.size, fs.sum { _1[:ha] }) }
end

puts "\nZeilen ohne Schlag in den Daten (unschädlich): #{tot.join(', ')}" unless tot.empty?

unless offen.empty?
  ha = offen.sum { _1[:ha] }
  anteil = 100.0 * ha / schlaege.sum { _1[:ha] }
  puts format("\nUngeklärte Nutzungsrichtung: %.1f ha (%.0f %% der Fläche). Größte Posten zuerst:", ha, anteil)
  offen.group_by { _1[:sorte] }.sort_by { -_2.sum { |s| s[:ha] } }.first(5)
    .each { |s, fs| puts format('    %-16s %6.1f ha', s, fs.sum { _1[:ha] }) }
end
