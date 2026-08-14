# frozen_string_literal: true

module Atlas
  module Middleware
    # Decides which paths need a login. AuthApp knows how to authenticate;
    # this knows what is private, and that is an editorial list, not a mechanism.
    #
    # It sits between AuthApp and the static file serving, so it covers
    # everything below it: the Blätter, the images under uploads/, the rendered
    # Werkstatt documents, and any route added later. That placement is the whole
    # point — the guarded set contains static files, and a check inside the
    # routing tree would never reach them.
    #
    # It replaces a Caddy basicauth block plus a list of "do not invent a second
    # address for this" in the application. One list now, in web/geschuetzt.csv.
    class Guard
      def initialize(app, restricted: nil)
        @app = app
        @restricted = restricted
      end

      def call(env)
        path = Rack::Utils.unescape(env['PATH_INFO'].to_s)
        return @app.call(env) unless guarded?(path)

        rodauth = env['rodauth']
        raise 'Guard läuft ohne AuthApp davor — siehe config.ru' if rodauth.nil?

        # require_authentication throws :halt with a finished Rack response when
        # nobody is logged in. Inside a Roda app that throw is caught for you;
        # this is plain Rack, so the catch has to be here. Letting Rodauth build
        # the response rather than redirecting by hand keeps its return-to
        # handling: after logging in you land where you were going.
        halted = catch(:halt) do
          rodauth.require_authentication
          nil
        end

        halted || @app.call(env)
      end

      private

      # Both the address itself and any derived one. /blatt/X and /werkstatt/X
      # show the content of X, so they inherit its guard — otherwise the
      # application would hand out at a second address what it locks at the
      # first.
      #
      # Canonicalise BEFORE stripping the prefixes, and both times. A guard that
      # compares spellings guards nothing: "/./werkstatt/x" survives a plain
      # delete_prefix('/werkstatt'), and "/uploads/./x.png" never matched at all
      # while Rack::Files below happily served it.
      def guarded?(path)
        clean = canonical(path)

        restricted.restricted?(clean) ||
          restricted.restricted?(canonical(clean.delete_prefix('/blatt'))) ||
          restricted.restricted?(canonical(clean.delete_prefix('/werkstatt')))
      end

      def canonical(path)
        Pathname("/#{path.to_s.delete_prefix('/')}").cleanpath.to_s
      end

      def restricted = @restricted || Container['sources.restricted']
    end
  end
end
