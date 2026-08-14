# Sternprodukt atlas — delivery and local preview from one image.
#
#   docker compose --profile local up preview   → http://localhost:8137/  (tree from the image)
#   docker compose --profile local up dev       → http://localhost:8138/  (working tree)
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
RUN apk add --no-cache build-base

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

RUN apk add --no-cache tzdata wget

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

# Port 80, not something higher: the host's Caddy reaches this container as
# `diercki:80` over the shared external web network (bmeise, host_vars for
# paketzentrum). Moving it here would mean moving it there too.
EXPOSE 80

# 127.0.0.1, not localhost: /etc/hosts maps localhost to ::1 as well, and busybox
# wget tries IPv6 first. The check should not depend on resolver order to say
# whether the site is up.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget -qO- http://127.0.0.1/health >/dev/null || exit 1

CMD ["bundle", "exec", "puma", "--bind", "tcp://0.0.0.0:80", "--environment", "production"]
