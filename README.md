# DIERCKI - sternprodukt-Atlas

Ein Weltatlas im Stil des Diercke-Klassikers, aber Typ Sternprodukt. Mit 
Blättern zu Rumänien und Brandenburg, einer Zeichenerklärung nach Atlas-Vorbild
und einem QGIS-Kartensatz.

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

## Weitere Blätter

Liegen im Wurzelverzeichnis, folgen denselben Regeln, gehören aber nicht zum
Kartenwerk.

| Datei | Inhalt |
|---|---|
| `Inhalt.dc.html` | Übersichtsblatt im Sternprodukt-Look — dieselbe Ordnung wie hier, nur gestaltet und mit Signaturen |
| `Deckel-Entwuerfe.dc.html` | Entwürfe für den Einband |
| `Kleiner-Gruss-aus-der-Kueche.dc.html` | Zwischenstand vom 7. August, zwei Blattausschnitte. Kein Atlas-Bestandteil |

## Präsentationen

| Datei | Inhalt |
|---|---|
| `praesentationen/Pitch-Hoehle-der-Loewen.dc.html` | Pitch-Deck zum QField-Bahnreiseplaner |
| `praesentationen/QField-Bahnreiseplaner.dc.html` | Workshop: QField als Bahnreise-Planer, zwölf Folien |
| `praesentationen/Reiseplaner-Vorschlag.dc.html` | Entscheidungsvorlage Reiseführer Banat & România, 12 Folien |
| `praesentationen/Reiseplaner-Roadmap.dc.html` | Technische Roadmap dazu, 4 Seiten (Arbeitsdokument) |
| `praesentationen/Reiseplaner-Reisebegleitung.dc.html` | Reisevorbereitung für die eigene Rumänien-Reise, 10 Folien |
| `praesentationen/Zeichensystem-Post-its.dc.html` | Das Zeichensystem des Atlas, neun Zettel |
| `praesentationen/Iteration-2-Konzept.dc.html` | Iteration 2 — Konzept vor Bau, zehn Folien. Offen: Zuschnitt A, B oder C |
| `praesentationen/Wireframe-A-Chips.dc.html` | Wireframe A · Themenchips über der Karte — absichtlich grau und unfertig |
| `praesentationen/Wireframe-B-Tabs.dc.html` | Wireframe B · Themenliste mit Tab-Leiste unten |
| `praesentationen/Wireframe-C-Split.dc.html` | Wireframe C · Karte oben, Trefferliste unten |
| `Gruss-an-Stefan-Waldmann.dc.html` | Persönliche Präsentation, kein Atlas-Bestandteil |

## Struktur

```
atlas/
  signaturen.js       Signaturenkatalog (SVG-Zeichen je Kartenobjekt)
  SIGNATUREN.md       Aufbau des Katalogs, Regeln fürs Ergänzen
  typenscale.js       Schriftstaffel — sieben Stufen, Untergrenze 5,5 pt
  farben.js           Farbsystem — einzige Quelle für Hex-Werte im Atlas
  farben-paletten.rb  erzeugt die .gpl-Paletten aus farben.js
  register.csv        Namensregister des Bandes, von Hand gepflegt
  blaetter.csv        Blattschlüssel — welche Blattnummer welche Datei meint
  BLAETTER.md         Rechenweg dazu; die Nummern sind abgeleitet, nicht belegt
  marke/              Logo und handschriftliche Wortmarke
  GLOSSAR.md          Fachbegriffe der Blätter, alphabetisch
  paletten/           .gpl-Paletten für QGIS/GIMP, aus farben.js abgeleitet
  quellen/            Quellenregister je Blatt (belegt / abgeleitet / unbelegt)
  geodaten/           Skripte, die Rohdaten zu Kartendaten machen
  qgis/               QGIS-Kartensatz: basis/ (themenneutral) + themen/ (ein Ordner je Blatt)
                      themen/brandenburg-hanf/ ist zugleich das QField-Projektpaket
                      für die Feldbegehung (Anleitung im dortigen README)

bin/                  Werkzeuge — sync-report.rb vergleicht den Klon mit dem ZIP-Export,
                      vendor.rb holt die neun eingebackenen Fremdbibliotheken
web/                  die Webanwendung (Roda, dry-rb) und ihre Gestaltung
  app.rb              Routen
  boot.rb             Container (dry-system), Wurzelpfad, Vendor-Verzeichnis
  lib/atlas/          Reader, Umformungen, Middleware
  templates/          ERB-Vorlagen — spiegeln die Klassennamen von Muster.dc.html
  site.css            Gestaltung — gehört der Design-Oberfläche
  Muster.dc.html      jeder Baustein einmal — gehört der Design-Oberfläche
  site.js             Nachrüstung: Signaturen einsetzen, Register filtern
  nicht-oeffentlich.csv  Pfade, die keine zweite Adresse bekommen
test/                 minitest + rack-test
handarbeit/           nur der Mensch schreibt hier — QGIS-Projekte, Erfassungs-GeoPackages
praesentationen/      Präsentationen (Pitch-Deck, QField-How-to) und Wireframes
recherche/            Recherche-Notizen und festgehaltene Entscheidungen
skills/               projekteigene Skills (belegstatus, atlas-kartenblatt, …)
uploads/              Daten und Bilder, die Blätter zur Laufzeit laden
screenshots/          QA-Aufnahmen; drei davon bindet „Kleiner Gruß aus der Küche" ein
wip/                  Arbeitsablage, u. a. der ZIP-Export — global ignoriert
_ds/                  gebundenes Sternprodukt-Design-System (nicht anfassen)
```

