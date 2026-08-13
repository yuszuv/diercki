# QField-Projektpaket · Hanfkontrolle Brandenburg

Das Paket für die Feldbegehung. Es hat **einen Zweck**: die Lücke schließen, die
das Blatt „Brandenburg · Landwirtschaftliche Nutzung" offenlässt.

Die Karte färbt die Hanfschläge nach Nutzungsrichtung, aber diese Richtung ist
*abgeleitet* aus der Sorte — und die Sorte legt sie nur nahe. Was ein Bestand
wird, entscheiden Erntezeitpunkt und Schnitthöhe. Auf dem Blatt steht das als
Vorbehalt; hier steht das Werkzeug, ihn aufzulösen. Ein Erfassungsfeld
`richtung_ist` nimmt draußen auf, was tatsächlich angebaut wird. Kommt es
zurück, wird aus dem *abgeleiteten* Flächenkolorit ein belegtes.

    themen/brandenburg-hanf/
      stile/hanf_schlaege.qml     Flächenkolorit nach Nutzungsrichtung, ELSE = ungeklärt
      qfield/hanf_kontrolle.qml   Erfassungsformular, feldtauglich sortiert
      skripte/kontrolllayer.py    legt den leeren Erfassungslayer an

Die Daten liegen nicht hier, sondern unter `atlas/geodaten/brandenburg/`:
`hanf-2026.geojsonl` (NN-Auszug, unverändert) und `sorten.csv` (Zuordnung).

## 1 · Projekt aufsetzen

Arbeitssystem ist **EPSG:25833** — ETRS89 / UTM 33N. Meter, damit Hektar direkt
aus der Geometrie rechenbar sind; das ist auch das System des Agrarantrags.

1. `hanf-2026.geojsonl` als Vektorlayer laden. GDAL liest GeoJSONSeq direkt, der
   NN-Auszug muss nicht umgepackt werden. Layer umbenennen in `hanf_schlaege`.
2. `sorten.csv` als Nicht-Geometrie-Layer laden (Layer → Datenquellenverwaltung →
   Getrennte Textdatei, Trennzeichen `;`, **keine Geometrie**). Layername `sorten`.
3. Layereigenschaften von `hanf_schlaege` → **Verknüpfungen** → Layer `sorten`,
   Verknüpfungsfeld `sorte`, Ziellayerfeld `sorte_bez`. Präfix leer lassen, dann
   heißt das verknüpfte Feld `sorten_gruppe`.
4. Stil `stile/hanf_schlaege.qml` laden (Kategorien Symbologie + Beschriftung).
5. `skripte/kontrolllayer.py` in der Python-Konsole ausführen. Es legt
   `hanf-kontrolle.gpkg` neben dem Projekt an und lädt den Layer.
6. Auf `hanf_kontrolle` den Stil `qfield/hanf_kontrolle.qml` laden (Kategorien
   Felder + Formulare).

Warum die Verknüpfung und keine Kopie: die Zuordnung wird an *einer* Stelle
gepflegt. Web-Blatt, QGIS und QField lesen dieselbe CSV. Eine abgeleitete
Zwischendatei würde still veralten, sobald jemand vergisst, ein Skript zu
starten.

## 2 · Offline-Basiskarten wählen

Ohne Netz draußen. Vor dem Packen mit **QFieldSync** (Erweiterung installieren,
dann Plugins → QFieldSync → Projekt für QField packen):

- Basiskarte: DOP als **Offline-Raster** über den gewählten Ausschnitt. Nicht
  landesweit — pro Begehungstag reicht der Umkreis der Schläge plus 2 km. Ein
  landesweites DOP-Paket sprengt jeden Telefonspeicher und dauert Stunden.
- Ausschnitt: in QGIS auf die Schläge des Tages zoomen, dann in QFieldSync
  „Aktuellen Kartenausschnitt verwenden".
- Vektorlayer: `hanf_schlaege` als **Kopie** (offline), `hanf_kontrolle` als
  **Offline-Bearbeitung**. Der verknüpfte `sorten`-Layer muss mit — sonst
  fehlt draußen die Wertliste.
- Feldblöcke (FLIK) als WMS gehen offline nicht. Wenn sie gebraucht werden:
  vorher als Vektor exportieren und mitpacken.

## 3 · Draußen

Reihenfolge, die sich bewährt: erst Schlag betreten, dann Formular. Nicht
umgekehrt — das Standardgeometrie-Feld nimmt die GPS-Position bei Anlage des
Objekts, und die soll im Bestand liegen, nicht am Feldrand.

- **GPS-Genauigkeit** prüfen, bevor der erste Punkt sitzt: QField zeigt sie im
  Positionierungs-Menü. Unter 5 m ist für Schlagzuordnung genug, für eine
  Grenzaussage nicht. Das Feld `gps_genauigkeit` nimmt den Wert automatisch auf.
- **`richtung_ist`** ist das Feld, um das es geht. „unklar" ist eine erlaubte
  Antwort und besser als eine geratene — sie bleibt dann als eigene Klasse
  sichtbar, genau wie auf dem Kartenblatt.
- **Ein Foto je Schlag** genügt, aus Bestandshöhe in den Bestand hinein. Foto
  vom Feldrand über den ganzen Schlag sagt fachlich wenig.
- **Akku:** Karte hell und DOP-Raster kosten. Telefon im Flugmodus mit GPS an,
  Powerbank in die Tasche. Ein Begehungstag mit 20 Schlägen ist ohne Nachladen
  machbar, mit Fotos knapp.

## 4 · Zurück

Plugins → QFieldSync → **Vom QField-Projekt synchronisieren**. Danach, bevor
irgendetwas weiterverarbeitet wird:

1. **Plausibilität** — liegt jeder Kontrollpunkt im zugehörigen Schlag?
   `pruefe-hanf.rb` prüft die Sortentabelle, nicht die Aufnahme; für die
   Aufnahme genügt in QGIS ein räumlicher Verbund mit `hanf_schlaege` und ein
   Blick auf die Punkte ohne Treffer.
2. **`richtung_ist` gegen `sorten_gruppe` halten.** Die Abweichungen sind der
   Ertrag der Begehung. Wo sie systematisch auftreten (immer dieselbe Sorte
   anders genutzt), gehört das in `sorten.csv` — in die Spalte `begruendung`,
   mit Datum und „im Feld bestätigt".
3. **Belegstatus fortschreiben.** Eine im Feld bestätigte Zeile wird von
   `unbelegt` zu `belegt`, Quelle: die Begehung. Das ist der einzige Weg, auf
   dem eine Zeile dieser Tabelle je den Status wechselt.

Konflikte beim Sync entstehen, wenn dieselbe Zeile in QGIS und in QField
geändert wurde. QFieldSync fragt dann; im Zweifel gilt die Feldaufnahme, weil
sie näher am Gegenstand war.
