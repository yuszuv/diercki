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

## Und dann kauft dry-system doch noch etwas: der settings-Provider

Nachgetragen am 14.08.2026. Der Abschnitt darüber sagt, der Container sei bei sechs
Readern unentschieden. Der settings-Provider ist der Posten, der ihn ins Plus bringt,
und er kostete kaum etwas, weil das Gem ohnehin dalag.

Abgelöst wurden zwei handgeschriebene Stellen für dieselben drei Werte: die Pflicht-
und Formprüfung in `web/auth.rb` und ein eigener `.env`-Leser in `config.ru`. Dafür
drei Gründe, in dieser Reihenfolge:

1. **Es sammelt.** `Config.load` führt jeden Konstruktor aus und wirft einmal mit
   allem, was schiefstand. `Auth.env!` brach beim ersten fehlenden Wert ab — man
   reparierte drei Fehler in drei Anläufen.
2. **Die Prüfung wird deklarativ**, und `dry-types` braucht es dafür nicht: ein Lambda
   als `constructor:` genügt. Die base64-Prüfung des Hashs zog unverändert um.
3. **Eine `.env`-Kette**, die es sonst nirgends gibt, und damit ein Mechanismus statt
   zwei. Genau die Sorte Dopplung, die dieses Projekt schon zweimal eingesammelt hat
   (die neun CDN-Adressen, die zwei Wächter-Listen).

Zwei Dinge waren beim Bau gemessen statt vermutet, und beide fielen anders aus als in
der Übergabe (`settings-umbau.md`) angenommen:

**Die Callable-Vermutung war falsch, und sie war überflüssig.** Die Übergabe hielt es
für den Hebel, `plugin :sessions` ein Callable für `secret` zu geben, weil `AuthApp`
das Geheimnis zur Ladezeit der Klasse liest, Settings aber erst nach `finalize!`
bereitstünden. Roda nimmt kein Callable — es prüft in `self.configure` auf `String`
und wirft sonst. Es braucht auch keines: ein **nicht finalisierter** dry-system-
Container löst faul auf und startet den Provider dabei von selbst, also liefert
`Container['settings']` die Werte vor `finalize!`. Die Startreihenfolge von `AuthApp`
blieb, wie sie war — der teuerste Posten der Übergabe entfiel ersatzlos.

**Die „wörtlich lesen"-Haltung wurde bewusst eingetauscht.** Der Loader in `config.ru`
las die `.env` ohne `${…}`-Auflösung, und das stand dort als Absicht: ein Wert ändert
sich nicht auf dem Weg herein. dotenv löst auf. Gemessen (3.2.0): ein roher bcrypt-Hash
in einer `.env` wird zu `""`, in doppelten Anführungszeichen ebenso, nur einfache
halten ihn — und die helfen gegen compose wieder nicht. Getauscht wurde also eine
Eigenschaft gegen die Kette. Vertretbar, weil die Sicherheitszusage daran nicht hängt:
der Hash reist base64, hat also keine `$`, und ein roh übergebener scheitert weiterhin
laut — jetzt mit zwei auflösenden Lesern als Begründung statt einem. Wer den Tausch
zurücknehmen will, nimmt Bauform B aus der Übergabe und lebt mit zwei Lesern.

### Die Belege zur base64-Regel, an einem Ort

Hierher verweisen `web/boot.rb`, `.env.example`, `docker-compose.yml` und
`WEB-APPLICATION.md`, statt die Messung je noch einmal abzuschreiben. Ein bcrypt-Hash
besteht aus `$`-Feldern, und beide Leser einer `.env` lösen die auf:

| Leser | Eingabe | kommt an als |
|---|---|---|
| docker compose | `$2a$12$KDvI6RuYis…/qxuoa` | `a2/qxuoa` |
| dotenv 3.2.0 | dieselbe Zeile | `""` |
| dotenv, `"…"` | dieselbe Zeile doppelt gequotet | `""` |
| dotenv, `'…'` | dieselbe Zeile einfach gequotet | unverändert — hilft aber nicht gegen compose |
| beide | base64 (`JDJhJDEy…`) | unverändert |

