# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # atlas/register.csv — the name register of the bound volume. 272 entries,
    # each with the sheets it appears on and its own source status.
    #
    # The file comes from the design UI (commit d5666a4) and is maintained by
    # hand there. Nothing here writes to it.
    class Register
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree']

      PATH = 'atlas/register.csv'

      # The kinds are listed in the header comment of register.csv —
      # incompletely, though: the file also carries pass, grosslandschaft and
      # stausee. A kind that is missing here is not swallowed, it is shown raw.
      KIND_LABEL = {
        'hauptstadt' => 'Hauptstadt', 'stadt' => 'Stadt', 'ort' => 'Ort',
        'gipfel' => 'Gipfel', 'gebirge' => 'Gebirge',
        'grosslandschaft' => 'Großlandschaft', 'landschaft' => 'Landschaft',
        'fluss' => 'Fluss', 'stausee' => 'Stausee', 'park' => 'Park',
        'pass' => 'Pass', 'bahnhof' => 'Bahnhof', 'haltestelle' => 'Haltestelle',
        'klimastation' => 'Klimastation', 'strecke' => 'Strecke',
        'energie' => 'Energie', 'kreis' => 'Kreis',
        'trachtgebiet' => 'Trachtgebiet', 'begegnung' => 'Begegnung',
        'verweis' => 'Verweis'
      }.freeze

      STATUSES = %w[belegt abgeleitet unbelegt].freeze

      # Only sheet 4 carries a search grid — the header comment of register.csv
      # says so, and all 86 field values sit there. Reporting "Feld offen" for
      # the other entries would claim an absence that is not one.
      GRID_SHEET = 4

      Entry = Data.define(:name, :variant, :kind, :numbers, :field, :value, :status, :note) do
        def kind_label = KIND_LABEL.fetch(kind, kind)
        def on_grid_sheet? = numbers.include?(GRID_SHEET)
        def field_open? = field.nil? && on_grid_sheet?

        def matches?(query)
          return true if query.nil? || query.empty?

          needle = query.downcase
          name.downcase.include?(needle) || variant.to_s.downcase.include?(needle)
        end
      end

      def all
        tree.parse(PATH, :entries) do |csv|
          Transforms::REGISTER.call(csv).filter_map do |row|
            name = Transforms.presence(row[:name])
            next unless name

            Entry.new(name: name,
                      variant: Transforms.presence(row[:variante]),
                      kind: row[:art].to_s.strip,
                      numbers: row[:blaetter].to_s.split.map(&:to_i),
                      field: Transforms.presence(row[:feld]),
                      value: Transforms.presence(row[:wert]),
                      status: Transforms.presence(row[:status]) || 'unbelegt',
                      note: Transforms.presence(row[:anmerkung]))
          end
        end
      end

      # Server-side filtering: the form works without JavaScript, and every
      # filtered view is a real, linkable address.
      def filter(query: nil, kind: nil, status: nil)
        all.fmap do |entries|
          entries.select do |e|
            e.matches?(query) &&
              (kind.nil? || kind.empty? || e.kind == kind) &&
              (status.nil? || status.empty? || e.status == status)
          end
        end
      end

      def kinds = all.value_or([]).map(&:kind).reject(&:empty?).uniq.sort

      # Entries appearing on one sheet, for the sheet view's side column.
      def for_plate(nr)
        return [] if nr.nil?

        all.value_or([]).select { |e| e.numbers.include?(nr) }
      end

      def cited_numbers = all.value_or([]).flat_map(&:numbers).uniq.sort
    end
  end
end
