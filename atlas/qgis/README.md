# Sternprodukt-Atlas · QGIS-Kartensatz

Zwei Ebenen, absichtlich getrennt:

    basis/      themenneutral — hier wird nichts über Rumänien oder Bären gesagt
      svg/        parametrisierbare Signaturen (fill / outline / outline-width)
      skripte/    atlas.py — Prüfen, Streuen, Erfassungslayer anlegen
      qfield/     Erfassungsformular und Feldanleitung
      symbole/    Symbolbibliothek für die Stilverwaltung
      stile/      Layerstile als Gerüst: Feldnamen `wert`, `status`, `art`, `rang`
      layout/     Druckzusammenstellung A4 quer
      paletten/   Farbpalette für QGIS und GIMP

    themen/     ein Ordner je Kartenblatt
      rumaenien-baer/
        daten/    GeoJSON, EPSG:4326
        stile/    die Basisstile, auf die echten Feldnamen gezogen
        FELDER.md Feldvertrag: welches Feld welcher Stil erwartet

**Ein neues Thema anlegen:** `themen/<name>/` anlegen, Daten hineinlegen,
die passenden Stile aus `basis/stile/` kopieren und die Feldnamen ersetzen.
`basis/` bleibt unangetastet — sonst zieht die Änderung durch alle Blätter.

**Einrichtung, Rezepte und die CRS-Frage** stehen in der Anleitung
`QGIS-Kartensatz.html` im Projektwurzelverzeichnis (druckbar).

Kurzfassung: QGIS ≥ 3.28 · Arbeits-CRS **EPSG:3844** (Pulkovo 1942(58) / Stereo 70)
· `basis/svg` als SVG-Pfad eintragen · Palette und Symbolbibliothek importieren.

## Was die Stile über den Maßstab wissen

Ein Stil, der bei jedem Maßstab dasselbe zeichnet, ist kein Kartenstil, sondern eine
Anzeige. Drei Einstellungen tragen die Generalisierung; sie stehen in jeder `.qml`
und sind kein Beiwerk.

**Bezugsmaßstab** — alle Stile führen `referencescale="2500000"`, den Blattmaßstab
des Rumänien-Bogens auf A4. Damit hängen die Millimetermaße von Signatur, Strichstärke
und Schrift am Ausgabemaßstab: wer dasselbe Blatt auf 1:1 000 000 druckt, bekommt
proportional mitwachsende Zeichen statt eines zerfallenen Kartenbilds. Vorher stand
überall `-1` — jede Ausgabe sah anders aus als die Vorschau.

**Auswahl nach Maßstab** — `basis/stile/punkt_ort.qml` ist deshalb **regelbasiert**
und nicht kategorisiert: nur Regeln tragen Maßstabsgrenzen je Klasse.

| Rang | Ortsgröße | sichtbar bis | Schriftgrad |
|---|---|---|---|
| 1 | über 1 Mio. | immer | 9 pt |
| 2 | 500 000 – 1 Mio. | 1:6 000 000 | 8 pt |
| 3 | 100 000 – 500 000 | 1:3 000 000 | 7,1 pt |
| 4 | 25 000 – 100 000 | 1:1 500 000 | 6,5 pt |
| 5 | unter 25 000 | 1:600 000 | 5,5 pt |

Die Grade kommen aus `atlas/typenscale.js`; 5,5 pt ist die Untergrenze des Atlas.
Eine Auffangregel „ohne Rang" zeichnet NULL und Fremdwerte als gestrichelten Kreis
in der Konfliktfarbe — sonst verschwinden fehlerhafte Datensätze stumm.

**Beschriftungsrang** — wer verdrängt wen, wenn es eng wird. Die Werte waren vorher
willkürlich verteilt (3, 4, 6, 7, 8 ohne System); jetzt bilden sie eine Leiter:

| Rang | Stil | Inhalt |
|---|---|---|
| 10 – 2 | `punkt_ort` | Ortsnamen, je Ortsgröße gestaffelt |
| 9 | `staedte` (Thema) | Ortsnamen des Bärenblatts |
| 7 | `linie_verkehr` | Straßen- und Bahnnummern |
| 6 | `nationalparks` | Schutzgebietsnamen |
| 4 | `begegnungen`, `kreise_schwerpunkte_baer` | Vermerke |
| 3 | `kreise_dichte` | Kreiswerte |

Ortsnamen der beiden obersten Ränge sind zusätzlich `obstacle`-verstärkt: sie
verdrängen nicht nur, sie halten auch Platz frei.

**Schriftfallback** — jeder beschriftende Stil führt jetzt Gentium Book Plus →
Gentium Plus → Noto Serif. Ohne diese Kette substituiert QGIS still, wenn Gentium
lokal fehlt, und der Ausdruck kommt in einer fremden Schrift zurück, ohne Warnung.

## Herkunft und Aktualisierung

Dieser Ordner ist ein **Export aus dem Design-Projekt „Diercke-Atlas Redesign"**
(Claude-Projekt), dort unter `atlas/qgis/`. Stand: 2026-08-07.

Ausgepackt — etwa nach `~/137/spielwiese/diercke/` — ist er ein **Schnappschuss ohne
Rückkanal**: Änderungen hier kommen nicht von selbst ins Projekt zurück, und ein neuer
Download überschreibt sie. Deshalb:

- **Quelle der Wahrheit ist das Projekt.** Stile, Signaturen und Layouts dort ändern
  lassen und neu herunterladen — nicht im Auspack-Ordner pflegen.
- **Eigene QGIS-Projekte (.qgz) und Erfassungs-GeoPackages** daneben legen, nicht in
  `basis/` oder `themen/` hinein — dann übersteht die Arbeit jedes Update: neuen
  Schnappschuss auspacken, alten Ordner ersetzen, fertig.
- Die **Daten** in `themen/*/daten/` stammen aus benannten Quellen (Eurostat GISCO,
  OSM-Pipeline `atlas/geodaten/`, s. FELDER.md je Thema) und werden im Projekt
  erneuert, nicht von Hand.
- Wer echten Zweiwege-Sync will: den Ordner in ein Git-Repository legen und das
  Repository mit dem Projekt verbinden — dann entfällt das Schnappschuss-Modell.

## Relief (08/2026)

Zwei neue Stile in `basis/stile/`: `relief_isohypsen.qml` (Zähllinie alle 100 m,
Zwischenlinien mit Maßstabsgrenze) und `relief_hypsometrie.qml` (Höhenschichtkolorit
auf dem DGM, diskret). Schummerung braucht keinen Stil — sie ist eine
Darstellungsart des Rasterlayers; die Werte, die zum Atlas passen (Azimut 315°,
Höhe 45°, Z-Faktor 1,2–1,5) stehen in `themen/loreley-relief/README.md`, dort
auch die Konstruktion der Böschungsschraffen über Neigung und Exposition und was
davon sinnvoll nach QField mitkommt.

## QField-Projektpakete

`themen/brandenburg-hanf/` ist zugleich ein Feldpaket: Layerstil,
Erfassungsformular, Layerskript und eine Anleitung von Packen bis Rücksync. Sein
Zweck ist, draußen eine offene Frage zu schließen — das Feld `richtung_ist` nimmt
auf, was tatsächlich angebaut wird, und löst damit den Vorbehalt des
Landwirtschaftsblatts auf.
