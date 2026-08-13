# Übergabe — Stand 7. August 2026

Für den nächsten Chat mit frischem Kontext. Die verbindlichen Regeln stehen in
`CLAUDE.md`, der Backlog in `IDEEN.md`, was von außen fehlt in `DATENBEDARF.md`.
Diese Notiz sagt nur, wo der Faden liegt.

## Was in dieser Runde entstanden ist

| Ergebnis | Ort |
|---|---|
| Hanf 2026 schlaggenau im Landwirtschaftsblatt — flächentreue Signaturgröße (√ha) mit Größenleiter, Kartodiagramm je Landkreis, Matrix-Legende Sorte × Größe, Nebenkarte Kyritz | `Brandenburg-Landwirtschaft.html` |
| Blatt 8 Klima — Kartodiagramme, Walter-Lieth-Randspalte, Station-×-Monat-Matrix, Geländeklima-Nebenkarte, Vergleichsort-Tweak | `Brandenburg-Klima.html` |
| Werkstattblatt Relief — Isohypsen, Hypsometrie, Schummerung, Böschungsschraffen, Schraffe ≠ Schraffur | `Loreley-Relief.html` |
| QField-Feldpaket Hanfkontrolle | `atlas/qgis/themen/brandenburg-hanf/` |
| Reliefstile und Schummerungswerte für QGIS/QField | `atlas/qgis/basis/stile/relief_*.qml`, `atlas/qgis/themen/loreley-relief/README.md` |
| Vier Skills nach Sondierung | `skills/`, Begründung `recherche/skills-agents-mcp-sondierung.md` |
| Diercke-Scans entzerrt und gestöpselt | `scans/spread-*.jpg`, `scans/*-seite-*.jpg` |
| Skripte aufgeräumt, Index dazu | `atlas/geodaten/LIESMICH.md` |

## Der nächste Schritt

**CLC2018 und CLC5 einspielen** (DATENBEDARF № 7). Zwei getrennte Sachen mit
verwirrend ähnlichem Namen:

- `ruby atlas/geodaten/rumaenien-nutzung.rb` — braucht `clc2018.zip` oder `.gpkg`
  daneben (Copernicus, Handdownload). Erzeugt neun `nutzung-*.geojson` für das
  Rumänien-Wirtschaftsblatt.
- `atlas/geodaten/brandenburg/nutzung.sh` — holt CLC5 (BKG, 1,24 GB) und OSM selbst.
  Erzeugt `landnutzung.geojson`, das die **Handzonen** auf dem Landwirtschaftsblatt
  ersetzt und der Kyritz-Nebenkarte ihren belegten Hintergrund gibt.

Die **Präse zu Iteration 2** ist inzwischen gebaut:
`praesentationen/Iteration-2-Konzept.dc.html`. Sie beantwortet die Zoom-Frage nicht mit
ja oder nein, sondern legt drei Zuschnitte vor — A nichts bauen, B geführte Fahrt über
die vorhandenen Blätter, C echtes Multiscale mit eigener Auswahl je Stufe. **Was noch
fehlt, ist Jans Wahl**; solange sie offen ist, wird an Iteration 2 nichts gebaut.
Ebenfalls nachgezogen: AGENTS.md (zwei neue CLAUDE.md-Regeln, Skills-Abschnitt).

## Was auf dem Blatt steht und nicht belegt ist

Wer daran weiterarbeitet, muss diese vier kennen:

1. **Klimablatt: keine einzige belegte Zahl.** Alle Monatswerte sind Platzhalter aus
   dem Gedächtnis. Nötig: DWD-Monatsmittel 1991–2020. Tabelle
   `atlas/geodaten/brandenburg/klima-stationen.csv`, Anleitung `KLIMA.md`.
2. **Hanf-Nutzungsrichtung ist abgeleitet, nicht belegt** — aus dem Zuchtziel der
   Sorte (`sorten.csv`), und die Sorte entscheidet die Nutzung nicht: das tun
   Erntezeitpunkt und Schnitthöhe. Vier Sorten (Muka 76, Estica, Orion 33,
   Santhica 70 — 6 Schläge, 55 ha, 9 %) sind ungeprüft und stehen als *ungeklärt*
   auf der Karte. Santhica braucht wohl eine eigene Gruppe (Cannabinoid-Zuchtziel).
3. **Loreley: Geländemodell konstruiert.** Ein Beispielblatt für Darstellungsformen,
   keine Aussage über das Mittelrheintal. Belegt würde es mit DGM1 des LVermGeo RLP.
4. **Kyritz-Nebenkartenhintergrund unbelegt** — von Hand generalisiert, in 1:145 000
   eine Behauptung. Fällt mit CLC5 weg.

## Zwei Regeln, die hier teuer gelernt wurden

- **Zuordnungstabellen zur Laufzeit lesen**, kein Build-Schritt, keine abgeleitete
  Zwischendatei. `sorten.csv` und `klima-stationen.csv` werden vom Blatt beim Laden,
  von QGIS per Attributverknüpfung und von QField als Wertliste gelesen. Skripte
  dürfen prüfen und berichten (`pruefe-hanf.rb`), nicht erzeugen.
- **Fehlt ein Eintrag, wird nicht geraten** — der Fall bekommt eine eigene, sichtbare
  Klasse. Beides steht inzwischen in `CLAUDE.md` und im Skill `belegstatus`.

## Drei technische Fallen dieses Projekts

1. **d3-Wicklungsrichtung** weicht von RFC 7946 ab — falsch gewickelter Außenring
   macht die Karte weltgroß.
2. **`projN.precision(0)` plus `clipExtent`** bei großer Maßstabszahl. Ohne das läuft
   der Kegelentwurf in die Singularität: 32 MB Pfadtext, Blatt nicht rasterisierbar.
   Ein `clip-path` versteckt nur optisch.
3. **Schwellen an die Sachverteilung binden, nicht an die Flächenverteilung.** Ein
   Flächenperzentil als Schraffenschwelle vergibt per Konstruktion an 1−q der Karte
   eine Schraffe — das Ergebnis ist eine Schraffur, also das Gegenteil der Absicht.
