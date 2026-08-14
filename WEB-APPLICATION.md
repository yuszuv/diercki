# The web application

Roda, dry-rb, one Puma process. How the atlas is served and what it is built
from. Orientation, the commands to start it and the Blätter tables are in
`README.md`; the sync between the clone and the design UI is in `TWO-PLACES.md`.

## Delivery and preview

The Blätter are static; the application around them is not. A Roda app serves the tree
and builds the home page, Schaukasten, Blattschau, Namensregister and Werkstatt out of
it. One process, no nginx. The commands are under "Getting it running" in `README.md`.

**Everything is read at runtime.** The sheet list comes from the tables in `README.md`,
the register from `atlas/register.csv`, the Blattschlüssel from `atlas/blaetter.csv`,
the prose from the `.md` files. A correction to a file is there on the next request;
there is no derived copy that can go quietly stale. Where something is missing, nothing
is guessed: the case appears as a visible box with path and reason — a Blatt without a
README row, a Blattnummer without a file, a link into nothing.

A Blatt stays reachable at its own address (`/Rumaenien-Physisch.html`), so every
cross-reference inside every Blatt keeps working; `/blatt/Rumaenien-Physisch.html` is
the framed view with its Quellenregister beside it.

Both **run without a network.** The Blätter would otherwise load d3, topojson, React and
Babel from unpkg and the world geometry from jsDelivr; `bin/vendor.rb` puts those nine
files under `/vendor` and a Rack middleware rewrites the references on the way out. The
Blätter themselves are untouched — they belong to the design project and must stay
byte-comparable. The `integrity` hashes keep validating because the vendored files are
byte-identical; `bin/vendor.rb` checks that and aborts otherwise.

The nine addresses live in **one** place, `web/lib/atlas/vendor.rb`. There used to be
three: twice as a `sub_filter` block in `web/nginx.conf`, once as a shell list in the
`Dockerfile` — two chances to update eight of nine.

Serving them ourselves has two reasons beyond the offline preview, and both hold in
public too: visitors' IP addresses do not go to third parties, and
`deutschlandGeoJSON@main` is a moving target — what a finished Blatt loads should not
change underneath it. The same argument as for keeping the generated geodata in the
repo.

Exactly **the nine vendored addresses** are rewritten, never the host. A prefix rule
would hit any unpkg URL: an upstream version bump would produce a `/vendor` path that
does not exist, and the Blatt would break on a 404. This way an unvendored version keeps
loading from the CDN — it degrades to the status quo instead of failing. A source note
citing a CDN URL in an `href` stays a working citation for the same reason.

Bodies over 512 KB are not even read on the way out. The largest file that carries one
of the nine is `support.js` at 69 KB; above the limit sit exactly two files, and neither
can match — `atlas/geodaten/verkehr-daten.js` is map data, and `_ds/_ds_bundle.js` cites
jsDelivr only for `speech-rule-engine` and `wicked-good-xpath`.

The only real network dependency left is the Overpass call in `Nikolais-Ort.dc.html` — a
live query that cannot be baked in. Without a network the Blatt draws from
`atlas/geodaten/friedhof-freiburg.geojson`.

## The path of a request

Top to bottom: the gate, the hand-maintained files, the one disk access, the readers,
the views. None of it is generated in advance — every edge is walked while the request
runs.

```mermaid
flowchart TB
  subgraph tor["the gate · before everything"]
    direction LR
    AUTH["AuthApp<br/><small>Rodauth · /anmelden /abmelden</small>"]:::g
    GUARD["Middleware::Guard<br/><small>reads geschuetzt.csv</small>"]:::g
  end

  subgraph quelle["maintained by hand"]
    direction LR
    README[("README.md")]
    REG[("register.csv")]
    BL[("blaetter.csv")]
    GES[("geschuetzt.csv")]
    MD[("quellen/*.md<br/>recherche/*.md")]
  end

  TREE["Sources::Tree<br/><small>the only disk access · remembers parses per mtime+size</small>"]
  TR["Transforms<br/><small>table → rows · CSV → rows</small>"]

  subgraph leser["readers · each returns a Result"]
    direction LR
    S["Sheets"]:::r
    R["Register"]:::r
    P["Plates"]:::r
    W["Workshop"]:::r
    X["Restricted"]:::r
  end

  subgraph sicht["views"]
    direction LR
    V1["/"]
    V2["/blaetter"]
    V3["/blatt/…"]
    V4["/register"]
    V5["/werkstatt/…"]
  end

  FF{{"offener Fall<br/><small>every Failure, made visible</small>"}}:::f

  AUTH --> GUARD
  GUARD -->|"not logged in"| AUTH
  GUARD --> sicht
  GUARD --> FILES

  quelle --> TREE
  TREE --> TR
  TR --> leser
  TREE -.->|"kramdown"| V5
  X -.->|"which paths"| GUARD

  S --> V1 & V2 & V3
  R --> V1 & V3 & V4
  P --> V3 & V4
  W --> V5
  leser -.->|"Failure"| FF

  BLATT[("Kartenblatt<br/><small>unchanged</small>")]
  V3 -->|"iframe"| FILES
  FILES["Middleware::Files"] --> BLATT
  BLATT --> UMS["Middleware::VendorRewrite<br/><small>nine CDN addresses → /vendor</small>"]

  classDef r fill:#f7f4ee,stroke:#8b8173
  classDef f fill:#f1e9d8,stroke:#cb5a2a,stroke-width:2px
  classDef g fill:#e5ddce,stroke:#4a4139
```

