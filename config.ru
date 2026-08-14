# frozen_string_literal: true

# The atlas, served.
#
#   bundle exec puma                         local, without Docker
#   docker compose --profile local up dev
#
# The order matters and reads outside in:
#
#   AuthApp         owns /anmelden and /abmelden, puts rodauth into the env
#   Guard           reads web/geschuetzt.csv and demands a login where it says so
#   VendorRewrite   rewrites the nine CDN addresses in whatever comes back,
#                   whether that is a Blatt from disk or a page from the app
#   Files /vendor   the nine libraries themselves, outside the tree
#   Files ROOT      the repository: Blätter, _ds/, atlas/, uploads/
#   App             the addresses the site invents: /, /blaetter, /blatt/…,
#                   /register, /werkstatt
#
# The guard sits ABOVE the file serving on purpose. Two of the guarded paths are
# static files — a deck and a photograph — and a check inside the routing tree
# would never see them, because Files answers first and the request never
# reaches Roda.
#
# Static files win over routes, which is why the application uses no address a
# file could occupy. A Blatt is reached at /Rumaenien-Physisch.html as before —
# every link in every Blatt keeps working — and its framed view at
# /blatt/Rumaenien-Physisch.html.

# .env, for the times nothing else reads it.
#
# docker compose loads this file by itself; `bundle exec puma` does not, and the
# application refuses to start without ATLAS_KONTO and friends. So the documented
# way to run it locally would fail on a machine that has a perfectly good .env
# sitting next to this file.
#
# Read literally: no ${…} resolution, no `export` prefix, no multi-line values.
# That is the same stance as the semicolon CSVs — these files carry none of it,
# and reading them plainly keeps the failure mode obvious if they ever do. It
# also means a value never changes on the way in, which is exactly the mistake
# compose makes with a bcrypt hash.
#
# A variable already in the environment wins. That is what lets CI and the
# container set them without a file, and what lets you override one for a single
# run without editing anything.
env_file = File.expand_path('.env', __dir__)
if File.exist?(env_file)
  File.readlines(env_file, chomp: true).each do |line|
    next if line.strip.empty? || line.strip.start_with?('#')

    key, value = line.split('=', 2)
    next if key.nil? || value.nil?

    ENV[key.strip] ||= value.strip.gsub(/\A(["'])(.*)\1\z/m, '\2')
  end
end

require_relative 'web/app'
require_relative 'web/auth'

Atlas::Container.finalize!

use Rack::CommonLogger unless ENV['RACK_ENV'] == 'test'

# Text only. The tree also hands out PNGs, PDFs and woff2 fonts, all of them
# already compressed — running them through gzip costs time and gains bytes.
textual = %r{\A(text/|image/svg|application/(javascript|json|geo\+json|xml))}
use Rack::Deflater, if: ->(_env, _status, headers, _body) {
  headers['content-type'].to_s.match?(textual)
}

use Atlas::AuthApp
use Atlas::Middleware::Guard

use Atlas::Middleware::VendorRewrite
use Atlas::Middleware::Files, root: Atlas::VENDOR_DIR, prefix: '/vendor',
                              cache: 'public, max-age=2592000, immutable'
use Atlas::Middleware::Files, root: Atlas::ROOT

run Atlas::App.freeze.app
