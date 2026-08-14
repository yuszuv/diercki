# frozen_string_literal: true

module Atlas
  module Sources
    # Which paths require a login. Read at runtime from web/geschuetzt.csv, whose
    # header explains why it exists and which way its error falls.
    #
    # This class only answers the question. Middleware::Guard asks it — for every
    # request, before the static files are served — and Atlas::AuthApp does the
    # authenticating.
    class Restricted
      include Atlas::Import['sources.tree']

      PATH = 'web/geschuetzt.csv'

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
      # empty list — a missing Quellenregister is a visible case and the page
      # still stands. Not this one: if the list cannot be read, "no rule found"
      # would mean "nothing is guarded", and the guarded documents would go out
      # in full.
      #
      # The header of geschuetzt.csv states which way the error must fall. This
      # is where the code obeys it.
      def restricted?(path) = all.failure? || !rule_for(path).nil?

      # nil for "no rule", but only when the list was actually read. Callers that
      # want to display a reason ask this; callers that decide access ask
      # #restricted? above.
      def rule_for(path)
        wanted = normalise(path)
        all.value_or([]).find { |r| r.path == wanted }
      end

      private

      def normalise(path) = "/#{path.to_s.strip.delete_prefix('/')}"
    end
  end
end
