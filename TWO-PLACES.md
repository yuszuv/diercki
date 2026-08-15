# Working in two places

How the clone, the Claude design UI and GitHub stay in step. The rules for who
owns which artefact live here; `README.md` has the orientation and
`WEB-APPLICATION.md` the web application.

This project is developed in two places — in the Claude design UI and here in the
terminal — and lives in a third: `yuszuv/diercki` on GitHub. That works as long as it is
clear what comes into being where.

**When in doubt the clone leads.** It has the history, it has the scripts, it is what a
stranger can clone and build. The UI is the workshop for drawing, not the archive.

## The one asymmetry everything follows from

The atlas project in the UI is an ordinary Claude project, not a design system. It
**cannot be written to programmatically** — there is no way to move a file changed here
over there automatically. The other direction is trivial: export the project, unpack the
ZIP, done.

The division of labour follows from that. Not "sometimes here, sometimes there" but
**fixed per artefact**, so that as few files as possible are touched in both places:

| What | Where | Why |
|---|---|---|
| Kartenblätter, Zeichenerklärung, decks (`*.html`, `*.dc.html`, `praesentationen/`) | **UI** | that is where the preview, the tweaks bar and the bound design system are |
| Signaturenkatalog, colours, type scale (`atlas/signaturen.js`, `farben.js`, `typenscale.js`) | **UI** | the Blätter import them; the same drawing pass |
| Geodata pipelines (`atlas/geodaten/`) | **local** | need GDAL, osmium and several gigabytes of raw data |
| QGIS-Kartensatz (`atlas/qgis/`) | **local** | QGIS reads and writes these files, XML validity matters |
| Docs, Quellenregister, research | **local** | they describe the clone, and the clone leads |
| Namensregister (`atlas/register.csv`) | **UI** | written and maintained there; nothing here writes into it |
| Design of the web edition (`web/site.css`, `web/Muster.dc.html`) | **UI** | the Musterblatt shows every building block once and can be drawn there |
| The rest of the web application (`web/`, `config.ru`, `Gemfile`, `Dockerfile`, `docker-compose.yml`, `bin/`, `test/`) | **local** | the UI does not know it and does not need it |
| `handarbeit/` | **local, human only** | binary files from QGIS and QField |
| `_ds/` | **neither** | comes from the Sternprodukt design system and travels along in the export |

## The round trip

1. **Before a UI session:** commit and push locally. That gives a named state to compare
   against afterwards.
2. **In the UI:** draw Blätter. Touch nothing from the local column.
3. **Afterwards:** export the project as a ZIP, drop it into `wip/` (globally ignored
   there), then

       ruby bin/sync-report.rb          # report: SAME · DIFFERENT · CLONE ONLY · EXPORT ONLY
       ruby bin/sync-report.rb --diff   # plus text diffs

   The script **writes nothing** — it reports, and marks per file which side leads
   according to the table above. Carrying over is done by hand, in blocks, with a commit.
4. **Keep working locally:** commit, push. As long as only the local column is affected,
   no return trip is needed.
5. **If a Blatt was changed locally after all:** note it under "Where the clone differs"
   below **and** upload the file on the next visit to the UI — otherwise the next export
   silently overwrites it.
6. **If a file the UI owns was created locally:** upload it, and expect nothing back
   until you do. `sync-report.rb` flags these as *ONLY LOCAL — CHECK: should this be in
   the UI?*, which is the only warning there is. They are not a conflict yet; they
   become one the moment somebody draws the same thing over there from scratch.

### Two ways a file can be missing

The report separates them, and they need different answers:

- **ONLY IN EXPORT** — the UI has something the clone does not. Usually to be adopted:
  copy it in, commit it. Watch for files a newly adopted Blatt *needs*: adopting
  `Inhalt.dc.html` without its eight `screenshots/thumb-*.png` gives eight broken
  images, and nothing in the sheet says so. That is not hypothetical — it is the case
  this warning was written from, and on 14.08.2026 all nine went in together.
- **ONLY LOCAL with a CHECK note** — the clone has something the UI should own. Upload
  it. That was `web/site.css` and `web/Muster.dc.html`, the design seam of the web
  edition: built here because the web edition was built here, uploaded 15.08.2026,
  drawn over there from now on.

  **The marker outlives the upload.** The report compares against the ZIP in `wip/`, not
  against the UI, so both keep showing as CHECK until the next export brings them back
  down. That is not drift and needs no second upload — the note clears itself once a
  newer export is in place.

## Why not file by file through the tool

A full comparison through `DesignSync get_file` is the expensive dead end: a 256 KiB cap,
silent truncation above it, and the detour through a model context normalises invisible
characters — that is how one-byte deviations in `support.js` and a lost narrow space in
`_ds/readme.md` came about. Above the cap sit `_ds/_ds_bundle.js` (2.3 MB), the thirteen
woff2 fonts and `atlas/geodaten/verkehr-daten.js` (4.7 MB) anyway. The ZIP is
byte-faithful, complete, and usually the newer state.

The tool is right for **the design system** (`_ds/`) — that *is* a design-system project
and can be addressed in both directions. The path there is lossless because `write_files`
with `localPath` reads from disk.

## GitHub

`origin` is the third place and the only one that outlives both. Push after every
completed round — the clone is the source of truth only for as long as it also lies
somewhere else.

## Where the clone differs from the design project

The design project is the source of truth — but not the newer state on every point. What
is deliberately different here is recorded here, so that the next comparison does not
take it for drift and silently roll it back.

**The clone is ahead because it fixed a bug:**

- `atlas/qgis/themen/brandenburg-hanf/qfield/hanf_kontrolle.qml` — over there a straight
  quote in "unklar" closes the `desc` attribute early; the file is not well-formed XML
  there and QGIS will not read it.
- `atlas/qgis/basis/layout/layout_a4_quer_thema.qpt` — over there the frame entry carries
  five duplicate attributes with contradictory values (paper tone / 0.6 mm against ink /
  0.3 mm). The paper version is the one here.
- `atlas/geodaten/brandenburg/README.md` and `SORTEN.md` name the InVeKoS application
  data as the hemp geometry. Over there the older state still stands ("Hanf hat keine
  offene Geometrie"), which contradicts its own Kartenblatt: that reads
  `hanf-2026.geojsonl` and `sorten.csv` at runtime.

**The clone is ahead because a view was built here:**

- `web/site.css` carries `.belegbalken` and `.balken` for `/belegstand`, added
  15.08.2026. The file is UI-owned, so this block has to travel back on the next visit —
  otherwise the next export rolls it back and the bar on that page loses its geometry
  while everything else still stands. It uses no new colour: the three bar segments take
  `--olive`, `--akzent` and `--error`, the same tokens `.status` already uses, and a
  status word outside the three deliberately gets no segment at all.

**Images are smaller here than over there.** `screenshots/katzundgoldt-crop.png` (472 KB
instead of 1.2 MB) and `uploads/neumaier-frueher.png` (67 KB instead of 1.5 MB) are
deliberately reduced — enough for the screen size at which the greetings embed them.
Whoever needs them at print size takes them from the design project.

**Files no Blatt needs stay out:** the template scans under `scans/` are pure comparison
material. What `.gitignore` excludes is justified there.

## git repo

`yuszuv/diercki`, see `github.md` for roles and the last sync state. The design project
is the source of truth; changes to `handarbeit/` come from the human only.
