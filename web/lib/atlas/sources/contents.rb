# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # atlas/INHALT.md — the one list of what the atlas contains.
    #
    # It replaced four: the three tables in README.md, atlas/blaetter.csv, the
    # hard-wired markup of Inhalt.dc.html and the SIGNATUR table in web/site.js.
    # Only the first two were ever checked against each other, and the gap showed:
    # Deckel-Entwuerfe.dc.html was missing from the contents sheet without anybody
    # noticing.
    #
    # A markdown file and not a CSV, because a list that is also documentation
    # stays honest — the argument the old comment in sheets.rb made for keeping
    # the list in the README, now met without keeping it in two places.
    #
    # The Kennung is the address. It survives a rename and a move; the file path
    # does not, which is why nothing here or anywhere else should key on it.
    class Contents
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree']
      include Atlas::Table

      PATH = 'atlas/INHALT.md'

      # What the Schaukasten shows.
      SHOWN = %i[sheets further].freeze

      # Which heading a table sits under decides what its rows are. A table under
      # a heading not listed here is not a mistake — the file explains its own
      # columns in prose, and prose may carry tables.
      GROUPS = {
        '## Blätter' => :sheets,
        '## Weitere Blätter' => :further,
        '## Laufzeitdateien' => :runtime,
        '## Präsentationen' => :decks
      }.freeze

      Entry = Data.define(:kennung, :file, :nr, :signature, :sources, :status, :text, :group) do
        def title = File.basename(file).sub(/\.(dc\.)?html\z/, '').tr('-', ' ')

        # The published address, and deliberately not the path on disk. A sheet
        # loads its neighbours relatively and the browser resolves against the
        # URL, so the URL space stays flat while the disk is nested. Two entries
        # must therefore not share a slug — open_cases says so if they do.
        def slug  = File.basename(file)
        def deck? = group == :decks
        def numbered? = !nr.nil?
        def derived?  = status == 'abgeleitet'
        def sources_path = sources && "atlas/quellen/#{sources}"

        # "relief / Schummerung" → ["relief", "Schummerung"], for the card slot.
        def signature_parts = signature&.split('/', 2)&.map(&:strip)
      end

      def all
        tables.fmap do |list|
          list.flat_map do |table|
            group = GROUPS[table[:heading]]
            group ? table[:rows].filter_map { |row| entry(row, group) } : []
          end
        end
      end

      # Rows whose cell count does not match their header — a `|` in prose, most
      # likely. Counted per section so the report says where to look.
      def ragged
        tables.value_or([])
              .select { |table| GROUPS[table[:heading]] && table[:ragged].positive? }
              .to_h { |table| [table[:heading].to_s.delete_prefix('## '), table[:ragged]] }
      end

      # The Schaukasten shows sheets, not the runtime files every sheet loads.
      # Named by what it wants rather than by what it rejects: a fifth group
      # would otherwise appear there by accident.
      def cartographic = all.fmap { |list| list.select { |e| SHOWN.include?(e.group) } }
      def decks        = all.fmap { |list| list.select(&:deck?) }

      def find(slug) = find_by(slug, reason: :not_listed) { |e, wanted| e.slug == wanted }
      def for_file(file) = find_by(file, reason: :not_listed) { |e, wanted| e.slug == wanted }

      def by_number  = all.value_or([]).select(&:numbered?).to_h { |e| [e.nr, e] }
      def by_kennung = all.value_or([]).to_h { |e| [e.kennung, e] }

      # Sheet numbers register.csv cites that this list does not map.
      def unmapped(cited_numbers) = unmatched(cited_numbers, &:nr).sort

      # Every direction a gap can point, and none of them silent.
      #
      # stray is the case the move created: an export drops the sheets back into
      # the root, where this list says they belong under blaetter/. That is the
      # normal state after a UI session, not a fault — but unsaid it would mean
      # the application quietly serving the older of two copies.
      def open_cases
        list = all.value_or([])
        listed = list.map(&:file).to_set
        elsewhere = list.reject { |e| e.file == e.slug }.to_h { |e| [e.slug, e.file] }
        root = tree.list('.').value_or([]).reject(&:directory?).map(&:name).select { |n| n.end_with?('.html') }

        {
          without_entry: (root - elsewhere.keys).reject { |n| listed.include?(n) }.sort,
          without_file: list.reject { |e| tree.exist?(e.file) }.map(&:file).sort,
          duplicate_kennung: list.map(&:kennung).tally.select { |_, n| n > 1 }.keys.sort,
          duplicate_slug: list.map(&:slug).tally.select { |_, n| n > 1 }.keys.sort,
          stray: (root & elsewhere.keys).sort,
          ragged: ragged
        }
      end

      # URL → path on disk, for Middleware::Files. Only entries that actually sit
      # somewhere else are in here: a file already at its slug needs no detour.
      def by_slug
        all.value_or([]).reject { |e| e.file == e.slug }.to_h { |e| ["/#{e.slug}", e.file] }
      end

      private

      def tables = tree.parse(PATH, :contents) { |markdown| Transforms.markdown_tables(markdown) }

      def entry(row, group)
        file = Transforms.presence(row['datei'])
        return unless file

        Entry.new(kennung: Transforms.presence(row['kennung']),
                  file: file,
                  nr: Transforms.presence(row['nr'])&.to_i,
                  signature: Transforms.presence(row['signatur']),
                  sources: Transforms.presence(row['quellen']),
                  status: Transforms.presence(row['status']),
                  text: row['inhalt'].to_s,
                  group: group)
      end
    end
  end
end
