# Sternprodukt-Atlas

Thematische Kartenblätter nach dem Vorbild des Diercke-Schulatlas, gezeichnet mit D3 im
Browser. Jedes Blatt ist eine eigenständige HTML-Datei im Wurzelverzeichnis; die Daten
darunter kommen aus offenen Quellen und werden von Skripten unter `atlas/geodaten/`
reproduzierbar erzeugt.

Zwei Ausgabewege aus demselben Bestand: die HTML-Blätter für den Druck und der
QGIS-Kartensatz unter `atlas/qgis/` für die Arbeit im Feld.

## Blätter ansehen

Blatt 15 und 16 holen Geodaten aus `uploads/` per `fetch` — über `file://` scheitert das an
der Same-Origin-Regel. Also grundsätzlich über einen lokalen Server:

    python3 -m http.server 8000

Dann `http://localhost:8000/Rumaenien-Physisch.html` aufrufen. Alle Blätter sind auf
420 × 297 mm (A3 quer) gesetzt; im Browser skaliert das mit.

## Blattregister

| Blatt | Datei | Inhalt | Daten |
|---|---|---|---|
| 01–14 | `Zeichenerklaerung.dc.html` | Zeichenerklärung: Farbsystem, Relief, Signaturen, Kolophon | — |
| 07 | `Brandenburg-Landwirtschaft.html` | Landwirtschaftliche Nutzung, Schwerpunkt Hanf | im Blatt, Umrisse per CDN |
| 15 | `Rumaenien-Verkehr.html` | Hauptverkehrsnetz — Bahn, Autobahn, Schnellstraße | `uploads/*.dat` |
| 16 | `Rumaenien-Braunbaer.html` | Braunbär: Dichte, Nachweise, Begegnungen | im Blatt, Gewässer aus `uploads/`, NUTS-Kreise per CDN |
| 17 | `Rumaenien-Physisch.html` | Höhenschichten und Schummerung aus SRTM | `blatt15-daten.js` |
| 18 | `Rumaenien-Wirtschaft.html` | Bodennutzung, Bergbau, Industrie, Energie | `blatt18-daten.js`, `blatt15-daten.js` |
| 19 | `Rumaenien-Landschaften.html` | Neun historische Landschaften | `blatt15-daten.js` |
| — | `QGIS-Kartensatz.dc.html` | Dokumentation des QGIS-Kartensatzes | — |

Blatt 7 und 16 tragen ihre Sachdaten als Arrays im Blatt selbst; die Geometrien für
Bundesland-, Staats- und Kreisgrenzen holen sie zur Laufzeit von jsDelivr beziehungsweise
Eurostat. Die Karten unter `atlas/qgis/themen/` sind die QGIS-Fassung derselben Themen, kein
Zulieferer für die HTML-Blätter. **Alle Blätter brauchen zum Anzeigen eine Internetverbindung**
— D3 und topojson kommen von unpkg.

Die Zeichenerklärung führt eine eigene Blattzählung 01–14 innerhalb einer Datei; die
Kartenblätter zählen davon unabhängig weiter.

## Verzeichnisse

    atlas/
      signaturen.js     Signaturenkatalog — die gemeinsame Sprache aller Blätter
      farben.js         Farbsystem; Blätter holen Farben hier, nicht als Hex-Literal
      GLOSSAR.md        Fachbegriffe der Blätter, alphabetisch
      geodaten/         Pipelines und erzeugte Datenmodule → eigener Abschnitt unten
      paletten/         dieselben Farben als .gpl für QGIS und GIMP
      qgis/             Kartensatz: basis/ themenneutral, themen/ je Karte
      quellen/          Quellenregister je Blatt, mit Belegstatus
    arbeit/             Bereich des Menschen — QGIS-Projekte, Feld-GeoPackages
    uploads/            Rohdaten, die Blatt 15 und 16 direkt laden
    _ds/                gebundenes Design-System (Schriften, Tokens) — generiert

Die Rollen sind getrennt: in `arbeit/` schreibt nur der Mensch, alles Übrige pflegt das
Projekt. Details in `github.md`.

Wer an Signaturen oder Farben rührt, muss die QGIS-Seite nachziehen — welche Artefakte das
betrifft, steht in `CLAUDE.md`.

## Geodaten

Jede Pipeline ist nach `region-thema` benannt und lädt sich ihre Quellen selbst:

