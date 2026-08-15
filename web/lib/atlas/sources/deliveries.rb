# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # doku/DATENBEDARF.md — what the atlas is waiting for, and which sheet it
    # would lift.
    #
    # Each entry names its sheet by Kennung since 15.08.2026: `### 1 · … —
    # `rum-braunbaer``. That is the whole reason the Kennung exists — a heading
    # that named the sheet in prose could not be joined to anything.
    #
    # The link is per sheet and not per claim. Which single line a delivery would
    # lift stands in its Wirkung paragraph as prose, and prose is where it stays:
    # claim-level would need a reference inside the Quellenregister rows
    # themselves, which is an editorial change, not a reader.
    class Deliveries
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree']

      PATH = 'doku/DATENBEDARF.md'

      HEADING = /\A###\s+(\d+)\s+·\s+(.+?)\s+—\s+`([a-z0-9-]+)`(.*)\z/
      DONE = /✓/

      Delivery = Data.define(:nr, :title, :kennung, :open) do
        def open? = open
      end

      def all
        tree.parse(PATH, :deliveries) do |markdown|
          Transforms.lines(markdown).filter_map do |line|
            next unless (m = line.strip.match(HEADING))

            Delivery.new(nr: m[1].to_i, title: m[2], kennung: m[3],
                         open: !m[4].match?(DONE))
          end
        end
      end

      def open_deliveries = all.value_or([]).select(&:open?).sort_by(&:nr)

      # Kennung → the still-open deliveries for that sheet.
      def by_kennung = open_deliveries.group_by(&:kennung)
    end
  end
end
