# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # atlas/blaetter.csv — the key from a sheet number to a file.
    #
    # Without it the "blaetter" column of register.csv points at nothing: 272
    # entries citing numbers 1 to 9 that appear nowhere else in the repo. The
    # numbers there are derived, not evidenced; see atlas/BLAETTER.md for the
    # reasoning. This class carries that status through to the view rather than
    # flattening it into a plain link.
    class Plates
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree']

      PATH = 'atlas/blaetter.csv'

      Plate = Data.define(:nr, :file, :sources, :status, :note) do
        def numbered? = !nr.nil?
        def derived?  = status == 'abgeleitet'
        def sources_path = sources && "atlas/quellen/#{sources}"
      end

      def all
        tree.parse(PATH, :plates) do |csv|
          Transforms::REGISTER.call(csv).map do |row|
            Plate.new(nr: Transforms.presence(row[:nr])&.to_i,
                      file: row[:datei].to_s,
                      sources: Transforms.presence(row[:quellen]),
                      status: Transforms.presence(row[:status]),
                      note: Transforms.presence(row[:anmerkung]))
          end
        end
      end

      def for_file(file)
        all.bind do |plates|
          hit = plates.find { |p| p.file == file }
          hit ? Success(hit) : Failure([:no_plate_row, file])
        end
      end

      # nr → Plate, for the register's sheet column.
      def by_number
        all.value_or([]).select(&:numbered?).to_h { |p| [p.nr, p] }
      end

      # Sheet numbers cited by register.csv that this table does not map. An open
      # case, listed in the workshop — not silently swallowed. The caller passes
      # the cited numbers instead of this class reaching for the register: the
      # key should not have to know who is using it.
      def unmapped(cited_numbers)
        (cited_numbers - by_number.keys).sort
      end
    end
  end
end
