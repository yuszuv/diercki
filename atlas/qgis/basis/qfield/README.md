# QField und QFieldCloud

Der Kartensatz ist so gebaut, dass ein Blatt ohne Umbau aufs Telefon geht.

## Ein Blatt feldtauglich machen

1. Projekt wie in der Anleitung aufbauen, CRS **EPSG:3844**.
2. Erfassungslayer anlegen — Python-Konsole, aus `../skripte/atlas.py`:
   `erfassungslayer("/pfad/beobachtungen.gpkg")`
3. Auf den neuen Layer `beobachtung.qml` laden (Kategorien *Felder* und *Formulare*).
   Damit bekommt QField Auswahllisten statt Freitext, ein Datum, das sich selbst setzt,
   und ein Fotofeld.
4. **QFieldSync** → *Projekt für QField packen*. Dabei zählt:
   - Erfassungslayer auf **Offline-Bearbeitung**, alle anderen auf **keine Aktion**.
   - Grundkarte eng zuschneiden. Ein Deltakasten reicht; ganz Rumänien als Kachelsatz
     sprengt jedes Telefon.
   - Ein Kartenthema festlegen, sonst startet QField mit allen Layern gleichzeitig.
5. Ordner aufs Gerät kopieren oder über QFieldCloud verteilen.

## QFieldCloud

Nur nötig, wenn mehrere Leute gleichzeitig erfassen. Sonst reicht der Ordner.

- Ein Projekt je Kartenblatt, nicht je Begehung.
- **Nur der Erfassungslayer** ist gemeinsam bearbeitbar. Alles andere bleibt Lesestoff,
  sonst sind Grenzen und Trassen nach der dritten Begehung verschoben.
- Die GeoJSON aus `themen/*/daten/` gehören nicht in die Cloud-Bearbeitung: sie kommen
  aus der Pipeline und werden dort erneuert, nicht im Feld.
- Vor der Fahrt einmal synchronisieren, nach der Fahrt einmal. Dazwischen offline —
  spart Akku und vermeidet halbe Uploads.

## Was erfahrungsgemäß schiefgeht

| Symptom | Ursache |
|---|---|
| Signaturen fehlen auf dem Telefon | Das SVG liegt nur im QGIS-Suchpfad. QFieldSync kopiert Dateien nur, wenn sie **im Projektordner** liegen — für Feldprojekte `basis/svg/` neben das Projekt kopieren. |
| Beschriftung in fremder Schrift | Gentium ist auf Android nicht installiert. Für Feldprojekte auf eine Systemschrift stellen oder Beschriftung abschalten. |
| Fotos landen nicht im Sync | `RelativeStorage` muss an sein (im `beobachtung.qml` gesetzt) und der Zielordner im Projektordner liegen. |
| Punkte scheinbar versetzt | Gerät liefert WGS 84, Projekt steht auf 3844 — das rechnet QField um. Verdächtig wird es erst ab etwa 50 m: dann die GPS-Genauigkeit im Positionsdialog prüfen. |
