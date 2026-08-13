# Entscheidungen aus der Fragerunde, 2026-08-07

## Pitch-Deck „Höhle der Löwen"
- Gegenstand: der QField-Bahnreiseplaner
- Ton: trocken mit Rissen (Business-Theater, das gelegentlich bröckelt)
- Stand: ehrlich — Wireframes + QGIS-Workflow, gepitcht wird die Vision
- Kennzahlen: echte Zahlen (Bahnnetz, GTFS, …)
- Löwen: echte DHDL-Löwen namentlich
- Forderung: von mir erfunden (137.000 € für 13,7 %)
- Umfang: ~14 Folien (offen gelassen → meine Wahl)
- Demo-Folie: vorhandene Wireframes A/B/C (offen gelassen → meine Wahl)
- Getrennt von der How-to-Präse (zwei Präsen)

## How-to-Präse „QField als Bahnreise-Planer"
- Eigenständig, Workshop-Stil für Dritte (offen gelassen → meine Wahl)

## Ablage
- Neue Präsen: praesentationen/ am Root (arbeit/ bleibt menschlich)

## Banat-ÖPNV-Karte
- Gebiet: Banat regional (Timișoara & Umgebung)
- Verkehrsmittel: Bahn (CFR) + Tram Timișoara
- Daten: frisch ziehen (OSM/GTFS)
- Stil: klassische Verbindungskarte, geknickte Linien, nicht geographisch treu

## Bärenkarte (Blatt 16)
- Honig-Industrie + Wildbienen qualitativ/symbolisch — Signaturen, keine harten Zahlen

## Nikolais Blatt (Freiburger Hauptfriedhof)
- Eigenständiges stilles Blatt, außerhalb der Atlas-Nummerierung, ohne Gimmicks
- Nur Karte, fast ohne Worte
- Jan kann die Stelle auf 3–4 Umkreise eingrenzen → interaktiver Markier-Modus
  (meine Wahl), Ausschnitt: Übersicht + Waldfriedhof-Detail (meine Wahl)

## Sonstiges
- Unicode-Näherung ⋆ₕ überarbeiten: jetzt mit rein (Neo-Layout durchsuchen)
- CLC2018: offene EEA-Quelle versuchen, ggf. gröber; Token wird nicht genutzt
- Präsen-Feinschliff: inhaltlich/Struktur/Sprache; welche, blieb offen →
  Reiseplaner-Präsis zuerst, nach den Neubauten
- Reihenfolge (meine Wahl): 1 Zeichenerklärung-Gliederung + Zeichensatz-Summary,
  2 Pitch-Deck, 3 How-to-Präse, 4 Banat-ÖPNV, 5 Bärenkarte, 6 Nikolais Blatt
  (interaktiv mit Jan), 7 Unicode-Näherung, 8 CLC2018/Das Bodennutzungsblatt, QGIS-Assets laufend

## Nachtrag: `arbeit/` → `handarbeit/` (07.08.2026)

Der Name war falsch, und zwar auf zwei Ebenen. Erstens implizierte er, alles andere
sei keine Arbeit. Zweitens — und das war der teure Teil — schützte die Regel den
**Ordner** statt der **Sache**, und deshalb landeten dort Dateien, die gar nicht
geschützt werden mussten: drei Präsentationen, die nur hier leben und die ich
deswegen monatelang nicht anfassen durfte, obwohl es dafür keinen Grund gab.

**Neuer Name:** `handarbeit/` — der Doppelsinn ist der Punkt. Von Hand gemacht,
und von Jans Hand.

**Neue Fassung der Regel:** geschützt sind Dateitypen, nicht Verzeichnisse.
`.qgz .qgs .qgd .gpkg .shp` — alles, was außerhalb des Projekts bearbeitet wird und
binär ist, also nicht zusammengeführt, nur überschrieben werden kann. Steht in
`handarbeit/README.md` mit Begründung.

**Mitbewegt:** die drei Reiseplaner-Präsen nach `praesentationen/`, wo sie
hingehören. Relative Pfade angepasst, fehlende Wortmarke aus dem Design-System
nachgeholt.
