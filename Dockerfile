# Sternprodukt atlas — delivery and local preview from one image.
#
#   docker compose up atlas   → http://localhost:8137/  (tree baked into the image)
#   docker compose up dev     → http://localhost:8138/  (working tree bind-mounted)
#
# The atlas is static: no build step, no runtime beyond nginx. The only build work is
# vendoring the libraries the sheets would otherwise pull from unpkg and jsDelivr.
# The sheets themselves are left untouched — they belong to the design project and
# must stay byte-comparable for the sync; nginx rewrites the URLs on the way out
# (see web/nginx.conf).

# ---------------------------------------------------------------------------
# 1 · Vendor the libraries. Versions pinned exactly as the sheets reference them —
#     changing one here breaks the integrity hashes that sit next to them.
# ---------------------------------------------------------------------------
FROM alpine:3.20 AS vendor
RUN apk add --no-cache curl openssl

WORKDIR /vendor
RUN set -eux; \
    dl() { mkdir -p "$(dirname "$2")"; curl -fsSL --retry 3 -o "$2" "$1"; }; \
    \
    dl https://unpkg.com/d3@7.9.0/dist/d3.min.js \
       unpkg/d3@7.9.0/dist/d3.min.js; \
    dl https://unpkg.com/topojson-client@3.1.0/dist/topojson-client.min.js \
       unpkg/topojson-client@3.1.0/dist/topojson-client.min.js; \
    dl https://unpkg.com/react@18.3.1/umd/react.production.min.js \
       unpkg/react@18.3.1/umd/react.production.min.js; \
    dl https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js \
       unpkg/react-dom@18.3.1/umd/react-dom.production.min.js; \
    dl https://unpkg.com/@babel/standalone@7.24.7/babel.min.js \
       'unpkg/@babel/standalone@7.24.7/babel.min.js'; \
    dl https://unpkg.com/@babel/standalone@7.29.0/babel.min.js \
       'unpkg/@babel/standalone@7.29.0/babel.min.js'; \
    \
    dl https://cdn.jsdelivr.net/npm/world-atlas@2.0.2/countries-50m.json \
       jsdelivr/npm/world-atlas@2.0.2/countries-50m.json; \
    dl https://cdn.jsdelivr.net/gh/isellsoap/deutschlandGeoJSON@main/2_bundeslaender/3_mittel.geo.json \
       jsdelivr/gh/isellsoap/deutschlandGeoJSON@main/2_bundeslaender/3_mittel.geo.json; \
    dl https://cdn.jsdelivr.net/gh/isellsoap/deutschlandGeoJSON@main/4_kreise/4_niedrig.geo.json \
       jsdelivr/gh/isellsoap/deutschlandGeoJSON@main/4_kreise/4_niedrig.geo.json

# Two sheets carry integrity attributes. Verify rather than hope: a mismatch would
# make the browser refuse the script later, without a useful message.
RUN set -eux; \
    check() { \
      actual="sha384-$(openssl dgst -sha384 -binary "$1" | openssl base64 -A)"; \
      [ "$actual" = "$2" ] || { echo "SRI mismatch for $1"; echo "  expected: $2"; echo "  got:      $actual"; exit 1; }; \
      echo "SRI ok: $1"; \
    }; \
    check unpkg/d3@7.9.0/dist/d3.min.js \
      'sha384-CjloA8y00+1SDAUkjs099PVfnY2KmDC2BZnws9kh8D/lX1s46w6EPhpXdqMfjK6i'; \
    check unpkg/topojson-client@3.1.0/dist/topojson-client.min.js \
      'sha384-Ukv1p/xTma6P4/2bY5KzWBw+ydSpXmhCMtyciIQVDJ1RmOxtCYNMF1uXT9T63H67'

# ---------------------------------------------------------------------------
# 2 · Serve.
# ---------------------------------------------------------------------------
FROM nginx:1.27-alpine

# Extend the MIME table rather than replacing it. A `types` block in the server
# config would override the whole default map — .html would become octet-stream,
# and sub_filter (which keys on text/html) would silently stop rewriting the CDN
# URLs. Appending before the closing brace keeps the defaults and adds ours.
RUN sed -i '$ s|^}|    application/geo+json              geojson;\n    text/csv                          csv;\n    text/plain                        geojsonl dat gpl qml qpt md;\n}|' /etc/nginx/mime.types \
 && grep -q 'geo+json' /etc/nginx/mime.types

COPY web/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=vendor /vendor /opt/vendor
# .dockerignore keeps working material out; what lands here is the tree git knows.
COPY . /srv

WORKDIR /srv
EXPOSE 80

# 127.0.0.1, not localhost: /etc/hosts maps localhost to ::1 as well, and busybox
# wget tries IPv6 first. The server listens on both now, but the check should not
# depend on resolver order to say whether the site is up.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
