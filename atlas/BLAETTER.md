# Blattschlüssel

`blaetter.csv` sagt, welche Blattnummer welche Datei meint. Zur Laufzeit gelesen —
von der Webfassung, für den Verweis vom Registereintrag aufs Blatt und zurück.

## Warum es die Tabelle gibt

`register.csv` nennt in der Spalte `blaetter` Nummern von 1 bis 9. **Diese Nummern
stehen sonst nirgends im Repo.** Kein Blatt nennt seine Bandnummer, `Inhalt.dc.html`
nummeriert nicht, das Quellenregister auch nicht. Die Treffer `blatt15`, `blatt17` in
den Blättern sind Element-Kennungen im CSS, keine Bandnummern.

Ohne Schlüssel bleibt die Spalte `blaetter` eine Zahl ohne Ziel: das Register kann
nicht aufs Blatt verweisen, und das Blatt kann nicht zeigen, welche Namen auf ihm
stehen.

## Woher die Nummern kommen: abgeleitet, nicht belegt

Erschlossen aus dem Inhalt der Einträge, die die jeweilige Nummer tragen. Der
Rechenweg, damit er nachprüfbar bleibt und nicht als Beleg durchgeht:

| Nr | Einträge | was darunter steht | ergibt |
|---|---|---|---|
| 1 | 26 | Barnim, Cottbus, Eberswalde — durchweg Brandenburg | Brandenburg-Landwirtschaft |
| 2 | 6 | Alt Madlitz, Potsdam; 3 × `klimastation` | Brandenburg-Klima |
| 3 | 2 | Loreley, Rhein | Loreley-Relief |
| 4 | 115 | 41 Städte, 12 Gipfel, 9 Großlandschaften | Rumaenien-Physisch |
| 5 | 42 | Banat, Brașov; 9 × `landschaft` | Rumaenien-Landschaften |
| 6 | 8 | Brațul Chilia/Sf. Gheorghe/Sulina, Cernavodă; 2 × `energie` | Rumaenien-Wirtschaft |
| 7 | 94 | 28 Orte, 9 × `strecke` | Rumaenien-Verkehr |
| 8 | 40 | 22 × `bahnhof`, 10 × `haltestelle`; Anina, Baziaș | Banat-Liniennetz |
| 9 | 56 | 13 Kreise, 8 Parks; Alba mit „109 Bären" | Rumaenien-Braunbär |

**Blatt 4 ist unabhängig gestützt.** Der Kopfkommentar von `register.csv` sagt „Nur
Blatt 4 trägt ein Suchgitter", und genau dort liegen alle 86 Feldangaben der Datei.
Das ist eine zweite, unabhängige Aussage über dieselbe Nummer.

**Die schwächste Stelle ist 6 gegen 7.** Die drei Donauarme könnten auch aufs
Verkehrsblatt gehören — dessen Nebenkarte zeigt laut README das Donaudelta. Für
Wirtschaft spricht Cernavodă und die zwei Energie-Einträge; entschieden ist es nicht.

Deshalb steht in allen neun Zeilen `status = abgeleitet`, und die Webfassung schreibt
das ans Blatt. Wer die Zuordnung bestätigt — am gedruckten Band oder am Entwurf —
setzt die Zeile auf `belegt` und schreibt hier die Quelle dazu. Wer sie widerlegt,
korrigiert die Spalte `nr`; sonst ändert sich nichts.

## Was `nr` ist und was sie nicht ist

Eine **Zitiernummer, keine Kennung.** Sie beantwortet „auf welcher Seite des
gebundenen Bandes steht das", und dafür wird sie gebraucht: die Spalte `blaetter`
in `register.csv` zitiert sie 272-fach, und `Plates#by_number` ist der einzige Weg
von dort aufs Blatt. Sie ist also nicht stillgelegt.

Als **Adresse** taugt sie trotzdem nicht, und zwar aus drei Gründen, die
zusammenkommen: sie ist *abgeleitet* (der Rechenweg steht oben, 6 gegen 7 ist offen),
sie gibt es nur für die neun Blätter des Bandes — sieben Zeilen dieser Tabelle
tragen keine, und Nebenkarten tragen überhaupt keine —, und sie benennt eine Seite,
keine Datei. Wer etwas dauerhaft adressieren will (Verweise zwischen Blättern, ein
Wegeverzeichnis, eine Führung), braucht eine eigene Kennung; `nr` bleibt hier als
Angabe stehen und wandert nicht in diese Rolle.

## Die Spalte `quellen`

Zeigt auf die Datei unter `atlas/quellen/`. Zwei Namen weichen ab und sind deshalb
hier explizit statt geraten: `Verkehr.md` gehört zu `Rumaenien-Verkehr.html`,
`Braunbaer.md` zu `Rumaenien-Braunbaer.html`. Wo die Spalte leer ist, gibt es noch
kein Quellenregister — derzeit für `Rumaenien-Physisch.html` und
`Rumaenien-Landschaften.html`.

## Fehlt ein Eintrag

Wird nicht geraten. Ein Blatt ohne Zeile taucht in der Werkstatt als offener Fall
auf; eine Blattnummer ohne Datei zeigt das Register weiter als bloße Zahl an, so wie
vor dieser Tabelle. Nichts verschwindet still.
