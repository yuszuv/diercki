repo: yuszuv/diercki
branch: main

## Rollen
- Projekt (Claude) schreibt: atlas/, Blätter (*.html), Doku, uploads/-Daten
- Mensch schreibt: handarbeit/ (QGIS-Projekte, Feld-GeoPackages)

## Verfahren
Wie zwischen Oberfläche, Klon und GitHub abgeglichen wird, steht in `README.md`
unter „Arbeiten an zwei Orten". Kurzform: im Zweifel führt der Klon; der Weg herunter
ist der ZIP-Export nach `wip/`, verglichen mit `ruby bin/sync-report.rb`; einen
programmatischen Weg hinauf gibt es nicht.

## Last sync
date: 2026-08-14T21:11Z

### Updated in this project
- Inhalt.dc.html aus dem Export übernommen: das Inhaltsverzeichnis bebildert jede
  Blattzeile mit einer Vorschau des Blattes, die Signaturenspalte wächst dafür von
  104 auf 148 px, und Blatt 8 tauscht die Klimastation gegen die Isotherme
- screenshots/thumb-*.png (acht Stück) mitgenommen — ohne sie zeigt das Blatt acht
  kaputte Bilder und sagt nichts dazu; .gitignore und .dockerignore trugen die
  Ausnahme dafür schon
- Übrig aus diesem Durchgang: web/site.css und web/Muster.dc.html sind hier
  entstanden und gehören der Oberfläche — sie müssen von Hand hinauf, den Weg gibt
  es nur so (sync-report meldet sie als einzige CHECK-Fälle)

## Sync history
- 2026-08-13 — Vollabgleich gegen den ZIP-Export; Abweichungen in README unter „Wo der Klon vom Design-Projekt abweicht" festgehalten; README.md am Projekt-Root angelegt; Kleiner-Gruss-aus-der-Kueche.dc.html und Gruss-an-Stefan-Waldmann.dc.html dazu
- 2026-08-13 — handarbeit/reiseplaner/ nach praesentationen/ verschoben (drei Wireframes, DS-Pfade nachgezogen); Inhalt.dc.html als Übersichtsblatt angelegt
- 2026-08-07T05:11:20Z — Erstbefüllung verifiziert (69 Dateien), GBIF-Nachweise, Braunbärenblatt: Nachweise-Modus
- 2026-08-07T04:57:31Z — Repo-Gerüst (.gitignore, arbeit/, github.md) angelegt

## Screen map
| Screen | Repo-Dateien |
|---|---|
| Rumaenien-Verkehr.html | uploads/bahn.geojson.dat, uploads/strassen*.dat, uploads/gewaesser.geojson-86b9210a.dat |
| Rumaenien-Braunbaer.html | uploads/gewaesser.geojson-86b9210a.dat, atlas/qgis/themen/rumaenien-baer/daten/ (inkl. baeren-gbif.geojson) |
| QGIS-Kartensatz.dc.html | atlas/qgis/ |
| Nikolais-Ort.dc.html | atlas/geodaten/friedhof-freiburg.geojson, atlas/geodaten/freiburg-friedhof.rb, atlas/quellen/Nikolais-Ort.md, uploads/neumaier_kurzhaar.jpg |
| Zeichen-Naeherung.dc.html | (misst zur Laufzeit, keine Datendatei) |
