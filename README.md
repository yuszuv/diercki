# Diercke-Atlas Redesign

Ein Weltatlas im Stil des Diercke-Klassikers (seit 1883), aber im Sternprodukt-Look
gebaut: Blätter zu Rumänien und Brandenburg, eine Zeichenerklärung nach Atlas-Vorbild
und der QGIS-Kartensatz dahinter.

`Inhalt.dc.html` ist dasselbe Verzeichnis im Sternprodukt-Look — gruppiert, verlinkt,
mit den Hinweisen, die man beim Nachschlagen braucht. Diese Datei bleibt die
maschinenlesbare Fassung.

## Blätter

Jedes Blatt ist eine eigenständige HTML-Datei im Wurzelverzeichnis, D3-basiert, mit
Legende und Quellenangabe im Fuß.

| Datei | Inhalt |
|---|---|
| `Rumaenien-Physisch.html` | Physische Übersicht — Relief, Hypsometrie |
| `Rumaenien-Wirtschaft.html` | Wirtschaft — Rohstoffe, Industrie, Energie |
| `Rumaenien-Verkehr.html` | Hauptverkehrsnetz — Straßen, Bahnen, Donaudelta-Nebenkarte |
| `Banat-Liniennetz.dc.html` | Banat · Liniennetzplan — oktilinear, topologietreu, nicht lagetreu |
| `Rumaenien-Braunbaer.html` | Braunbär — Verbreitung, Streusignatur nach GBIF-Nachweisen |
| `Rumaenien-Landschaften.html` | Historische Landschaften |
| `Brandenburg-Landwirtschaft.html` | Brandenburg · landwirtschaftliche Nutzung — Hanf 2026 schlaggenau, Kartodiagramm je Kreis, Matrix-Legende, Nebenkarte Kyritz |
| `Brandenburg-Klima.html` | Brandenburg · Klima — Kartodiagramme, Walter-Lieth-Randspalte, Geländeklima-Nebenkarte. **Alle Werte noch unbelegt** |
| `Loreley-Relief.html` | Werkstattblatt: ein Gelände in vier Registern — Isohypsen, Hypsometrie, Schummerung, Böschungsschraffen. Geländemodell konstruiert |
| `Nikolais-Ort.dc.html` | Freiburger Hauptfriedhof, drei Blätter — Grundriss mit DTK10-Hintergrund, Person, Abschied. Kein Atlas-Bestandteil im engeren Sinn, folgt aber seinen Regeln |
| `Zeichenerklaerung.dc.html` | Zeichenerklärung des ganzen Atlas, Blatt für Blatt (Farbsystem, Relief, Gewässer/Siedlung/Schrift, Grenzen, Verkehr, Rohstoffe, Industrie/Energie, Landwirtschaft, …) |
| `QGIS-Kartensatz.dc.html` | Anleitung: Blätter in QGIS öffnen, drucken, um eigene Themen erweitern |
| `Zeichen-Naeherung.dc.html` | Messblatt zur Unicode-Näherung des Sternprodukt-Zeichens — misst Glyphenabdeckung live gegen U+FFFF |

## Präsentationen

| Datei | Inhalt |
|---|---|
| `praesentationen/Pitch-Hoehle-der-Loewen.dc.html` | Pitch-Deck zum QField-Bahnreiseplaner |
| `praesentationen/QField-Bahnreiseplaner.dc.html` | Workshop: QField als Bahnreise-Planer, zwölf Folien |
| `praesentationen/Reiseplaner-Vorschlag.dc.html` | Entscheidungsvorlage Reiseführer Banat & România, 12 Folien |
| `praesentationen/Reiseplaner-Roadmap.dc.html` | Technische Roadmap dazu, 4 Seiten (Arbeitsdokument) |
| `praesentationen/Reiseplaner-Reisebegleitung.dc.html` | Reisevorbereitung für die eigene Rumänien-Reise, 10 Folien |
| `praesentationen/Zeichensystem-Post-its.dc.html` | Das Zeichensystem des Atlas, neun Zettel |
| `Gruss-an-Stefan-Waldmann.dc.html` | Persönliche Präsentation, kein Atlas-Bestandteil |

## Struktur

