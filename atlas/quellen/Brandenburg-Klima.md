# Brandenburg · Klima — Quellenregister

Stand der Prüfung: 08/2026.

**Dieses Blatt trägt derzeit keine belegte Zahl.** Es zeigt die Darstellungsformen
an Platzhalterwerten, damit die Form prüfbar ist, bevor die Daten da sind. Jede
Zahl auf dem Blatt ist als *unbelegt* gekennzeichnet — in den Diagrammen, in der
Zeichenerklärung und in der Fußzeile.

| Angabe auf dem Blatt | Status | Quelle / Anmerkung |
|---|---|---|
| Monatsmittel Lufttemperatur, Monatssummen Niederschlag | unbelegt | Größenordnungen aus dem Gedächtnis gesetzt. Nötig: DWD Climate Data Center, Monatsmittel der Referenzperiode 1991–2020 je Station. Tabelle: `atlas/geodaten/brandenburg/klima-stationen.csv`, Anleitung `KLIMA.md` |
| Stationslagen Potsdam, Cottbus | belegt | Lage unstrittig; Stationshöhen genähert |
| Stationslagen Neuruppin, Alt Madlitz, Wittstock/Dosse | abgeleitet | Koordinaten genommen, nicht gegen die DWD-Stationsübersicht geprüft |
| Diethardt (Vergleichsdiagramm) | abgeleitet | Rhein-Lahn-Kreis, Rheinland-Pfalz — außerhalb des Kartenfelds, deshalb `rolle = vergleich`: erscheint nur in der Randspalte, zuschaltbar über den Tweak *Vergleichsort* |
| Walter-Lieth-Konvention (1 °C ≙ 2 mm, arid/humid) | belegt | etablierte Diagrammkonvention; die Skalenkopplung ist der Grund, warum sich zwei Stationen vergleichen lassen |
| Aridität/Humidität der einzelnen Monate | unbelegt | folgt rechnerisch aus den Platzhalterwerten und ist damit so unbelegt wie diese |
| Geländeklima-Nebenkarte (Odertal) | unbelegt | schematisches Profil, **nicht lagetreu** — als solches beschriftet. Kaltluftsee und Kaltluftbahnen sind Lehrfiguren, keine Messung. Belegbar nur mit einem DGM plus Temperaturmessreihe in der Aue |
| Berlin als eigenes Stadtklima | abgeleitet | die Wärmeinsel ist gut dokumentiert, die Fläche auf dem Blatt aber nur die Landesgrenze — keine Isotherme |
| Grenzen, Länder | belegt | deutschlandGeoJSON (GADM) |

## Was gebraucht wird

1. **DWD-Monatsmittel 1991–2020** für die fünf Orte im Kartenfeld und Diethardt —
   Lufttemperatur und Niederschlagssumme. Danach `status` je Zeile auf `belegt`
   setzen und `quelle` mit der Referenzperiode füllen; das Blatt zieht beim
   nächsten Laden nach.
2. **DWD-Stations-IDs und geprüfte Koordinaten** für die Spalte `dwd_id` —
   erst damit wird `koord_status` von `abgeleitet` zu `belegt`.
3. Für die Geländeklima-Nebenkarte: **DGM** des Odertals plus, wenn es die
   Aussage tragen soll, eine Messreihe aus der Aue gegen eine von der Hochfläche.
