#!/usr/bin/env ruby
# frozen_string_literal: true

#
# sync-report.rb — compare the clone against a ZIP export of the Claude design project.
#
# Creates NOTHING and writes NOTHING. It reports; a human decides what to carry over —
# the same split as pruefe-hanf.rb, and the rule from CLAUDE.md: scripts may check and
# report, they do not generate.
#
# Usage:  ruby bin/sync-report.rb                # newest ZIP in wip/
#         ruby bin/sync-report.rb path/to.zip
#         ruby bin/sync-report.rb --diff         # add text diffs for DIFFERENT
#         ruby bin/sync-report.rb --only DIFFERENT
#
# Needs: unzip, diff (only with --diff)
#
# Why this route exists: a full comparison through DesignSync get_file is the expensive
# dead end — 256 KiB cap, silent truncation, and the detour through a model context
# normalises invisible characters. The ZIP is byte-exact and complete. The procedure is
# documented in README under "Arbeiten an zwei Orten".
#

require 'tmpdir'
require 'digest'
require 'set'

ROOT = File.expand_path('..', __dir__)
Dir.chdir(ROOT)

# --- Ownership per path ------------------------------------------------------
# Who wins on a difference. Ground rule: when in doubt the clone leads. The
# exceptions are the files drawn in the design UI — that is where the preview and
# the bound design system live, and editing them locally means carrying them back
# by hand.
OWNERSHIP = [
  # [pattern, owner, reason in half a sentence]
  [%r{\A_ds/},                          :design_system, 'comes from the design-system project'],

  # The design seam of the web application. Both are ordinary files the UI can
  # open and draw: the stylesheet, and the pattern sheet that shows every
  # building block once. The ERB templates below stay local and mirror their
  # class names — one file, one owner, no argument.
  [%r{\Aweb/(site\.css|Muster\.dc\.html)\z}, :ui, 'the design seam of the web edition'],

  # docker-compose.yml, not compose.yaml: the file is called the former, and the
  # pattern used to name the latter — so it never matched and fell through to
  # the default. Same outcome, but for no reason anyone could see.
  [%r{\A(web/|Dockerfile|docker-compose\.yml|config\.ru|Gemfile|\.ruby-version|\.dockerignore|bin/|test/)},
   :local, 'the UI does not know it'],

  # Written in the design UI, imported wholesale in d5666a4. Without a rule of
  # its own it fell through to "when in doubt the clone leads", which is the
  # wrong side for a file nothing here writes.
  [%r{\Aatlas/register\.csv\z},         :ui,    'the name register is maintained in the design UI'],
  [%r{\Ahandarbeit/},                   :local, 'only the human writes here'],
  [%r{\Aatlas/geodaten/},               :local, 'needs GDAL and raw data'],
  [%r{\Aatlas/qgis/},                   :local, 'QGIS reads and writes these'],
  [%r{\Aatlas/(signaturen|farben|typenscale)\.js\z}, :ui, 'part of the drawing pass'],
  [%r{\Aatlas/quellen/},                :local, 'sourcing work happens here'],
  [%r{\Arecherche/},                    :local, 'notes are written here'],
  [%r{\.dc\.html\z},                    :ui,    'drawn in the design UI'],
  [%r{\A[^/]+\.html\z},                 :ui,    'map sheet, drawn in the design UI'],
  [%r{\Apraesentationen/},              :ui,    'decks are built in the design UI'],
  [%r{\A(README|CLAUDE|AGENTS|IDEEN|DATENBEDARF|github)\.md\z}, :local, 'describes the clone'],
].freeze

def ownership(path)
  OWNERSHIP.each { |pattern, who, why| return [who, why] if path.match?(pattern) }
  [:local, 'no rule of its own — when in doubt the clone leads']
end

# --- What is not compared at all ---------------------------------------------
# Working stores and raw deliveries. Neither side has a claim on them.
SKIP = [
  %r{\A\.git/}, %r{\A\.claude/}, %r{\A\.ruby-lsp/}, %r{\Awip/},
  %r{\.(gpkg|zip|inhalt|osm\.pbf|dat)\z},
  %r{\Aatlas/geodaten/brandenburg/(clc5_2018|landnutzung\.geojson)},
  %r{ne_10m_},                        # Natural Earth raw delivery, the script refetches it
  %r{\A(screenshots)/(?!vorschau-|katzundgoldt-)},
  %r{\A\.DS_Store\z}, %r{Thumbs\.db\z},
].freeze