Bei compose halten weder Anführungszeichen noch `$$`-Verdopplung noch `env_file:`
dagegen. Der Fehler ist still: die Anwendung startet, und das richtige Passwort wird
abgelehnt, ohne dass irgendwo etwas dazu steht. Deshalb prüft der Konstruktor in
`web/boot.rb` das Dekodierte gegen die bcrypt-Form und bricht laut ab.

Nicht genommen: `dry-types` für die Konstruktoren. Ein Lambda tut es, und ein Gem für
drei Prüfungen wäre dieselbe Rechnung wie bei `dry-transformer` oben.

## `/version`, weil ein Deploy Erfolg melden konnte, ohne etwas zu tun

Nachgetragen am 15.08.2026.

Am 14.08. lief `make webhost LIMIT=paketzentrum` durch, meldete Erfolg und lieferte
weiter den Stand von `07a96b1` aus — drei gemergte PRs später. Gemessen: der Container
war Stunden alt, und die laufende Seite trug in `WEB-APPLICATION.md` noch „not yet
applied". Aufgefallen ist es nur, weil PR #4 zufällig ein **sichtbares** Merkmal
mitbrachte (die Rubrik *Abgeschlossen* in der Werkstatt). Ohne dieses Merkmal wäre es
nicht aufgefallen, und das ist der eigentliche Befund.

Die Ursache lag in bmeise und ist dort behoben (Ansibles `omit` ist eine Zeichenkette
und liest sich als *definiert*, weshalb ein `default('always')` nie griff und das Image
nie geholt wurde). Hier interessiert die zweite Hälfte: **nichts prüfte, welcher Stand
ausliefert.** Die vier `curl`-Nachkontrollen in `paketzentrum.yml` gingen alle durch —
sie fragen, ob der Wächter hält, und der hielt ja. Eine Zusage, die niemand prüft, ist
keine Zusage; genau deshalb gibt es in der CI schon den Schritt, der das
veröffentlichte Image zurückzieht und befragt.

`/version` nennt den Commit, aus dem das Image gebaut wurde. Drei Entscheidungen dazu:

- **Als Build-Argument hereingereicht**, nicht hergeleitet. `.dockerignore` schließt
  `.git` aus, also *kann* das Image es nicht selbst wissen. Das OCI-Label
  `image.revision` trägt denselben Wert, ist aber aus dem laufenden Container nicht
  lesbar — und dort wird gefragt.
- **Ohne Argument antwortet die Route `arbeitsbaum`**, nicht leer und nicht geraten.
  Ein Wort, das nie eine SHA sein kann, hält den Vergleich ehrlich. Das ist dieselbe
  Regel wie beim Rest: fehlt etwas, bekommt der Fall eine eigene sichtbare Klasse.
- **Öffentlich wie `/health`.** Der Commit ist ohnehin öffentlich, Repo und Image auch.
  Hinter dem Wächter bräuchte der Prüfschritt eine Anmeldung und hätte damit mehr
  bewegliche Teile als das, was er bewacht.

## Kein web_pipe

0.16.0 vom 07.11.2021, letzter Commit 15.11.2023, Gemspec auf `main` nagelt
`rack ~> 2.0` fest. Die Form — ein unveränderlicher Conn-Struct durch eine Kette von
Operations — passt gut zum Geschmack des Projekts; das Gem passt nicht mehr zu Rack 3.

## Ein Cache, der die Frische nicht kostet

`Sources::Tree#parse` merkt sich ein geparstes Ergebnis, solange `mtime` und Größe der
Datei gleich bleiben. Eine `stat` je Anfrage statt `read` + `parse`.

Der Anlass war gemessen, nicht vermutet: der Schaukasten las `geschuetzt.csv`
**27-mal je Anfrage** — einmal je Karte. Nach der Änderung: `/blaetter` 12,2 → 5,6 ms,
`/register` 9,8 → 3,1 ms, `/blatt/…` 11,0 → 0,9 ms.

