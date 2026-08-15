# Inhalt des Atlas

Welche Blätter der Band führt, in welcher Ordnung, und was jedes ist. Von Hand
gepflegt, zur Laufzeit gelesen — es gibt keine abgeleitete Zweitfassung.

Bis zum 15.08.2026 stand diese Liste an vier Stellen: als drei Tabellen in der
`README.md`, als `atlas/blaetter.csv`, fest verdrahtet im Markup von
`Inhalt.dc.html` und ein viertes Mal als `SIGNATUR` in `web/site.js`. Geprüft
wurden nur die ersten beiden gegeneinander. Was dabei herauskam, stand als
Beispiel im Projekt selbst: `Deckel-Entwuerfe.dc.html` fehlte im
Inhaltsverzeichnis, ohne dass es jemandem auffiel.

## Die Spalten

**Kennung** — die Adresse eines Blattes, kebab-case, unabhängig von Datei und
Pfad. Wer auf ein Blatt verweist, nennt seine Kennung: ein Wegeverzeichnis, ein
Halt in einer Führung, eine Verknüpfung von Blatt zu Blatt. Sie ändert sich
nicht, wenn die Datei umbenannt wird oder in ein Verzeichnis umzieht — genau
dafür gibt es sie.

**Datei** — der Pfad relativ zur Wurzel. Darf sich ändern; die Kennung nicht.

**Nr** — die Blattnummer des gebundenen Bandes. Eine *Zitiernummer, keine
Kennung*: abgeleitet, nur für die neun Blätter des Bandes vorhanden, und sie
benennt eine Seite statt einer Datei. Der Rechenweg steht in `BLAETTER.md`.
`register.csv` zitiert sie in der Spalte `blaetter`.

**Signatur** — welche Signatur aus `atlas/signaturen.js` für dieses Blatt steht,
als `familie / name`. Eine kartographische Entscheidung, kein Automatismus aus
dem Dateinamen — deshalb steht sie hier und nicht im Code. Leer heißt: noch
keine gewählt, und der Platz auf der Blattkarte bleibt leer.

Die Familie `hanf` ist der eine Sonderfall: das Landwirtschaftsblatt zeichnet
seine Signatur selbst über `hanfRaws(name)`, statt eine aus dem Katalog zu
holen. Das stand bis zum 15.08.2026 als Dateinamen-Vergleich in `web/site.js`
und war der Grund, warum das Blatt dort scheinbar keine Signatur hatte.

**Quellen** — die Datei unter `atlas/quellen/`. Leer heißt: es gibt noch kein
Quellenregister, und der Belegstand zeigt das als offenen Fall.

**Status** — der Belegstatus der *Blattnummer*, nicht des Blattinhalts. Den
führt das Quellenregister.

Fehlt ein Eintrag, wird nicht geraten: die Werkstatt zeigt beide Richtungen als
offenen Fall — eine Datei ohne Zeile und eine Zeile ohne Datei.

## Blätter