Nicht im Klon, aber im Design-Projekt: `scans/` — die Referenzscans des gedruckten
Diercke (rund 60 MB). Sie sind Vergleichsmaterial, kein Blatt bindet sie ein; wer
sie braucht, holt sie aus dem Export.

Backlog und lose Enden: `IDEEN.md`. Was an Daten von außen fehlt:
`DATENBEDARF.md`. Agent-Einstieg: `AGENTS.md`; verbindliche Regeln: `CLAUDE.md`.

Farben und Signaturen laufen ausschließlich über `atlas/farben.js` und
`atlas/signaturen.js` — keine neuen Hex-Werte oder Ad-hoc-Symbole in einzelnen Blättern.
Die `.gpl`-Paletten sind daraus abgeleitet (`atlas/farben-paletten.rb`) und
werden nicht von Hand gepflegt.

## Erzeugte Geodaten werden versioniert

Die Skripte unter `atlas/geodaten/` erzeugen Kartendaten aus fremden Lieferungen.
Ihre **Ergebnisse liegen im Repo**, nicht nur die Skripte — auch wenn das der
üblichen Regel widerspricht, Erzeugtes nicht zu versionieren.

Der Grund ist die Eingangsseite: CLC2018 kommt als mehrere Gigabyte über ein
Portal, verschachtelt als `Results/…geoPackage.zip/DATA/…gpkg`; die GBIF- und
Overpass-Abfragen liefern je nach Tag ein anderes Ergebnis. Ein Erzeugnis, dessen
Eingang sich nicht verlässlich wiederbeschaffen lässt, ist praktisch eine Quelle
und wird wie eine behandelt. Sonst zahlt den Preis, wer klont: ein Blatt, das
stumm leer bleibt, und ein halber Tag Suche nach dem Grund.

Betroffen sind `nutzung-*.geojson` (neun Flächenklassen, 12 MB, gelesen von
`Rumaenien-Wirtschaft.html`), `friedhof-freiburg.geojson` und die Datensätze
unter `atlas/qgis/themen/rumaenien-baer/daten/`.

Draußen bleiben nur die **Zwischenstufen** — Rohlieferungen, entpackte Archive,
Arbeitskopien. Was `.gitignore` ausschließt, steht dort begründet.

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

## Auslieferung und Vorschau

Die Blätter sind statisch, die Anwendung um sie herum ist es nicht: eine Roda-App
serviert den Baum und baut Startseite, Schaukasten, Blattschau, Namensregister und
Werkstatt daraus. Ein Prozess, kein nginx.

    bundle install
    ruby bin/vendor.rb               # einmalig: die neun Fremdbibliotheken holen
    bundle exec rackup -p 8139       # http://localhost:8139/

    docker compose --profile local up preview   # 8137 — Baum aus dem Image
    docker compose --profile local up dev       # 8138 — Arbeitsverzeichnis gemountet

