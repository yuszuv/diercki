# Geodaten Brandenburg — Blatt 7 · Landwirtschaftliche Nutzung

Ein Aufruf, `./nutzung.sh`, erzeugt aus offenen Quellen fünf GeoJSON-Dateien.
Alles Zwischenzeug (`*.osm.pbf`, `source.gpkg`, das entpackte CLC5) bleibt liegen und
wird beim zweiten Lauf nicht neu geladen; nur die Zieldateien werden überschrieben.

    apt install osmium-tool gdal-bin wget unzip
    ./nutzung.sh

## Quellen

| Datensatz | Bezug | Lizenz |
| --- | --- | --- |
| CORINE Land Cover 5 ha 2018 (CLC5) | `daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/` — 1,24 GB, einmalig | © GeoBasis-DE / BKG 2021, dl-de/by-2-0 |
| OSM Brandenburg | Geofabrik, `europe/germany/brandenburg-latest.osm.pbf` | © OpenStreetMap-Mitwirkende, ODbL |
| Hanfschläge | „gemeldete" GIS-InVeKoS-Antragsdaten Brandenburg mit anonymisierten Betriebsnummern (`antrag_gem_xx`), über den Geobroker; daraus `hanf-<jahr>.geojsonl` | uneingeschränkt (OpenData), © MLEUV, dl-de/by-2-0 |
| Verarbeitungsstandorte | `verarbeitung.csv`, von Hand gepflegt | eigene Erhebung |

Der Quellenvermerk auf dem Blatt muss BKG, OSM und MLEUV nennen, jeweils mit
Veränderungshinweis — die Daten werden hier generalisiert, also *verändert*. Die
Antragsdaten schreiben die Form vor: „© MLEUV, dl-de/by-2-0, Daten geändert".

## Zieldateien und Datenvertrag

Dateinamen und Attributnamen sind der Vertrag mit dem Kartenblatt; nicht umbenennen.

- **`landnutzung.geojson`** — `klasse` ∈ `acker`, `gruenland`, `feucht`, `wald`,
  `sonderkultur`, `obstbau`, `bergbaufolge`, `stadt`, `wasser`.
  Je Klasse eine aufgelöste Multipolygon-Geometrie, Splitter unter 5 km² fallen weg,
  Vereinfachung ≈ 200 m. Das entspricht dem Blattmaßstab; Parzellenschärfe hat es nie.
- **`gewaesser.geojson`** — `name`, `rang` (1 = stärker gezeichnet).
- **`orte.geojson`** — `name`, `rang` (1 Berlin, 2 Landeshauptstadt, 3 city, 4 town), `einwohner`.
- **`hanf-kreise.geojson`** — `kreis`, `ha`, `jahr`, Geometrie = Kreisumriss.
- **`verarbeitung.geojson`** — `name`, `art`.

Beschnitten wird nur grob auf ein Rechteck um Berlin und Brandenburg. Den sauberen
Rand macht das Blatt selbst — es klippt gegen den Landesumriss (`#bbclip`).

## `hanf-<jahr>.geojsonl` — nicht aus dieser Pipeline

Die Schlaggeometrie erzeugt `nutzung.sh` **nicht**; sie wird von Hand aus den
Antragsdaten gezogen und daneben gelegt. Eine Zeile je Schlag (GeoJSONSeq), damit
GDAL und QGIS sie direkt lesen. Attribute wie geliefert, darunter `groesse` (ha),
`sorte_bez`, `code` (701 = Hanf) und `antragjahr`. `sorten.csv` hängt über `sorte_bez`
daran, siehe `SORTEN.md`; `pruefe-hanf.rb` prüft beides gegeneinander.

So entsteht sie, mit den beiden Fallen:

    # Nutzungscode 701 = Hanf, laut Agrarfoerderantrag-Nutzcodeliste im Paket
    SHAPE_ENCODING=ISO-8859-1 ogr2ogr -f GeoJSONSeq -t_srs EPSG:4326 \
      hanf-2026.geojsonl /vsizip/antrag.zip/antrag_land_gem.shp \
      -where "code = '701'"

1. **Die `.cpg` lügt.** Sie deklariert `UTF-8`, die `.dbf` enthält aber Latin-1.
   Ohne `SHAPE_ENCODING` ersetzt GDAL jeden Umlaut durch U+FFFD — sichtbar in
   `bind_name` und `egs_name` als `Fl<FFFD>che`, und dann unwiederbringlich.
2. **Kooperativen liegen doppelt im Bestand.** Das Attribut `auswertung`
   kennzeichnet sie; für Flächensummen sind diese Sätze auszuschließen, sonst wird
   doppelt gezählt. In den bisherigen Auszügen ist das Feld durchgehend leer.

Der Bestand wird mehrmals jährlich fortgeschrieben und gilt fachlich nur für sein
Antragsjahr — die Datei ist eine Momentaufnahme, kein stehender Datensatz.

## Was die Daten nicht hergeben

- **Gemüse und Sonderkulturen im Oderbruch** stehen in CLC5 nicht als eigene Klasse.
  `sonderkultur` sind dort Wein und Oliven-Analoga, `obstbau` ist CLC 222 (Werder).
  Wer den Oderbruch als Gemüsebau zeigen will, braucht die Anbaustatistik je Gemeinde
  und den gleichen Weg wie beim Hanf: Zahl auf Verwaltungsgeometrie.
- **Hanf hatte lange keine offene Geometrie — das gilt nicht mehr.** Das
  Feldblockkataster (DFBK, `data.geobasis-bb.de/geofachdaten/Landwirtschaft/dfbk.zip`)
  kennt nur die Bodennutzungskategorie — *Ackerland, Grünland, Dauerkultur* — und
  damit nie die Kultur. Es scheidet als Hanf-Geometrie aus, und daher stammt der
  Umweg über Kreisfläche + `ha` aus `hanf-anbau.csv`.
  Die **Antragsdaten** dagegen tragen die Kultur als Nutzungscode: 701 = Hanf, nach
  der Nutzcodeliste, die dem Paket beiliegt. Damit gibt es Schlaggeometrie, und
  `hanf-<jahr>.geojsonl` ist genau das. `hanf-anbau.csv` steht deshalb zur
  Disposition: Kreissummen ließen sich aus den Schlägen ableiten, statt sie von Hand
  zu pflegen. Solange die Spalten leer sind, bleibt `hanf-kreise.geojson` leer —
  das ist Absicht, aber kein Dauerzustand.
- **CLC5 ist Stand 2018.** Für ein Blatt in dieser Auflösung reicht das; für Aussagen
  über Veränderung nicht.

## Prüfen, wenn etwas leer bleibt

    unzip -l clc5_2018.utm32s.shape.zip | grep '\.shp$'   # Pfad in CLC_SHP
    ogrinfo -so -al clc5_2018/utm32s/shape/clc5.shp       # Feldname in CLC_FELD
    ogrinfo -so -al source.gpkg                           # Zeilenzahl je Tabelle
