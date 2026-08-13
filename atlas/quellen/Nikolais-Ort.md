# Quellenregister · Nikolais Ort (Hauptfriedhof Freiburg)

Blatt: `Nikolais-Ort.dc.html`

Dieses Blatt trägt weniger Zahlen als jedes andere im Atlas, und das ist Absicht.
Es behauptet keine Grabstelle. Es zeigt die Fläche, benennt, was belegt ist, und
lässt die Wahl eines Ortes offen.

| Aussage | Status | Quelle |
|---|---|---|
| Anonymes Urnengrabfeld = Feld 35 | belegt | friedhof.freiburg.de, Gemeinschaftsgräber; de.wikipedia.org/wiki/Hauptfriedhof_Freiburg_im_Breisgau |
| Auf Feld 35 auch Kindergräber und Anatomie-Gräber | belegt | Wikipedia, ebd. |
| Keine Trauerfeier am Grab, keine Angehörigen anwesend | belegt | friedhof.freiburg.de |
| Grabstätte nicht kenntlich gemacht, nicht gestaltbar | belegt | friedhof.freiburg.de |
| Umbettung grundsätzlich nicht erlaubt | belegt | friedhof.freiburg.de |
| Denkmal für anonym Bestattete auf dem Hauptfriedhof | belegt | Badische Zeitung, 16.11.2020 |
| Hauptfriedhof seit 1872, 27,11 ha | belegt | Friedhofsverwaltung Freiburg |
| Anschrift Friedhofstraße 8, 79106 Freiburg | belegt | Friedhofsverwaltung Freiburg |
| **Lage von Feld 35 im Grundriss** | **unbelegt** | braucht den Feldplan der Friedhofsverwaltung |
| Nikolai Neumaier liegt auf Feld 35 | **unbelegt** | Angabe des Nutzers; nicht öffentlich prüfbar, wird auch nicht geprüft |

## Widerspruch zur früheren Notiz

`IDEEN.md` sprach vom „Waldfriedhofsteil". Die Recherche findet das anonyme
Urnengrabfeld dagegen als **Feld 35**. Der Hauptfriedhof bietet daneben
Urnengräber im Baumfeld — eine andere Grabart an anderer Stelle. Welche der
beiden zutrifft, weiß nur Jan; das Blatt hält bis dahin beide offen.

## Geometrie

Grundriss, Wege und Bauten kommen aus OpenStreetMap (ODbL), am 7. August 2026
über Overpass Turbo geholt und mit `atlas/geodaten/freiburg-friedhof.rb` auf das
Friedhofspolygon zugeschnitten: aus 4560 Objekten des Abfragerechtecks bleiben
183 innerhalb der Fläche — 172 Wege, 10 Bauten, das Polygon selbst.

Die Fläche ist `relation/13108791`, „Hauptfriedhof Freiburg". Zuschnittregel:
ein Objekt gehört dazu, wenn mindestens 60 % seiner Stützpunkte innerhalb liegen —
nicht schon, wenn es die Fläche streift, sonst kommen die Umlandstraßen mit.

Benannte Bauten im Bestand, und damit die Orientierungspunkte des Blattes:
Krematorium Freiburg, Einsegnungshalle, Mitscherlich Kapelle, Friedhofsverwaltung.
Die Einsegnungshalle ist auch in den Textquellen der Bezugspunkt — das Gräberfeld
der Fliegerangriffs-Opfer liegt nördlich von ihr.

## Die Rückseite

Blatt 2 trägt den Text über Nikolai Neumaier: Krankheit, Sterben, die Übergabe an
Stefan Waldmann. Das ist **Erinnerung des Nutzers**, keine recherchierte Quelle und
keine öffentliche Angabe — sie steht hier, weil er sie selbst gegeben hat, und sie
wird nicht durch Fremdquellen ergänzt.