Der Cache sitzt in `Tree` und nicht in den fünf Readern, weil das sonst fünf Caches mit
fünf Gelegenheiten wären, unterschiedlich ungültig zu werden. `test/web_test.rb` prüft,
dass eine geänderte Datei trotzdem sofort erscheint — das ist die Zusage, die der Cache
nicht kosten darf.

Die Ablage ist eine `Concurrent::Map`, kein `Mutex` um eine gewöhnliche Hash. Puma
bedient in Threads, aber gebraucht wird keine Sperre, sondern eine threadsichere Ablage:
das Lock lag ohnehin nur um den Zugriff, nicht um `read` + `parse`, zwei Threads parsten
dieselbe veraltete Datei also schon vorher doppelt. Das bleibt so und ist gewollt — beide
rechnen aus denselben Bytes denselben Wert, und ein Lock über den Lesevorgang wäre die
eine Stelle, an der eine langsame Platte alle übrigen Anfragen anhielte.

### Der Stempel trägt ctime, und das ist der ganze Punkt

Zuerst war es `[mtime, size]`. Das ist kein Identitätsnachweis, sondern eine
Vermutung: `File.utime` dreht die mtime zurück, eine gleich lange Neufassung hält
die Größe — und genau das tun `rsync -a`, `cp -p`, `tar -x` und jedes
Backup-Zurückspielen. Kehrt das Paar mit anderem Inhalt wieder, passt der
gespeicherte Eintrag **für immer**, und eine korrigierte Datei erscheint nicht
mehr. Das ist der eine Ausfall, den dieses Projekt nicht haben darf.

Gemessen: mtime und Größe Byte für Byte wiederhergestellt — `ctime` unterscheidet
sich trotzdem. Der Kernel setzt ihn bei jeder Inode-Änderung, auch bei dem
`utime`-Aufruf, der die mtime fälscht; aus Userspace ist er nicht zu setzen. Er
kommt aus demselben `stat` und kostet nichts.

**Was dabei auffiel, und ehrlicher ist als der erste Anlauf:** Die Nachprüfung
„nur speichern, wenn ein zweiter `stat` denselben Stempel liefert" taugt für sich
allein wenig. Sie fängt die Verschränkung, die sich beim nächsten Zugriff ohnehin
selbst heilt, und verpasste genau den Fall, der bleibt. Der Test dazu fiel auch
*mit* dieser Prüfung durch, solange ctime fehlte. Sie bleibt als billiger zweiter
Gurt drin — tragend ist ctime.

### Nicht genommen: dry-effects

Der Gedanke lag nahe und war offenbar schon einmal da (die Leseerlaubnis auf die
Gem-Quellen steht in `.claude/settings.local.json`, sonst ist nichts davon
festgehalten). `Dry::Effects.Cache` würde die Instanzvariable loswerden: `Tree`
gäbe nur bekannt, dass hier etwas zu merken wäre, und ein Handler weiter außen
entschiede, wer merkt und wie lange.

Dagegen sprechen drei Dinge. Der Handler bestimmt die Lebensdauer, und die
richtige ist hier prozessweit, nicht anfrageweit — anfrageweit installiert parst
jede neue Anfrage `README.md` wieder von vorn. Der Schlüssel von `fetch_or_store`
kennt keine mtime, die Frische-Zusage müsste also weiterhin von Hand hinein; und
genau das Invalidieren ist hier der ganze Inhalt, nicht das Merken. Und es wäre
ein weiteres Gem für genau eine Stelle — dasselbe Muster wie bei
`dry-transformer`, nur eine Sitzung später.

Nicht genommen: `Dry::Core::Cache`. Es liegt zwar dieselbe `Concurrent::Map` darunter,
aber der Cache hängt an der Klasse statt an der Instanz — zwei `Tree` mit verschiedenem
`root` teilten sich eine Ablage — und er kennt kein Löschen. Um die Frische zu halten,
müsste der Stempel in den Schlüssel, und dann hinterließe jedes Speichern einer Datei
einen Eintrag für immer. Gerade in der Vorschau des Arbeitsverzeichnisses, also im Fall,
für den das Ganze gebaut ist.
