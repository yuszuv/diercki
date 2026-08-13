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
date: 2026-08-13T21:00Z

### Updated in this project
- Vollabgleich gegen den ZIP-Export gelaufen; Abweichungen in README unter
  „Wo der Klon vom Design-Projekt abweicht" festgehalten
- README.md am Projekt-Root neu angelegt (Repo folgt über den üblichen Sync-Weg)
- Kleiner-Gruss-aus-der-Kueche.dc.html: Vorschau-Seite mit Ausschnitten aus Verkehr und Braunbär
- Gruss-an-Stefan-Waldmann.dc.html: persönliche Präsentation, kein Atlas-Bestandteil

## Sync history
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
