# Ideen & Später

Lose Enden, noch nicht verplant. Wird laufend ergänzt.

Erledigt (Entscheidungen: `recherche/entscheidungen-2026-08-07.md`):

- ✓ Pitch-Deck für „Höhle der Löwen" — `praesentationen/Pitch-Hoehle-der-Loewen.dc.html`
- ✓ ÖPNV-Verbindungskarte Banat — Blatt 17, oktilinear, topologietreu
- ✓ Bärenkarte + Imkerei und Wildbienen — `Rumaenien-Braunbaer.html`, mit Mohn-Mauerbienen-Nebenkarte
- ✓ How-to-Präse „QField als Bahnreise-Planer" — `praesentationen/QField-Bahnreiseplaner.dc.html`
- ✓ Post-it-Präse zum Zeichensystem — `praesentationen/Zeichensystem-Post-its.dc.html`
- ✓ Typenscale für den ganzen Atlas — `atlas/typenscale.js`, sieben Stufen, Untergrenze 5,5 pt
- ✓ Unicode-Näherung des Sternprodukt-Zeichens gemessen — `Zeichen-Naeherung.dc.html`:
  ⋆ₕ erreicht nur Stufe 3 (Systemkette). Empfehlung: `*_hbar` als ASCII-Fassung,
  `⋆` allein als Zeichen-Fassung. Noch nicht in CLAUDE.md/Templates übernommen.
- ✓ Präse zu Iteration 2 (Konzept vor Bau) — `praesentationen/Iteration-2-Konzept.dc.html`,
  10 Folien: Grenzen von Iteration 1, der Kreis Blatt → Feldpaket → Aufnahme → Belegstatus,
  das gebaute Hanf-Feldpaket, dann die Zoom-Frage geprüft (Aufgabentabelle, Generalisierungs-
  Einwand) und in drei Zuschnitte A/B/C aufgelöst. Empfehlung als Tweak umschaltbar,
  Vorgabe B. **Offen: Jans Wahl zwischen A, B und C.**
- ✓ Feinschliff Reiseplaner-Duo (Pitch-Deck, How-to-Präse) — Sprache/Ton durchgesehen,
  keine Korrekturen nötig
- ✓ Feinschliff Zeichenerklärung (15 Blatt) — Sprache, Konsistenz, Asset-Referenzen
  durchgesehen, keine Korrekturen nötig
- ✓ QML-Stile druckreif — bereits erledigt, IDEEN.md-Eintrag war veraltet:
  `referencescale=2500000` durchgängig, `scalemaxdenom` gestaffelt in `punkt_ort.qml`
  (5 Ortsgrößen, 600k–6M), Beschriftungsrang als Leiter (10/8/7/6/5/4/2)

In Arbeit:

