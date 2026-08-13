# Sondierung: Skills, Agents, MCP — was trägt hier was?

Stand 07.08.2026. Das Gate vor dem Schreiben der vier Skills (IDEEN.md № 2).

**Belegstatus dieser Notiz:** die Einschätzungen unten sind *abgeleitet* — aus der
Arbeit an diesem Projekt, nicht aus einer Erhebung. Was MCP-Verbinder für
QFieldCloud, DWD oder den Geobroker konkret können, habe ich **nicht geprüft**;
ob es sie überhaupt gibt, weiß ich nicht. Wo unten „Verbinder" steht, ist das
eine Anforderung, kein Befund.

## Die drei Mittel sind nicht austauschbar

| Mittel | trägt | trägt nicht |
|---|---|---|
| **Skill** | Regelkunde, die zwischen Projekten gleich bleibt: Konventionen, Fallen, Reihenfolgen | Zugriff auf Daten; Arbeitsteilung |
| **Agent** | eine abgegrenzte Teilaufgabe mit eigenem Kontext, deren Ergebnis kurz ist | alles, wo der Hauptfaden die Zwischenschritte braucht |
| **MCP-Verbinder** | Zugriff auf einen Dienst, der sonst Handarbeit wäre | Urteil darüber, ob die Daten taugen |

Das erklärt, warum die Frage „ein Skill oder vier" die falsche erste Frage war.
Zuerst gehört sortiert, *welches Mittel* jeder Fall braucht.

## Was in diesem Projekt tatsächlich weh getan hat

Rückblick auf die Reibungspunkte, nach Kosten:

1. **Die abgeleitete Zwischendatei.** `sorten.csv` → Ruby → GeoJSON → Blatt. Drei
   Stellen, an denen der Stand auseinanderläuft, und eine Korrektur, die eine
   Ruby-Konsole braucht. → **Skill** (Regel), kein Agent, kein Verbinder.
2. **Die Skript-Dublette.** `export-geodaten.rb` und `.sh` machten dasselbe, in zwei
   Sprachen, im selben Ordner. Niemandem fiel es auf, weil kein Index existierte.
   → **Skill** (Regel: ein Skript je Gegenstand, Index dazu).
3. **d3-Wicklungsrichtung.** Kostet einen halben Tag, wenn man sie nicht kennt.
   → **Skill**, und zwar wörtlich.
4. **`precision(0)` bei großer Maßstabszahl.** Der Kegelentwurf lief in die
   Singularität, 32 MB Pfadtext, Blatt nicht rasterisierbar. → **Skill**.
5. **Belegstatus glattgebügelt.** Ich habe Sortengruppen als Tatsache gesetzt, die
   Ableitungen waren. → **Skill** (Haltung), inzwischen auch `CLAUDE.md`.
6. **Geodaten-Beschaffung.** Overpass-Spiegel, CORINE-Handdownload, CLC5 mit 1,24 GB.
   Das ist der einzige Fall, in dem ein **Verbinder** wirklich Arbeit abnähme.

Fünf von sechs sind Regelkunde. Das ist die Antwort auf die Sondierungsfrage:
**Skills tragen hier fast alles.** Agents und Verbinder sind Randfälle.

## Agents — ein guter Fall, ein schlechter

**Guter Fall: Quellenregister-Prüfung.** Ein Agent, der ein Blatt und sein
Register liest und meldet, welche Angabe auf dem Blatt keine Zeile im Register hat
(und umgekehrt). Abgegrenzt, mechanisch, das Ergebnis ist eine kurze Liste. Genau
das Profil, für das ein eigener Kontext lohnt.

**Schlechter Fall: Kartenblatt bauen.** Das ist Gestaltung im Dialog — Nebenkarte
hierhin oder dorthin, Signatur größer, Klasse fallen lassen. Ein Agent, der das
abgeschlossen erledigt, nimmt genau die Rückfragen weg, die die Arbeit besser
gemacht haben. In diesem Verlauf war jede Kurskorrektur ein Zuruf.

## Verbinder — die eine echte Lücke

Was hier von Hand lief und nicht von Hand laufen müsste:

- **DWD Climate Data Center** — das Klimablatt hat keine belegte Zahl, weil die
  Reihen nicht da sind. Ein Verbinder, der Monatsmittel je Station liefert, würde
  das Blatt in einem Zug belegen.
- **Overpass** — läuft schon halb automatisch (`freiburg-friedhof.rb` rotiert vier
  Spiegel), bräuchte aber kein eigenes Skript mehr.
- **Geobroker Brandenburg / BKG** — CLC5 als 1,24-GB-Download ist der schlechteste
  Weg zu neun generalisierten Klassen.
- **QFieldCloud** (selbst gehostet) — Rücksync und Konfliktbericht.

Alle vier haben dasselbe Muster: **Beschaffung** ist mechanisch, **Bewertung** nicht.
Ein Verbinder darf die Datei holen; ob sie die Aussage trägt, entscheidet der Mensch
und wird ins Quellenregister geschrieben.

## Empfehlung für den Zuschnitt

Bei vier getrennten Skills bleiben — aber mit anderem Schnitt als in IDEEN.md
skizziert, weil die Sondierung einen fünften Kandidaten zum wichtigsten gemacht hat:

1. **`atlas-kartenblatt`** — der Kern. Signaturenkatalog und Farbsystem als einzige
   Quellen, Typenscale, Generalisierung als Maßstabsauswahl, Nebenkarte,
   Zeichenerklärung, A4-Druckgeometrie. Dazu die vier technischen Fallen (Wicklung,
   `precision`, Schriftuntergrenze, WMS-CRS).
2. **`belegstatus`** — *neu und vorn*: belegt/abgeleitet/unbelegt für Karte **und**
   Chat, Quellenregister je Blatt, sichtbare Klasse statt geratener Farbe,
   Korrekturwege ohne Build-Schritt. Das war der teuerste Fehler und die Regel,
   die am weitesten über die Kartographie hinausträgt.
3. **`qgis-kartensatz`** — basis/themen-Trennung, Feldvertrag, Bezugsmaßstab,
   Maßstabsgrenzen nur regelbasiert, Beschriftungsrang als Leiter, Schriftfallback,
   QField-Paket und Rücksync.
4. **`sternprodukt-ton`** — Erinnerung wörtlich übernehmen, zu nicht-öffentlichen
   Personen nicht recherchieren, Sprachregister. Keine Kartographie, sondern Haltung.

„Geodaten beschaffen" bekommt **keinen** eigenen Skill: der vorhandene
`geodaten-quellen` deckt es, und die zwei Ergänzungen (Overpass als regulärer Weg,
Skript nimmt beide Eingangsformen) sind zwei Absätze, die dort hineingehören.

## Was vorher zu klären ist

- Können in dieser Umgebung überhaupt neue Skills registriert werden, oder sind die
  vier Dateien Vorlagen für Claude Code? **Ungeprüft.** Die Dateien liegen unter
  `skills/<name>/SKILL.md`, was der Claude-Code-Konvention entspricht — falls die
  Registrierung anders läuft, ist der Inhalt trotzdem richtig, nur der Ort falsch.
- Gibt es MCP-Verbinder für DWD, Geobroker, QFieldCloud? **Ungeprüft.**
