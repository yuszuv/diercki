# Datenbedarf — was von Jan kommt

Sammelstelle für Geo- und Fachdaten, die einzelne Blätter von *abgeleitet* auf
*belegt* heben. Nach Wirkung sortiert. Wenn etwas geliefert ist: Zeile nach
„Erledigt" verschieben, Blatt nachziehen, Quellenregister aktualisieren.

## Offen

### 1 · MMAP-Kreistabelle zur Braunbärenzählung — Braunbär
Abundanz je județ aus dem Bericht des Ministerul Mediului, Apelor și Pădurilor
(vorläufige Ergebnisse 04/2025). Format egal: CSV, PDF-Tabelle, Screenshot.
**Wirkung:** die Kreiswerte auf dem Braunbärenblatt sind derzeit eine unbelegte
Modellannahme; mit der Tabelle wird aus der Modellskizze eine Karte, und der
Warnhinweis im Untertitel entfällt. Größter Hebel im ganzen Atlas.

### 2 · STPT-GTFS-Paket — Liniennetz Banat
`stops.txt`, `routes.txt`, `trips.txt`, `stop_times.txt` von tranzy.ai/opendata
bzw. stpt.ro/open-data.
**Wirkung:** das Tram-Inset ist derzeit auf fünf Korridore verdichtet. Mit den
echten Haltestellenfolgen je Linie wird es vollständig, die Umsteigepunkte
stimmen, und die oktilineare Schematisierung lässt sich aus den realen
Koordinaten *ableiten* statt sie zu setzen — die Karte bleibt nicht lagetreu,
aber ihre Generalisierung wird nachvollziehbar.

### 3 · Bahnhofsfolgen der CFR-Strecken im Banat — Liniennetz Banat
Aus OSM (`railway=station`/`halt` entlang der Streckenrelationen) oder als
Kursbuchauszug.
**Wirkung:** die Zwischenhalte sind derzeit in Auswahl gezeigt; damit werden sie
vollständig und der Vermerk „Bahnhalte in Auswahl" fällt weg.

### 4 · Bienenstock-Register je Kreis — Braunbär
ANSVSA oder APIA, Zahl der gemeldeten Bienenvölker/Stände je județ.
**Wirkung:** aus den fünf qualitativen Trachtsignaturen wird ein Kartogramm.

### 5 · GBIF-Abzug Wildbienen, country=RO — Braunbär
Familien Andrenidae, Halictidae, Megachilidae; *Hoplitis papaveris* gern separat.
**Wirkung:** die Wildbienenebene steht derzeit auf dem Lebensraumargument.
Mit Fundpunkten steht sie auf Nachweisen — und die Nebenkarte zur
Mohn-Mauerbiene kann von „Beispiel für die Lebensweise" auf ein belegtes
rumänisches Vorkommen umgestellt werden.

### 6 · Schadensstatistik an Bienenständen — Braunbär
Aus den Kreisumweltbehörden. **Wirkung:** belegt die Aussage zum Konflikt
Bär ↔ Imkerei, die derzeit nur allgemein begründet ist.

### 7 · CLC2018 — Bodennutzungsblatt  ✓ *erledigt 08.08.2026*
Die neun `nutzung-*.geojson` aus `rumaenien-nutzung.rb` sind da (Upload 08.08.,
zusammen ≈ 11,6 MB) und liegen unter `atlas/geodaten/`. Das Wirtschaftsblatt lädt
acht davon als echte Flächenklassen; die Handzeichnung in `nutzung-daten.js` ist
nur noch Rückfallebene mit Vermerk am Blattfuß. `nutzung-acker.geojson` bleibt auf
dem Blatt ungenutzt (Ackerland ist Grundton), liegt aber für QGIS bereit.
Quellenregister: `atlas/quellen/Rumaenien-Wirtschaft.md`.

### 10 · Hanf: Saattermine je Schlag — Hanf-Integration
**Teilerledigt 07.08.2026:** Die InVeKoS-Schlagdaten 2026 sind da
(`uploads/hanf_daten-….txt` → `atlas/geodaten/brandenburg/hanf-schlaege.geojson`,
54 Schläge, 593,8 ha, Geometrie + ha + Sorte + ÖR/Bindungen) und im
Brandenburg-Blatt verbaut. **Weiter offen:** echte Saattermine — die Daten
führen nur `guelt_von` (Antrags-Gültigkeitsbeginn), `ansaatjahr` ist leer.
**Wirkung:** mit Terminen wird die Anbaufolge-Zeitleiste (Diercke-Vorbild
Knoblauchsland) möglich; bis dahin bleibt der Saattermin bewusst weg.
Dazu weiter offen: die `ha`-Spalte je Kreis in `hanf-anbau.csv`.

