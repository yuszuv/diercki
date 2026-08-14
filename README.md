# DIERCKI — sternprodukt atlas

A world atlas in the manner of the Diercke classic, but of the Sternprodukt kind.
Blätter on Romania and Brandenburg, a legend after the atlas model, and a QGIS map
set.

`Inhalt.dc.html` is the same table of contents in the Sternprodukt look — grouped,
linked, with the notes you need while looking something up. This file stays the
machine-readable version.

> **A note on language.** Prose here is English; the cartographic and project
> vocabulary stays German and untranslated — *Blatt*, *Signatur*, *Schummerung*,
> *Quellenregister*, *belegt / abgeleitet / unbelegt*. That is the rule in `CLAUDE.md`,
> and a *Signatur* is not a "symbol". It covers terms that carry cartographic meaning,
> not every German word in reach: *legend* and *map set* are plain technical vocabulary
> and get translated. Filenames never do.
>
> Two things in this file are **read by the application** and must not be translated:
> the three headings `## Blätter`, `## Weitere Blätter` and `## Präsentationen`
> (`Sources::Sheets::HEADINGS` matches them literally), and the description cells of
> those tables (they appear on the Schaukasten cards). Change a heading and the sheet
> list goes empty.

## Getting it running

A single Blatt needs nothing: open `Rumaenien-Physisch.html` in a browser and there it
is. It will pull d3 and topojson from a CDN, though.

For the whole application — home page, Schaukasten, Blattschau, Namensregister,
Werkstatt — there are two ways.

### With Ruby, without Docker

Needs Ruby 3.4 (rbenv: `rbenv install 3.4.2`, `.ruby-version` sits next to this file).

```sh
bundle install                 # gems into .bundle/gems, not into the system
ruby bin/vendor.rb             # once: the nine vendored libraries into .vendor/
bundle exec rackup             # → http://localhost:9292/  (Rack's own default)
```

`bin/vendor.rb` is the **only** step that needs a network. Everything after it works
offline. It verifies the two SRI hashes on the way and aborts if a file is not
byte-identical — otherwise the browser would refuse the script later without a word.

Tests: `bundle exec ruby -Itest test/web_test.rb`

### With Docker

Needs no Ruby on the machine.

```sh
docker compose --profile local up dev       # → http://localhost:9292/
```

`dev` mounts the working tree read-only: a change to a file is there on the next
request, without a restart and without a build step. To check what would actually ship:

```sh
docker compose --profile local up preview   # → http://localhost:9293/, tree from the image
```

Both sit behind the `local` profile and never start on the server.

### When it does not work

| Symptom | Cause |
|---|---|
| `/vendor/…` returns 404, Blätter stay blank | `ruby bin/vendor.rb` never ran |
| `bundle install` wants Ruby 3.4.2, you have 3.4.9 | The `Gemfile` only asks for `~> 3.4.0`; `.ruby-version` is the rbenv pin. Install that version or adjust the file |
| Gems missing inside the container | The host's `.bundle/config` points into the repo; the image sets `BUNDLE_APP_CONFIG` for that reason — do not override it |
| A page shows a box saying "offener Fall" | Not a bug but the design: a file or an assignment is missing, and the page says which |

## Blätter

Each Blatt is a standalone HTML file in the root, D3-based, with a Zeichenerklärung
and its sources in the footer.

| Datei | Inhalt |
|---|---|
| `Rumaenien-Physisch.html` | Physische Übersicht — Relief, Hypsometrie |
| `Rumaenien-Wirtschaft.html` | Wirtschaft — Rohstoffe, Industrie, Energie |
| `Rumaenien-Verkehr.html` | Hauptverkehrsnetz — Straßen, Bahnen, Donaudelta-Nebenkarte |
| `Banat-Liniennetz.dc.html` | Banat · Liniennetzplan — oktilinear, topologietreu, nicht lagetreu |
| `Rumaenien-Braunbaer.html` | Braunbär — Verbreitung, Streusignatur nach GBIF-Nachweisen |
| `Rumaenien-Landschaften.html` | Historische Landschaften |
| `Brandenburg-Landwirtschaft.html` | Brandenburg · landwirtschaftliche Nutzung — Hanf 2026 schlaggenau, Kartodiagramm je Kreis, Matrix-Legende, Nebenkarte Kyritz |
| `Brandenburg-Klima.html` | Brandenburg · Klima — Kartodiagramme, Walter-Lieth-Randspalte, Geländeklima-Nebenkarte. **Alle Werte noch unbelegt** |
| `Loreley-Relief.html` | Werkstattblatt: ein Gelände in vier Registern — Isohypsen, Hypsometrie, Schummerung, Böschungsschraffen. Geländemodell konstruiert |
| `Nikolais-Ort.dc.html` | Freiburger Hauptfriedhof, drei Blätter — Grundriss mit DTK10-Hintergrund, Person, Abschied. Kein Atlas-Bestandteil im engeren Sinn, folgt aber seinen Regeln |
| `Zeichenerklaerung.dc.html` | Zeichenerklärung des ganzen Atlas, Blatt für Blatt (Farbsystem, Relief, Gewässer/Siedlung/Schrift, Grenzen, Verkehr, Rohstoffe, Industrie/Energie, Landwirtschaft, …) |
| `QGIS-Kartensatz.dc.html` | Anleitung: Blätter in QGIS öffnen, drucken, um eigene Themen erweitern |
| `Zeichen-Naeherung.dc.html` | Messblatt zur Unicode-Näherung des Sternprodukt-Zeichens — misst Glyphenabdeckung live gegen U+FFFF |