**Alles wird zur Laufzeit gelesen.** Die Blattliste kommt aus den Tabellen dieser
README, das Register aus `atlas/register.csv`, der Blattschlüssel aus
`atlas/blaetter.csv`, die Prosa aus den `.md`-Dateien. Eine Korrektur an einer Datei
steht beim nächsten Aufruf da; es gibt keine abgeleitete Kopie, die still veraltet.
Fehlt etwas, wird nicht geraten: der Fall erscheint als sichtbarer Kasten mit Pfad und
Grund — ein Blatt ohne README-Zeile, eine Blattnummer ohne Datei, ein Verweis ins
Leere.

Ein Blatt bleibt unter seiner eigenen Adresse erreichbar
(`/Rumaenien-Physisch.html`), damit jeder Verweis in jedem Blatt weiter funktioniert;
`/blatt/Rumaenien-Physisch.html` ist die gerahmte Fassung mit Quellenregister daneben.

Beides **läuft ohne Netz.** Die Blätter laden d3, topojson, React und Babel sonst von
unpkg und die Weltgeometrie von jsDelivr; `bin/vendor.rb` legt diese neun Dateien
unter `/vendor` und eine Rack-Middleware schreibt die Verweise im Ausgang um. Die
Blätter selbst bleiben unangetastet — sie gehören dem Design-Projekt und müssen
byte-genau vergleichbar bleiben. Die `integrity`-Hashes gelten weiter, weil die
eingebackenen Dateien byte-gleich sind; `bin/vendor.rb` prüft das und bricht sonst ab.

Die neun Adressen stehen an **einer** Stelle, `web/lib/atlas/vendor.rb`. Vorher waren
es drei: zweimal als `sub_filter`-Block in `web/nginx.conf`, einmal als Shell-Liste im
`Dockerfile` — also zwei Gelegenheiten, acht von neun zu ändern.

Selbst auszuliefern hat außer der Vorschau ohne Netz zwei Gründe, die auch öffentlich
gelten: die IP-Adressen der Besucher gehen nicht an Dritte, und
`deutschlandGeoJSON@main` ist ein bewegliches Ziel — was ein fertiges Blatt lädt, soll
sich nicht unter ihm ändern. Dieselbe Begründung wie dafür, dass die erzeugten
Geodaten im Repo liegen.

Umgeschrieben werden **genau die neun eingebackenen Adressen**, nicht der Host. Eine
Präfixregel würde jede unpkg-URL treffen: eine Versionsanhebung upstream ergäbe einen
`/vendor`-Pfad, den es nicht gibt, und das Blatt liefe auf 404. So fällt eine nicht
eingebackene Version auf das CDN zurück — sie verschlechtert sich auf den Ist-Zustand,
statt zu brechen. Eine Quellenangabe, die per `href` ein CDN zitiert, bleibt aus
demselben Grund ein funktionierender Verweis.

Einzige echte Netz-Abhängigkeit bleibt der Overpass-Aufruf in `Nikolais-Ort.dc.html`
— eine Live-Abfrage, die sich nicht einbacken lässt. Ohne Netz zeichnet das Blatt aus
`atlas/geodaten/friedhof-freiburg.geojson`.

### Wovon die Anwendung gebaut ist

Roda routet, dry-rb trägt die Daten: `dry-system` verdrahtet die Reader,
`dry-transformer` macht die Parse-Ketten für README-Tabellen und Semikolon-CSV,
`dry-monads` bringt das `Result`. Letzteres ist keine Verzierung — jeder Reader gibt
`Success` oder `Failure` zurück, und ein `Failure` wird zum sichtbaren Kasten. Damit
ist die Projektregel „fehlt ein Eintrag, wird nicht geraten" im Typ der Rückgabe
verankert und nicht in der Sorgfalt des Aufrufers.

Nicht genommen wurde `web_pipe`, obwohl seine Form gut passt: letzte Fassung
November 2021, letzter Commit November 2023, und die Gemspec nagelt `rack ~> 2.0`
fest.

`web/site.js` ist **Nachrüstung, keine Voraussetzung.** Der Server liefert jede Seite
vollständig, auch alle 272 Registerzeilen. Das Skript setzt die Signaturen aus
`atlas/signaturen.js` ein — der Katalog ist ein JS-Modul, der Browser ist sein
natürlicher Leser, ein zweiter Parser in Ruby wäre eine zweite Stelle mit eigener
Meinung — und filtert die schon gelieferte Tabelle ohne Rückfrage. Ohne JavaScript
filtert das Formular per GET, und jede Filterung ist eine teilbare Adresse.

### Ein Schutz, zwei Listen

