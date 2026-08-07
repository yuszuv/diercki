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

