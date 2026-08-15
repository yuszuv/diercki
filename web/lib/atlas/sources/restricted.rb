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
      include Atlas::Table

      PATH = 'web/geschuetzt.csv'

      Rule = Data.define(:path, :reason)

      # normalise is an instance method, so the block cannot call it — it runs
      # inside Tree#parse with nothing but the row, which is the contract. Hence
      # the module function.
      table(path: PATH, tag: :rules, rows_from: Transforms.method(:rows)) do |row|
        path = Transforms.presence(row[:pfad])

        Rule.new(path: Restricted.normalise(path), reason: row[:grund].to_s.strip) if path
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
        wanted = Restricted.normalise(path)
        lookup_by { |r| r.path == wanted }
      end

      # The identity of a path, not the way it was spelled.
      #
      # This used to be strip + delete_prefix, and that was a hole: Sources::Tree
      # canonicalises before it reads, so "/recherche/./x.md" and "/recherche/x.md"
      # are the same file to the reader and were two different strings to the
      # guard. Nine spellings of the four guarded paths answered 200 without a
      # login — measured, not feared.
      #
      # A module function because both sides need it: #rule_for on an instance,
      # and the row block, which has no instance to ask.
      def self.normalise(path)
        Pathname("/#{path.to_s.strip.delete_prefix('/')}").cleanpath.to_s
      end
    end
  end
end
