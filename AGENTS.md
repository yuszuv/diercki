# AGENTS.md

Einstieg für Coding-Agents (Claude Code u. a.) im Repo `yuszuv/diercki`.
Die verbindlichen Projekt-Regeln stehen in `CLAUDE.md` — dieses Blatt doppelt sie nicht.

## Rollen
- Agents schreiben: `atlas/`, Kartenblätter (`*.html`, `*.dc.html`), Doku, `praesentationen/`, `recherche/`, `web/`, `bin/`, `test/`
- Nur der Mensch schreibt: `handarbeit/` (QGIS-Projekte, Erfassungs-GeoPackages)
- `_ds/` ist das gebundene Design-System — nie anfassen
- `web/site.css` und `web/Muster.dc.html` gehören der Design-Oberfläche: hier nur
  ändern, wenn es eine Klasse betrifft, die die Vorlagen neu erzeugen — und dann
  beides zusammen. Die ERB-Vorlagen unter `web/templates/` spiegeln die
  Klassennamen des Musterblatts

## Sprache
- **Commit-Messages englisch.** Kartographisches Fachvokabular bleibt darin deutsch
  und unübersetzt: *Blatt*, *Signatur*, *Schummerung*, *Quellenregister*,
  *belegt / abgeleitet / unbelegt*
- **Doku dieses Repos:** englische Prosa, deutsches Fachvokabular. Die Regel greift
  nur bei Begriffen, die Bedeutung verlieren — *Zeichenerklärung* und *Kartensatz*
  sind technische Allerweltswörter und dürfen *legend* und *map set* heißen
- **Code unter `web/`:** Bezeichner und Kommentare englisch; sichtbare Zeichenketten,
  CSS-Klassen, Routen und CSV-Spaltennamen deutsch
- **Doku des Design-Systems (`_ds/**`) ist deutsch — Vorgabe, kein Altbestand.**
  Nicht mitübersetzen, wenn dieses Repo seine eigene Doku auf Englisch führt: sie ist
  Marken- und CI-Material, geschrieben in genau der Stimme, die sie vorschreibt. Und
  `_ds/` wird ohnehin nie angefasst — eine Änderung dort wäre beim nächsten Abgleich
  Drift
- **Dateinamen der Blätter bleiben, wie sie sind** (`Zeichenerklaerung.dc.html`,
  `QGIS-Kartensatz.dc.html`), ebenso die drei vom Programm gelesenen Überschriften in
  der `README.md`

## Die Webanwendung
Roda + dry-system + dry-monads, ein Puma-Prozess, kein nginx.
Start: `bundle exec rackup` (9292), Tests: `bundle exec ruby -Itest test/web_test.rb`.

- **Jeder Reader gibt ein `Result` zurück.** Ein `Failure` wird zum sichtbaren
  `.fehlfall`-Kasten mit Pfad und Grund. Das ist die Projektregel „fehlt ein
  Eintrag, wird nicht geraten" im Typ der Rückgabe, nicht in der Sorgfalt des
  Aufrufers. Kein `rescue`, das einen fehlenden Eintrag zu einem leeren macht.
- **Die neun CDN-Adressen stehen nur in `web/lib/atlas/vendor.rb`.** Von dort
  lesen die Rack-Middleware und `bin/vendor.rb`. Nie eine zehnte Stelle aufmachen.
- **Kartenblätter werden nie umgeschrieben, nur gerahmt.** Die Umschrift geschieht
  im Ausgang; auf der Platte muss ein Blatt byte-gleich zum Export bleiben.
- **`web/nicht-oeffentlich.csv` und `basicauth.paths` in bmeise gehören zusammen.**
  Wer eine neue Route baut, die den Inhalt einer Datei unter einer zweiten Adresse
  ausgibt, prüft diese Liste — sonst geht die Passwortabfrage des Hosts ins Leere.

## Eiserne Regeln (Kurzform, Details in CLAUDE.md)
- Farben ausschließlich aus `atlas/farben.js` bzw. den `.gpl`-Paletten — keine neuen Hex-Literale
- Signaturen ausschließlich aus `atlas/signaturen.js` — keine Ad-hoc-Symbole in Blättern
- Bei Änderungen an Katalog/Farben/Blättern die QGIS-Artefakte nachziehen
  (`QGIS-Kartensatz.dc.html`, `atlas/paletten/`, `atlas/geodaten/`, Werkstatt-Blatt der Zeichenerklärung)
