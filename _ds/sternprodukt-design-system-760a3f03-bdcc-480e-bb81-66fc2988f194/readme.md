# Sternprodukt Design System

CI für die Freiberuflichkeit von **Jan Paki** (sternprodukt.de) — Web-Entwickler & IT-Berater, inzwischen vor allem Hanf- und Naturschutz-Berater in der Prignitz (Brandenburg). Elegant, simpel, leicht nerdig, verspielt.

Das System liefert **Aussehen, Ton und Maße** für alles, was unter diesem Namen erscheint: Web, Präsentationen, Geschäftspapiere, Karten. Was gebaut wird und womit, entscheidet das jeweilige Projekt; die Marke stellt Farbe, Schrift, Raster, Bild-Look, Sprache und das Sternprodukt-Zeichen.

## Das Sternprodukt

Das zentrale Brand-Element ist das **Sternprodukt** — Thema von Jan Pakis Diplomarbeit in theoretischer Physik (Deformationsquantisierung, Stetigkeit von Sternprodukten). Es ist ein **Zeichen in drei Registern**, kontextabhängig eingesetzt, nie neu gezeichnet — nur übersetzt:

1. **Zeichnung** — die Bleistift-Skizze (`assets/logo-stern.png`), ein Stern mit ⋆-Operator: Logo, Briefkopf, Favicon.
2. **LaTeX / typografisch** — `$\mathbin{\star_{\scriptscriptstyle\mathrm{\hbar}}}$`, gesetzt als ⋆ₕ: Fließtext, Formeln, Deck-Titel.
3. **Unicode-Näherung** — ⋆ₕ / ⋆_ℏ / ⋆ (Fallback ∗), wo nur Text geht: E-Mail, Dateinamen, CLI.

Dazu gehört ein diskordianisches Augenzwinkern: ein winziges **„fnord"** auf jedem Dokument, und die **137** (Kehrwert der Feinstrukturkonstante) in vier kanonischen Setzweisen (`tokens/gimmicks.css`): blinkend im Footer (`.sp-137-blink`, gern als Marquee-Fracht), als Symbol α⁻¹ im Fließtext (`.sp-137-alpha`), als Weltuhr-Formel π + π² + 4π³ im Kolophon (`.sp-137-formel`), als Türschild „Zimmer 137" (`.sp-137-zimmer`). Genau ein solches Element pro Seite, nie mehr.

## Ton & Copy