## Weitere Blätter

In the root, following the same rules, but not part of the Kartenwerk.

| Datei | Inhalt |
|---|---|
| `Inhalt.dc.html` | Übersichtsblatt im Sternprodukt-Look — dieselbe Ordnung wie hier, nur gestaltet und mit Signaturen |
| `Deckel-Entwuerfe.dc.html` | Entwürfe für den Einband |
| `Kleiner-Gruss-aus-der-Kueche.dc.html` | Zwischenstand vom 7. August, zwei Blattausschnitte. Kein Atlas-Bestandteil |

## Präsentationen

| Datei | Inhalt |
|---|---|
| `praesentationen/Pitch-Hoehle-der-Loewen.dc.html` | Pitch-Deck zum QField-Bahnreiseplaner |
| `praesentationen/QField-Bahnreiseplaner.dc.html` | Workshop: QField als Bahnreise-Planer, zwölf Folien |
| `praesentationen/Reiseplaner-Vorschlag.dc.html` | Entscheidungsvorlage Reiseführer Banat & România, 12 Folien |
| `praesentationen/Reiseplaner-Roadmap.dc.html` | Technische Roadmap dazu, 4 Seiten (Arbeitsdokument) |
| `praesentationen/Reiseplaner-Reisebegleitung.dc.html` | Reisevorbereitung für die eigene Rumänien-Reise, 10 Folien |
| `praesentationen/Zeichensystem-Post-its.dc.html` | Das Zeichensystem des Atlas, neun Zettel |
| `praesentationen/Iteration-2-Konzept.dc.html` | Iteration 2 — Konzept vor Bau, zehn Folien. Offen: Zuschnitt A, B oder C |
| `praesentationen/Wireframe-A-Chips.dc.html` | Wireframe A · Themenchips über der Karte — absichtlich grau und unfertig |
| `praesentationen/Wireframe-B-Tabs.dc.html` | Wireframe B · Themenliste mit Tab-Leiste unten |
| `praesentationen/Wireframe-C-Split.dc.html` | Wireframe C · Karte oben, Trefferliste unten |
| `Gruss-an-Stefan-Waldmann.dc.html` | Persönliche Präsentation, kein Atlas-Bestandteil |

## Layout

```
atlas/
  signaturen.js       Signaturenkatalog (SVG per map object)
  SIGNATUREN.md       how the catalogue is built, rules for adding to it
  typenscale.js       type scale — seven steps, lower bound 5.5 pt
  farben.js           colour system — the single source of hex values in the atlas
  farben-paletten.rb  generates the .gpl palettes from farben.js
  register.csv        Namensregister of the volume, maintained by hand
  blaetter.csv        Blattschlüssel — which Blattnummer means which file
  BLAETTER.md         the reasoning; the numbers are abgeleitet, not belegt
  marke/              logo and handwritten wordmark
  GLOSSAR.md          the Blätter's technical terms, alphabetically
  paletten/           .gpl palettes for QGIS/GIMP, derived from farben.js
  quellen/            Quellenregister per Blatt (belegt / abgeleitet / unbelegt)
  geodaten/           scripts that turn raw deliveries into map data
  qgis/               QGIS-Kartensatz: basis/ (theme-neutral) + themen/ (one folder per Blatt)
                      themen/brandenburg-hanf/ doubles as the QField package for
                      fieldwork (instructions in the README there)

bin/                  tools — sync-report.rb compares the clone against the ZIP export,
                      vendor.rb fetches the nine vendored libraries,
                      pruefe-blaetter.rb checks the Blattschlüssel against sheet content
web/                  the web application (Roda, dry-rb) and its design
  app.rb              routes
  auth.rb             the login: Rodauth as a middleware in front of everything
  boot.rb             container (dry-system), root path, vendor directory
  lib/atlas/          readers, transforms, middleware
  templates/          ERB templates — they mirror the class names of Muster.dc.html
  site.css            design — owned by the design UI
  Muster.dc.html      every building block once — owned by the design UI
  site.js             enhancement: place the Signaturen, filter the Register
  geschuetzt.csv      paths that require a login
test/                 minitest + rack-test
handarbeit/           only the human writes here — QGIS projects, survey GeoPackages
praesentationen/      decks (pitch, QField how-to) and wireframes
recherche/            research notes and recorded decisions
skills/               project-owned skills (belegstatus, atlas-kartenblatt, …)
uploads/              data and images the Blätter load at runtime
screenshots/          QA captures; three are embedded by "Kleiner Gruß aus der Küche"
wip/                  working store, including the ZIP export — globally ignored
_ds/                  the bound Sternprodukt design system (do not touch)
```