- ✓ **Belegstand des Atlas** (15.08.2026) — `/belegstand` liest die acht Quellenregister
  als Angaben statt als Prosa und zählt sie: 120 Aussagen, 59 belegt · 29 abgeleitet ·
  15 unbelegt · 17 mit eigenem Wort. Je Blatt eine Zeile mit Balken, Filter nach Status
  und Blatt, offene Fälle als `.fehlfall`. Neu: `Sources::Evidence`, `Atlas::Table` (die
  gemeinsame Form der Leser, Zeilenquelle als Parameter), `Transforms.markdown_tables`.
  **Beim ersten Durchlauf gefunden:** ein Tippfehler „abderleitet" in `Verkehr.md`, der
  als eigene Statuskategorie erschienen wäre — korrigiert. Offen dazu: die zwei Blätter
  ohne Quellenregister (Rumaenien-Physisch, Rumaenien-Landschaften) und die Verknüpfung
  zu `DATENBEDARF.md` („welche Lieferung hebt wie viele Aussagen"), bewusst zurückgestellt.
  `web/site.css` ist UI-Eigentum und muss zurückreisen — vermerkt in `TWO-PLACES.md`.

- **Eine kuratierte CSV als Inhaltsverzeichnis — und dann der Repo-Zuschnitt**
  (Idee Jan, 15.08.2026). Gehört mit der Dateinamen-Frage und dem Adressraum für
  Zuschnitt B zusammen; wird als ein Vorhaben angegangen, nicht als drei.

  *Befund vorab:* die Blattliste steht heute an **drei** Stellen. `README.md` führt
  sie als drei Tabellen (Blätter, Weitere Blätter, Präsentationen) und ist die Quelle
  für `Sources::Sheets`. `atlas/blaetter.csv` führt 16 Zeilen für `Sources::Plates`.
  Und `Inhalt.dc.html` — das Inhaltsverzeichnis-Blatt selbst — führt sie ein drittes
  Mal, **fest verdrahtet im Markup**, Abteilung für Abteilung. Nur die ersten beiden
  werden gegeneinander geprüft (`Sheets#open_cases` gegen das Wurzelverzeichnis);
  gegen `Inhalt.dc.html` prüft nichts. Das ist die einzige Liste im Projekt, die
  still veralten kann — genau der Fall, gegen den die Regel in `CLAUDE.md` steht.

  *Zuschnitt:* eine kuratierte `atlas/inhalt.csv`, die `blaetter.csv` aufnimmt und
  trägt: Kennung, Datei, Titel, Abteilung, Rang, `nr` (als Angabe, nicht als Adresse),
  Quellen, Status, Anmerkung. `Inhalt.dc.html` und die Werkstatt lesen sie zur
  Laufzeit; die README-Tabelle wird durch einen Verweis ersetzt, damit es bei *einer*
  Liste bleibt. Alles Nötige steht schon: `Sources::Tree` liest bei jedem Request neu,
  `Transforms.rows` parst, Failure → `.fehlfall` macht Fehlendes sichtbar.
  **Grenze ziehen:** die CSV trägt Identität und Ordnung. Nicht die Halte (die gehören
  ins Blatt, s. Punkt 6) und nicht die Erklärtexte einer Führung (eigene Tabelle,
  eigene Lebensdauer). Sonst wird sie der Eimer, in den alles fällt.

  *rom-rb, nochmal überdacht (15.08.2026):* **Der CSV-Adapter ist tot.** `rom-csv`
  steht bei 0.3.0 vom 22.02.2016 (belegt: RubyGems-API), ROM-Kern bei 5.4.3 — der
  Adapter ist gegen ROM 0.x gebaut und seit zehn Jahren ohne Release. Damit fällt der
  direkte Weg weg, und es bleiben zwei:

  1. **rom-sql über die vorhandene In-Memory-SQLite** (Sequel und sqlite3 stehen schon
     im Gemfile, für Rodauth). Reifer Adapter, echte Joins über register × blaetter ×
     quellen × sorten. Preis: die DB ist ein abgeleiteter Zwischenstand — genau das,
     was die Regel in `CLAUDE.md` verbietet, es sei denn sie wird bei jeder Änderung
     neu befüllt. Dafür bräuchte es wieder eine mtime-Prüfung pro Anfrage, also
     `Tree#parse` — mit einer Datenbank dazwischen. Zwei weitere Konflikte: ROM gibt
     bei fehlender Datei eine *leere Relation*, und Stillschweigen ist hier der eine
     verbotene Ausgang; die `Result`-Grenze müsste also obendrauf ohnehin bleiben.
  2. **Kein ROM, sondern die gemeinsame Form der Leser herausziehen.** Die fünf unter
     `web/lib/atlas/sources/` wiederholen dieselben vier Schritte: parsen, Spalten
     wandeln, nach Schlüssel finden, Unpaariges auflisten. Das sind rund 30 Zeilen,
     keine Abhängigkeit — und das eigentlich Wertvolle (`Plates#unmapped`,
     `Sheets#open_cases`, beide Richtungen sichtbar) bekommt man von ROM sowieso nicht.

  **Entschieden 15.08.2026: Variante 2.** Bei 272 Zeilen in sechs Dateien ist die
  Abfrage nicht das Problem. rom-sql bleibt als Rückfallweg benannt, aber erst bei
  einem Auslöser: der *dritten* Prüfung über Tabellengrenzen hinweg — heute gibt es
  zwei (Register↔Blattschlüssel, README↔Verzeichnis); kämen Wegeverzeichnis und
  Sortenliste als kreuzende Tabellen dazu, ist der Zeitpunkt da. Vorher zahlt man eine
  Abhängigkeit für Joins über Listen, die in den Speicher passen.

  *Wie die 30 Zeilen zuzuschneiden sind — und wo Markdown hineingehört:* die fünf
  Leser unterscheiden sich in genau **einem** Schritt, nämlich `Text → Array<Hash>`.
  Danach ist alles gleich: Struct bauen, nach Schlüssel finden, Unpaariges auflisten.
  Also wird **die Zeilenquelle der Parameter**, nicht das Dateiformat. Beide Fassungen
  liegen schon fertig in `Transforms`: `rows` für die Semikolon-CSV, `section` +
  `table_rows` für Markdown-Tabellen unter einer Überschrift — `Sources::Sheets` liest
  so bereits heute die README.

  Perspektivisch trägt das mehr, als es kostet: **die kuratierte Liste könnte eine
  Markdown-Datei sein** — `atlas/INHALT.md`, Prosa und darunter eine Tabelle — statt
  einer CSV. Das löst den Einwand auf, der oben gegen die CSV steht (der Kommentar in
  `sheets.rb` verteidigt die README, weil eine Liste, die zugleich Doku ist, ehrlich
  bleibt): eine Markdown-Tabelle ist beides, wird zur Laufzeit gelesen, und es bleibt
  trotzdem bei *einer* Liste. Die Wahl CSV oder Markdown wird damit redaktionell — wer
  pflegt das, mit wieviel Prosa daneben — und nicht mehr technisch. Vor dem Bauen zu
  entscheiden; die Semikolon-CSV bleibt richtig für Tabellen ohne Prosa (`sorten.csv`,
  `geschuetzt.csv`).

  **Zwei Dinge dürfen dabei nicht eingeebnet werden:** `Restricted` fällt *geschlossen*
  (`restricted?` gibt bei Lesefehler `true`), jeder andere Leser fällt offen auf eine
  leere Liste mit sichtbarem Fall. Diese Asymmetrie ist Absicht und im Kopf von
  `geschuetzt.csv` begründet — eine gemeinsame Oberklasse, die die Fehlerrichtung
  vereinheitlicht, macht aus geschützten Dokumenten offene. Und die Suchfunktionen
  geben teils `Failure([:grund, schlüssel])`, teils `nil` zurück, je nachdem ob der
  Aufrufer einen Fehlfall anzeigen oder eine Entscheidung treffen will; auch das ist
  keine Unsauberkeit, die man wegvereinheitlicht.

  *Repo-Zuschnitt, im selben Zug:* das Wurzelverzeichnis trägt 16 Blatt-Dateien flach
  nebeneinander, dazu vier Laufzeitdateien aus dem Design-System (`support.js`,
  `deck-stage.js`, `doc-page.js`, `tweaks-panel.jsx`), dazu Doku, Gemfile, Dockerfile
  und eine PDF. Verschieben ist kein Kosmetikschritt: `datei` ist heute die Adresse,
  `Sheets#open_cases` liest `.` direkt und siebt Blätter mit `/` im Pfad aus
  (`sheets.rb:53–57`), und die `.dc.html` erwarten die DS-Dateien auf gleicher Höhe.
  Deshalb: erst die Kennung, dann der Umzug — in dieser Reihenfolge kostet er nichts,
  umgekehrt bricht er jeden Verweis.

- **Reiseplaner-Wireframes A/B/C.** Nicht zu verwechseln mit den drei *Zuschnitten*
  A/B/C der Iteration-2-Präse (eine Zeile weiter oben, andere Entscheidung). Hier geht
  es um die Bedienung: `praesentationen/Wireframe-A-Chips.dc.html`
  (Themenchips über der Karte, Hauptscreen), `-B-Tabs` (Themenliste mit Tab-Leiste unten),
  `-C-Split` (Karte oben, Trefferliste unten). Screenshots liegen als `wf-a.png`,
  `wf-b.png`, `wf-c.png` daneben. Absichtlich WIP: grau und unfertig, damit die
  Diskussion um die Anordnung geht.
  **Entschieden 15.08.2026: C bekommt keine eigene Folie** — weder im Pitch (Folie 04
  „Zwei Screens") noch im Vorschlag (Folie 05/06). Die Decks bleiben damit, wie sie sind;
  `-C-Split` bleibt als Wireframe liegen, ohne Auftritt.
  **Weiter offen:** die Bedienungsvariante selbst — A (Chips) oder B (Tabs).

- **Diercke-Scans Klima (46/47) + Landwirtschaft (48–51)** — extract-rotate-stitch-Pipeline
  gelaufen: `scans/spread-klima.jpg`, `spread-landwirtschaft-48-49.jpg`, `-50-51.jpg`
  + Einzelseiten (`klima-seite-46/47.jpg`, `lawi-seite-48–51.jpg`), Schwarzränder
  bereinigt, Bundsteg als freigelassene Lücke. **Finale Scan-Optimierung ans Ende
  verschoben** (Feinschliff Beschnitt, ggf. Deskew, Legenden-Rekonstruktion S. 48,
  Nachscan-Streifen einsetzen — s. DATENBEDARF № 11).

- **TODO · Grabfeld auf dem Freiburger Hauptfriedhof recherchieren** (offen, 13.08.2026)

  Zwei Fragen, die auseinandergehalten gehören:

  1. **Welche Grabart?** Drei Kandidaten stehen nebeneinander — das anonyme
     Urnengrabfeld (**Feld 35**, so die Recherche), der **Waldfriedhofsteil** (so die
     frühere Notiz) und das **Baumfeld** als eigene Grabart. Das ist keine
     Recherchefrage, sondern Jans Erinnerung; sie wird nicht gegengeprüft.
  2. **Wo liegt das Feld im Grundriss?** Das ist die Recherchefrage. OSM kennt die
     Feldnummern nicht. Nötig ist der Feldplan der Friedhofsverwaltung (Eigenbetrieb
     Friedhöfe Stadt Freiburg, Friedhofstraße 8) — ein abfotografierter
     Übersichtsplan am Eingang genügt zum Digitalisieren. Siehe DATENBEDARF № 8.

     **Vorschlag 15.08.2026: dieser Gang geht an Stefan.** Er ist in Freiburg, es sind
     zwanzig Minuten, und der eigentliche Grund ist nicht der Plan, sondern der Besuch.
     Als Bitte am Ende der Waldmann-Präse oder in der Mail dazu — Formulierung steht
     als Entwurf, noch nicht eingesetzt. Nimmt DATENBEDARF № 8 aus Jans Spalte.

  Solange beides offen ist, zeigt das Blatt **Näherungen statt eines Punkts** und
  beschriftet sie als solche. Nichts anderes eintragen — die Regel steht im Skill
  `sternprodukt-ton`: nicht behaupten, wo etwas ist, wenn es nicht bekannt ist.

- Stilles Blatt: Freiburger Hauptfriedhof, Nikolais Ort — `Nikolais-Ort.dc.html` steht als
  erste Fassung: Grundriss aus OSM, Markier-Modus, fünf Zeichen-Fassungen als Tweak.
  Offen: **welches Feld?** Die Recherche findet das anonyme Urnengrabfeld als **Feld 35**,
  die frühere Notiz sprach vom Waldfriedhofsteil; der Hauptfriedhof hat daneben ein
  *Baumfeld* als eigene Grabart. Das Blatt hält beides offen, bis Jan entscheidet.
  Offen außerdem: die Lage von Feld 35 im Grundriss (braucht den Feldplan der
  Friedhofsverwaltung, OSM kennt die Feldnummern nicht) und die echte Clojure-SVG
  (EPL-1.0) statt des Nachbaus. Für später: farbig markierte Baumgruppen o. ä. dort,
  wo Nikolai liegen _könnte_ — Näherung statt Behauptung, solange Feld 35 nicht
  eingegrenzt ist.
- Doku-Durchsicht: README, CLAUDE.md, AGENTS.md — README am 07.08.2026 nachgezogen
  (neue Blätter, Laufzeit-Tabellen, QField-Paket); CLAUDE.md um zwei Regeln ergänzt
  (Belegstatus in Chat-Antworten, Korrekturwege ohne Build-Schritt); AGENTS.md am
  07.08.2026 nachgezogen (zwei neue Regeln in Kurzform, Fachvokabular-Zeile,
  Skills-Abschnitt, LIESMICH und Übergabe in der Orientierung). Damit abgeschlossen.

Später (sortiert nach Relevanz × Nützlichkeit, 07.08.2026):

1. **Hanf-Integration Brandenburg (Spin-off).** — *Kartographisch fertig* (07.08.2026):
   54 Schläge schlaggenau, Sortengruppe aus `atlas/geodaten/brandenburg/sorten.csv` zur Laufzeit, Kartodiagramm
   je Landkreis, Matrix-Legende. **Der fachliche Teil ist vertagt:** Nutzungsrichtung
   von Muka 76, Estica, Orion 33, Santhica 70 klären (55 ha, 9 % der Fläche, stehen als
   *ungeklärt* auf dem Blatt); Santhica braucht wohl eine eigene Gruppe (Cannabinoid).
   Wartet außerdem auf Hanf-2025 für das Vorher/Nachher-Kartenpaar — eine zweite
   `hanf-2025.geojsonl` daneben genügt (existiert noch nicht — s. DATENBEDARF).

2. **Möglichkeiten von Skills, Agents und MCPs ausloten.** Bevor die vier Skills
   geschrieben werden: was tragen Agents (arbeitsteilige Unteraufgaben) und MCP-Verbinder
   (QFieldCloud, DWD, Geobroker, git) hier wirklich? Kandidaten, die sich anbieten:
   Geodaten-Beschaffung als Verbinder statt als Handgriff, Quellenregister-Prüfung als
   eigener Agent, QFieldCloud-Sync. Erst Sondierung, dann Zuschnitt — sonst schreibt man
   vier Skills für eine Arbeitsteilung, die es so nicht mehr gibt.
2. **Integration der neuen Diercke-Darstellungsformen** aus Klima + Landwirtschaft
   (Plan mit Jan abzustimmen): Kartodiagramm-Säulen in der Karte (Allgäu),
   Schlagkarte 1:25 000 (Rechterfeld/Soßmar), Anbaufolge-Streifendiagramm
   (Knoblauchsland), Vorher/Nachher-Kartenpaar (Flurbereinigung), 2D-Farbmatrix-
   Legende (Niederschlag × Monate), Klimadiagramm-Randspalte, Stadtklima-/
   Geländeklima-Nebenkarten, Bodentypen- und Betriebsgrößen-Choroplethen.
4. ✓ **QGIS-Asset-Erstellung reviewt** (07.08.2026) — QML/Symbole/Layout waren sauber
   (alle Farben aus farben.js). Behoben: fehlende Schlüssel ergänzt (flaecheWarm,
   grauHell/grauDunkel, baer, schutzgebiet), veralteter Wasserwert in der QGIS-.gpl
   (#6f9ea3 → #35707b), und der versprochene .gpl-Export existiert jetzt wirklich:
   `atlas/farben-paletten.rb` erzeugt alle sieben Paletten aus farben.js.
   Doku nachgezogen (QGIS-Kartensatz, Zeichenerklärung Werkstatt-Blatt).
4. **CLC2018 einspielen**, sobald Exporte da sind (DATENBEDARF № 7).
6. **Iteration 2 — Mobile/QField/Nutzung.** Erste zwei Teile stehen (07.08.2026):
   die Konzept-Präse (s. oben) und das Feldpaket. Was jetzt fehlt, ist keine Bauarbeit,
   sondern eine Entscheidung — Zuschnitt A, B oder C — und die zwei Datenlieferungen davor.
   **QField-Projektpaket** `atlas/qgis/themen/brandenburg-hanf/` — Layerstil,
   Erfassungsformular, Layerskript, Anleitung von Packen bis Rücksync. Sein Zweck ist
   die Auflösung des offenen Vorbehalts: das Feld `richtung_ist` nimmt draußen auf,
   was tatsächlich angebaut wird. **Offen:** die Präse dazu (Konzept vor Bau) und die
   Frage, ob ein Prezi-artiges Zoom-Werkzeug im Web etwas trägt, was das Blatt nicht kann.

   **Empfehlung Zuschnitt B, geprüft 15.08.2026** (abgeleitet — aus der Prüftabelle
   Folie 06, nicht aus einem gebauten Prototyp): die zwei Aufgaben, die das Werkzeug
   gewinnt, liefert B ohne zweiten Karteninhalt; C zahlt Wochen für die Aufgabe, bei
   der das Blatt gewinnt. Bedingung an B war die Laufzeit-Pflege des Wegeverzeichnisses.
   Befund: zwei Drittel stehen schon. `Sources::Tree#parse` liest bei jedem Request neu
   (mtime+Größe), und ein fehlendes Ziel wird über `Result`-Failure als `.fehlfall`
   sichtbar — `Plates#unmapped` und `Sheets#open_cases` sind das Vorbild.
   **Die Lücke ist ein Adressraum:** Blätter werden heute über den *Dateinamen*
   adressiert (`blaetter.csv` Spalte `datei`, `Sheet#slug`), und ein Kartenausschnitt
   hat überhaupt keine Adresse — die Abbildung steht fest im Blattskript
   (`d3.geoPath(proj)`), Fragment-Auswertung gibt es nur in `deck-stage.js` für
   Foliennummern. `nr` springt dafür nicht ein: sie ist Zitiernummer des gebundenen
   Bandes und bleibt es (Begründung jetzt in `atlas/BLAETTER.md`, Abschnitt
   „Was `nr` ist und was sie nicht ist").

   **Entschieden 15.08.2026: Halte werden im Blatt deklariert**, nicht als Ausschnitt
   im Wegeverzeichnis. Das Blatt trägt eine Kennung je anfahrbarer Stelle — Hauptkartenfeld,
   jede Nebenkarte, eine benannte Betonung —, das Wegeverzeichnis nennt nur *Blatt +
   Haltekennung + Text + Reihenfolge*. Grund ist der Einwand von Folie 07: ein Ausschnitt
   ist eine Generalisierungsentscheidung. Eine bbox in einer CSV erlaubt jedem, einen
   Ausschnitt zu erfinden, für den das Blatt nie generalisiert wurde — Halte im Blatt
   machen das technisch unmöglich, und wo eine Führung anhalten will und es keinen Halt
   gibt, ist die Antwort „dann eine Nebenkarte zeichnen" (also der Zug aus Zuschnitt A)
   statt eines vorgetäuschten Maßstabs. Vorbild im Haus: `data-screen-label` in den
   Decks — die Folie deklariert sich, `deck-stage.js` fährt nur hin. Fehlt ein Halt,
   greift der vorhandene Weg: Failure → `.fehlfall`.

   **Offen, bei Jan (15.08.2026): Stabilität der Dateinamen.** Solange `datei` die
   Adresse ist, bricht jedes Umbenennen die Verweise. Jan sieht sich das an, wenn er
   an die TODOs geht; davon hängt ab, ob eine Kennungsspalte nötig ist oder ob die
   Dateinamen als gesetzt gelten. Hängt mit der CSV-Kuratierung zusammen (unten).
7. ✓ **Skills destilliert** (07.08.2026) — Sondierung erst
   (`recherche/skills-agents-mcp-sondierung.md`), dann vier Skills unter `skills/`:
   `belegstatus`, `atlas-kartenblatt`, `qgis-kartensatz`, `sternprodukt-ton`.
   Zuschnitt gegen die IDEEN-Skizze geändert: „Geodaten beschaffen" bekam **keinen**
   eigenen Skill (der vorhandene `geodaten-quellen` deckt es), stattdessen ist
   `belegstatus` dazugekommen und nach vorn gerückt — es war der teuerste Fehler
   dieses Verlaufs und trägt am weitesten über die Kartographie hinaus.
   Ungeprüft: ob in dieser Umgebung neue Skills registrierbar sind.
8. ✓ **Scan-Feinschliff** abgeschlossen, s. oben.

Unsortierter Bestand:

- **Skill aus diesem Verlauf destillieren** (Zuschnitt: vier getrennte Skills, so
  entschieden). Was hier gelernt wurde, verteilt sich gerade über `CLAUDE.md`,
  `AGENTS.md` und verstreute Kommentare — und verdünnt sich dabei. Kandidaten,
  nach Tragweite:

  1. **„Atlas-Kartenblatt bauen"** — der eigentliche Kern. Signaturenkatalog und
     Farbsystem als einzige Quellen, Typenscale mit Untergrenze 5,5 pt, Quellenregister
     mit *belegt / abgeleitet / unbelegt*, Generalisierung als Maßstabsauswahl (nicht als
     Filter), Nebenkarte, Zeichenerklärung, Blattkopf, A4-Druckgeometrie. Dazu die Fallen:
     die **d3-Wicklungsrichtung** (weicht von RFC 7946 ab, kostet einen halben Tag, wenn
     man sie nicht kennt), Schriftgrade unter 5,5 pt, WMS-Hintergründe in EPSG:3857 wegen
     `d3.geoMercator`.
  2. **„QGIS-Kartensatz pflegen"** — basis/themen-Trennung, Feldvertrag, Bezugsmaßstab,
     Maßstabsgrenzen nur über regelbasierte Renderer, Beschriftungsrang als Leiter,
     Schriftfallback. Die QML-Runde hier war reine Regelkunde und ließe sich fast wörtlich
     übernehmen.
  3. **„Geodaten beschaffen"** — überschneidet sich mit dem vorhandenen
     `geodaten-quellen`-Skill, hätte aber zwei Ergänzungen: Overpass Turbo als *regulären*
     Weg statt als Notnagel (mit Spiegel-Rotation und `area` statt Rechteck), und das
     Muster „Skript nimmt beide Eingangsformen" — Rohdaten wie Turbo-Export.
  4. **„Persönliches im Sternprodukt-Ton"** — der schmalste, aber vielleicht wertvollste:
     Erinnerung wörtlich übernehmen statt überarbeiten, im Quellenregister als Erinnerung
     kennzeichnen, zu nicht-öffentlichen Personen nicht recherchieren, Sprachregister nach
     orbit.sternprodukt.de. Das ist keine Kartographie, sondern Haltung — und geht deshalb
     sonst verloren.

  Ein fünfter Kandidat ist beim Bauen dazugekommen und gehört in № 1 oder eigenständig:
  **„Korrekturwege ohne Build-Schritt"** — pflegbare Zuordnungstabelle zur Laufzeit lesen
  (Blatt, QGIS-Attributverknüpfung, QField-Wertliste), Prüfskript statt Exportskript,
  fehlender Eintrag bekommt eine sichtbare Klasse statt einer geratenen Farbe. Das war
  hier der Fehler, der am meisten gekostet hat, und die Regel dagegen steht inzwischen
  in `CLAUDE.md`.

- **Erdős-Zahl bis zu Jan zurückverfolgen.** Über das Collaboration-Distance-Werkzeug
  von MathSciNet (AMS) sind Waldmann und Neumaier direkt bestimmbar. Der Haken: die
  Erdős-Zahl zählt gemeinsame *Veröffentlichungen*, und eine betreute Diplomarbeit ist
  keine. Es liefe also auf eine „Betreuungs-Erdős-Zahl" hinaus — die es als Begriff
  nicht gibt, die man aber sauber definieren und dann ausrechnen könnte. Vorarbeit:
  `recherche/achter-stock-freiburg.md`.

- **Bildlook-Review.** Den Skill `bildlook` einmal gegen den fertigen Atlas halten und
  prüfen, ob das Bildregister noch reicht: bisher Zeitungslook (2px Rahmen, 3px
  Passepartout, sepia) und Bleistift-Look (SVG-Duoton auf `--ink-pencil`, drei
  Eichungen). Der Atlas hat inzwischen Fälle, die keiner der beiden sauber trägt —
  Schwarzweiß mit Trauerflor (`Nikolais-Ort.dc.html`), Porträt im Deck, Kartenkachel
  unter Flächenfarbe, Scan als Beleg (`scans/`). Prüfen, welche davon eigene
  Varianten verdienen und welche nur Anwendungsfälle der zwei vorhandenen sind —
  und ob die Eichungen für den Druck stimmen, nicht nur für den Bildschirm.

- **Vita ausbauen — in der Waldmann-Präse.** Stefan interessiert es, was aus Jan geworden
  ist; bisher trägt die Präse das nur beiläufig. Der Bogen: Diplomarbeit → Web-Entwicklung
  und IT-Beratung freiberuflich → Hanf- und Naturschutz-Beratung in der Prignitz →
  Kartographie und dieser Atlas. Nicht als Lebenslauf, sondern als Antwort auf die Frage,
  die zwischen alten Bekannten wirklich gestellt wird. Zwei bis drei Folien, nicht mehr.
  Steinbruch: `templates/lebenslauf/` des Design-Systems für die Fakten-Ordnung,
  `praesentationen/Pitch-Hoehle-der-Loewen.dc.html` für den Prignitz-Teil.
  Vor dem Bauen zu klären: wie viel Privates hinein soll.

- **Meta-Präse: „Was ist Sternprodukt eigentlich?"** — aus dem Material zusammensetzen,
  das inzwischen da ist, kein neues erfinden. Zwei Stränge, die sich treffen: das
  *Zeichen* (Deformationsquantisierung, ⋆ₕ, die drei Register, der Zeichensatz statt
  Icon-Set) und die *Menschen* dahinter — Nikolai Neumaier, Stefan Waldmann, der
  Lehrstuhl Römer, Jan selbst und der Weg von der Diplomarbeit über die
  Freiberuflichkeit bis in die Prignitz. Steinbruch: `Gruss-an-Stefan-Waldmann.dc.html`,
  `praesentationen/Zeichensystem-Post-its.dc.html`, `Nikolais-Ort.dc.html`,
  die Herkunft-Karte des Design-Systems, `uploads/Diplomarbeit.pdf`.
  Offene Frage vor dem Bauen: für wen — Kundschaft, Freunde, oder für dich selbst
  als Ablage? Davon hängt ab, wie viel Physik drinbleibt.
- Foto von Nikolai Neumaier für die Waldmann-Präse gefunden (`uploads/Screenshot From 2026-08-07 18-47-40_3_selected.png`) —
  zeigt ihn am Anfang seiner Krankheits-Genese, „wie früher". Noch nicht in die Präse eingesetzt.
- Inhaltliche Auswertung der Diplomarbeit (PDF) und Einfügen der daraus extrahierten Artefakte in die Waldmann-Präse — verschoben, bis besseres Modell verfügbar
