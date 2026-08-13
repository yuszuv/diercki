# Rumänien · Hauptverkehrsnetz — Quellenregister

Stand der Prüfung: 08/2026.

Dieses Blatt ist überwiegend **Geometrie**, keine Behauptung: was gezeichnet ist, steht so
in den Quelldaten. Die wenigen Aussagen:

| Angabe auf dem Blatt | Status | Quelle / Anmerkung |
|---|---|---|
| Trassen von Bahn, Autobahn, Schnellstraße | belegt | OpenStreetMap, Auszug Geofabrik `romania-latest.osm.pbf`, Pipeline `atlas/geodaten/rumaenien-verkehr.rb`, vereinfacht auf 0,004° |
| Streckennummern 100–900 auf der Karte | belegt | OSM-Feld `name` der Bahnstrecken; die Schilder stehen dort, wo die Nummer im Datensatz liegt |
| Magistralenverzeichnis in der Randspalte (Endpunkte) | abgeleitet | Streckenverlauf nach CFR-Netzgliederung. **900 fehlt in den OSM-Daten** und ist deshalb ausgegraut |
| „Autobahn in Bau", Ausbaustand 08/2026 | belegt | OSM `highway=construction` + `construction=motorway` zum Auszugsdatum |
| Höhenschichten und Schummerung | belegt | Terrain Tiles (SRTM) über AWS, Zoomstufe 7 |
| Flüsse, Strichstärke nach Größenrang | belegt | Natural Earth 1:10 M, Feld `scalerank`. **Nur 18 Objekte im Ausschnitt** — Siret, Someș, Jiu, Argeș, Bega und Timiș fehlen, weil sie im Datensatz `rivers_lake_centerlines` nicht enthalten sind |
| Staatsgrenzen, Küsten | belegt | Natural Earth 1:50 M |
| Maßstab 1 : 3 810 000 | abderleitet | aus der Projektion gemessen: Großkreisdistanz zwischen zwei Bildpunkten der Blattmitte gegen deren Bildabstand |
| Nebenkarte 1 : 1 670 000 | abgeleitet | gleiche Rechnung für den Deltaausschnitt |

## Von Hand gesetzt (nicht aus Daten)

| Element | Anmerkung |
|---|---|
| Ortslagen und Rangstufen der 64 Städte | Koordinaten von Hand, ±1 km. Rangstufen nach Einwohnerklassen (über 1 Mio. / 250 000–1 Mio. / 100 000–250 000 / darunter), **nicht** aus einem Einwohnerdatensatz gezogen |
| Flughäfen (5) und Häfen (8) | Symbolstandorte von Hand neben den Ortssignaturen gesetzt, keine Koordinaten der Anlagen |
| Donau–Schwarzmeer-Kanal | Trasse von Hand generalisiert (Cernavodă – Medgidia – Agigea, Zweig nach Midia); nicht aus OSM |
| Umriss des Donaudeltas, Razim-Sinoi-Lagunen | von Hand generalisiert, keine amtliche Abgrenzung des Biosphärenreservats |
| Korridorhinweise („nach Budapest" u. a.) | Beschriftung, kein Datensatz |
| Gebirgs- und Gewässernamen | von Hand platziert |

## Was gebraucht wird

1. **OSM `highway=primary`** — das DN-Netz jenseits von motorway/trunk; ohne das endet
   die Straßendarstellung im Delta zu früh.
2. **`ne_10m_rivers_europe`** — das dichtere Flussnetz (Siret, Someș, Jiu, Argeș, Bega, Timiș).
3. **OSM `natural=wetland`** für Delta und Lagunen — ersetzt meinen Handumriss durch Geometrie.
4. **OSM `waterway=canal`** — die echte Kanaltrasse.
5. **`ne_10m_populated_places`** — Einwohnerzahlen, damit die Rangstufen aus Daten kommen.
