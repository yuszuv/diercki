# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # The sheet list is the table in README.md — deliberately not a second list
    # here. Add a sheet and forget the README, and it shows up as an open case
    # rather than quietly appearing or quietly not appearing.
    class Sheets
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree', 'sources.plates', 'sources.register']

      HEADINGS = {
        sheets: '## Blätter',
        further: '## Weitere Blätter',
        decks: '## Präsentationen'
      }.freeze

      Sheet = Data.define(:file, :text, :group) do
        # "Rumaenien-Physisch.html" → "Rumaenien Physisch"
        def title = File.basename(file).sub(/\.(dc\.)?html\z/, '').tr('-', ' ')
        def slug  = File.basename(file)
        def deck? = group == :decks
      end

      def all
        tree.parse('README.md', :sheets) do |markdown|
          HEADINGS.flat_map do |group, heading|
            Transforms.sheets(markdown, heading).map { |row| Sheet.new(**row, group:) }
          end
        end
      end

      def cartographic = all.fmap { |list| list.reject(&:deck?) }
      def decks        = all.fmap { |list| list.select(&:deck?) }

      def find(slug)
        all.bind do |list|
          hit = list.find { |s| s.slug == slug }
          hit ? Success(hit) : Failure([:not_listed, slug])
        end
      end

      # Both directions are documentation faults and both stay visible.
      #
      # Reading the root directory directly is the point of having a server at
      # all — the browser version had to ask nginx for an autoindex JSON to learn
      # the same thing.
      def open_cases
        sheets = all.value_or([])
        listed = sheets.map(&:file).to_set
        present = tree.list('.').value_or([]).reject(&:directory?).map(&:name)

        {
          without_entry: present.select { |n| n.end_with?('.html') && !listed.include?(n) }.sort,
          without_file: sheets.reject { |s| s.file.include?('/') }
                              .reject { |s| tree.exist?(s.file) },
          without_number: plates.unmapped(register.cited_numbers)
        }
      end
    end
  end
end