| Skript | Erzeugt | Quellen |
|---|---|---|
| `atlas/geodaten/rumaenien-verkehr.rb` | Bahn, Straßen, Flüsse (Blatt 15) | OSM (Geofabrik), Natural Earth |
| `atlas/geodaten/rumaenien-nutzung.rb` | neun Nutzungsklassen (Blatt 18) | CORINE Land Cover 2018 |
| `atlas/geodaten/freiburg-friedhof.rb` | Friedhofsgrundriss | OSM |
| `atlas/geodaten/brandenburg/nutzung.sh` | Nutzung, Gewässer, Orte (Blatt 7) | CLC5 (BKG), OSM, zwei gepflegte CSV |
| `atlas/geodaten/brandenburg/pruefe-hanf.rb` | Prüfbericht | `sorten.csv` gegen `hanf-<jahr>.geojsonl` |

    apt install osmium-tool gdal-bin wget unzip

Das deckt alle Skripte ab; `rumaenien-nutzung.rb` und `freiburg-friedhof.rb` kommen mit
`gdal-bin` allein aus. Jedes Skript prüft seine Werkzeuge beim Start und bricht mit der
passenden `apt`-Zeile ab.

**CORINE braucht einen manuellen Schritt:** der Datensatz ist nur nach kostenloser
Registrierung zu bekommen. `rumaenien-nutzung.rb` bricht mit einer Anleitung ab, wenn das
GeoPackage nicht daneben liegt.

**In `atlas/geodaten/` liegt Gepflegtes neben Wegwerfbarem.** Versioniert sind die Skripte,
die Datenmodule (`blatt*-daten.js`) und handgepflegte Tabellen wie `hanf-anbau.csv`. Alles
Andere — `.osm.pbf`, `.gpkg`, `.zip`, entpackte Shapefiles, zusammen mehrere Gigabyte — ist
Zwischenstufe und per `.gitignore` ausgenommen; die Skripte holen es beim nächsten Lauf
wieder. Was ignoriert wird und warum, steht kommentiert in `.gitignore`.

Ausnahme: unter `atlas/qgis/` ist ein `.gpkg` ein gepflegtes Kartenartefakt und wird
versioniert.

## Quellen und Belege

Jede Zahl, die auf einem Blatt steht, hat in `atlas/quellen/` eine Zeile mit einem von drei
Status: **belegt**, **abgeleitet** oder **unbelegt**. Unbelegte Angaben werden auf dem Blatt
als solche gekennzeichnet — oder sie fliegen raus.

Belegt sind bisher nur Blatt 15 und 16. Für Blatt 7, 17, 18 und 19 fehlt das Register noch —
deren Zahlen sind damit formal unbelegt.

## Bekannte Lücken

**`atlas/geodaten/blatt15-daten.js` ist eine Rekonstruktion.** Das Original im
Claude-Design-Projekt ließ sich nicht vollständig exportieren — es ist 291 KB groß, der
Export deckelt bei 256 KiB und liefert abgeschnittenes JSON. Der hiesige Nachbau enthält
`gewaesser` aus `uploads/gewaesser.geojson-86b9210a.dat`, also genau den einen Key, den
Blatt 17, 18 und 19 daraus lesen.

Der `bahn`-Datensatz des Originals fehlt bewusst: er machte den Großteil der 291 KB aus, und
gelesen wird er von niemandem — Blatt 15 holt seine Daten direkt aus `uploads/` und bindet
das Modul gar nicht ein. Falls er doch gebraucht wird, erzeugt ihn
`atlas/geodaten/rumaenien-verkehr.rb` neu.

**Nicht importierte Bilddateien.** Aus dem Design-Projekt fehlen lokal noch die Binärdateien:
`scans/` (8 Vorlagenscans des gedruckten Atlas), einige `screenshots/`, sowie die Assets des
Reiseplaners (`wf-a.png`, `wf-b.png`, `logo-stern.png`, `wordmark-hand.png`). Die
Präsentationen unter `arbeit/reiseplaner/` zeigen deshalb leere Bildrahmen.

## Konventionen

- Deutsche Feld- und Layernamen sind der Vertrag zwischen Daten und Blatt. Wer ein Feld
  umbenennt, bricht den Build.
- Farben kommen aus `atlas/farben.js` beziehungsweise der `.gpl`, nie als neues Hex-Literal.
- Commits nach Conventional Commits.
