# frozen_string_literal: true

require 'set'

module Atlas
  # The shape the table readers under sources/ share.
  #
  # They differ in exactly one step — String → Array<Hash> — and agree on the
  # three after it: build a struct per row, find one by key, list what stayed
  # unpaired. So the row source is the parameter here, not the file format:
  # Transforms.rows for the semicolon CSV, Transforms.markdown_table for a
  # markdown table under a heading. A list that wants prose around it can be a
  # .md file without anything here changing.
  #
  # Not a container component, and that is deliberate. web/boot.rb auto-registers
  # everything under sources.* and calls .new without arguments to do it; a
  # parameterised class there would break the boot. Same reason Transforms is a
  # plain module — see the auto_register lambda in boot.rb.
  #
  # What this module must never do is decide the direction a failure falls.
  # Restricted#restricted? falls closed (a list it cannot read means everything
  # is guarded); every other reader falls open to an empty list plus a visible
  # case. A core that unified that would turn guarded documents into open ones.
  # So it offers both #find_by (Result, for callers that display a Fehlfall) and
  # #lookup_by (nil, for callers that make a decision), and picks neither.
  #
  # The macro fits a reader whose list is one table in one file: Plates,
  # Register, Restricted. Sheets builds its list from three sections of README.md
  # and Evidence from one table per sheet across eight files; both define #all
  # themselves and use the helpers below. Workshop reads directories and does not
  # belong here at all.
  module Table
    def self.included(base) = base.extend(ClassMethods)

    module ClassMethods
      # Defines #all. The block gets one row hash and returns a struct, or nil to
      # drop the row — an empty key line is not an error, it is nothing.
      #
      # The block is handed straight to Tree#parse, whose contract is that it
      # must be pure. Keep it that way: it sees a row and nothing else.
      #
      # @param path      [String] repo-relative
      # @param tag       [Symbol] separates two parses of the same file
      # @param rows_from [#call]  String -> Array<Hash>
      def table(path:, tag:, rows_from:, &build)
        define_method(:all) do
          tree.parse(path, tag) do |text|
            rows_from.call(text).filter_map { |row| build.call(row) }
          end
        end
      end
    end

    # For callers that want to show why nothing was found. The reason travels as
    # a symbol and Views::REASONS gives it its wording.
    #
    # @return [Dry::Monads::Result]
    def find_by(key, reason:, &pred)
      all.bind do |list|
        hit = list.find { |item| pred.call(item, key) }
        hit ? Dry::Monads::Success(hit) : Dry::Monads::Failure([reason, key])
      end
    end

    # For callers that make a decision rather than render one. nil means "no
    # entry", but only once the list was actually read — a caller that must
    # distinguish "no rule" from "no list" asks #all itself. Restricted does.
    def lookup_by(&pred) = all.value_or([]).find(&pred)

    # Wanted keys this table does not carry. The other direction — entries
    # pointing at nothing — is the caller's, because only it knows what "exists"
    # means for its keys. Both are documentation faults and both stay visible.
    def unmatched(wanted, &key_of)
      have = all.value_or([]).filter_map(&key_of).to_set
      wanted.reject { |key| have.include?(key) }
    end
  end
end