Five things the picture is meant to show:

0. **`Sources::Tree#parse` keys on the resolved path and a three-part stamp** —
   mtime, size and **ctime**. The first two can be made to recur with different
   contents (`cp -p`, `rsync -a`, a backup rollback), and a stamp that recurs
   would match forever, so a corrected file would stop appearing. ctime cannot be
   forged from userspace and comes out of the same `stat`.
1. **The gate comes before the file serving.** Two of the guarded paths are static files;
   a check inside the routing tree would never see them.
2. **`Sources::Tree` is the only disk access.** Everything else gets its data from
   there. That is why the remembering sits there too, and not five times beside it.
3. **Every reader empties into the same outlet for what is missing.** A `Failure` is not
   caught and smoothed over; it is drawn.
4. **The Kartenblatt sits outside.** It passes through the static layer unchanged and is
   only framed by the Blattschau — it hangs off no reader.

## What the application is built from

Roda routes, `dry-system` wires the readers and carries the settings, `dry-monads` brings
the `Result`.

The last one is not decoration — every reader returns `Success` or `Failure`, and a
`Failure` becomes a visible box. That puts the project rule "fehlt ein Eintrag, wird
nicht geraten" into the return type rather than into the caller's diligence. A `nil` or
an empty list can be used by accident; a `Result` forces a decision before you reach the
value.

The parsers (`web/lib/atlas/transforms.rb`) are plain module functions. `dry-transformer`
sat there for a while; the reasoning for taking it out is in
`recherche/entscheidungen-webanwendung.md`, together with why `dry-monads` and
`dry-system` stay.

`web_pipe` was not taken, although its shape fits well: last release November 2021, last
commit November 2023, and the gemspec pins `rack ~> 2.0`.

`web/site.js` is **an enhancement, not a prerequisite.** The server delivers every page
complete, all 272 register rows included. The script places the Signaturen from
`atlas/signaturen.js` — the catalogue is a JS module, the browser is its natural reader,
and a second parser in Ruby would be a second place with its own opinion — and filters
the already-delivered table without a round trip. Without JavaScript the form filters by
GET, and every filtering is a shareable address.

## Build and publish

`.github/workflows/ci.yml` runs on every pull request and on every push to
`main`:

- **Tests** — `bin/vendor.rb` (the only step needing a network; its SRI check runs
  too), the 25-case suite, and a smoke run of the report scripts.
- **Image** — `docker build`. On `main` it also pushes to
  `ghcr.io/yuszuv/diercki`, tagged `latest` and `sha-<commit>`, then pulls that
  image back, starts it and asks `/health` plus one Blatt — the CDN rewriting is
  the thing that would break quietly.

Nothing here deploys. The deploy stays `make webhost LIMIT=paketzentrum` in
bmeise, by hand.

**Why the build moved off the server.** It used to happen there, on the argument
that the image is content rather than a compiled artefact. That was true while the
atlas was static HTML behind nginx. It stopped being true when the atlas grew a
Ruby application: the image now compiles `nio4r` and pulls platform-specific
`sqlite3` binaries, and a `Gemfile.lock` missing `x86_64-linux-musl` fails the
build — a failure that was previously discoverable only at deploy time, on the
server, in front of a live site.

It also puts this project back in line with what bmeise's own `dockerapp` role
asks for: *"Prefer pre-built images"*. `diercki` was the only `build: true` entry
across every host, and the role already handles both modes — `pull: always` when
`dockerapp_build` is unset. Nothing in the role changes.

`ATLAS_IMAGE` overrides the tag, so a deploy can pin `sha-<commit>` instead of
following `latest`.

The image carries three OCI labels and no others. Docker labels were Traefik's
service-discovery mechanism, and that layer was retired across bmeise in July
2026 — Caddy is configured from a templated Caddyfile driven by `web_apps`, not
from container metadata. The exception is
`org.opencontainers.image.source`: it is what links a package on ghcr to its
repository, without which the package floats unattached.

## The gate

A small part of the atlas is not on show: what shows a non-public person, or is written
about one. `web/geschuetzt.csv` lists those paths with a reason each, and is read at
runtime like every other table here.

