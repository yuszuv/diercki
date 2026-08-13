# Projekt-Anweisungen

- **Belegstatus sichtbar halten — auch in Chat und Fachantworten.** Die Dreiteilung
  *belegt / abgeleitet / unbelegt* des Quellenregisters gilt nicht nur für Kartenblätter,
  sondern für jede fachliche Aussage. Wenn eine Antwort auf Plausibilität, Namensmuster
  oder allgemeiner Kategorienkenntnis beruht statt auf einer benennbaren Quelle, muss das
  dabeistehen — im selben Satz, nicht in einer Fußnote. Lieber „das habe ich abgeleitet,
  hier ist die Begründung, hier wäre der Beleg zu holen“ als eine glatte Auskunft.
  Betrifft besonders: Sortenkunde, Standort- und Bodenaussagen, Zahlen zu Erntemengen,
  rechtliche Fristen. Im Zweifel die Unsicherheit benennen und den Weg zum Beleg nennen.
- **Korrekturwege ohne Build-Schritt.** Eine Zuordnungstabelle, die ein Mensch pflegen
  soll (Sorten, Codelisten, Klassengrenzen), wird zur Laufzeit gelesen — vom Blatt, von
  QGIS per Attributverknüpfung, von QField als Wertliste. Keine abgeleitete Zwischendatei,
  die still veraltet, wenn das Exportskript nicht lief. Skripte dürfen *prüfen* und
  *berichten*; erzeugen nur, wo die Rohdaten sonst unbenutzbar wären (GDAL-Pipelines).
  Fehlt ein Eintrag, wird nicht geraten: der Fall bekommt eine eigene, sichtbare Klasse.

- **Kartographisches Fachvokabular:** In Chat und Deliverables durchgehend die korrekten deutschen Fachbegriffe verwenden, nie umgangssprachliche Behelfe. Also *Signatur* statt „Symbol", *Grundriss* für die flächentreue Stadtdarstellung, *Situation* für den Karteninhalt ohne Relief, *Schummerung*, *Hypsometrie*, *Isohypse* bzw. *Höhenlinie*, *Äquidistanz*, *Generalisierung* (mit *Zusammenfassen*, *Vereinfachen*, *Verdrängen*, *Betonen*), *Kartennetzentwurf* bzw. *Abbildung* statt „Projektion" im deutschen Fließtext, *Maßstabszahl*, *Bezugssystem*, *Kartenfeld*, *Kartenrand*, *Nebenkarte*, *Zeichenerklärung* bzw. *Legende*, *Streusignatur*, *Flächenkolorit*, *Kartogramm* (flächenwertbezogen) gegenüber *Kartodiagramm* (Diagramme in der Karte), *Choroplethenkarte*, *Isolinienkarte*, *Anamorphose*. Bei schematischen Netzdarstellungen: *Liniennetzplan*, *oktilinear*, *topologietreu*, *lagetreu* bzw. *nicht lagetreu*.
- Wo ein Fachbegriff dem Leser nicht geläufig sein könnte, einmal kurz erklären — aber nicht durch ein Behelfswort ersetzen.

- **Zeichensatz oder Signatur — die Grenze:** Die Design-System-Regel „kein Icon-Set, sondern Unicode" gilt für **Fließtext, Interface, Metadaten und Präsentationen**; dort bleibt es bei ↗ ↪ № ⋆ₕ und dem et-Register. Sie gilt **nicht für das Kartenfeld**: dort regiert der Signaturenkatalog (`atlas/signaturen.js`), und Signaturen werden gezeichnet. Eine Signatur ist keine Ikone — sie ist in der Zeichenerklärung definiert, in Millimetern bemaßt, im Maßstab generalisiert und trägt den Karteninhalt selbst.
  - Bedingungen für jede neue Signatur: Maße in mm, Farben aus `atlas/farben.js`, Eintrag in der Zeichenerklärung, Lesbarkeit bei Druckgröße geprüft, keine Dopplung einer vorhandenen Signatur.
  - Grenzfall Signatur **außerhalb** des Kartenfelds (z. B. in einer Folie): dann gilt die Logik des Sternprodukt-Zeichens — es ist eine *Zeichnung*, kein Icon, und wird als solche behandelt.

- **QGIS-Teil mitpflegen:** Bei jeder Änderung am Signaturenkatalog (`atlas/signaturen.js`), an `atlas/farben.js` oder an Kartenblättern immer prüfen, ob die QGIS-Artefakte nachgezogen werden müssen — sonst veralten sie: `QGIS-Kartensatz.dc.html`, `atlas/paletten/*.gpl`, die Export-Skripte unter `atlas/geodaten/` und das Blatt „Werkstatt · QGIS, QField, Paletten" in der `Zeichenerklaerung.dc.html`. Beschreibungen dort müssen den aktuellen Signaturen entsprechen (z. B. Tiegel statt Branchenquadrat, Grundriss-Städtesignatur, Texturen unter Flächenfarben).
- Nebenbei refactorieren, wo der QGIS-Teil Dopplungen oder harte Hex-Werte trägt: Farben kommen aus `atlas/farben.js` bzw. der `.gpl`, nicht als neue Literale.

- **Ton:** Verspieltheit raus aus allen Deliverables — kein fnord, kein Kaffeering, keine Marquees. Erlaubt bleibt genau ein dezentes Zahlen-Gimmick pro Dokument: die 137 (Standard), auf Hanf-Blättern wahlweise die 420.
- **E-Mail-Verbinder:** In Adressen das Sternprodukt im LaTeX-Register statt Ꙩ. Prioritär, wo MathJax läuft (Web, Deck): echtes LaTeX `\mathbin{\star_{\scriptscriptstyle\mathrm{\hbar}}}` — also `jan $\mathbin{\star_{\scriptscriptstyle\mathrm{\hbar}}}$ sternprodukt.de`. Nur wo kein MathJax verfügbar ist (Plaintext-Mail, Dateiname, CLI) die Unicode-Näherung `jan ⋆ₕ sternprodukt.de`, gesetzt als `&#8902;<sub>&#8463;</sub>` in der Serifen-Schrift.