| Aussage | Status |
|---|---|
| Krebserkrankung, Verlauf gut ein Jahr | Angabe des Nutzers |
| Aufhören mit dem Rauchen während der Erkrankung | Angabe des Nutzers |
| Vermittlung in die Abteilung Römer kurz vor dem Tod | Angabe des Nutzers |
| Übernahme der Betreuung durch Stefan Waldmann danach | Angabe des Nutzers |
| Zwei Anekdoten (Judas Priest, Chemie-Note) | Erinnerung des Nutzers, wörtlich übernommen |
| Arbeitsgebiete, Lehrstuhl, Gedenk-Kolloquium | öffentlich, s. Waldmann-Präse |

**Sprachregister:** Die Rückseite folgt dem Ton von orbit.sternprodukt.de
(github.com/yuszuv/orbit) — erste Person, kurze Aussagesätze, konkrete Namen und
Jahre, Schweres in einem Nebensatz ohne Ausschmückung, ein einzelnes `;)` als
äußerste Regung. Vorbild dort: „Durch eine schwere persönliche und gesundheitliche
Krise ist der zum Hanf gekommen." Ein Halbsatz, dann weiter. Die Formulierungen
stammen, wo möglich, wörtlich vom Nutzer und wurden nicht literarisch überarbeitet.

## Hintergrundkarte

DTK10 des Landesamts für Geoinformation und Landentwicklung Baden-Württemberg,
Open Data unter **dl-de/by-2-0**. Quellenvermerk wie vom Dienst verlangt:
**LGL-BW (2026), Datenlizenz Deutschland – Namensnennung – Version 2.0,
www.lgl-bw.de**

    WMS   https://owsproxy.lgl-bw.de/owsproxy/ows/WMS_LGL-BW_ATKIS_DTK_10_K
    Ebene RDS.LY_DTK10K_EIN      Graustufenkombination, ohne Höhenlinien
          RDS.LY_DTK10K_COL_DIM  Farbkombination aufgehellt
          RDS.LY_DTK10K_COL      Farbkombination
    CRS   EPSG:3857 (deckt sich mit d3.geoMercator, deshalb pixelgenau)

Die Graustufenkombination ist vom Herausgeber ausdrücklich als
Hintergrunddarstellung gedacht und lässt die Höhenlinien weg — sie konkurriert
also nicht mit der Situation im Kartenfeld. Angefordert wird die doppelte
Pixelzahl, damit der Druck nicht an 96 dpi scheitert.

## Wicklungsrichtung — eine Falle, die zweimal zuschlägt

d3-geo rechnet sphärisch und erwartet **Außenringe im Uhrzeigersinn**. Ein
andersherum gewickelter Ring bedeutet dort „alles außer dieser Fläche": der
Grundriss wird weltgroß, die Wege kollabieren auf einen Punkt, und `invert()`
liefert Koordinaten im Atlantik. OSM und RFC 7946 wickeln entgegengesetzt, QGIS
und ogr ist es gleich — die Datei ist also nach Standard korrekt und trotzdem
für d3 falsch.

Gedreht wird deshalb an vier Stellen, damit das Bild nicht davon abhängt, welchen
Weg die Daten nehmen: in `freiburg-friedhof.rb` (beide Zweige) und in allen drei
Ladewegen des Blattes.

## Das gesetzte Zeichen

Der Punkt, den das Blatt speichert, liegt ausschließlich im Browser
(`localStorage`, Schlüssel `nikolais-ort-punkt`). Er wandert nicht ins Projekt,
nicht ins Repo, nicht in einen Export. Das ist keine technische Einschränkung,
sondern die Zusage des Blattes.

## Zeichen-Register

Fünf Fassungen, umschaltbar. Das Clojure-Zeichen ist derzeit nachgebaut, nicht
das Original — die echte Datei (commons.wikimedia.org/wiki/File:Clojure_logo.svg,
EPL-1.0) gehört an ihre Stelle, mit Quellenangabe in der Zeichenerklärung.
