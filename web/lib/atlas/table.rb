# frozen_string_literal: true

require 'set'

module Atlas
  # The shape the table readers under sources/ share. They differ in one step —
  # String → Array<Hash> — and agree on the three after it, so the row source is
  # the parameter here, not the file format.
  #
  # A module and not a container component: boot.rb auto-registers everything
  # under sources.* and calls .new without arguments to do it.
  #
  # It never decides the direction a failure falls. Restricted falls closed,
  # every other reader falls open — a core that unified that would turn guarded
  # documents into open ones. Hence both #find_by and #lookup_by, and neither
  # preferred.
  #
  # The macro fits a reader whose list is one table in one file: Plates,
  # Register, Restricted. Sheets and Evidence define #all themselves and use the
  # helpers; Workshop reads directories and is not here at all.
  module Table
    def self.included(base) = base.extend(ClassMethods)

    module ClassMethods
      # Defines #all. The block gets one row hash and returns a struct, or nil to
      # drop the row. It is handed to Tree#parse, whose contract is that it must
      # be pure.
      #
      # @param rows_from [#call] String -> Array<Hash>
      def table(path:, tag:, rows_from:, &build)
        define_method(:all) do
          tree.parse(path, tag) do |text|
            rows_from.call(text).filter_map { |row| build.call(row) }
          end
        end
      end
    end

    # For callers that show why nothing was found; the reason travels as a symbol
    # and Views::REASONS gives it its wording.
    def find_by(key, reason:, &pred)
      all.bind do |list|
        hit = list.find { |item| pred.call(item, key) }
        hit ? Dry::Monads::Success(hit) : Dry::Monads::Failure([reason, key])
      end
    end

    # For callers that decide rather than render. nil means "no entry", but only
    # once the list was read — Restricted has to tell that from "no list" and
    # asks #all itself.
    def lookup_by(&pred) = all.value_or([]).find(&pred)

    # Wanted keys this table does not carry. The other direction is the caller's:
    # only it knows what "exists" means for its keys.
    def unmatched(wanted, &key_of)
      have = all.value_or([]).filter_map(&key_of).to_set
      wanted.reject { |key| have.include?(key) }
    end
  end
end
