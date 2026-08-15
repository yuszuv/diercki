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

      # Which heading a table sits under decides what its rows are. A table under
      # a heading not listed here is not a mistake — the file explains its own
      # columns in prose, and prose may carry tables.
      GROUPS = {
        '## Blätter' => :sheets,
        '## Weitere Blätter' => :further,
        '## Präsentationen' => :decks
      }.freeze

      Entry = Data.define(:kennung, :file, :nr, :signature, :sources, :status, :text, :group) do
        def title = File.basename(file).sub(/\.(dc\.)?html\z/, '').tr('-', ' ')
        def slug  = File.basename(file)
        def deck? = group == :decks
        def numbered? = !nr.nil?
        def derived?  = status == 'abgeleitet'
        def sources_path = sources && "atlas/quellen/#{sources}"

        # "relief / Schummerung" → ["relief", "Schummerung"], for the card slot.
        def signature_parts = signature&.split('/', 2)&.map(&:strip)
      end

      def all
        tree.parse(PATH, :contents) do |markdown|
          Transforms.markdown_tables(markdown).flat_map do |table|
            group = GROUPS[table[:heading]]
            group ? table[:rows].filter_map { |row| entry(row, group) } : []
          end
        end
      end

      def cartographic = all.fmap { |list| list.reject(&:deck?) }
      def decks        = all.fmap { |list| list.select(&:deck?) }

      def find(slug) = find_by(slug, reason: :not_listed) { |e, wanted| e.slug == wanted }
      def for_file(file) = find_by(file, reason: :not_listed) { |e, wanted| e.slug == wanted }

      def by_number  = all.value_or([]).select(&:numbered?).to_h { |e| [e.nr, e] }
      def by_kennung = all.value_or([]).to_h { |e| [e.kennung, e] }

      # Sheet numbers register.csv cites that this list does not map.
      def unmapped(cited_numbers) = unmatched(cited_numbers, &:nr).sort

      # Both directions stay visible: a file with no row, and a row with no file.
      # Reading the root directly is the point of having a server at all.
      def open_cases
        list = all.value_or([])
        listed = list.map(&:file).to_set
        present = tree.list('.').value_or([]).reject(&:directory?).map(&:name)

        {
          without_entry: present.select { |n| n.end_with?('.html') && !listed.include?(n) }.sort,
          without_file: list.reject { |e| tree.exist?(e.file) }.map(&:file).sort,
          duplicate_kennung: list.map(&:kennung).tally.select { |_, n| n > 1 }.keys.sort
        }
      end

      private

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