- **Sprache:** Deutsch, Ich-Perspektive, Leser wird nicht direkt adressiert (in Geschäftspost förmliches „Sie").
- **Ton:** trocken, selbstironisch, anekdotisch. Understatement statt Marketing: „Auf github habe ich nichts Großartiges zu zeigen, aber …". Kursiv für ironische Betonung (*spannender*, *pfiffiger*).
- **Nerd-Signale:** Fachbegriffe unübersetzt und selbstverständlich (Monaden, algebraische Effekte, λ-Kalkül, Präzession der Erdachse); Zahlen-Insider (137, fnord); Unicode-Spielereien (Œrbëjt, №, ⋅, Ꙩ als @-Ersatz).
- **Hashtags** als Metadaten-Zeile unter Einträgen: `#lambda-kalkül #functional-ruby #curry` — klein, mit Bindestrichen, in Mono-Medium (500).
- **Keine Emoji** (höchstens ein ASCII-`;)`), keine Ausrufezeichen-Dichte, keine Buzzwords.
- **Links im Fließtext**, externe mit ↗ markiert, „↪ mehr" als Weiterlesen-Link.
- Rechnungen und Briefe: klassisch-höflich („Ich bitte Sie, mir den Betrag …"), № statt „Nr.", Datum ausgeschrieben.

## Farbe

Warm-neutrale 1970er-BRD-Interpretation. Grund `#fdfdfd`, warme Flächen `#f7f4ee`/`#f1e9d8`, Espresso-Tinte `#2a231c`, warme Grau-Trias `#e5ddce/#8b8173/#4a4139`. Der Bleistift-Blauviolett-Ton der Zeichnungen bleibt `#434462`.

**Zwei Hauptfarben**, je als Tint/Base/Deep: **Orange** `#cb5a2a` (Akzent, sparsam) und **Petrol** `#2f6f74` (kühler Gegenpol). **Oliv** `#6f7538` und **Pflaume** `#5a3a52` runden als sparsame Stütztöne den Farbkreis. Rot `#a83a28` nur für Fehler. Keine Verläufe.

## Typografie

**Gentium (Plus)** für Fließtext & Überschriften, unter der Familie `"Gentium Book Plus"`; **Noto Sans Mono** für Code. Warm, buchig, kontrastarm — bodenständig. Gewichte **400 / 600 / 700** je + Kursiv: Site-Title auf 400, Überschriften auf 600. Mono liegt nur in **400 und 500** vor — kein Bold; wo Mono Betonung braucht, trägt sie 500, Versalabstand und Farbe, nie ein synthetisches 700. 17px/1.55 Grundschrift, Überschriften mit −0.02em. Fallback: Noto Serif.

Die Zeichen, die Gentium nicht hat, trägt der Serifen-Fallback **Noto Serif** selbst — in zwei zusätzlich selbstgehosteten Subsets: `math` (U+2216–22FF u. a.: `⋆ ∗ ∘ ⊗ ⊕ ⊙ ⋅ ℏ ∈ ↪ ⋈ ⨝ ⋊ ≀ ∏`) und `cyrillic-ext` (U+A640–A69F: `Ꙩ`). Damit hat jedes Zeichen eine benannte Datei als Herkunft statt des Betriebssystem-Zufalls, die Näherung bleibt **serif**, und es braucht weder eine zweite Symbolfamilie noch einen Sans-Fremdkörper. Der Weg dahin führte über STIX Two Text und Noto Sans Math — beide nach Messung wieder entfernt, weil Noto Serif es allein kann.

Zur **Glyphenabdeckung** gilt eine Rangfolge in vier Stufen, jede **gemessen** (Glyphenbreite gegen die Breite des Ersatzzeichens U+FFFF, s. Karte „Zeichensatz statt Icon-Set"):

① **Gentium trägt es selbst** — `№` `Œ` `↗`, die Interpunktions- und Mathematik-Grundlagen (`†` `‡` `⁂` `※` `≈` `≡` `∞` `∴` `∑` `∏` `∫` `∂` `∧` `∨` `·` `×`) und das ganze **et-Register** (`&`, `⁊`, `ꝫ`, `ꝯ`). Druck- und PDF-fest, kein Fallback nötig.
② **Noto Serif trägt es** aus `math` oder `cyrillic-ext` — `⋆` `∗` `∘` `⊗` `⊕` `⊙` `⋅` `ℏ` `∈` `↪` `⋈` `⨝` `⋊` `≀` und `Ꙩ`. Selbstgehostet und serif, aber nie einziger Träger einer Information.
③ **Nur die Systemkette trägt es** — gemessen derzeit `‿` (U+203F) und `⸗` (U+2E17): im Druck und in Titeln durch Zeichnung oder LaTeX ersetzen.
④ **Gemessenes Tofu** — identische Breite wie U+FFFF, es gibt also gar keine Glyphe. Betrifft u. a. `U+3001` `U+30FB` `U+1361` `U+1802` `U+0FD2` `U+1039F` und die pIqaD-PUA `U+F8D0`.

Regel daraus unverändert: **Zeichen, die garantiert erscheinen müssen — Druck, PDF, Titel — nehmen die Zeichnung oder das LaTeX-Register**, nie die Unicode-Näherung.

Das **LaTeX-Register** ist für Mathematik das bessere System und auf der Karte „Zeichensatz statt Icon-Set" mit MathJax ausgesetzt: Unicode kennt einen Codepoint, LaTeX kennt die **Rolle** (`\mathbin`, `\mathrel`, `\mathop` setzen dieselbe Glyphe mit unterschiedlichem Abstand), und die Quelle ist reines ASCII — versionierbar, diffbar, ohne Encoding-Risiko.

Die **Verbindungszeichen** haben eine eigene Karte („Verbindungszeichen"): neben dem lateinischen et-Register dokumentiert sie, wie andere Schriftkulturen dasselbe Problem lösen (Maqaf `־`, Wāw `و`, Enotikon `‿`, Doppelbindestrich `⸗` u. a.) — als **Zitat, nicht als Ausstattung**; sechs der zwölf sind auf einem Standardsystem gemessenes Tofu. Dazu die Klasse, die ein Zeichensatz-Raster prinzipiell nicht abbilden kann: **unsichtbare und schriftinterne Verbinder** — der **Zero Width Joiner** (U+200D, Breite 0 px, und das ist hier richtig statt Tofu), das indische **Virama** und das armenische **Yentamna**. **Klingonisch scheidet aus**, und zwar aus dem Grund, der hier zählt: pIqaD ist *nicht* Teil von Unicode (Vorschlag im Mai 2001 abgelehnt), sondern liegt in der **Private Use Area** (U+F8D0–U+F8FF, ConScript Registry, ISO 15924 `Piqd`). Ohne privat installierte Schrift steht dort nichts, und die Codepoints bedeuten für jedes andere System etwas anderes — semantisch leer, also kein Zeichen, sondern Grafik. Grafik wird gezeichnet, nicht gesetzt.

Alle Schriften sind **selbstgehostet** als `@font-face` in `assets/fonts/` (`.woff2`, SIL OFL) — **komplett CDN-frei, ohne jede Netz-Abhängigkeit**: Gentium (6 Schnitte), Noto Sans Mono (2) und Noto Serif in fünf Subsets (latin 400/700, latin-ext, math, cyrillic-ext). Die `unicode-range`-Angaben sorgen dafür, dass eine Seite nur lädt, was sie wirklich braucht — das `math`-Subset kostet 27 KB und kommt nur, wenn ein Sonderzeichen vorkommt. QGIS nutzt installierte Systemfonts — dafür „Gentium Plus" / „Noto Sans Mono" lokal installieren (Debian/Ubuntu: `fonts-sil-gentiumplus`, `fonts-noto-mono`).

## Layout & Oberfläche

- **Layout:** eine zentrierte Spalte, `--content-width: 800px`, Abstände aus der 30px-`--spacing-unit` (Hälften/Viertel). Seitenkopf mit 5px dunkler Oberkante + 1px Haarlinie darunter.
- **Breakpoints — genau zwei:** `--on-palm: 600px` und `--on-laptop: 800px`, angewandt als `@media`-Regeln in `tokens/base.css`. Eine einspaltige Seite kann nur zweimal die Meinung ändern; mehr Stufen wären Beschäftigung. Weil `@media` keine Custom Properties lesen kann, stehen die Literale bewusst doppelt (Token + Regel).
- **Seitenrand fluide, Blockabstände fest:** `--page-gutter: clamp(16px, 5vw, 30px)` ist der einzige mitwachsende Abstand — auf 360px bleiben damit 328px Textbreite statt 300, ab 600px Viewport ist er identisch mit `--spacing-unit`. Alles andere bleibt starr, sonst zerfällt der vertikale Rhythmus. Der Seitentitel skaliert über `--h1-size: clamp(27px, 6vw, 38px)`. Vorschau: Karte „Breakpoints & Ränder".
- **Ecken:** durchgehend Radius 0. Linien und Weißraum schaffen die Hierarchie.
- **Schatten:** sparsam — der einzige ist ein weicher Doppelschatten (`--shadow-frame`) unter großen gerahmten Fotos. Flächen und Controls sind schattenlos.
- **Hover:** Links dicker unterstrichen (2.5px, `text-underline-offset: 3px`), Bilder entfärben sich zurück zu Farbe. Press: dezent, ohne Verschiebung.
- **Animation:** klein und schnell — 0.15s/0.3s ease; Übergänge als „slide-fade" (`cubic-bezier(1,.5,.8,1)`); `sp-blink`-Keyframe (3.2s, weich, nur auf 38% Deckkraft — dezent, nie hart aus) für die 137 — vier kanonische Setzweisen als `.sp-137-*` in `tokens/gimmicks.css`. `prefers-reduced-motion` wird respektiert.
- Keine Transparenz/Blur, keine Hintergrundbilder, keine Patterns — Weißraum ist der Hintergrund.

## Bilder

Der **„Zeitungslook"**: jedes Foto bekommt 2px grauen Rahmen, 3px weißes Passepartout und `grayscale(30%) contrast(110%) sepia(30%)`; beim Hover wird der Filter entfernt (Farbe „entwickelt sich"). Große Einzelbilder zusätzlich mit `--shadow-frame`. Bildsprache sonst: Bleistift-Zeichnungen und Retro-/Comic-Illustrationen (`assets/thumbs/`, `assets/heros/`).

Neben dem Zeitungslook gibt es den **Bleistift-Look** für Kartenkacheln:
SVG-Duoton-Filter mit Ende auf `--ink-pencil`, pro Quelle eigens geeicht (Strichkarte, Papierkarte, Luftbild). Fotos werden dann hart entsättigt (`--filter-pencil-photo`) statt warm-sepia.

Das Prinzip hinter beiden: **erst entsättigen, dann färben** — ein Bild trägt Tonwert und Buntheit getrennt, und nur wer die Buntheit zuerst herauszieht, bekommt aus zehn Fotos verschiedener Herkunft eine Serie statt zehn Stimmungen. Ausführlich mit Rezept: `docs/illustration.md`.

## Icons

Es gibt **kein Icon-Set**. Icons sind Unicode-Zeichen im Fließtext: ↗ (extern), ↪ (mehr), №, ⋅, Ꙩ. Dazu das **et-Register der Verbindungszeichen** als Stil-Element — `&` (kursiv zeigt die e‑t-Ligatur), `⁊` (tironische Note), `ꝫ`/`Ꝫ`, `ꝯ` — und die algebraische Reihe `·` `∘` `∧` `∨` `×` `∑`; **genau ein Verbindungszeichen pro Dokument**, nie gemischt (Ein-Gimmick-Regel). Das punktweise Produkt `·` der Algebra C^∞(M) ist dabei das Zeichen, das das Sternprodukt deformiert; `⋆` selbst kommt aus dem `math`-Subset (Stufe ②), `·` dagegen aus Gentium (Stufe ①). Welches Produkt welches Zeichen beansprucht — von der Poisson-Klammer bis zum SQL-`JOIN` — steht auf der Karte „Produkte & Operatoren". Das Sternprodukt-Zeichen folgt dem Drei-Register-System (siehe Brand-Karte „Das Sternprodukt-Zeichen"). Emoji werden nicht verwendet. **Kein Logo erfinden** — die Zeichnung ist gesetzt.


## Bausteine

- **Tokens** — `styles.css` → `tokens/{fonts,colors,typography,spacing,effects,code,gimmicks,base}.css` (80 Custom Properties; Basiswerte + semantische Aliase). Gestaltet wird über Tokens, nicht über eigene Hex-Werte — auch in den Templates und Karten, die deshalb kaum noch Hex-Literale enthalten.
- **Komponenten** — `components/**`, jede als `<Name>.jsx` + `.d.ts` + `.prompt.md`, pro Verzeichnis eine `@dsCard`-Vorschau im Design-System-Tab. Das Set ist absichtlich klein und deckt nur die brand-*definierenden* Primitive ab:
  - **Gallery** + **Figure** (`components/content/gallery/`) — dichtes Foto-Mosaik im Zeitungslook. *Varianten:* Gallery `coarse` (gröberes Raster); Figure `width`/`height` (Rasterspannen), optional `href`.
  - **CodeBlock** / **MonoCode** (`components/content/code/`) — Code-Block auf warmem Papier `#f8f8f6` bzw. Inline-Code auf hellem Grau. Syntax-Highlighting liegt in `tokens/code.css` unter **Pygments-kompatiblen Klassennamen**: die Ausgabe von `pygmentize -f html` passt ohne Umschreiben, gerendert über das `html`-Prop. Belegte Sprachen sind **Ruby** und **Shell**; die sechs Farbregister (Kommentar, Keyword, String, Konstante/Klasse, Funktion, Zahl) kommen ausschließlich aus der Marken-Palette. Die Karte *Mono-Schrift* zeigt dagegen nur die Schrift selbst — Ziffern, Metadaten, Inline-Code.
  - **ExternalLink** (`components/content/links/`) — externer Link mit angehängtem „ ↗", neuer Tab.
- **Muster statt Komponenten** — Seitenkopf/Masthead, Seitentitel, Footer, Listen-Eintrag und Hero-Bild sind bewusst keine Komponenten: ihre Substanz (5px-Oberkante, Titel + 2px-Regel, fnord-Marquee, Thumbnail + #hashtags, Bild-Look) lebt als beschriebenes Muster in den `guidelines/`-Karten und wird pro Projekt frisch gebaut.
- **Specimen-Karten** — `guidelines/`, im Design-System-Tab in fünf durchnummerierten Gruppen; die Dateinamen tragen die Reihenfolge (`01-zeichen.html` … `18-mathematik.html`): **01 Marke** (Sternprodukt-Zeichen, Wortmarke & hquer, Gimmicks, Herkunft), **02 Schrift & Farbe** (Gentium, Noto Sans Mono, Größenskala, Fließtext-Satz, Mono im Einsatz, Zeichensatz, Verbindungszeichen, Produkte & Operatoren, Farbe), **03 Layout & Bild** (Raster, Bild-Look), **04 Bausteine** (die drei Komponenten-Karten), **05 Karte & Druck** (QGIS-Kartenstil, Web-Karte, Mathematik). 18 Karten in `guidelines/`, dazu die drei Komponenten-Karten aus `components/` — zusammen 21 im Tab; jede beantwortet eine Frage und trägt den Erklärtext dazu.
- **Erklärstücke** — `docs/kartographie.md` (Projektion & EPSG:25833, Shapefile vs. GeoPackage, Feldblock/FLIK/Schlag, Topologie, Symbologie & Farbschemata, Casing, Labeling, A4-Layout, Rezept „Feldkarte in sechs Schritten") `docs/font-alternativen.html` (die geprüften Alternativen zu Noto) sowie `docs/illustration.md` (warum entsättigen vor färben, Zeitungs- und Bleistift-Look, Motivsprache, Rezept „vom Scan zum Asset"). Die readme sagt *was gilt*, die Erklärstücke sagen *warum* — für Leute, die Code können und Karten mögen, aber nie Kartographie gelernt haben.
- **Assets** — `assets/`: `logo-stern.png` (Logo), `wordmark-hand.png` (handschriftliche Wortmarke), `favicon.ico`, `kaffeering.png` (freigestellter Kaffeering — einziges Papier-Artefakt, dezent, max. einer pro Dokument, zählt als das eine verspielte Element statt fnord/137), `weltuhr-137.png` (Weltuhr-Formel π + π² + 4π³ als Bild, Kolophon-Gimmick), `reference-website.png` (Screenshot sternprodukt.de, Beleg für die Herkunft-Karte), `sternprodukt.gpl` (GIMP/QGIS-Palette), `fonts/` (alle Webfonts, s. Typografie), `filters/` (SVG-Duoton für den Bleistift-Look), `vendor/` (Fremdcode: `deck-stage.js`, `doc-page.js`, `mathjax-tex-svg.js` für das LaTeX-Register), `qgis/`, `scans/` (Original-Scans, s. Herkunft), `thumbs/` & `heros/`.

## Anwendungen

- **`templates/leere-seite/`** — der nackte Rahmen ohne Beispielinhalt: Oberkante, Kopf, Seitentitel, Spalte, Footer. **Hier anfangen**, wenn eine neue Seite entsteht; die Inhaltsseite zeigt dieselbe Struktur ausgefüllt.
- **`templates/inhaltsseite/`** — Inhaltsseite fürs Web: 5px-Oberkante + Haarlinie, handschriftlicher Kopf, Seitentitel mit 2px-Regel, 800px-Textspalte, Zeitungslook-Bild, Code auf warmem Papier, Hashtag-Zeile, Footer mit 137-Marquee. Der Einstieg für alles Seitenartige.
- **`templates/muster/`** — die vier Muster, die absichtlich keine Komponenten sind, zum Herauskopieren: Seitenkopf mit Navigation, Seitentitel mit 2px-Regel, Listen-Einträge mit Thumbnail und #hashtag-Zeile, Hero-Bild mit Doppelschatten, Footer mit 137-Laufschrift. Jedes Muster einzeln abschaltbar — der Steinbruch, wenn eine Seite nicht bei `leere-seite` anfangen soll.
- **`templates/bericht/`** — mehrseitiger Fachbericht A4 (4 Seiten): Titelseite mit Auftraggeber-Block, Inhalt mit Punktführung, Zusammenfassung, gegliederter Fachteil mit Standorttabelle, Zeitungslook-Abbildung und Fußnote, Empfehlungen, Quellen und Kolophon. Laufender Kopf und Seitenzählung auf jeder Seite; umschaltbar zwischen Bericht, Gutachten und Machbarkeitsstudie, mit optionaler Vertraulichkeits-Kennzeichnung. Für alles, was länger ist als ein Protokoll.
- **`templates/lebenslauf/`** — tabellarischer Lebenslauf A4 (2 Seiten): Kopf mit Name, Rolle und optionalem Portrait im Zeitungslook, Seitenspalte mit Kontakt, Schwerpunkten, Software und Sprachen, Werdegang und Ausbildung über einer Mono-Jahresspalte, zweispaltiger Block für Vorträge und Ehrenamt, Ort-Datum-Zeile mit Unterschriftslinie. Umschaltbar zwischen Lebenslauf, Kurzprofil und Fachlichem Werdegang; Portrait, Privatanschrift und Referenz-Absatz einzeln abschaltbar.
- **`templates/visitenkarte/`** — Visitenkarte 85 × 55 mm, Vorder- und Rückseite: 4px-Oberkante, Zeichnung oder handschriftliche Wortmarke, Kontaktdaten in Mono. Rückseite umschaltbar (Kontakt / Zimmer 137 / leer); die Maßangaben für die Druckerei (3 mm Anschnitt, 300–350 g/m², ungestrichen, kein Stanzwerkzeug) stehen als zuschaltbare Notiz daneben und drucken nicht mit.
- **`templates/deck/`** — Präsentation, 1280×720, sieben Folientypen mit Folienchrome der Marke (5px-Oberkante, Serifen-Titel + 2px-Regel, Hashtag-Fußzeile, Zeitungslook für Bilder, Schlussfolie mit 137-Marquee). Direkt PPTX-exportierbar; Mindestschriftgröße 17px (≈ 24px @1080p).
- **`templates/rechnung/`** — Rechnungsvorlage **nach dem Original** (№ 153). Bewusst eine Reproduktion und *keine* DIN-Vorlage: Ränder und Zonen folgen dem gescannten Vorbild, nicht der Norm. Wer DIN-Maße braucht, nimmt Brief oder Kostenvoranschlag.
- **`templates/kostenvoranschlag/`** — KVA mit ausgewiesener USt: Positionstabelle aus Pauschalen und Stundenposten, Netto/USt/Gesamt, Gültigkeitsdatum; die Verbindlichkeitsformel ist umschaltbar (freibleibend / unverbindlich / bindend bis Datum).
- **`templates/beratungsprotokoll/`** — Feldbegehung, Beratungsgespräch oder Telefonat: Kopfdaten mit Witterung und Gemarkung, Schlagtabelle mit FLIK/Nutzungscode/Fläche, nummerierte Empfehlungen, offene Punkte mit Frist und Verantwortlichkeit, Unterschriftfeld.
- **`templates/brief/`** — Geschäftsbrief nach **DIN 5008**, Zonen absolut gesetzt und nachgemessen: Briefkopf 27 mm (Form A) bzw. 45 mm (Form B), Anschriftfeld 85 × 45 mm, Informationsblock bei 125 mm / 75 mm breit, Betreffzeile bei 97,4 bzw. 115,4 mm, Schreibrand 24,1 mm, Falzmarken bei 87 / 148,5 / 192 mm, Fußsteg 25 mm. Drei Kopf-Layouts; „Form: Automatisch" wählt B für den hohen Kopf A und A für die kompakten Köpfe B/C. Ein Tweak **„Zonen"** blendet die DIN-Hilfslinien ein — damit ist die Konformität nachprüfbar statt behauptet.
- **`templates/webkarte/`** — Leaflet-Karte mit Marken-Chrome: Radius 0 auf Controls und Popups, Papier-Attribution, gedämpfter Kachel-Grundfilter, Casing-Symbologie als Web-Geschwister von `assets/qgis/linien_standard.qml`.
- **`templates/email/`** — Geschäftspost im Textregister: Signatur lang und kurz (`signatur.txt`, `signatur-kurz.txt`), Thunderbird-Einrichtung (`thunderbird.md`) und die zugehörigen Einstellungen (`user.js`). Kein DC — E-Mail ist hier bewusst Plaintext.
- **`templates/xlsx-flaechen/`** — Flächen-Übersicht als Tabellen-Export.
- **`guidelines-print/`** — das System zum Vortragen und Ausdrucken: `Destillat-Deck.html` (11 Folien, das System selbst), `Anwendungen-Deck.html` (9 Folien, „Sternprodukt im Einsatz") und `Destillat.html` (dasselbe als Druckdokument). Sie laufen auf `assets/vendor/deck-stage.js` bzw. `doc-page.js` — Fremdcode liegt bewusst unter `assets/vendor/`, damit er nicht in den Komponenten-Baum und in jedes Consumer-Bundle gerät. Diese Dateien tragen keine `@dsCard`-Zeile und erscheinen deshalb nicht im Design-System-Tab.

Jedes Template lädt das System über eine gleichlautende `ds-base.js` in seinem eigenen Ordner. Die dreizehn Kopien sind **Absicht, kein Versehen**: ein Consumer kopiert genau einen Ordner, ändert genau eine `base`-Zeile und ist fertig — eine geteilte Datei würde diese Eigenschaft zerstören.
- **QGIS** — komplettes Asset-Set in `assets/qgis/`: Symbol-Bibliothek (`sternprodukt_symbole.xml`), Layer-Standardstile (`*.qml`), Druckzusammenstellung (`layout_a4_quer.qpt`), Anleitung (`assets/qgis/README.md`). Palette `assets/sternprodukt.gpl` unter Einstellungen → Optionen → Farben importieren. Karten-Stil: Papier `#fdfdfd` als Hintergrund, Flächen in Grau-Tönen mit `#828282`-Umrissen (0.46 mm, miter), Auswahl `#2a7ae2`, Konflikte/Fehler `#d32f2f` gestrichelt, Beschriftung DejaVu Serif 9pt mit Papier-Puffer, Mono für Maßstäbe/Koordinaten. Arbeitssystem ist **EPSG:25833** (ETRS89 / UTM 33N — Meter, damit Hektar direkt aus der Geometrie rechenbar); Hintergrundkarten werden wie Fotos gedämpft. Warum das so ist: `docs/kartographie.md`.
- **GIMP** — dieselbe `.gpl` in den Paletten-Ordner legen; Zeichnungen im Bleistift-Ton `#434462` auf Weiß.
- **`SKILL.md`** — Agent-Skill-Einstieg (Claude Code kompatibel).
- **Web-Karten (Leaflet)** tragen das Marken-Chrome: Radius 0 auf Controls und Popups, Papier-Attribution, Kachel-Grundfilter. Die Straßen-Symbologie (Casing unter Fahrbahn) ist das Web-Geschwister von `assets/qgis/linien_standard.qml`.

## Herkunft

Die Werte dieses Systems wurden aus Jan Pakis Portfolio-Website „Œrbëjt" (https://github.com/yuszuv/orbit) und seinen Geschäftspapieren (Rechnung № 153, Briefkopf, Bleistift-Zeichnungen) destilliert. Die Original-Scans liegen in `assets/scans/`: das Skizzenblatt (`scan-skizzenblatt.jpeg`) — Quelle von `logo-stern.png` und `wordmark-hand.png` — und die Kaffeeringe (`scan-kaffeeringe.jpeg`), aus denen `assets/kaffeering.png` extrahiert wurde. Die Unterschrift wurde bewusst aus diesem Fundus entfernt — ein zu sensibles Datum. Diese Quellen sind Nachweis, nicht Vorbild: für die Gestaltung genügen `styles.css`, `guidelines/` und `templates/`.

Die eigene Website **sternprodukt.de** ist die Reinform der Haltung und als Referenzkarte dokumentiert (`guidelines/04-herkunft.html`): 26 Zeilen Quelltext, kein Stylesheet, `bgcolor="white"`, drei deprecated Elemente (`center`, `hr`, `center`) — und ein vollständiger MathJax-Stack, dessen einziger Zweck der korrekte Satz des Zeichens ist. Der Titel „418 Page intentionally left blank" verweist auf das **TPILB-Project** (this-page-intentionally-left-blank.org), eine Bewegung, die die Vakat-Seite des Buchdrucks ins Web zurückholen wollte — „a place of quietness and simplicity on the overcrowded World Wide Web". Letzte Lebenszeichen 2004/2005, Domain seit ca. 2018 tot; ein Spiegel liegt unter c-pwr.com/pgp/blankpage.
