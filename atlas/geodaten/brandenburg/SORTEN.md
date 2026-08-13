# Hanfsorten — Nutzungsrichtung

Die Karte färbt die Hanfschläge nach **Nutzungsrichtung**, nicht nach Sorte. Diese
Zuordnung steht in `sorten.csv` und ist die einzige Stelle, an der sie gepflegt wird;
das Kartenblatt verknüpft sie zur Laufzeit über `sorte_bez` mit den Schlägen aus
`hanf-<jahr>.geojsonl`.

## Spalten

| Spalte | Bedeutung |
| --- | --- |
| `sorte` | Sortenbezeichnung wie in den Antragsdaten (`sorte_bez`), unverändert |
| `gruppe` | `korn`, `faser`, `dual` — oder **leer**, wenn ungeklärt |
| `status` | `belegt`, `abgeleitet`, `unbelegt` — nach dem Quellenregister-Vokabular des Atlas |
| `zuchtziel` | wofür die Sorte gezüchtet wurde, in eigenen Worten |
| `herkunft` | Länderkürzel des Zuchtprogramms |
| `begruendung` | warum die Zeile so steht — der Satz, den ein Prüfer angreifen können muss |

Eine Zeile mit leerer `gruppe` erscheint auf dem Blatt als eigene Klasse
**„Nutzungsrichtung ungeklärt"**, grau und mit gestricheltem Ring. Sie verschwindet
nicht still.

## Warum keine Zeile „belegt" ist

Die naheliegende Quelle trägt die Aussage nicht: die **EU-Sortenliste für Hanf**
(Anhang der GAP-Durchführungsverordnung, jährlich fortgeschrieben) regelt die
Beihilfefähigkeit über den **THC-Gehalt** — sie sagt nichts über Faser oder Korn.
Belegen ließe sich die Nutzungsrichtung über:

1. **Beschreibende Sortenliste des Bundessortenamts** — führt Ertragskomponenten,
   deckt aber nur in Deutschland geprüfte Sorten ab.
2. **Sortenblätter der Züchter** — HempIt (FR) für die Futura-, Fedora-, Ferimon-
   und Santhica-Reihe, IWNiRZ (PL) für Henola, Hemp Genetics International (CA)
   für die CFX-Reihe. Primärquelle, aber Werbematerial.
3. **Die Praxis des Betriebs** — die eigentlich belastbare Auskunft.

## Der entscheidende Vorbehalt

**Die Sorte bestimmt die Nutzungsrichtung nicht, sie legt sie nur nahe.** Was ein
Bestand wird, entscheiden Erntezeitpunkt und Schnitthöhe: derselbe Futura-Schlag
kann als Faser gemäht oder als Korn gedroschen werden. Eine Karte, die nach Sorte
färbt, zeigt deshalb die **Anlage**, nicht das Ergebnis. Das steht so auch in der
Fußzeile des Blatts und im Quellenregister.

Sauber belegbar würde die Karte erst mit einem Feld „Nutzungsrichtung" aus der
Betriebsmeldung oder der Abnahmeabrechnung — dann fiele diese ganze Tabelle weg.

## Ändern — an drei Stellen dieselbe Datei

`sorten.csv` bearbeiten. **Kein Build-Schritt, keine abgeleitete Datei.** Die
Zuordnung wird überall zur Laufzeit gezogen, damit sie nirgends still veralten kann:

| Wo | Mechanismus |
| --- | --- |
| Kartenblatt (Web) | liest `hanf-<jahr>.geojsonl` und `sorten.csv` beim Laden; Seite neu laden genügt |
| QGIS | `sorten.csv` als Nicht-Geometrie-Layer laden, dann Layereigenschaften → **Verknüpfungen** → Feld `sorte_bez` auf `sorte`. Der Stil färbt über das verknüpfte Feld `gruppe` |
| QField | dieselbe CSV als Wertliste im Attributformular; eine Korrektur im Feld ist ein Zeileneintrag, kein Export |

Das GeoJSONSeq-Format (`.geojsonl`, eine Zeile je Objekt) liest GDAL und damit QGIS
direkt — der Schlagauszug muss nicht umgepackt werden.

Ob die Tabelle noch zu den Daten passt, sagt:

    ruby pruefe-hanf.rb

Das Skript erzeugt nichts. Es meldet Sorten ohne Zeile, Zeilen ohne Schlag und
wie viel Fläche an ungeklärten Zeilen hängt — damit die Recherche dort anfängt,
wo sie sich lohnt.

### Was passiert, wenn eine Sorte fehlt

Sie wird **nicht geraten**. Der Schlag bekommt die Gruppe „ungeklärt", erscheint
grau mit Fragezeichen und in einer eigenen Zeile der Zeichenerklärung, die Konsole
warnt mit Namen. Ein neuer Jahrgang mit neuen Sorten fällt damit sofort auf,
statt sich in eine plausible Farbe zu verstecken.
