# Relief in QGIS und QField

Die vier Register des Blatts `Loreley-Relief.html` als QGIS-Einstellungen. Das Blatt
ist die Vorlage, hier steht, wie es in QGIS und auf dem Telefon dasselbe zeigt.

    basis/stile/relief_isohypsen.qml     Isohypsen, Zähllinie alle 100 m, beschriftet
    basis/stile/relief_hypsometrie.qml   Höhenschichtkolorit auf dem DGM (diskret)

Böschungsschraffen haben **keinen** QML-Stil — dazu unten.

## Daten

DGM des Landes, nicht ein globales Modell. Für die Loreley: **DGM1 des LVermGeo
Rheinland-Pfalz**, für Brandenburg das DGM1 der LGB. 1 m Rasterweite ist für ein
Kartenblatt großzügig; auf 5 oder 10 m aggregieren (Raster → Analyse → Aggregieren
oder `gdalwarp -tr 10 10 -r average`). Das spart Speicher und nimmt der Schummerung
das Rauschen, das sonst als Moiré erscheint.

## Register 1 · Isohypsen

Raster → Extraktion → **Konturlinien**, Äquidistanz 20 m. Ergibt einen Linienlayer
mit dem Feld `ELEV` — im Stil heißt das Feld `hoehe`, also entweder umbenennen oder
die Regeln anpassen (Feldvertrag im Kopf der `.qml`).

Die Äquidistanz gehört auf das Blatt. Ohne sie ist eine Isolinienkarte stumm.

## Register 2 · Hypsometrie

`relief_hypsometrie.qml` auf das DGM laden. Die Stufengrenzen sind die
Atlas-Grenzen — bei einer Höhenspanne von 70 bis 450 m liegt fast alles in zwei
Stufen. Dann eigene Grenzen setzen und in der Zeichenerklärung die Zahl der
**sichtbar belegten** Stufen nennen.

## Register 3 · Schummerung

QGIS bringt sie mit: Layereigenschaften → Symbolisierung → Darstellungsart
**Schummerung**. Werte, die zum Blatt passen:

| Einstellung | Wert | warum |
|---|---|---|
| Azimut | **315°** | Licht aus Nordwest. Verabredung, nicht Physik — Licht aus Südost erzeugt Reliefumkehr |
| Vertikaler Winkel | **45°** | flacher wirkt dramatischer, aber sättigt die Schatthänge nach Schwarz |
| Z-Faktor | **1,2–1,5** | Überhöhung. Höhere Werte lassen steile Hänge durchsättigen und flache Rauigkeit als Streifen erscheinen |
| Mehrfachrichtung | aus | nimmt der Form die Richtung |

Dann die Hypsometrie **über** die Schummerung legen, Mischmodus der oberen Ebene
**Multiplizieren**, Deckkraft der Schummerung etwa 55 %. Schummerung nie allein:
sie ist nicht messbar und hängt an der willkürlichen Beleuchtungsrichtung.

Eine Überhöhung ist immer eine Gestaltungsentscheidung — sie gehört angegeben.

## Register 4 · Böschungsschraffen

Es gibt keinen QML-Stil dafür, und das ist kein Versäumnis: Schraffen sind kein
Symbol, sondern eine Konstruktion aus dem Neigungsraster. In QGIS geht es so:

1. Raster → Analyse → **Hangneigung** auf dem DGM.
2. Ein Punktraster über das Gebiet legen (Vektor → Forschungswerkzeuge →
   Regelmäßige Punkte, Abstand nach Ausgabemaßstab: rund 1,3 mm im Druck).
3. Neigung und **Exposition** (Raster → Analyse → Ausrichtung) auf die Punkte
   samplen.
4. Punktlayer mit einem Linien-Geometriegenerator zeichnen, Länge konstant,
   **Strichstärke nach Neigung**, Drehung nach Exposition.
5. Schwelle: unter etwa 18 % der Maximalneigung des Gebiets **keine** Schraffe.

Punkt 5 ist der, an dem es schiefgeht. Eine Schwelle als *Flächenperzentil* vergibt
per Konstruktion an einen festen Anteil der Karte eine Schraffe — und weil die
ebene Hochfläche meist die Mehrheit der Fläche einnimmt, landet die Schwelle mitten
in ihrer Rauigkeit. Das Ergebnis ist eine **Schraffur** (gleichmäßig) statt
**Schraffen** (ändern sich mit dem Gelände), also das Gegenteil der Absicht. Die
Schwelle bindet an die Spannweite der Hänge, nicht an die Verteilung der Fläche.

## QField

Auf dem Telefon zählt anderes als im Druck:

- **Schummerung als Basiskarte einbrennen.** Ein DGM live schummern kostet Rechenzeit
  und Akku. In QGIS die Kombination Schummerung + Hypsometrie als **GeoTIFF
  exportieren** (Projekt → Import/Export → Karte als Bild speichern, oder besser
  Raster → Diverses → Zusammenführen der gerenderten Ebenen) und dieses eine Bild
  als Offline-Raster mitpacken.
- **Isohypsen als Vektor mitnehmen**, nicht als Bild — draußen will man sie an- und
  ausschalten und ihre Höhe antippen können.
- **Schraffen nicht mitnehmen.** Der Geometriegenerator rechnet auf jedem Zoom neu;
  auf dem Telefon ruckelt das, und im Feld trägt die Schummerung die Form besser.
- **Maßstabsgrenzen setzen**, sonst zeichnet QField beim Herauszoomen alle
  Zwischenlinien und wird träge: Zwischenisohypsen erst ab 1:50 000, Beschriftung
  erst ab 1:80 000 (steht so in `relief_isohypsen.qml`).
- **Helligkeit.** Das Höhenschichtkolorit ist für Papier geeicht. Draußen bei Sonne
  die Deckkraft der Schummerung höher setzen (70–80 %) — Kontrast schlägt dort
  Feinabstufung.
