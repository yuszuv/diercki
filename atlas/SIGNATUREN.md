# Der Signaturenkatalog

`atlas/signaturen.js` ist die einzige Quelle für Kartenzeichen im Atlas. Kein Blatt
zeichnet eigene Signaturen; wer eine braucht, trägt sie hier ein. Diese Datei
erklärt, wie der Katalog gebaut ist und was beim Ergänzen gilt.

## Warum ein Katalog und kein Icon-Set

Eine **Signatur** ist kein Icon. Sie ist in der Zeichenerklärung definiert, in
Millimetern bemaßt, im Maßstab generalisiert und trägt den Karteninhalt selbst —
sie steht nicht neben der Aussage, sie *ist* die Aussage. Die Design-System-Regel
„kein Icon-Set, sondern Unicode" gilt für Fließtext, Oberfläche und
Präsentationen; im Kartenfeld regiert dieser Katalog. Die Grenze steht in
`CLAUDE.md`.

## Die fünf Grundformen

Jeder Eintrag ist einer von fünf Typen. Sie entsprechen den kartographischen
Grundformen, nicht technischen Kategorien.

| Kürzel | Form | wofür | Signatur der Funktion |
|---|---|---|---|
| `L` | **Liniensignatur** | Fluss, Straße, Bahn, Grenze | `L(name, sub, layers, extra?)` |
| `P` | **Punktsignatur** | Ort, Bergwerk, Kraftwerk, Hafen | `P(name, sub, spec)` |
| `A` | **Flächensignatur** | Bodennutzung, Bebauung, Schutzgebiet | `A(name, sub, fill, extra?)` |
| `S` | **Sondersignatur** | alles, was gezeichnet werden muss — rohes SVG | `S(name, sub, raw)` |
| `T` | **Schriftmuster** | Beschriftungsregeln je Objektklasse | `T(name, sub, text, style)` |

`name` erscheint in der Zeichenerklärung, `sub` ist die Maßangabe darunter (und
lässt sich blattweise ausblenden).

### Aufbau der Liniensignatur

`layers` ist ein Stapel, **von unten nach oben** gezeichnet. Damit entsteht das
*Casing*: eine breite dunkle Linie unten, eine schmalere farbige darüber, bei
Autobahnen zusätzlich eine helle Mittellinie.

```js
L('Autobahn', 'Casing 1,3 · Band 0,95 · Mittellinie 0,12',
  [{ w: 1.3, c: F.tinte }, { w: .95, c: F.orange }, { w: .12, c: F.papier }])
```

Je Lage: `w` Strichstärke in mm, `c` Farbe aus `farben.js`, `dash` Strichelung in
mm, `o` Deckkraft, `cap` Linienende. Im `extra`-Objekt: `straight: 1` zeichnet die
Musterlinie gerade statt geschwungen (für Grenzen und Bahnen), `ticks` setzt
Sprossen quer zur Achse (Bahnen).

### Aufbau der Punktsignatur

`shape` wählt die Grundform — `circle`, `ring`, `square`, `squareOpen`, `dot`,
`triangle`, `doublering`, `tiegel`, `grundriss`, `none`. `size` ist der
Durchmesser in mm, `sw` die Konturstärke. `glyph` setzt ein Zeichen hinein,
`label` eines daneben. `sizes` statt `size` erzeugt eine abgestufte Reihe für
Streusignaturen.

### Aufbau der Flächensignatur

`fill` ist die Grundfarbe, `border` die Umrandung, `pat` die Textur darüber:
`dots`, `hlines`, `vlines`, `hatch`, `crosshatch`, `raster`, `arcs`, `marsh`,
`plus`. **Textur unter Flächenfarbe ist Absicht** — sie hält die Karte im
Graustufendruck lesbar, wo Farbe allein zusammenfällt.

## Reihenfolge der Gruppen

Die achtzehn Gruppen folgen nicht dem Alphabet, sondern dem Aufbau eines
Kartenbildes von unten nach oben — erst die Erdoberfläche, dann was der Mensch
darauf gesetzt hat, zuletzt der Kartenrahmen:

