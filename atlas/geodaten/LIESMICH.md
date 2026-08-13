# Geodaten — welches Skript macht welche Datei

Ein Skript je Gegenstand, der Name sagt den Gegenstand. Alles, was ein Skript holt
oder zwischenspeichert (`*.osm.pbf`, `source.gpkg`, entpackte Lieferungen), bleibt
liegen und wird beim zweiten Lauf nicht neu geladen.

| Skript | Eingabe | Ausgabe | gelesen von |
|---|---|---|---|
| `rumaenien-verkehr.rb` | OSM (Geofabrik), Natural Earth — holt selbst | `bahn`, `strassen`, `strassen-bau`, `gewaesser` `.geojson` | Rumaenien-Verkehr, Rumaenien-Physisch |
| `rumaenien-nutzung.rb` | `clc2018.zip` oder `.gpkg` — **einmaliger Handdownload** | `nutzung-*.geojson` (neun Klassen) | Rumaenien-Wirtschaft (über `nutzung-daten.js`) |
| `freiburg-friedhof.rb` | Overpass (vier Spiegel) oder Overpass-Turbo-Export | `friedhof-freiburg.geojson` + `.gpkg` | Nikolais-Ort |
| `brandenburg/nutzung.sh` | CLC5 (BKG), OSM — holt selbst | `landnutzung`, `gewaesser`, `orte`, `hanf-kreise`, `verarbeitung` `.geojson` | Brandenburg-Landwirtschaft |
| `brandenburg/pruefe-hanf.rb` | `hanf-*.geojsonl`, `sorten.csv` | **nichts** — berichtet nur | — |

## Was hier *keine* Datei erzeugt

Zuordnungstabellen, die ein Mensch pflegt, werden zur Laufzeit gelesen — vom Blatt,
von QGIS per Attributverknüpfung, von QField als Wertliste. Sie haben deshalb kein
Exportskript, sondern höchstens ein Prüfskript:

| Tabelle | Anleitung |
|---|---|
| `brandenburg/sorten.csv` | `brandenburg/SORTEN.md` |
| `brandenburg/klima-stationen.csv` | `brandenburg/KLIMA.md` |
| `brandenburg/hanf-*.geojsonl` | der NN-Auszug, unverändert wie geliefert |

Ebenfalls nicht hier: `atlas/farben-paletten.rb` — es übersetzt `farben.js` in
`.gpl`-Paletten und rührt keine Geodaten an, liegt deshalb neben `farben.js`.

## Zwei Fallen, die Zeit gekostet haben

1. **Die GeoJSON-Ausgabe von ogr2ogr überschreibt nicht.** Zieldateien müssen vorher
   weg. Dabei nur die *eigenen* Ziele löschen: ein `*.geojson`-Rundumschlag nimmt die
   Ausgaben des Nachbarskripts mit. (Genau das tat `rumaenien-verkehr.rb` bis 08/2026.)
2. **Die CLC5-Lieferung des BKG ist kein einzelnes Shapefile.** Das ZIP entpackt nach
   `clc5_2018.utm32s.shape/clc5/` mit einer Datei je Klassengruppe
   (`clc5_class1xx` … `class5xx`), und Ordnerlayout wie Klassenattribut haben sich
   zwischen Ausgaben geändert. `nutzung.sh` sucht deshalb beide statt sie anzunehmen
   und vergleicht nur die ersten drei Stellen des CLC-Schlüssels — die Hierarchie
   trägt, die Schlüsseltiefe nicht.
3. **d3 wickelt Außenringe andersherum als RFC 7946.** Ein falsch gewickelter Ring
   bedeutet dort „alles außer dieser Fläche", und die Karte wird weltgroß. QGIS und
   ogr ist die Richtung gleich — der Fehler zeigt sich erst im Blatt.
