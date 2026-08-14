# Sternprodukt atlas — delivery and local preview from one image.
#
#   docker compose --profile local up preview   → http://localhost:9293/  (tree from the image)
#   docker compose --profile local up dev       → http://localhost:9292/  (working tree)
#
# One process: Puma serves the Roda application AND the repository tree. There is
# no nginx anymore — the CDN rewriting that lived in its sub_filter blocks is a
# Rack middleware now, reading the same list of nine URLs that bin/vendor.rb
# downloads from. It used to exist three times.
#
# The map sheets themselves are left untouched: they belong to the design project
# and must stay byte-comparable for bin/sync-report.rb. Their CDN references are
# rewritten on the way out, never on disk.

# ---------------------------------------------------------------------------
# 1 · Build: gems and the vendored libraries.
# ---------------------------------------------------------------------------
FROM ruby:3.4-alpine AS build

# build-base for puma's nio4r extension; the rest of the stack is pure Ruby.
# sqlite-dev for the sqlite3 gem, build-base for puma's nio4r extension.
RUN apk add --no-cache build-base sqlite-dev

WORKDIR /build
# BUNDLE_APP_CONFIG points away from the app root on purpose: the dev preview
# bind-mounts the working tree, and the host's .bundle/config there names a
# BUNDLE_PATH inside the repo. Without this, that file would win over the
# variables below and the container would look for its gems in /srv/.bundle.
ENV BUNDLE_PATH=/gems \
    BUNDLE_APP_CONFIG=/gems/.bundle \
    BUNDLE_WITHOUT=test \
    BUNDLE_DEPLOYMENT=1

# .ruby-version comes along: the Gemfile reads it, so bundler needs it here.
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && rm -rf /gems/ruby/*/cache

# The URL list lives in one Ruby file; this reads it. Versions pinned exactly as
# the sheets reference them, and the two SRI hashes are verified here — a
# mismatch would make the browser refuse the script later, without a useful
# message.
COPY web/lib/atlas/vendor.rb web/lib/atlas/vendor.rb
COPY bin/vendor.rb bin/vendor.rb
RUN ruby bin/vendor.rb /opt/vendor

# ---------------------------------------------------------------------------
# 2 · Serve.
# ---------------------------------------------------------------------------
FROM ruby:3.4-alpine

RUN apk add --no-cache tzdata wget sqlite-libs

# The login needs three values and refuses to start without them — a default
# secret is worse than none, because nothing looks broken while it is in place.
# They come from the deploy (bmeise), not from here:
#
#   ATLAS_KONTO           the login name
#   ATLAS_PASSWORT_HASH   ruby -rbcrypt -e 'print [BCrypt::Password.create("…")].pack("m0")'
#                         base64 — docker compose resolves ${…} in every value it
#                         reads, and a bcrypt hash is made of $-fields. Measured:
#                         raw, it arrives mangled and the password silently stops
#                         matching. web/boot.rb refuses to start on a raw one.
#   ATLAS_SESSION_SECRET  ruby -rsecurerandom -e 'print SecureRandom.hex(64)'
#
# There is no database file and no volume: with only :login and :logout enabled
# Rodauth never writes, so the single account lives in an in-memory SQLite seeded
# at boot. See web/auth.rb.
ENV BUNDLE_PATH=/gems \
    BUNDLE_APP_CONFIG=/gems/.bundle \
    BUNDLE_WITHOUT=test \
    BUNDLE_DEPLOYMENT=1 \
    RACK_ENV=production \
    ATLAS_VENDOR_DIR=/opt/vendor \
    LANG=C.UTF-8

COPY --from=build /gems /gems
COPY --from=build /opt/vendor /opt/vendor

WORKDIR /srv
# .dockerignore keeps working material out; what lands here is the tree git knows.
COPY . /srv

# Which commit this image was built from, answerable at /version.
#
# Handed in, because .dockerignore excludes .git. Not derivable from the OCI
# label either: a label cannot be read from inside a running container, which is
# where the question gets asked. Last in the file so a new revision invalidates
# only this layer and not the COPY above it.
ARG ATLAS_REVISION=""
ENV ATLAS_REVISION=$ATLAS_REVISION

# One knob for the port, so there is one number to change rather than four.
# Default 80: the host's Caddy reaches this container as `diercki:80` over the
# shared external web network (bmeise, host_vars for paketzentrum). Moving it
# here means moving it there in the same breath.
#
# Locally nobody meets this number — docker-compose.yml publishes 9292, Rack's
# own default, which is also what `bundle exec puma` binds without a flag.
ENV ATLAS_PORT=80
EXPOSE 80

# 127.0.0.1, not localhost: /etc/hosts maps localhost to ::1 as well, and busybox
# wget tries IPv6 first. The check should not depend on resolver order to say
# whether the site is up.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -qO- "http://127.0.0.1:${ATLAS_PORT}/health" >/dev/null || exit 1

CMD ["sh", "-c", "exec bundle exec puma --bind tcp://0.0.0.0:${ATLAS_PORT} --environment production"]