```
gewaesser · relief · siedlung · beschriftung   Grundgerüst der Situation
grenzen · politisch                            politische Gliederung
strassen · bahnen · seeLuft                    Verkehr
rohstoffe · industrie · energie                Wirtschaft
landwirtschaft · klima · bevoelkerung          Fläche und Menschen
geologie · umwelt · stadt                      Fachthemen
chrome                                         Kartenrand, Maßstab, Gradnetz
```

Diese Reihenfolge ist auch die Blattfolge der Zeichenerklärung. Wer eine Gruppe
einfügt, fügt sie an der sachlich richtigen Stelle ein, nicht am Ende.

## Maße

**Alle Maße in Millimetern, immer.** Der Renderer rechnet mit `1 mm = 96/25.4 px`
um. Das ist keine Formalie: eine Signatur wird für den Druck entworfen, und nur in
Millimetern lässt sich prüfen, ob sie bei Druckgröße noch lesbar ist. Wer in Pixeln
denkt, entwirft für den Bildschirm und wundert sich später.

Untergrenzen aus der Praxis: Linien nicht unter **0,15 mm** (Laserdrucker und
Offsetdruck schließen sie sonst), Punktsignaturen nicht unter **1,2 mm**,
Schrift nicht unter **5,5 pt** — der Typenscale in `atlas/typenscale.js` setzt das
durch.

## Eine Signatur ergänzen

1. **Prüfen, ob es sie schon gibt.** Eine zweite Signatur für dieselbe Sache ist
   der häufigste Fehler; sie macht die Zeichenerklärung unbrauchbar.
2. **Grundform wählen** — Punkt, Linie, Fläche. Sondersignatur (`S`) nur, wenn
   sich die Sache mit keiner Grundform sagen lässt.
3. **Maße in mm setzen**, Farben ausschließlich aus `atlas/farben.js`.
4. **In die richtige Gruppe** einsortieren, nicht ans Ende der Datei.
5. **Bei Druckgröße prüfen** — auf 100 % ausdrucken, nicht am Bildschirm beurteilen.
6. **QGIS-Teil nachziehen**: `atlas/qgis/`, die `.gpl`-Paletten, das Werkstattblatt
   der Zeichenerklärung. Sonst veraltet der Kartensatz still.

## Was der Katalog *nicht* enthält

- **Farben** — die stehen in `atlas/farben.js`, hier wird nur referenziert.
- **Schriftgrade** — die stehen in `atlas/typenscale.js`.
- **Daten** — Bestandszahlen und Aussagen gehören ins Quellenregister
  (`atlas/quellen/`), nicht in den Katalog.
- **Blattspezifisches** — eine Signatur, die nur ein einziges Blatt braucht und
  nie wieder, ist keine Signatur, sondern eine Zeichnung. Sie bleibt im Blatt.

## Wohin der Katalog wirkt

```
atlas/signaturen.js
   ├─→ Zeichenerklaerung.dc.html   14 Blatt, gedruckte Referenz
   ├─→ atlas/qgis/*.qml            Layerstile für QGIS und QField
   ├─→ atlas/paletten/*.gpl        Farbpaletten für QGIS und GIMP
   └─→ die Kartenblätter selbst
```

Eine Änderung am Katalog ist damit immer eine Änderung an vier Orten. Deshalb
steht in `CLAUDE.md` die Regel, den QGIS-Teil mitzupflegen.

## Sonderfälle

**Die Hanf-Signatur** hat drei Fassungen — Brokkoli (Standard), klassisches
Hanfblatt, ℏ — umschaltbar über `hanfRaws(variante)`. Grund: dasselbe Objekt
braucht je nach Publikum ein anderes Zeichen, ohne dass die Bedeutung wechselt.
Einträge mit dieser Eigenschaft tragen ein `hv`-Feld.

**Die Historientafel** (`HISTORIE`, `EPOCHEN`) ist kein Katalogteil, sondern
Blatt 13 der Zeichenerklärung: dieselben Sachverhalte in drei Druckepochen —
Kupferstich 1883, Offsetdruck 1957, dieses System. Sie zeigt, dass die
Signaturenwahl von der Drucktechnik abhängt und nicht vom Geschmack.
