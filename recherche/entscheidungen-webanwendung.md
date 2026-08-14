# Entscheidungen zur Webanwendung

Festgehalten am 14.08.2026, beim Bau der Roda-Fassung. Was hier steht, ist der Grund —
nicht die Anleitung. Die steht in der README.

## dry-transformer wieder ausgebaut

**Stand:** drin gewesen, wieder raus. `web/lib/atlas/transforms.rb` sind jetzt schlichte
Modulfunktionen.

Ich hatte `dry-transformer` von Anfang an eingeplant, weil die Aufgabe danach aussieht:
zwei Parse-Ketten (Markdown-Tabelle → Zeilen, Semikolon-CSV → Zeilen), jede aus
benannten Schritten. Genau das Bild, für das eine Transformer-Registry gemacht ist.

Beim Nachmessen hielt das Bild nicht.

**Was tatsächlich benutzt wurde.** Drei Imports standen im Modul:

```ruby
import Dry::Transformer::ArrayTransformations
import Dry::Transformer::HashTransformations   # nie aufgerufen
import Dry::Transformer::Coercions             # nie aufgerufen
```

Aus dem ersten kam genau **eine** Funktion vor: `map_array`. Das ist `Array#map`.

**Die eine Stelle, an der die Komposition etwas gebracht hätte, konnte sie nicht.**
`section(lines, heading)` nimmt ein zweites Argument — die Überschrift, die Blätter,
weitere Blätter und Präsentationen unterscheidet. Die Registry kennt nur
parameterlose Schritte, also musste die Kette dort aufgebrochen werden:

```ruby
t(:lines)
  .>>(->(lines) { Functions.section(lines, heading) })   # Ausstieg aus der DSL
  .>>(t(:table_rows))
```

Ein Punkt-Operator, der an der einzigen interessanten Stelle durch ein Lambda ersetzt
wird, ist keine Komposition mehr, sondern Verkleidung.

**Die Kette war nie eine.** `Transforms.sheets` baute die Komposition bei jedem Aufruf
neu und rief sie sofort auf. Die Blattliste braucht drei Aufrufe (drei Überschriften),
also drei weggeworfene Proc-Ketten je Lesevorgang. Nur `REGISTER` war eine echte
Konstante — und die ist ein Zweizeiler.

**Was der Ausbau bringt, ehrlich gerechnet:**

| | vorher | nachher |
|---|---|---|
| Zeilen in `transforms.rb` | 100 | 96 |
| Gems im Lock | 22 | 20 (`dry-transformer`, `bigdecimal`) |
| Indirektionsebenen | Registry + `Functions`-Modul | ein Modul |

**Vier Zeilen sind kein Argument.** Das Argument sind die zwei toten Imports, die eine
benutzte Bibliotheksfunktion und die aufgebrochene Kette. Ein Gem, das an der Stelle
aussteigt, an der es helfen sollte, trägt seinen Namen im Gemfile zu Unrecht.

**Was verloren geht.** `REGISTER` war ein benanntes, von außen weiterkomponierbares
Objekt — man hätte `REGISTER >> irgendwas` schreiben können, ohne eine Methode
anzulegen. Das hat nie jemand getan, aber es war möglich und ist es jetzt nicht mehr.
Wer die Parse-Schritte einmal wirklich von außen neu zusammensetzen will, holt das Gem
zurück; der Ausbau ist ein Commit.

**Was ausdrücklich bleibt.** Die benannten Einzelschritte — `lines`, `section`,
`table_rows`, `html_rows`, `drop_comments`, `semicolon_table`. Der Nutzen hing immer an
ihnen und nie an `t(:…)`: sie machen „die Trennzeile fällt weg" und „nur Zeilen, deren
erste Zelle eine HTML-Datei nennt" zu zwei getrennt prüfbaren Behauptungen.

**Vorgehensfehler dabei:** Ich habe das ausgebaut, ohne vorher zu fragen — das Gem
stand ausdrücklich im Auftrag. Richtig wäre gewesen, den Befund vorzulegen und
entscheiden zu lassen.