- Jede Zahl auf einer Karte braucht eine Zeile im Quellenregister (`atlas/quellen/`)
- Ton: keine Verspieltheit in Deliverables; genau ein Zahlen-Gimmick (137, auf Hanf-Blättern wahlweise 420)
- Belegstatus gilt auch in Chat und Fachantwort: beruht eine Aussage auf Plausibilität
  statt auf einer benennbaren Quelle, steht das im selben Satz dabei
- Zuordnungstabellen (Sorten, Codelisten, Klassengrenzen) werden zur Laufzeit gelesen —
  vom Blatt, von QGIS per Attributverknüpfung, von QField als Wertliste. Kein Build-Schritt,
  keine abgeleitete Zwischendatei. Skripte dürfen prüfen und berichten; fehlt ein Eintrag,
  wird nicht geraten — der Fall bekommt eine eigene, sichtbare Klasse
- Kartographisches Fachvokabular durchgängig (Signatur, Grundriss, Situation, Schummerung,
  Isohypse, Äquidistanz, Generalisierung, Kartennetzentwurf, Zeichenerklärung) — Details in CLAUDE.md

## Teuer gelernt
- **d3-geo und die Wicklungsrichtung.** d3 rechnet sphärisch und erwartet Außenringe
  im **Uhrzeigersinn**; ein andersherum gewickelter Ring heißt dort „alles außer
  dieser Fläche" — die Karte wird weltgroß, Linien kollabieren, `invert()` liefert
  Unsinn. OSM und RFC 7946 wickeln entgegengesetzt, QGIS und ogr ist es gleich. Die
  Datei ist also nach Standard korrekt und trotzdem für d3 falsch. Beim Einlesen
  drehen, an **jedem** Ladeweg, nicht nur an einem.
- **Anekdotische Evidenz ist Evidenz.** Was Jan aus eigener Erinnerung erzählt, wird
  wörtlich übernommen und im Quellenregister als Erinnerung gekennzeichnet — **nicht
  in Frage gestellt und nicht überprüft**. Auch nicht wohlwollend: eine Recherche, die
  eine Erinnerung bestätigen *will*, ist immer noch eine Prüfung, und ein „ließ sich
  nicht bestätigen" ist ein Urteil, um das niemand gebeten hat. Öffentliche
  akademische Fakten (Publikationen, Affiliationen, Qualifikationsschriften) dürfen
  daneben stehen — aber als eigener Beitrag, nie als Gegenprobe. Zu nicht-öffentlichen
  Personen wird gar nicht recherchiert.
- **Sprachregister für Persönliches:** orbit.sternprodukt.de (`yuszuv/orbit`). Erste
  Person, kurze Aussagesätze, konkrete Namen und Jahre, Schweres in einem Nebensatz
  ohne Ausschmückung, höchstens ein `;)`.

## Skills
Vier projekteigene Skills unter `skills/`, Zuschnitt begründet in
`recherche/skills-agents-mcp-sondierung.md`:
`belegstatus` (belegt / abgeleitet / unbelegt, über die Kartographie hinaus),
`atlas-kartenblatt` (Blattbau, Signaturenkatalog, Typenscale, d3-Fallen),
`qgis-kartensatz` (basis/themen-Trennung, Feldvertrag, Maßstabsgrenzen),
`sternprodukt-ton` (Sprachregister, Persönliches).
Geodaten-Beschaffung hat bewusst keinen eigenen Skill — der vorhandene
`geodaten-quellen` deckt sie; welches Skript welche Datei erzeugt, steht in
`atlas/geodaten/LIESMICH.md`.

## Orientierung
- `README.md` — Struktur und Blattliste
- `WEB-APPLICATION.md` — die Webanwendung: Auslieferung, Aufbau, Wächter
- `TWO-PLACES.md` — der Abgleich mit der Design-Oberfläche
- `IDEEN.md` — Backlog
- `DATENBEDARF.md` — was an Daten von Jan noch fehlt
- `atlas/geodaten/LIESMICH.md` — welches Skript welche Geodatei erzeugt
- `recherche/uebergabe-2026-08-07.md` — wo der Faden liegt
- `github.md` — Repo-Bindung und Sync-Stand
