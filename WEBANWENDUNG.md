# The web application

Roda, dry-rb, one Puma process. This file describes how the atlas is served and
what it is built from. Orientation and the Blätter tables are in `README.md`;
the sync between the clone and the design UI is in `ZWEI-ORTE.md`.

## Delivery and preview

The Blätter are static; the application around them is not. A Roda app serves the tree
and builds the home page, Schaukasten, Blattschau, Namensregister and Werkstatt out of
it. One process, no nginx. See "Getting it running" above for the commands.

**Everything is read at runtime.** The sheet list comes from the tables in this README,
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

The only real network dependency left is the Overpass call in `Nikolais-Ort.dc.html` — a
live query that cannot be baked in. Without a network the Blatt draws from
`atlas/geodaten/friedhof-freiburg.geojson`.

### The path of a request

Top to bottom: the hand-maintained files, the one disk access, the readers, the views.
None of it is generated in advance — every edge is walked while the request runs.

```mermaid
flowchart TB
  subgraph quelle["maintained by hand"]
    direction LR
    README[("README.md")]
    REG[("register.csv")]
    BL[("blaetter.csv")]
    NOE[("nicht-oeffentlich.csv")]
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

  quelle --> TREE
  TREE --> TR
  TR --> leser
  TREE -.->|"kramdown"| V5

  S --> V1 & V2 & V3
  R --> V1 & V3 & V4
  P --> V3 & V4
  W --> V5
  X -->|"no second address"| V3 & V5
  leser -.->|"Failure"| FF

  BLATT[("Kartenblatt<br/><small>unchanged</small>")]
  V3 -->|"iframe"| FILES
  FILES["Middleware::Files"] --> BLATT
  BLATT --> UMS["Middleware::VendorRewrite<br/><small>nine CDN addresses → /vendor</small>"]

  classDef r fill:#f7f4ee,stroke:#8b8173
  classDef f fill:#f1e9d8,stroke:#cb5a2a,stroke-width:2px
```

Three things the picture is meant to show:

1. **`Sources::Tree` is the only disk access.** Everything else gets its data from
   there. That is why the remembering sits there too, and not five times beside it.
2. **Every reader empties into the same outlet for what is missing.** A `Failure` is not
   caught and smoothed over; it is drawn.
3. **The Kartenblatt sits outside.** It passes through the static layer unchanged and is
   only framed by the Blattschau — it hangs off no reader.

### What the application is built from

Roda routes, `dry-system` wires the readers, `dry-monads` brings the `Result`.

The last one is not decoration — every reader returns `Success` or `Failure`, and a
`Failure` becomes a visible box. That puts the project rule "fehlt ein Eintrag, wird
nicht geraten" into the return type rather than into the caller's diligence. A `nil` or
an empty list can be used by accident; a `Result` forces a decision before you reach the
value.

The parsers (`web/lib/atlas/transforms.rb`) are plain module functions. `dry-transformer`
sat there for a while; the reasoning for taking it out is in
`recherche/entscheidungen-webanwendung.md`.

`web_pipe` was not taken, although its shape fits well: last release November 2021, last
commit November 2023, and the gemspec pins `rack ~> 2.0`.

`web/site.js` is **an enhancement, not a prerequisite.** The server delivers every page
complete, all 272 register rows included. The script places the Signaturen from
`atlas/signaturen.js` — the catalogue is a JS module, the browser is its natural reader,
and a second parser in Ruby would be a second place with its own opinion — and filters
the already-delivered table without a round trip. Without JavaScript the form filters by
GET, and every filtering is a shareable address.

### One guard, two lists

The host's Caddy locks four paths behind a password prompt (bmeise,
`host_vars/paketzentrum.yml`, `basicauth.paths`). It guards **addresses** — and this
application invents new ones for the same content: `/blatt/<file>` and
`/werkstatt/<path>`. Without a counter-measure `/werkstatt/recherche/….md` would be the
full text at an address the Caddy has never heard of.

Hence `web/nicht-oeffentlich.csv`: what is listed there gets no second address but a
redirect to the original path, where the prompt lives. The entry stays visible in
Schaukasten and Werkstatt, marked *nicht öffentlich* — hiding it would be a different
answer than locking it.

`Sources::Restricted` **fails closed**: if the list cannot be read, every path counts as
guarded and the derived layer shuts rather than opens. Every other reader may fall back
to an empty list; this one may not.

**The two lists have to be maintained together.** Error direction as in bmeise: what is
missing is public, and nothing reports it. `test/web_test.rb` checks that every entry in
this list really is redirected — not that the list is complete; it cannot check that.
