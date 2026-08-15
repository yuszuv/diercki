# frozen_string_literal: true

require 'rack'
require 'rack/files'

module Atlas
  module Middleware
    # Serves the repository tree. What nginx used to do, minus the second config
    # language.
    #
    # Two instances are mounted: one for the tree, one for the vendored
    # libraries under /vendor. Anything this does not serve falls through to the
    # Roda application, which owns the addresses the site itself invents.
    class Files
      # Extensions the atlas actually hands out, measured against what the
      # sheets fetch at runtime plus what the documentation links to.
      #
      # An allowlist rather than "serve whatever is there": the dev preview
      # bind-mounts the working tree, and next to 17 MB of map data sit 23 GB of
      # raw deliveries — CLC packages, .osm.pbf, GeoPackages — that no sheet
      # asks for. They are ignored by git for the same reason.
      SERVABLE = %w[
        html css js mjs jsx json geojson geojsonl topojson csv dat txt md
        png jpg jpeg gif webp svg ico pdf
        woff woff2 ttf otf eot
        gpl qml qpt
      ].to_set.freeze

      # nginx got these by appending to /etc/nginx/mime.types with sed. Rack's
      # table knows csv, woff2 and the image formats already; these are the ones
      # peculiar to this tree.
      ADDITIONAL_TYPES = {
        '.geojson' => 'application/geo+json',
        '.topojson' => 'application/json',
        '.geojsonl' => 'application/geo+json-seq',
        '.dat' => 'text/plain',
        '.md' => 'text/markdown',
        '.gpl' => 'text/plain',
        '.qml' => 'application/xml',
        '.qpt' => 'application/xml',
        '.jsx' => 'text/javascript'
      }.freeze

      Rack::Mime::MIME_TYPES.merge!(ADDITIONAL_TYPES)

      # @param prefix [String, nil] URL prefix to strip, e.g. "/vendor"
      # @param cache [String] Cache-Control for what this instance serves
      # @param contents [#by_slug, nil] the one list, for the flat URL space
      def initialize(app, root:, prefix: nil, cache: 'no-cache', contents: nil)
        @app = app
        @prefix = prefix
        @cache = cache
        @contents = contents
        @files = Rack::Files.new(root.to_s)
      end

      def call(env)
        path = path_for(env)
        return @app.call(env) unless path && servable?(path)

        status, headers, body = @files.call(env.merge('PATH_INFO' => path))
        return @app.call(env) if status == 404

        headers['cache-control'] = @cache
        headers['content-type'] = with_charset(headers['content-type'])
        [status, headers, body]
      end

      private

      # Three ways a URL becomes a path. /vendor strips its prefix; a sheet is
      # looked up in atlas/INHALT.md; everything else is served where it lies.
      #
      # The lookup is what keeps the URL space flat while the disk is nested.
      # A sheet loads its neighbours relatively and the browser resolves against
      # the URL, so /Rumaenien-Verkehr.html has to stay that address no matter
      # which directory the file sits in. web/geschuetzt.csv guards the same
      # addresses and needs no line changed for the same reason.
      def path_for(env)
        path = env['PATH_INFO'].to_s
        return @contents&.by_slug&.fetch(path, path) || path unless @prefix

        return nil unless path.start_with?("#{@prefix}/")

        path.delete_prefix(@prefix)
      end

      def servable?(path)
        ext = ::File.extname(path).delete_prefix('.').downcase
        SERVABLE.include?(ext)
      end

      # The tree is UTF-8 throughout — Romanian diacritics in the sheets, German
      # in everything else. Without saying so, a browser guesses latin-1 for
      # text/csv and the register turns to mojibake.
      def with_charset(type)
        return type if type.nil? || type.include?('charset') || !textual?(type)

        "#{type}; charset=utf-8"
      end

      def textual?(type)
        type.start_with?('text/') ||
          type.match?(%r{\Aapplication/(javascript|json|geo\+json|xml)})
      end
    end
  end
end