Not in the clone but in the design project: `scans/` — the reference scans of the
printed Diercke, around 60 MB. They are comparison material, no Blatt embeds them;
whoever needs them takes them out of the export.

### Where the rest is written down

| File | What |
|---|---|
| `WEB-APPLICATION.md` | how the atlas is served, the path of a request, what the application is built from, the Wächter |
| `TWO-PLACES.md` | the sync between this clone and the Claude design UI, and where the two deliberately differ |
| `AGENTS.md` | entry point for coding agents |
| `CLAUDE.md` | the binding rules |
| `IDEEN.md` | backlog and loose ends |
| `DATENBEDARF.md` | what data is still missing from outside |
| `atlas/BLAETTER.md` | how the Blattnummern were derived |
| `atlas/GLOSSAR.md` | the Blätter's technical terms |

Colours and Signaturen go through `atlas/farben.js` and `atlas/signaturen.js` and
nowhere else — no new hex values, no ad-hoc symbols in individual Blätter. The `.gpl`
palettes are derived from them (`atlas/farben-paletten.rb`) and are not maintained by
hand.

## Generated geodata is versioned

The scripts under `atlas/geodaten/` build map data out of third-party deliveries.
**Their results live in the repo**, not just the scripts — even though that
contradicts the usual rule of not versioning what is generated.

The reason is the input side: CLC2018 arrives as several gigabytes through a portal,
nested as `Results/…geoPackage.zip/DATA/…gpkg`; the GBIF and Overpass queries return
something different depending on the day. A product whose input cannot be reliably
obtained again is effectively a source, and is treated as one. Otherwise whoever
clones pays the price: a Blatt that stays silently empty, and half a day spent looking
for the reason.

This covers `nutzung-*.geojson` (nine area classes, 12 MB, read by
`Rumaenien-Wirtschaft.html`), `friedhof-freiburg.geojson` and the datasets under
`atlas/qgis/themen/rumaenien-baer/daten/`.

Only the **intermediate stages** stay out — raw deliveries, unpacked archives, working
copies. What `.gitignore` excludes is justified there.

## Lookup tables without a build step

Tables a human maintains are read **at runtime** — by the Blatt as it loads, by QGIS as
an attribute join, by QField as a value list. No derived intermediate file that goes
quietly stale when an export script did not run:

| Table | read by | instructions |
|---|---|---|
| `atlas/geodaten/brandenburg/sorten.csv` | Landwirtschaftsblatt, QGIS theme `brandenburg-hanf` | `SORTEN.md` |
| `atlas/geodaten/brandenburg/klima-stationen.csv` | Klimablatt | `KLIMA.md` |
| `atlas/register.csv` | Namensregister of the web edition | header comment in the file |
| `atlas/blaetter.csv` | Blattschau and Register of the web edition | `BLAETTER.md` |

Where an entry is missing, nothing is guessed: the case gets a visible class of its own
("ungeklärt", "Ort nicht verifiziert"). Check scripts such as
`brandenburg/pruefe-hanf.rb` and `bin/pruefe-blaetter.rb` only **report** — they
generate nothing.

## Sources and evidence

Every number on a map has a row in the Quellenregister (`atlas/quellen/`), with the
status *belegt*, *abgeleitet* or *unbelegt*. Geometry from named datasets (Eurostat
GISCO, OSM, GBIF) goes into the footer of the Blatt instead.

## QGIS

The Kartensatz under `atlas/qgis/` is split into theme-neutral (`basis/`) and per-Blatt
(`themen/<name>/`). Setup and recipes are in `QGIS-Kartensatz.dc.html`; the working CRS
is EPSG:3844 (Stereo 70).

Since 08/2026 the styles know about scale: a **Bezugsmaßstab** of 1:2 500 000 in every
style (mm dimensions follow the output scale), **selection by scale** in `punkt_ort.qml`
(rule-based, five settlement sizes with their own bounds), and a **Beschriftungsrang**
laid out as a ladder from 10 down to 3 instead of arbitrary values. Type sizes come from
`atlas/typenscale.js`, lower bound 5.5 pt.

## Environment

- **QFieldCloud is self-hosted.** No 100 MB limit, no third-party storage. The object
  store underneath is S3-compatible and in our own hands; the WebDAV drop for
  attachments alone is therefore readily available. Reason about storage and syncing
  from that premise, not from app.qfield.cloud.
- Working CRS: EPSG:3844 (Stereo 70) for Romania, EPSG:25833 for Brandenburg.
- QGIS 4.2, QField "Coral Sea".