def skip?(path)
  SKIP.any? { |m| path.match?(m) }
end

def files_under(root)
  Dir.chdir(root) do
    Dir.glob('**/*', File::FNM_DOTMATCH)
       .reject { |p| File.directory?(p) }
       .reject { |p| p.end_with?('/.', '/..') }
       .reject { |p| skip?(p) }
       .to_set
  end
end

# --- Arguments ---------------------------------------------------------------
args     = ARGV.dup
withdiff = args.delete('--diff')
only     = (i = args.index('--only')) ? args.delete_at(i + 1)&.upcase : nil
args.delete('--only')
zip = args.first || Dir.glob('wip/*.zip').max_by { |f| File.mtime(f) }

abort 'No ZIP found. Put the export in wip/ or pass a path.' if zip.nil? || !File.exist?(zip)
abort 'unzip missing (apt install unzip)' unless system('command -v unzip >/dev/null')

puts "Export : #{zip}  (#{File.mtime(zip).strftime('%F %H:%M')}, #{(File.size(zip) / 1024.0 / 1024).round(1)} MB)"
puts "Clone  : #{ROOT}"
puts

Dir.mktmpdir('sync-report') do |tmp|
  system('unzip', '-q', '-o', File.expand_path(zip), '-d', tmp) or abort 'unzip failed'

  # Some exports wrap everything in a single top-level folder.
  entries = Dir.children(tmp)
  base    = (entries.size == 1 && File.directory?(File.join(tmp, entries.first))) ? File.join(tmp, entries.first) : tmp

  there = files_under(base)
  here  = files_under(ROOT)

  same, different, only_here, only_there = [], [], [], []

  (there & here).each do |p|
    a = File.join(base, p)
    b = File.join(ROOT, p)
    if File.size(a) == File.size(b) && Digest::SHA256.file(a) == Digest::SHA256.file(b)
      same << p
    else
      different << p
    end
  end
  only_here  = (here - there).to_a
  only_there = (there - here).to_a

  size = ->(n) { n < 1024 ? "#{n} B" : "#{(n / 1024.0).round} KB" }

  section = lambda do |title, list, &block|
    next if only && !title.start_with?(only)
    puts "-- #{title}  (#{list.size})"
    list.empty? ? puts('   none') : list.sort.each(&block)
    puts
  end

  unless only
    puts "SAME: #{same.size} files"
    puts
  end

  section.call('DIFFERENT — on both sides, but not equal', different) do |p|
    who, why = ownership(p)
    mark = { local: 'clone wins', ui: 'EXPORT wins', design_system: 'design system' }[who]
    puts format('   %-14s %-56s here %8s / there %8s  — %s',
                mark, p, size.(File.size(File.join(ROOT, p))), size.(File.size(File.join(base, p))), why)
  end

  section.call('ONLY LOCAL — in the clone, not in the export', only_here) do |p|
    who, why = ownership(p)
    hint = who == :local ? 'as intended' : 'CHECK: should this be in the UI?'
    puts format('   %-40s %8s  — %s (%s)', p, size.(File.size(File.join(ROOT, p))), hint, why)
  end

  section.call('ONLY IN EXPORT — there, not in the clone', only_there) do |p|
    puts format('   %-40s %8s  — missing here, probably to be adopted', p, size.(File.size(File.join(base, p))))
  end

  if withdiff && !different.empty?
    puts '-- Text diffs (DIFFERENT only, text files only)'
    different.sort.each do |p|
      next unless File.extname(p).match?(/\.(md|txt|css|js|html|json|csv|rb|sh|qml|svg|geojson)\z/)
      next if File.size(File.join(ROOT, p)) > 200_000
      puts "\n   ##### #{p}"
      system('diff', '-u', '--label', "there/#{p}", '--label', "here/#{p}",
             File.join(base, p), File.join(ROOT, p))
    end
    puts
  end

  puts '-' * 70
  puts "SAME #{same.size} · DIFFERENT #{different.size} · ONLY LOCAL #{only_here.size} · ONLY IN EXPORT #{only_there.size}"
  puts
  puts 'Nothing was changed. What gets adopted is your call — the rule is in README,'
  puts 'section "Arbeiten an zwei Orten": when in doubt the clone leads, except for the'
  puts 'files that are drawn in the design UI.'
end
