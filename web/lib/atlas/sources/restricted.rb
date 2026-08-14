# frozen_string_literal: true

module Atlas
  module Sources
    # Paths that must not get a second address.
    #
    # The host's Caddy guards four paths with a password. It guards ADDRESSES —
    # and this application invents new ones for the same content: /blatt/<file>
    # frames a sheet, /werkstatt/<path> renders a markdown file. Without this
    # check, /werkstatt/recherche/achter-stock-freiburg.md would be the full text
    # at an address the Caddy has never heard of.
    #
    # So: anything listed gets redirected to its original path, where the
    # password prompt lives. The application does not carry a second
    # authentication — one gate, in one place, and this only makes sure no route
    # walks around it.
    #
    # The list is web/nicht-oeffentlich.csv and has to match basicauth.paths in
    # bmeise. Its own header says why, and says which way the error falls.
    class Restricted
      include Atlas::Import['sources.tree']

      PATH = 'web/nicht-oeffentlich.csv'

      Rule = Data.define(:path, :reason)

      def all
        tree.parse(PATH, :rules) do |csv|
          Transforms.rows(csv).filter_map do |row|
            path = Transforms.presence(row[:pfad])
            next unless path

            Rule.new(path: normalise(path), reason: row[:grund].to_s.strip)
          end
        end
      end

      # Fails closed. Every other reader in this application may fall back to an
      # empty list — a missing source register is a visible case, and the page
      # still stands. Not this one: if the list cannot be read, "no rule found"
      # would mean "nothing is guarded", and the guarded research notes would go
      # out in full at an address the Caddy has never heard of.
      #
      # The header of nicht-oeffentlich.csv states which way the error must
      # fall. This is where the code obeys it.
      def restricted?(path) = all.failure? || !rule_for(path).nil?

      # nil for "no rule", but only when the list was actually read. Callers that
      # want to display a reason ask this; callers that decide access ask
      # #restricted? above.
      def rule_for(path)
        wanted = normalise(path)
        all.value_or([]).find { |r| r.path == wanted }
      end

      # Why the list would not read, for the page that has to say so.
      def unreadable = all.failure? ? all : nil

      private

      def normalise(path) = "/#{path.to_s.strip.delete_prefix('/')}"
    end
  end
end