```
atlas/
  signaturen.js      Signaturenkatalog (SVG-Zeichen je Kartenobjekt)
  SIGNATUREN.md       Aufbau des Katalogs, Regeln fürs Ergänzen
  typenscale.js       Schriftstaffel — sieben Stufen, Untergrenze 5,5 pt
  farben.js           Farbsystem — einzige Quelle für Hex-Werte im Atlas
  GLOSSAR.md          Fachbegriffe der Blätter, alphabetisch
  paletten/           .gpl-Paletten für QGIS/GIMP, aus farben.js abgeleitet
  quellen/            Quellenregister je Blatt (belegt / abgeleitet / unbelegt)
  geodaten/           Skripte, die Rohdaten zu Kartendaten machen
  qgis/               QGIS-Kartensatz: basis/ (themenneutral) + themen/ (ein Ordner je Blatt)
                      themen/brandenburg-hanf/ ist zugleich das QField-Projektpaket
                      für die Feldbegehung (Anleitung im dortigen README)

handarbeit/          nur der Mensch schreibt hier — QGIS-Projekte, Erfassungs-GeoPackages
praesentationen/      Präsentationen (Pitch-Deck, QField-How-to)
recherche/            Recherche-Notizen und festgehaltene Entscheidungen
scans/                Referenzscans des Diercke-Originals (Layout- und Legendenvorbild)
_ds/                  gebundenes Sternprodukt-Design-System (nicht anfassen)
```

Backlog und lose Enden: `IDEEN.md`. Was an Daten von außen fehlt:
`DATENBEDARF.md`. Agent-Einstieg: `AGENTS.md`; verbindliche Regeln: `CLAUDE.md`.

Farben und Signaturen laufen ausschließlich über `atlas/farben.js` und
`atlas/signaturen.js` — keine neuen Hex-Werte oder Ad-hoc-Symbole in einzelnen Blättern.
Die `.gpl`-Paletten sind daraus abgeleitet (`atlas/farben-paletten.rb`) und
werden nicht von Hand gepflegt.

## Zuordnungstabellen ohne Build-Schritt

Tabellen, die ein Mensch pflegt, werden **zur Laufzeit** gelesen — vom Blatt beim
Laden, von QGIS als Attributverknüpfung, von QField als Wertliste. Keine abgeleitete
Zwischendatei, die still veraltet, wenn ein Exportskript nicht lief:

| Tabelle | gelesen von | Anleitung |
|---|---|---|
| `atlas/geodaten/brandenburg/sorten.csv` | Landwirtschaftsblatt, QGIS-Thema `brandenburg-hanf` | `SORTEN.md` |
| `atlas/geodaten/brandenburg/klima-stationen.csv` | Klimablatt | `KLIMA.md` |

Fehlt ein Eintrag, wird nicht geraten: der Fall bekommt eine eigene, sichtbare
Klasse (»ungeklärt«, »Ort nicht verifiziert«). Prüfskripte wie
`brandenburg/pruefe-hanf.rb` **berichten** nur — sie erzeugen nichts.

## Quellen und Belege

Jede Zahl auf einer Karte hat eine Zeile im Quellenregister (`atlas/quellen/`), mit
Status *belegt*, *abgeleitet* oder *unbelegt*. Geometrie aus benannten Datensätzen
(Eurostat GISCO, OSM, GBIF) steht stattdessen in der Fußzeile des jeweiligen Blatts.

## QGIS

Der Kartensatz unter `atlas/qgis/` ist themenneutral (`basis/`) und pro Blatt
(`themen/<name>/`) getrennt. Einrichtung und Rezepte stehen in
`QGIS-Kartensatz.dc.html`; Arbeits-CRS ist EPSG:3844 (Stereo 70).

Die Stile wissen seit 08/2026 vom Maßstab: **Bezugsmaßstab** 1:2 500 000 in allen
Stilen (mm-Maße hängen am Ausgabemaßstab), **Auswahl nach Maßstab** in
`punkt_ort.qml` (regelbasiert, fünf Ortsgrößen mit eigenen Grenzen), und ein
**Beschriftungsrang** als Leiter von 10 bis 3 statt willkürlicher Werte. Schriftgrade
aus `atlas/typenscale.js`, Untergrenze 5,5 pt.

## Umgebung

- **QFieldCloud läuft selbst gehostet.** Kein 100-MB-Limit, kein fremder Speicher.
  Der Objektspeicher darunter ist S3-kompatibel und liegt in eigener Hand; die
  WebDAV-Ablage nur für Anhänge ist damit ohne Weiteres verfügbar. Empfehlungen zu
  Speicher und Abgleich immer von dieser Voraussetzung aus denken, nicht von
  app.qfield.cloud.
- Arbeits-CRS: EPSG:3844 (Stereo 70) für Rumänien, EPSG:25833 für Brandenburg.
- QGIS 4.2, QField „Coral Sea".

## git-Repo

`yuszuv/diercki`, siehe `github.md` für Rollen und letzten Sync-Stand. Das
Design-Projekt ist die Quelle der Wahrheit; Änderungen an `handarbeit/` kommen
ausschließlich vom Menschen.