Der Caddy des Hosts sperrt vier Pfade hinter eine Passwortabfrage (bmeise,
`host_vars/paketzentrum.yml`, `basicauth.paths`). Er schützt **Adressen** — und diese
Anwendung erfindet für denselben Inhalt neue: `/blatt/<datei>` und
`/werkstatt/<pfad>`. Ohne Gegenmaßnahme wäre `/werkstatt/recherche/…​.md` der volle
Text an einer Adresse, die der Caddy nicht kennt.

Deshalb `web/nicht-oeffentlich.csv`: was dort steht, bekommt keine zweite Adresse,
sondern eine Umleitung auf den Originalpfad, wo die Abfrage sitzt. Der Eintrag bleibt
in Schaukasten und Werkstatt sichtbar und als *nicht öffentlich* gekennzeichnet —
verschweigen wäre eine andere Auskunft als verschließen.

**Die beiden Listen müssen zusammen gepflegt werden.** Fehlerrichtung wie drüben: was
fehlt, ist öffentlich, und nichts meldet das. `test/web_test.rb` prüft, dass jeder
Eintrag der Liste hier wirklich umgeleitet wird — nicht, dass die Liste vollständig
ist; das kann sie nicht.

## Arbeiten an zwei Orten

Dieses Projekt wird an zwei Stellen weitergebaut — in der Claude-Design-Oberfläche
und hier im Terminal — und liegt an einer dritten: `yuszuv/diercki` auf GitHub. Das
geht gut, solange klar ist, was wo entsteht.

**Im Zweifel führt der Klon.** Er hat die Historie, er hat die Skripte, er ist das,
was ein Fremder klonen und bauen kann. Die Oberfläche ist die Werkstatt zum
Zeichnen, nicht das Archiv.

### Die eine Asymmetrie, aus der alles folgt

Das Atlas-Projekt in der Oberfläche ist ein gewöhnliches Claude-Projekt, kein
Design-System. Es lässt sich **programmatisch nicht beschreiben** — es gibt keinen
Weg, eine hier geänderte Datei automatisch dorthin zu bringen. Umgekehrt geht alles:
Projekt exportieren, ZIP entpacken, fertig.

Daraus folgt die Arbeitsteilung. Nicht „mal hier, mal dort", sondern **je Artefakt
festgelegt**, damit möglichst wenige Dateien an beiden Orten angefasst werden:

| Was | Wo | Warum |
|---|---|---|
| Kartenblätter, Zeichenerklärung, Decks (`*.html`, `*.dc.html`, `praesentationen/`) | **Oberfläche** | dort ist die Vorschau, die Tweaks-Leiste und das gebundene Design-System |
| Signaturenkatalog, Farben, Typenscale (`atlas/signaturen.js`, `farben.js`, `typenscale.js`) | **Oberfläche** | die Blätter importieren sie; derselbe Zeichenvorgang |
| Geodaten-Pipelines (`atlas/geodaten/`) | **lokal** | brauchen GDAL, osmium und mehrere Gigabyte Rohdaten |
| QGIS-Kartensatz (`atlas/qgis/`) | **lokal** | QGIS liest und schreibt die Dateien, XML-Validität zählt |
| Doku, Quellenregister, Recherche | **lokal** | sie beschreiben den Klon, und der Klon führt |
| Namensregister (`atlas/register.csv`) | **Oberfläche** | dort entstanden und dort gepflegt; hier schreibt nichts hinein |
| Gestaltung der Webfassung (`web/site.css`, `web/Muster.dc.html`) | **Oberfläche** | das Musterblatt zeigt jeden Baustein einmal und lässt sich dort zeichnen |
| Rest der Webanwendung (`web/`, `config.ru`, `Gemfile`, `Dockerfile`, `docker-compose.yml`, `bin/`, `test/`) | **lokal** | kennt die Oberfläche nicht und braucht sie nicht |
| `handarbeit/` | **lokal, nur der Mensch** | Binärdateien von QGIS und QField |
| `_ds/` | **keins von beidem** | kommt aus dem Sternprodukt-Design-System und wandert im Export mit |

### Die Runde

1. **Vor der Oberflächen-Runde:** lokal committen und pushen. Damit gibt es einen
   benannten Stand, gegen den sich hinterher vergleichen lässt.
