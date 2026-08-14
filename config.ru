# frozen_string_literal: true

# The atlas, served.
#
#   bundle exec rackup -p 8139       local, without Docker
#   docker compose --profile local up dev
#
# The order matters and reads outside in:
#
#   VendorRewrite   rewrites the nine CDN addresses in whatever comes back,
#                   whether that is a sheet from disk or a page from the app
#   Files /vendor   the nine libraries themselves, outside the tree
#   Files ROOT      the repository: sheets, _ds/, atlas/, uploads/
#   App             the addresses the site invents: /, /blaetter, /blatt/…,
#                   /register, /werkstatt
#
# Static files win over routes, which is why the application uses no address a
# file could occupy. A sheet is reached at /Rumaenien-Physisch.html as before —
# every link in every sheet keeps working — and its framed view at
# /blatt/Rumaenien-Physisch.html.

require_relative 'web/app'

Atlas::Container.finalize!

use Rack::CommonLogger unless ENV['RACK_ENV'] == 'test'

# Text only. The tree also hands out PNGs, PDFs and woff2 fonts, all of them
# already compressed — running them through gzip costs time and gains bytes.
textual = %r{\A(text/|image/svg|application/(javascript|json|geo\+json|xml))}
use Rack::Deflater, if: ->(_env, _status, headers, _body) {
  headers['content-type'].to_s.match?(textual)
}
use Atlas::Middleware::VendorRewrite
use Atlas::Middleware::Files, root: Atlas::VENDOR_DIR, prefix: '/vendor',
                              cache: 'public, max-age=2592000, immutable'
use Atlas::Middleware::Files, root: Atlas::ROOT

run Atlas::App.freeze.app
