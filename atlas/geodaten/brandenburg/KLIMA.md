# Klimastationen Brandenburg

`klima-stationen.csv` trägt die Monatswerte, die das Blatt „Brandenburg · Klima"
zeichnet. Sie wird **zur Laufzeit gelesen** — vom Blatt beim Laden, von QGIS als
Nicht-Geometrie-Layer mit Attributverknüpfung über `kuerzel`. Kein Build-Schritt,
keine abgeleitete Zwischendatei.

## Die Orte auf dem Blatt

| Ort | Verortung | Anmerkung |
| --- | --- | --- |
| Neuruppin | abgeleitet | Ostprignitz-Ruppin, Koordinate genommen, nicht geprüft |
| Alt Madlitz | abgeleitet | Briesen, Oder-Spree; Koordinate genommen, nicht geprüft |
| Potsdam | belegt | Säkularstation, Lage unstrittig |
| Cottbus | belegt | Lage unstrittig |
| Wittstock/Dosse | abgeleitet | Ostprignitz-Ruppin, Koordinate genommen, nicht geprüft |
| Diethardt | abgeleitet | Rhein-Lahn-Kreis, **Rheinland-Pfalz**, rund 400 m im Taunus. `rolle = vergleich`: erscheint nicht im Kartenfeld, sondern nur als zuschaltbares Vergleichsdiagramm (Tweak *Vergleichsort*), mit Höhenangabe und Vermerk. Der Kontrast zum märkischen Sand ist der lehrreichste auf dem Blatt — sobald echte Reihen vorliegen |

## Belegstatus — bitte zuerst lesen

**Alle Zahlen in der Datei sind derzeit `unbelegt`.** Sie stammen aus meiner
Erinnerung an die Größenordnungen und sind als Platzhalter gesetzt, damit das
Blatt seine Form zeigt. Sie taugen **nicht** für eine fachliche Aussage.

Was fehlt, sind die DWD-Werte. Zwei Wege:

1. **Climate Data Center**, Ordner `climate_environment/CDC/observations_germany/`
   `climate/multi_annual/mean_81-10/` bzw. die aktuelle Referenzperiode
   1991–2020 — Monatsmittel Lufttemperatur und Niederschlagssumme je Station.
2. **DWD-Stationsübersicht** für die Stations-IDs und geprüfte Koordinaten und
   Stationshöhen (die in der CSV sind ebenfalls genähert).

Sobald echte Werte drinstehen: `status` je Zeile auf `belegt` setzen und
`quelle` mit Referenzperiode füllen (z. B. `DWD CDC, Monatsmittel 1991–2020`).
Das Blatt liest die Spalte und beschriftet die Diagramme entsprechend — eine
Station mit `unbelegt` bekommt einen sichtbaren Vermerk, keine stille Kurve.

## Spalten

| Spalte | Bedeutung |
| --- | --- |
| `station` | Ortsname, wie er auf dem Blatt erscheint |
| `kuerzel` | Kurzform für Karte und QGIS-Verknüpfung |
| `dwd_id` | Stations-ID des DWD, leer bis geprüft |
| `lon`, `lat` | geographische Länge und Breite, Dezimalgrad (WGS 84) |
| `hoehe` | Stationshöhe in m über NHN |
| `rolle` | `kartenfeld` (Kartodiagramm auf der Karte) oder `vergleich` (nur Randspalte, außerhalb des Blattausschnitts) |
| `koord_status` | `belegt`, `abgeleitet`, `unbelegt` — für die **Verortung**, getrennt vom Belegstatus der Messwerte. Eine unbelegte Koordinate bekommt auf der Karte einen gestrichelten Ring und den Vermerk „Ort nicht verifiziert" |
| `status` | `belegt`, `abgeleitet`, `unbelegt` — für die **Monatswerte** |
| `quelle` | Datensatz und Referenzperiode |
| `t_jan` … `t_dez` | Monatsmittel der Lufttemperatur in °C |
| `n_jan` … `n_dez` | Monatssumme des Niederschlags in mm |

## Warum Walter-Lieth

Die Diagramme auf dem Blatt folgen der Klimadiagramm-Konvention nach Walter und
Lieth: Temperaturkurve und Niederschlagsbalken in einem Feld, im Maßstab
**1 °C ≙ 2 mm**. Wo die Niederschlagslinie unter die Temperaturkurve fällt, gilt
der Monat als arid und wird punktiert; darüber humid und gestrichelt. Das ist
kein Dekor, sondern der Grund, warum sich zwei Stationen überhaupt vergleichen
lassen — die Skalenkopplung ist die Aussage.

Für Brandenburg liegt der Reiz gerade an der Grenze: die Trockenheit im Lee des
Harzes und der Übergang zum kontinentalen Osten sind genau das, was die
Kopplung sichtbar macht. Das setzt aber echte Werte voraus.

## Vergleichsorte von außerhalb

Eine Zeile mit `rolle = vergleich` erscheint **nicht** im Kartenfeld, sondern nur
als Diagramm in der Randspalte — zuschaltbar über den Tweak *Vergleichsort*.
Das ist die richtige Stelle für Orte außerhalb Brandenburgs: ein Klimadiagramm
braucht keine Karte, und die Abbildung des Blatts (Lambert 52°/53,4° N) ist auf
Brandenburgs Breite geeicht.

Was dagegen **kein** Tweak sein kann: ein zweiter Kartenausschnitt. Die Loreley
wäre ein eigenes Blatt — und dort trägt nicht das Klima die Aussage, sondern das
Talrelief (Hangneigung, Exposition, Kaltluftabfluss, terrassierter Weinbau).
