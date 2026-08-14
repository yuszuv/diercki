# frozen_string_literal: true

require 'dry/monads'

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
      include Dry::Monads[:result]
      include Atlas::Import['sources.tree']

      PATH = 'web/nicht-oeffentlich.csv'

      Rule = Data.define(:path, :reason)

      def all
        tree.parse(PATH, :rules) do |csv|
          Transforms::REGISTER.call(csv).filter_map do |row|
            pfad = Transforms.presence(row[:pfad])
            next unless pfad

            Rule.new(path: normalise(pfad), reason: row[:grund].to_s.strip)
          end
        end
      end

      def restricted?(path) = !rule_for(path).nil?

      def rule_for(path)
        wanted = normalise(path)
        all.value_or([]).find { |r| r.path == wanted }
      end

      private

      def normalise(path) = "/#{path.to_s.strip.delete_prefix('/')}"
    end
  end
end