### 11 · Nachscans Diercke Klima + Landwirtschaft — Bundsteg-Streifen  ✓ *erledigt für S. 48*
Die extrahierten Seiten 46/47 und 48–51 verlieren am Bundsteg je einige mm;
auf S. 48 fehlt zusätzlich die halbe linke Legendenspalte (Text + Farbchips).
Beim Nachscannen genügt: Buch flacher aufdrücken bzw. Seite ein Stück weiter
zum Rand legen — konkret fehlen:
- **S. 46 rechts:** Streifen östlich ~14° (Oder, Rahmenlinie)
- **S. 47 links:** Weststreifen Bioklima-Karte + Dortmund-Kartenrand
- **S. 48 links:** Legendenspalte „Nutzungssysteme“ komplett, Seitenzahl
- **S. 49 links:** Weststreifen Verarbeitungs- und Bodentypen-Karte
- **S. 50/51:** nur Bundsteg-Ränder, verschmerzbar
**Wirkung:** vollständige Referenz-Spreads; die Legenden-Rekonstruktion
(als solche markiert) kann sonst nur den Text, nicht die Chips belegen.

### 8 · Feldplan der Friedhofsverwaltung Freiburg — Nikolais Ort
Lage von **Gräberfeld 35** im Grundriss des Hauptfriedhofs. OSM kennt die
Feldnummern nicht, und ohne den Plan bleibt die Fläche auf dem Blatt unbelegt.
Quelle: Eigenbetrieb Friedhöfe Stadt Freiburg. Format egal, auch ein abfotografierter
Übersichtsplan am Eingang genügt zum Digitalisieren.
**Wirkung:** aus „irgendwo auf dem Friedhof" wird „innerhalb dieser Fläche" — die
einzige inhaltliche Lücke, die auf dem Blatt noch als *unbelegt* steht.

### 9 · Baumkataster oder Begehungsdaten — Nikolais Ort
**Bestätigt 07.08.2026:** der erweiterte OSM-Abzug bringt 233 Einzelbäume, aber
**null Artangaben** — nur `leaf_type` (broadleaved/needleleaved). Damit ist die Lücke
gemessen, nicht mehr vermutet.
Zur Flora des Hauptfriedhofs sagt OSM nichts Belastbares; Artangaben an Einzelbäumen
gibt es nur, wenn ein Mapper sie eingetragen hat. Entweder das Baumkataster des
Grünflächenamts Freiburg, oder eine eigene Begehung mit QField (Erfassungslayer nach
dem Muster `basis/qfield/beobachtung.qml`, erweitert um Art, BHD, Totholzanteil).
**Wirkung:** alte Stadtfriedhöfe sind ökologisch bemerkenswert — aber das ist eine
Kategorienaussage, kein Befund über diesen Ort. Mit Daten wird daraus einer.

## Erledigt
- **OSM-Grundriss Hauptfriedhof Freiburg** (07.08.2026, über Overpass Turbo) —
  4560 Objekte des Abfragerechtecks, auf das Friedhofspolygon zugeschnitten auf 183:
  172 Wege, 10 Bauten, die Fläche. Vier benannte Bauten als Orientierung:
  Krematorium, Einsegnungshalle, Mitscherlich-Kapelle, Friedhofsverwaltung.
  Ablage: `atlas/geodaten/friedhof-freiburg.geojson`.
  **Erweiterter Abzug geliefert (07.08.2026)** — 462 Rohobjekte, zugeschnitten auf 459:
  1 Fläche, 172 Wege, 10 Bauten, 10 Mauern, 8 Hecken, 2 Rasenflächen, 1 Wasser,
  4 Denkmale (Germania, Grab- und Ehrenmal 27. November 1944, Vertriebenenkreuz,
  ein unbenanntes), 18 Möbel, **233 Einzelbäume**.
  *Bleibt offen (№ 9):* keiner der 233 Bäume trägt eine Artangabe — nur `leaf_type`
  (174 broadleaved, 9 needleleaved), und das ist Laub- gegen Nadelholz, keine Art.
  Die Flora braucht weiter Baumkataster oder Begehung.
- **Porträt Nikolai Neumaier** (`uploads/neumaier_kurzhaar.jpg`, 140 × 180 px).
  Eine höher aufgelöste Fassung derselben Aufnahme wäre für Blatt 2 und die
  Waldmann-Präse ein spürbarer Gewinn.

## Format
Alles recht: GeoJSON, GeoPackage, Shapefile, CSV, PDF-Tabelle, Screenshot.
Ablage in `uploads/`. CRS egal — ich rechne um; für Rumänien arbeite ich in
EPSG:3844 (Stereo 70), für Brandenburg in EPSG:25833.
