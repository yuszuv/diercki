# frozen_string_literal: true

module Atlas
  # The nine libraries the sheets would otherwise pull from unpkg and jsDelivr.
  #
  # THIS IS THE ONLY LIST. bin/vendor.rb downloads from it, the rewrite
  # middleware substitutes from it, and the Dockerfile calls bin/vendor.rb. It
  # used to exist three times — twice in nginx.conf and once as a shell function
  # in the Dockerfile — which is two chances to update eight of nine.
  #
  # Why serve them ourselves at all:
  #   · the preview works without a network,
  #   · visitors' IP addresses do not go to third parties,
  #   · deutschlandGeoJSON@main is a moving target, and what a finished sheet
  #     loads should not change underneath it.
  #
  # Why EXACT URLs and never a host prefix: a prefix rule would rewrite any
  # unpkg URL, so bumping d3 to 7.10 upstream would produce a /vendor path that
  # is not in the image and the sheet would break with a 404. Matching exactly
  # means an unvendored version keeps loading from the CDN — it degrades to the
  # status quo instead of failing. A source note citing a CDN URL in an href
  # stays a working citation for the same reason.
  module Vendor
    # remote URL => path below the vendor directory, served as /vendor/<path>
    LIBRARIES = {
      'https://unpkg.com/d3@7.9.0/dist/d3.min.js' =>
        'unpkg/d3@7.9.0/dist/d3.min.js',
      'https://unpkg.com/topojson-client@3.1.0/dist/topojson-client.min.js' =>
        'unpkg/topojson-client@3.1.0/dist/topojson-client.min.js',
      'https://unpkg.com/react@18.3.1/umd/react.production.min.js' =>
        'unpkg/react@18.3.1/umd/react.production.min.js',
      'https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js' =>
        'unpkg/react-dom@18.3.1/umd/react-dom.production.min.js',
      'https://unpkg.com/@babel/standalone@7.24.7/babel.min.js' =>
        'unpkg/@babel/standalone@7.24.7/babel.min.js',
      'https://unpkg.com/@babel/standalone@7.29.0/babel.min.js' =>
        'unpkg/@babel/standalone@7.29.0/babel.min.js',
      'https://cdn.jsdelivr.net/npm/world-atlas@2.0.2/countries-50m.json' =>
        'jsdelivr/npm/world-atlas@2.0.2/countries-50m.json',
      'https://cdn.jsdelivr.net/gh/isellsoap/deutschlandGeoJSON@main/2_bundeslaender/3_mittel.geo.json' =>
        'jsdelivr/gh/isellsoap/deutschlandGeoJSON@main/2_bundeslaender/3_mittel.geo.json',
      'https://cdn.jsdelivr.net/gh/isellsoap/deutschlandGeoJSON@main/4_kreise/4_niedrig.geo.json' =>
        'jsdelivr/gh/isellsoap/deutschlandGeoJSON@main/4_kreise/4_niedrig.geo.json'
    }.freeze

    # Two sheets carry integrity attributes next to these scripts. Verify at
    # download time rather than hope: a mismatch would make the browser refuse
    # the script later, without a useful message.
    INTEGRITY = {
      'unpkg/d3@7.9.0/dist/d3.min.js' =>
        'sha384-CjloA8y00+1SDAUkjs099PVfnY2KmDC2BZnws9kh8D/lX1s46w6EPhpXdqMfjK6i',
      'unpkg/topojson-client@3.1.0/dist/topojson-client.min.js' =>
        'sha384-Ukv1p/xTma6P4/2bY5KzWBw+ydSpXmhCMtyciIQVDJ1RmOxtCYNMF1uXT9T63H67'
    }.freeze

    # remote URL => the address the browser should ask for instead
    REWRITES = LIBRARIES.transform_values { |path| "/vendor/#{path}" }.freeze

    def self.integrity_for(path)
      require 'digest'
      require 'base64'
      "sha384-#{Base64.strict_encode64(Digest::SHA384.file(path).digest)}"
    end
  end
end