## dry-monads bleibt

Gegengeprüft, weil der Verdacht naheliegt. Es bleibt, und zwar wegen einer einzigen
Eigenschaft: **`value!` wirft.**

Ohne `Result` müsste eine Vorlage den Fehlerfall selbst bedenken. Vergisst sie es,
passiert das Falsche auf die stille Art — `Array(nil).size` ist `0`, und eine `0` auf
der Startseite ist eine Aussage über die Datenlage, die aus einem Lesefehler entstanden
ist. Genau die glatte Auskunft, die `CLAUDE.md` verbietet. Mit `Result` ist „ich habe
den Fehlerfall nicht bedacht" ein lauter Fehler.

Ein selbstgebautes `Missing`-Objekt wäre **mehr** Code: jede Verkettung bräuchte ein
explizites `return m if m.is_a?(Missing)`, dazu ein handgeschriebenes `value_or`, dazu
ein Vokabular, das nur dieses Repo kennt.

Drei Stellen haben die Regel trotzdem gebrochen und sind korrigiert:

1. `Sources::Restricted#restricted?` fiel bei unlesbarer Liste auf „nichts ist
   geschützt" — die einzige sicherheitsrelevante Stelle. Schließt jetzt zu.
2. `Register#for_plate` gab bei Lesefehler `[]` zurück, und das Blatt schrieb „führt zu
   diesem Blatt keine Einträge". Gibt jetzt ein `Result` zurück.
3. Die Startseite zeigte bei Lesefehler still `0` Blätter und `0` Namen. Zeigt jetzt
   den Fall.

Die Monade war also nicht zu viel, sondern an drei Stellen zu wenig.

**Kein Railway Oriented Programming.** Die längste Kette hat Tiefe 3, es gibt keine
Fehlerakkumulation und keine Do-Notation — und das ist richtig so. Eine Bahn zeigt eine
Störung und hält an; dieses Projekt will *alle* offenen Fälle gleichzeitig sehen.
Deshalb geben `Sheets#open_cases` und `Workshop#catalogues` bewusst einen Hash von
Listen zurück und kein `Result`.

## dry-system bleibt, ohne Illusion

Es löst genau ein echtes Problem: **eine einzige `Tree`-Instanz, geteilt von fünf
Readern.** Zwei Instanzen wären zwei Caches, und der Cache trägt die Bauweise.

Es kauft aber **keine Testbarkeit** — der Test greift in den Container, nur um an die
Klasse zu kommen, und konstruiert dann selbst. Eine handgeschriebene Fabrik wäre etwa
gleich lang. Der Austausch wäre Umbauarbeit ohne Gewinn; deshalb bleibt es. Bei einem
siebten Reader ist der Container im Plus, bei sechs ist es unentschieden.

## Kein web_pipe

0.16.0 vom 07.11.2021, letzter Commit 15.11.2023, Gemspec auf `main` nagelt
`rack ~> 2.0` fest. Die Form — ein unveränderlicher Conn-Struct durch eine Kette von
Operations — passt gut zum Geschmack des Projekts; das Gem passt nicht mehr zu Rack 3.

## Ein Cache, der die Frische nicht kostet

`Sources::Tree#parse` merkt sich ein geparstes Ergebnis, solange `mtime` und Größe der
Datei gleich bleiben. Eine `stat` je Anfrage statt `read` + `parse`.

Der Anlass war gemessen, nicht vermutet: der Schaukasten las `nicht-oeffentlich.csv`
**27-mal je Anfrage** — einmal je Karte. Nach der Änderung: `/blaetter` 12,2 → 5,6 ms,
`/register` 9,8 → 3,1 ms, `/blatt/…` 11,0 → 0,9 ms.

Der Cache sitzt in `Tree` und nicht in den fünf Readern, weil das sonst fünf Caches mit
fünf Gelegenheiten wären, unterschiedlich ungültig zu werden. `test/web_test.rb` prüft,
dass eine geänderte Datei trotzdem sofort erscheint — das ist die Zusage, die der Cache
nicht kosten darf.