2. **In der Oberfläche:** Blätter zeichnen. Nichts aus der lokalen Spalte anfassen.
3. **Danach:** Projekt als ZIP exportieren, nach `wip/` legen (dort global ignoriert),
   dann

       ruby bin/sync-report.rb          # Bericht: GLEICH · ANDERS · NUR LOKAL · NUR IM EXPORT
       ruby bin/sync-report.rb --diff   # zusätzlich Textdiffs

   Das Skript **schreibt nichts** — es berichtet und markiert je Datei, welche Seite
   nach der Tabelle oben gilt. Übernommen wird von Hand, in Blöcken, mit Commit.
4. **Lokal weiterarbeiten:** committen, pushen. Solange nur die lokale Spalte
   betroffen ist, braucht es keinen Rückweg.
5. **Wenn doch ein Blatt lokal geändert wurde:** unten unter „Wo der Klon abweicht"
   vermerken **und** die Datei beim nächsten Besuch in der Oberfläche hochladen —
   sonst überschreibt der nächste Export sie stillschweigend.

### Warum nicht Datei für Datei über das Werkzeug

Der Vollabgleich über `DesignSync get_file` ist der teure Irrweg: 256 KiB Deckel,
stilles Abschneiden bei größeren Dateien, und der Umweg durch einen Modellkontext
normalisiert unsichtbare Zeichen — so sind schon Ein-Byte-Abweichungen in
`support.js` und ein verlorenes schmales Leerzeichen in `_ds/readme.md` entstanden.
Über dem Deckel liegen ohnehin `_ds/_ds_bundle.js` (2,3 MB), die dreizehn
woff2-Schriften und `atlas/geodaten/verkehr-daten.js` (4,7 MB). Das ZIP ist
byte-treu, vollständig und meist der jüngere Stand.

Das Werkzeug taugt für **das Design-System** (`_ds/`) — das *ist* ein
Design-System-Projekt und lässt sich in beide Richtungen ansprechen. Der Weg dorthin
ist verlustfrei, weil `write_files` mit `localPath` von der Platte liest.

### GitHub

`origin` ist der dritte Ort und der einzige, der beide überlebt. Push nach jeder
abgeschlossenen Runde — der Klon ist die Quelle der Wahrheit nur so lange, wie er
auch woanders liegt.

## Wo der Klon vom Design-Projekt abweicht

Das Design-Projekt ist die Quelle der Wahrheit — aber nicht in jedem Punkt der
jüngere Stand. Was hier bewusst anders ist, steht hier, damit es beim nächsten
Abgleich nicht als Drift durchgeht und still zurückgedreht wird.

**Der Klon ist voraus, weil er einen Fehler behoben hat:**

- `atlas/qgis/themen/brandenburg-hanf/qfield/hanf_kontrolle.qml` — drüben schließt
  ein gerades Anführungszeichen in „unklar" das `desc`-Attribut vorzeitig; die Datei
  ist dort kein wohlgeformtes XML und QGIS liest sie nicht.
- `atlas/qgis/basis/layout/layout_a4_quer_thema.qpt` — drüben trägt der
  Rahmen-Eintrag fünf doppelte Attribute mit widersprüchlichen Werten
  (Papierton/0,6 mm gegen Tinte/0,3 mm). Hier steht die Papier-Fassung.
- `atlas/geodaten/brandenburg/README.md` und `SORTEN.md` benennen die
  InVeKoS-Antragsdaten als Hanf-Geometrie. Drüben steht noch der ältere Stand
  („Hanf hat keine offene Geometrie"), der dem eigenen Kartenblatt widerspricht:
  das liest `hanf-2026.geojsonl` und `sorten.csv` zur Laufzeit.

**Bilder liegen kleiner als drüben.** `screenshots/katzundgoldt-crop.png` (472 KB
statt 1,2 MB) und `uploads/neumaier-frueher.png` (67 KB statt 1,5 MB) sind
absichtlich verkleinert — für die Bildschirmgröße, in der die Grüße sie einbinden,
reicht das. Wer sie in Druckgröße braucht, holt sie aus dem Design-Projekt.

**Draußen bleiben Dateien, die kein Blatt braucht:** die Vorlagenscans unter
`scans/` sind reines Vergleichsmaterial. Was `.gitignore` ausschließt, steht dort
begründet.

## git-Repo

`yuszuv/diercki`, siehe `github.md` für Rollen und letzten Sync-Stand. Das
Design-Projekt ist die Quelle der Wahrheit; Änderungen an `handarbeit/` kommen
ausschließlich vom Menschen.
