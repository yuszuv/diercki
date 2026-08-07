# Geodaten Brandenburg — Blatt 7 · Landwirtschaftliche Nutzung

Ein Aufruf, `./export-geodaten.sh`, erzeugt aus offenen Quellen fünf GeoJSON-Dateien.
Alles Zwischenzeug (`*.osm.pbf`, `source.gpkg`, das entpackte CLC5) bleibt liegen und
wird beim zweiten Lauf nicht neu geladen; nur die Zieldateien werden überschrieben.

    apt install osmium-tool gdal-bin wget unzip
    ./export-geodaten.sh

## Quellen

| Datensatz | Bezug | Lizenz |
| --- | --- | --- |
| CORINE Land Cover 5 ha 2018 (CLC5) | `daten.gdz.bkg.bund.de/produkte/dlm/clc5_2018/aktuell/` — 1,24 GB, einmalig | © GeoBasis-DE / BKG 2021, dl-de/by-2-0 |
| OSM Brandenburg | Geofabrik, `europe/germany/brandenburg-latest.osm.pbf` | © OpenStreetMap-Mitwirkende, ODbL |
| Hanf-Anbaufläche je Kreis | `hanf-anbau.csv`, von Hand gepflegt | InVeKoS-Auswertung MLEUV, dl-de/by-2-0 |
| Verarbeitungsstandorte | `verarbeitung.csv`, von Hand gepflegt | eigene Erhebung |

Der Quellenvermerk auf dem Blatt muss BKG und OSM nennen, mit Veränderungshinweis —
die Daten werden hier generalisiert, also *verändert*.

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

## Was die Daten nicht hergeben

- **Gemüse und Sonderkulturen im Oderbruch** stehen in CLC5 nicht als eigene Klasse.
  `sonderkultur` sind dort Wein und Oliven-Analoga, `obstbau` ist CLC 222 (Werder).
  Wer den Oderbruch als Gemüsebau zeigen will, braucht die Anbaustatistik je Gemeinde
  und den gleichen Weg wie beim Hanf: Zahl auf Verwaltungsgeometrie.
- **Hanf hat keine offene Geometrie.** Feldblöcke (DFBK,
  `data.geobasis-bb.de/geofachdaten/Landwirtschaft/dfbk.zip`, © MLEUV, dl-de/by-2-0)
  kennen die Bodennutzungskategorie, nicht die Kultur. Deshalb Kreisfläche + `ha`
  aus `hanf-anbau.csv`; die Spalte ist absichtlich leer, bis die Zahlen belegt sind.
- **CLC5 ist Stand 2018.** Für ein Blatt in dieser Auflösung reicht das; für Aussagen
  über Veränderung nicht.

## Prüfen, wenn etwas leer bleibt

    unzip -l clc5_2018.utm32s.shape.zip | grep '\.shp$'   # Pfad in CLC_SHP
    ogrinfo -so -al clc5_2018/utm32s/shape/clc5.shp       # Feldname in CLC_FELD
    ogrinfo -so -al source.gpkg                           # Zeilenzahl je Tabelle
