# Brandenburg · Landwirtschaftliche Nutzung — Quellenregister

Stand der Prüfung: 08/2026.

| Angabe auf dem Blatt | Status | Quelle / Anmerkung |
|---|---|---|
| Hanfschläge 2026: Geometrie, Fläche (ha), Sorte | belegt | InVeKoS/NN-Auswertung MLEUV, Antragjahr 2026, Teilflächentyp HNF, Nutzungscode 701, dl-de/by-2-0. 54 Schläge, 593,8 ha. Aufbereitung `atlas/geodaten/brandenburg/hanf-schlaege.geojson` |
| Sortengruppe (Körner- / Faser- / Doppelnutzung) | abgeleitet | aus dem Zuchtziel der Sorte, gepflegt in `atlas/geodaten/brandenburg/sorten.csv` mit Begründung je Zeile (siehe `SORTEN.md`). **Keine Zeile ist belegt** — die EU-Sortenliste regelt den THC-Gehalt, nicht die Nutzungsrichtung. Vier Sorten (Muka 76, Estica, Orion 33, Santhica 70 — 6 Schläge, 55 ha) sind ungeprüft und werden auf dem Blatt als *ungeklärt* gezeichnet, nicht geraten |
| Nutzungsrichtung als Aussage über den Bestand | unbelegt | Die Sorte legt die Richtung nahe, entscheidet sie aber nicht — Erntezeitpunkt und Schnitthöhe tun das. Das Blatt zeigt die *Anlage*, nicht das Ergebnis. Belegbar erst mit einem Feld aus Betriebsmeldung oder Abnahmeabrechnung |
| Kartodiagramm „Hanf je Landkreis“ (Säulen + Flächenkolorit) | abgeleitet | Kreissummen aus denselben Schlagdaten, Zuordnung über Punkt-in-Polygon gegen die Kreisgeometrie (deutschlandGeoJSON). Die Stufen (< 10 / 10–40 / 40–100 / > 100 ha) sind gesetzt, nicht statistisch hergeleitet |
| Maßstäbe beider Nebenkarten | abgeleitet | zur Laufzeit aus der Abbildung gemessen: Großkreisdistanz zweier Bildpunkte gegen deren Bildabstand, auf 1000 gerundet — nicht als Zahl gesetzt |
| Größenskala der Hanfsignaturen | abgeleitet | flächentreu, Radius ∝ √ha (Signaturfläche proportional zur Schlaggröße) — kartographischer Standard für proportionale Signaturen. **Keine Flannery-Korrektur** (Exponent 0,57): sie ist an Kreisen gemessen, das Blattsignaturbild ist keiner. Bei einer Spanne von 1:508 (0,07–33,1 ha) fällt die Signatur unter ca. 3 ha unter die Strichstärke — dort greift eine **Mindestgröße**, in der Zeichenerklärung vermerkt. 16 der 54 Schläge sind davon betroffen |
| Matrix-Legende „Sorte × Schlaggröße“ | belegt | reine Auszählung der Schlagdaten; die Größenklassen (< 5 / 5–15 / > 15 ha) sind gesetzt |
| Öko-Regelung 6/7 je Schlag | belegt | Feld `oekoregel` derselben Auswertung |
| Nebenkarten-Hintergrund Kyritz (Grünland, Wald, Seen) | unbelegt | von Hand generalisiert wie die Hauptkarte, nur größer gezeichnet — in diesem Maßstab eine Behauptung. Fällt weg, sobald die CLC5-Exporte da sind | kein Feld in den Daten; `guelt_von` ist der Antrags-Gültigkeitsbeginn, kein Saatdatum — bewusst weggelassen (DATENBEDARF № 10) |
| Nutzungszonen (Grünland, Wald, Sonderkultur, Obst, Ödland) | abgeleitet | eigene Generalisierung nach Landschaftskenntnis, keine Parzellenschärfe; CLC5-Ablösung vorbereitet (`brandenburg/nutzung.sh`) |
| Verarbeitungsstandorte (Prenzlau, Wittenberge) | unbelegt | von Hand gesetzt; `verarbeitung.csv` bewusst leer, bis belegt |
| Grenzen, Länder | belegt | deutschlandGeoJSON (GADM), Natural Earth 1:50 M |
| Flüsse | abgeleitet | von Hand generalisiert; Oder/Neiße aus der Grenzgeometrie |
| Ortslagen und Rangstufen | abgeleitet | Koordinaten von Hand, Rangstufen nach Einwohnerklassen ohne Datensatz |

## Was gebraucht wird

1. **Saattermine je Schlag** — hebt die weggelassene Zeitdimension auf das Blatt
   (Anbaufolge-Streifen nach Diercke-Vorbild wird dann möglich).
2. **CLC5-Exporte** (`landnutzung.geojson` u. a.) — ersetzen die Handzonen.
3. **Verarbeitungsstandorte** mit Koordinaten und Art (`verarbeitung.csv`).