**What the gate is and is not.** It guards addresses on the served site. The repository
is public, and the same files lie in it in plain sight — so this is a decision about
what the atlas *presents*, not a claim that anything here is secret. Taking an entry
off the list opens a page; taking a file out of the repository is a different act, and
the only one that would make it unavailable.

**Rodauth, mounted as a Roda middleware in front of everything.** Not a branch of the
routing tree — two of the guarded paths are static files, a deck and a photograph, and
`Middleware::Files` answers those before Roda ever sees the request. `Atlas::AuthApp`
owns `/anmelden` and `/abmelden` and puts `rodauth` into the Rack env;
`Middleware::Guard` reads the list and decides what needs it. Rodauth knows how to
authenticate and nothing about this atlas; the list is an editorial decision.

A derived address inherits the guard of its content: `/blatt/X` and `/werkstatt/X` are
locked when `X` is. The entry still appears in Schaukasten and Werkstatt, marked
*nicht öffentlich* — hiding it would be a different answer than locking it.

**No database file and no volume.** Rodauth needs Sequel and a database, but not a file:
with only `:login` and `:logout` enabled it never writes. Measured, not assumed — a full
login and logout cycle issues zero `INSERT`, `UPDATE` or `DELETE`. So the single account
lives in an in-memory SQLite seeded at boot, the application stays stateless, the image
immutable and the dev bind mount read-only. The session is a signed cookie, so several
Puma workers need share nothing.

Three environment values, all required and none defaulted — a fallback secret is worse
than none, because nothing looks broken while it is in place:

| Variable | What |
|---|---|
| `ATLAS_KONTO` | the login name |
| `ATLAS_PASSWORT_HASH` | `ruby -rbcrypt -e 'print [BCrypt::Password.create("…")].pack("m0")'` — **base64**, see below |
| `ATLAS_SESSION_SECRET` | `ruby -rsecurerandom -e 'print SecureRandom.hex(64)'` |

**Declared, not read by hand.** They are settings on the container, registered in
`web/boot.rb` through `dry-system`'s settings provider; the shape of each one lives in a
constructor next to its name. Two things follow that are worth the provider on their
own. The checks all run before any of them is reported, so three wrong values produce
one message naming three faults instead of three restarts. And the `.env` reading comes
with it — dotenv's chain, `.env.<RACK_ENV>.local · .env.local` (never in test) ·
`.env.<RACK_ENV>` · `.env`, with the environment winning over every file. Before this
there were two readers of the environment in the repository, one of them hand-written in
`config.ru`.

`AuthApp` takes the secret while its class body runs, which is before
`Container.finalize!` in `config.ru`. That is not an oversight and needs no deferring: an
unfinalized `dry-system` container resolves lazily and starts the provider on the way.
Deferring would not be available anyway — `plugin :sessions` checks that `:secret` is a
String inside its own configure step and refuses a callable outright.

### Why the hash is base64

A bcrypt hash is `$2a$12$…`, three fields separated by dollar signs, and two readers on
the way in resolve `${…}` in what they read. Docker Compose does it to every value,
`.env` files included, and no quoting and no `$$`-doubling stops it there. dotenv does it
to the same file when the application reads it without Docker; only single quotes stop
that one, and they do not help against compose.

Measured, not feared, on both paths: `$2a$12$KDvI6RuYis…/qxuoa` reaches the container as
`a2/qxuoa`, and the same line read by dotenv arrives as an empty string. In the first
case the application starts and the correct password is simply rejected, and nothing in
any log says why.

Base64 has no dollar signs, so nothing on the way in can chew on it. The constructor in
`web/boot.rb` decodes it and checks the result against the bcrypt shape; a raw hash
aborts the boot with the command that produces the right value. A loud failure at start
instead of a quiet one at the login screen.

The same applies to `dockerapp_env` in bmeise — it writes exactly such a `.env`.

`Sources::Restricted` **fails closed**: if the list cannot be read, every path counts as
guarded and the whole derived layer shuts rather than opens. Every other reader in this
application may fall back to an empty list; this one may not.

`test/web_test.rb` checks that every entry in the list really is guarded, that a guarded
*static* file is guarded too, and that logging in opens them — not that the list is
complete. It cannot check that, and neither can anything else: what is missing from the
list is public, and nothing reports it.

The host's Caddy still terminates TLS and routes the domain. Its `basicauth` block for
this service became redundant with the gate above, and `bmeise` has already dropped it
(commit `d632fd4`, committed and pushed, **not yet applied**).

That inverts the old warning. The danger is no longer removing the block too early but
**deploying too early**: on the host the block is still in place, so nothing is open
right now — but the moment `make webhost LIMIT=paketzentrum` runs, Caddy is rewritten
without it. If `ghcr.io/yuszuv/diercki:latest` does not yet carry the gate at that
point, the old container keeps serving the old tree with no guard at all. The order is
therefore: merge, wait for the `Image` job to publish, deploy, then the two `curl`
checks recorded in `inventory/host_vars/paketzentrum.yml`.
