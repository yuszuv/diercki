# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # The evidence standing of the whole atlas: the status lines of the eight
    # Quellenregister, read across the sheets instead of one sheet at a time.
    # App#sheet_sources renders the same files to opaque HTML, where a status is
    # prose; here they are data, so "what in this atlas is unbelegt" has an
    # answer.
    #
    # Two things it deliberately does not do. Status words are not bent onto the
    # three — Nikolais-Ort.md marks a memory as a memory, and a tenth register
    # would bring an eleventh word. And tables are recognised by their header,
    # never by position; see Transforms.markdown_tables for what that prevents.
    class Evidence
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree', 'sources.contents', 'sources.workshop']

      # The vocabulary atlas/quellen/README.md defines. Everything else is real
      # too — it is just not one of these.
      KNOWN = %w[belegt abgeleitet unbelegt].freeze

      # The column that makes a table a claim table. The first column is spelled
      # three ways across the registers and carries no weight here; this one does.
      STATUS = 'status'

      Claim = Data.define(:sheet, :file, :section, :text, :status, :note) do
        def known?     = KNOWN.include?(status)
        def evidenced? = status == 'belegt'
      end

      # A register whose tables carry no status column at all. Not an error and
      # not a claim — a fact about the file that stays visible instead of being
      # silently passed over.
      Skipped = Data.define(:sheet, :file, :section, :columns)

      Reading = Data.define(:claims, :skipped)

      # @return [Dry::Monads::Result<Array<Reading>>] one per sheet that has a register
      def all
        contents.all.fmap do |list|
          list.filter_map { |plate| read(plate) if plate.sources_path }
        end
      end

      def claims  = all.value_or([]).flat_map(&:claims)
      def skipped = all.value_or([]).flat_map(&:skipped)

      # Server-side, like Register#filter: every filtered view is a real address
      # and works without JavaScript.
      def filter(status: nil, sheet: nil)
        claims.select do |claim|
          (status.nil? || status.empty? || claim.status == status) &&
            (sheet.nil? || sheet.empty? || claim.file == sheet)
        end
      end

      # The three first and in their own order, then whatever else the registers
      # carry, alphabetically. Not merged and not renamed — the point is that a
      # seventh word shows up here on its own.
      def statuses
        found = claims.map(&:status).uniq
        (KNOWN & found) + (found - KNOWN).sort
      end

      # Sheet file → counts. The three known words get their own keys so a
      # template can rely on them; anything else lands in :sonstige under its own
      # spelling, which is what keeps a seventh word visible.
      def tally_by_sheet
        claims.group_by(&:file).transform_values { |list| tally(list) }
      end

      def tally_all = tally(claims)

      # Both directions, like Sheets#open_cases. A sheet naming a register that
      # is not there is a broken reference; a register no sheet names is a file
      # nobody reaches. Neither is guessed at.
      def open_cases
        list = contents.all.value_or([])
        named = list.filter_map(&:sources_path).to_set

        {
          # Only the sheets of the bound volume are held to this. The
          # Zeichenerklärung, the QGIS instructions and the Einbandentwürfe carry
          # no claims about the world, so a missing register there is not a gap —
          # listing them would drown the two that are. Nikolais-Ort keeps one
          # without a number, which is allowed and not counted either way.
          without_register: list.select { |p| p.numbered? && p.sources_path.nil? }.map(&:file).sort,
          unreadable: list.select { |p| p.sources_path && !tree.exist?(p.sources_path) }
                          .map(&:sources_path).sort,
          # Workshop already lists the directory; asking it beats writing the path
          # a second time. README.md there is the legend of the vocabulary, not a
          # register — it names no sheet because it describes all of them.
          unclaimed: workshop.source_registers.value_or([])
                             .map(&:path)
                             .reject { |path| named.include?(path) || path.end_with?('README.md') }
                             .sort
        }
      end

      private

      def read(plate)
        tree.parse(plate.sources_path, :evidence) { |text| Transforms.markdown_tables(text) }
            .fmap { |tables| harvest(plate, tables) }
            .value_or(Reading.new(claims: [], skipped: []))
      end

      def harvest(plate, tables)
        claims = []
        skipped = []

        tables.each do |table|
          if table[:header].include?(STATUS)
            claims.concat(claims_from(plate, table))
          else
            skipped << Skipped.new(sheet: title(plate), file: plate.file,
                                   section: section(table), columns: table[:header])
          end
        end

        Reading.new(claims: claims, skipped: skipped)
      end

      def claims_from(plate, table)
        subject = table[:header].first
        note = (table[:header] - [subject, STATUS]).first

        table[:rows].filter_map do |row|
          text = plain(row[subject])
          next if text.empty?

          Claim.new(sheet: title(plate), file: plate.file, section: section(table),
                    text: text, status: plain(row[STATUS]), note: note && plain(row[note]))
        end
      end

      def tally(list)
        counts = list.group_by(&:status).transform_values(&:length)
        known = KNOWN.to_h { |word| [word.to_sym, counts.fetch(word, 0)] }
        known.merge(sonstige: counts.reject { |word, _| KNOWN.include?(word) },
                    gesamt: list.length)
      end

      # Emphasis off, so **unbelegt** and unbelegt are one word rather than two.
      # This is markup cleanup and not vocabulary normalising — the line between
      # them is the whole point of this class, so it is drawn here and nowhere
      # else. Nothing below maps one word onto another.
      def plain(cell) = cell.to_s.gsub(/[*`]/, '').strip

      def section(table) = table[:heading]&.delete_prefix('## ')&.gsub(/[*`]/, '')

      def title(plate) = File.basename(plate.file).sub(/\.(dc\.)?html\z/, '').tr('-', ' ')
    end
  end
end