| Kennung | Datei | Nr | Signatur | Quellen | Status | Inhalt |
|---|---|---|---|---|---|---|
| bb-landwirtschaft | Brandenburg-Landwirtschaft.html | 1 | hanf / brokkoli | Brandenburg-Landwirtschaft.md | abgeleitet | Brandenburg · landwirtschaftliche Nutzung — Hanf 2026 schlaggenau, Kartodiagramm je Kreis, Matrix-Legende, Nebenkarte Kyritz |
| bb-klima | Brandenburg-Klima.html | 2 | klima / Klimastation | Brandenburg-Klima.md | abgeleitet | Brandenburg · Klima — Kartodiagramme, Walter-Lieth-Randspalte, Geländeklima-Nebenkarte. **Alle Werte noch unbelegt** |
| loreley-relief | Loreley-Relief.html | 3 | relief / Böschung, Steilstufe | Loreley-Relief.md | abgeleitet | Werkstattblatt: ein Gelände in vier Registern — Isohypsen, Hypsometrie, Schummerung, Böschungsschraffen. Geländemodell konstruiert |
| rum-physisch | Rumaenien-Physisch.html | 4 | relief / Schummerung | | abgeleitet | Physische Übersicht — Relief, Hypsometrie |
| rum-landschaften | Rumaenien-Landschaften.html | 5 | politisch / Staatsfläche: Grenzkolorit | | abgeleitet | Historische Landschaften |
| rum-wirtschaft | Rumaenien-Wirtschaft.html | 6 | energie / Erdölleitung | Rumaenien-Wirtschaft.md | abgeleitet | Wirtschaft — Rohstoffe, Industrie, Energie |
| rum-verkehr | Rumaenien-Verkehr.html | 7 | bahnen / Bahnhof, Haltepunkt | Verkehr.md | abgeleitet | Hauptverkehrsnetz — Straßen, Bahnen, Donaudelta-Nebenkarte |
| banat-liniennetz | Banat-Liniennetz.dc.html | 8 | bevoelkerung / Pendlerverflechtung | Banat-Liniennetz.md | abgeleitet | Banat · Liniennetzplan — oktilinear, topologietreu, nicht lagetreu |
| rum-braunbaer | Rumaenien-Braunbaer.html | 9 | umwelt / Nationalpark | Braunbaer.md | abgeleitet | Braunbär — Verbreitung, Streusignatur nach GBIF-Nachweisen |
| nikolais-ort | Nikolais-Ort.dc.html | | | Nikolais-Ort.md | | Freiburger Hauptfriedhof, drei Blätter — Grundriss mit DTK10-Hintergrund, Person, Abschied. Kein Atlas-Bestandteil im engeren Sinn, folgt aber seinen Regeln |
| zeichenerklaerung | Zeichenerklaerung.dc.html | | chrome / Maßstabsbalken | | | Zeichenerklärung des ganzen Atlas, Blatt für Blatt (Farbsystem, Relief, Gewässer/Siedlung/Schrift, Grenzen, Verkehr, Rohstoffe, Industrie/Energie, Landwirtschaft, …) |
| qgis-kartensatz | QGIS-Kartensatz.dc.html | | chrome / Gradnetz | | | Anleitung: Blätter in QGIS öffnen, drucken, um eigene Themen erweitern |
| zeichen-naeherung | Zeichen-Naeherung.dc.html | | | | | Messblatt zur Unicode-Näherung des Sternprodukt-Zeichens — misst Glyphenabdeckung live gegen U+FFFF |

## Weitere Blätter

| Kennung | Datei | Inhalt |
|---|---|---|
| inhalt | Inhalt.dc.html | Übersichtsblatt im Sternprodukt-Look — dieselbe Ordnung wie hier, nur gestaltet und mit Signaturen |
| deckel-entwuerfe | Deckel-Entwuerfe.dc.html | Entwürfe für den Einband |
| kuechengruss | Kleiner-Gruss-aus-der-Kueche.dc.html | Zwischenstand vom 7. August, zwei Blattausschnitte. Kein Atlas-Bestandteil |

## Präsentationen

| Kennung | Datei | Inhalt |
|---|---|---|
| pitch-loewen | praesentationen/Pitch-Hoehle-der-Loewen.dc.html | Pitch-Deck zum QField-Bahnreiseplaner |
| qfield-bahnreiseplaner | praesentationen/QField-Bahnreiseplaner.dc.html | Workshop: QField als Bahnreise-Planer, zwölf Folien |
| reiseplaner-vorschlag | praesentationen/Reiseplaner-Vorschlag.dc.html | Entscheidungsvorlage Reiseführer Banat & România, 12 Folien |
| reiseplaner-roadmap | praesentationen/Reiseplaner-Roadmap.dc.html | Technische Roadmap dazu, 4 Seiten (Arbeitsdokument) |
| reiseplaner-reisebegleitung | praesentationen/Reiseplaner-Reisebegleitung.dc.html | Reisevorbereitung für die eigene Rumänien-Reise, 10 Folien |
| zeichensystem-postits | praesentationen/Zeichensystem-Post-its.dc.html | Das Zeichensystem des Atlas, neun Zettel |
| iteration-2-konzept | praesentationen/Iteration-2-Konzept.dc.html | Iteration 2 — Konzept vor Bau, zehn Folien. Offen: Zuschnitt A, B oder C |
| wireframe-a | praesentationen/Wireframe-A-Chips.dc.html | Wireframe A · Themenchips über der Karte — absichtlich grau und unfertig |
| wireframe-b | praesentationen/Wireframe-B-Tabs.dc.html | Wireframe B · Themenliste mit Tab-Leiste unten |
| wireframe-c | praesentationen/Wireframe-C-Split.dc.html | Wireframe C · Karte oben, Trefferliste unten. Bekommt keine eigene Folie in den Decks (entschieden 15.08.2026) |
| gruss-waldmann | Gruss-an-Stefan-Waldmann.dc.html | Persönliche Präsentation, kein Atlas-Bestandteil |
