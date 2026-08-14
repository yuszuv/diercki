#!/usr/bin/env ruby
# frozen_string_literal: true

#
# pruefe-blaetter.rb — does the Blattschlüssel hold up against the sheets?
#
# Creates NOTHING and writes NOTHING. It reports; a human decides whether a row
# in atlas/blaetter.csv moves from "abgeleitet" to "belegt". Same role as
# sync-report.rb and pruefe-hanf.rb, and the same rule from CLAUDE.md: scripts
# may check and report, they do not generate.
#
# The question:
#
#   atlas/register.csv cites numbers 1 to 9 in its "blaetter" column.
#   atlas/blaetter.csv claims which file each number is. That claim is derived,
#   not evidenced (see atlas/BLAETTER.md).
#
#   Here it is cross-checked: if Blatt 6 really is Rumaenien-Wirtschaft.html,
#   then the names carrying the 6 in register.csv must appear on that sheet —
#   and on no other sheet more often.
#
# What the result does NOT say: a high rate does not prove the number, it only
# supports it. A name can appear on several sheets, and a sheet can carry names
# no register entry mentions. A number is only evidenced against the bound volume
# or the draft.
#
# Usage:  ruby bin/pruefe-blaetter.rb
#         ruby bin/pruefe-blaetter.rb --missing   # list the names not found
#
# Ruby >= 3.2, no dependencies.

require 'pathname'

ROOT = Pathname(File.expand_path('..', __dir__))
Dir.chdir(ROOT)

SHOW_MISSING = ARGV.include?('--missing')

# --- Reading ------------------------------------------------------------------
# Semicolon CSV as the rest of the atlas writes it: # comments, then a header.
def semicolon(path)
  rows = Pathname(path).read.lines.reject { |l| l.strip.empty? || l.start_with?('#') }
  head = rows.shift.split(';').map(&:strip)
  rows.map { |r| head.zip(r.split(';', -1).map(&:strip)).to_h }
end

register = semicolon('atlas/register.csv')
key = semicolon('atlas/blaetter.csv')

# --- The catch: sheets spell special characters three ways ---------------------
# A name like "Baziaș" sits in the markup as text, as an HTML entity, or — when
# it comes from a JavaScript data literal — as a \u escape. Searching only for
# the raw form marks down exactly those sheets that draw their labels from data:
# Banat scored 25 % that way instead of its real 58 %.
ENTITIES = { 'ä' => '&auml;', 'ö' => '&ouml;', 'ü' => '&uuml;', 'ß' => '&szlig;',
             'Ä' => '&Auml;', 'Ö' => '&Ouml;', 'Ü' => '&Uuml;' }.freeze

def spellings(name)
  [name,
   name.gsub(/[äöüßÄÖÜ]/, ENTITIES),
   name.unpack('U*').map { |c| c > 127 ? format('\u%04x', c) : c.chr }.join]
end

def carries?(text, name)
  spellings(name).any? { |form| text.include?(form) }
end

# --- The candidates ------------------------------------------------------------
# Every HTML file in the root is a candidate, not just the presumed one:
# otherwise the check would test an assumption against itself.
SHEETS = Pathname('.').children
                      .select { |p| p.file? && p.to_s.end_with?('.html') }
                      .to_h { |p| [p.basename.to_s, p.read] }

puts "Blattschlüssel checked against sheet content — #{SHEETS.size} files searched."
puts 'A high rate supports a number; it does not evidence it.'
puts

header = format('%-3s %-33s %-5s %-7s  %s', 'Nr', 'per blaetter.csv', 'n', 'found', 'best other sheet')
puts header
puts '-' * header.length

weak = []

key.reject { |row| row['nr'].to_s.strip.empty? }
   .sort_by { |row| row['nr'].to_i }
   .each do |row|
  nr = row['nr'].to_i
  file = row['datei']
  names = register.select { |r| r['blaetter'].to_s.split.include?(nr.to_s) }
                  .map { |r| r['name'] }.reject(&:empty?).uniq

  if names.empty?
    puts format('%-3d %-33s %-5s  register.csv never cites this number', nr, file, '—')
    next
  end

  rates = SHEETS.to_h { |name, text| [name, names.count { |n| carries?(text, n) }] }
  own = rates.fetch(file, 0)
  other, other_count = rates.reject { |k, _| k == file }.max_by { |_, v| v }
  percent = 100.0 * own / names.size

  verdict = if rates.values.max > own then '!! another sheet fits better'
            elsif percent >= 70 then 'supports the assignment'
            elsif percent >= 40 then 'weak'
            else '!! does not carry the assignment'
            end
  weak << [nr, file, percent, verdict] if percent < 70 || rates.values.max > own

  puts format('%-3d %-33s %-5d %3d/%-3d  %s (%d) — %s',
              nr, file, names.size, own, names.size, other, other_count, verdict)

  next unless SHOW_MISSING

  absent = names.reject { |n| carries?(SHEETS.fetch(file, ''), n) }
  puts "      not found: #{absent.join(', ')}" unless absent.empty?
end

puts
if weak.empty?
  puts 'Every assignment is supported by the sheet content.'
else
  puts 'Worth a closer look:'
  weak.each { |nr, file, p, v| puts format('  Blatt %d · %s — %.0f %% — %s', nr, file, p, v) }
  puts
  puts 'A low rate does not necessarily mean "wrong". It also means little when a'
  puts 'sheet pulls its labels from a file at runtime — Brandenburg-Klima reads'
  puts 'klima-stationen.csv, so its place names appear nowhere in the markup.'
  puts 'Run with --missing to see which ones.'
end
