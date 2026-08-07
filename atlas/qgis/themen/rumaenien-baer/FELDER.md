# Feldvertrag — Thema „Rumänien · Braunbär"

Alle Daten liegen in **EPSG:4326** (GeoJSON-Konvention). Umprojizieren übernimmt QGIS
beim Laden, wenn das Projekt auf EPSG:3844 steht.

## kreise-baeren.geojson — Fläche, 42 Objekte (NUTS-3, Eurostat 2021)

| Feld | Typ | Werte |
|---|---|---|
| name | Text | Kreisname (NAME_LATN) |
| nuts_id | Text | z. B. RO123 |
| gruppe | Text | Name der Modellierungseinheit, NULL wenn keine |
| bestand | Ganzzahl | mittlere Abundanz der Einheit, auf allen Mitgliedern gleich |
| dichte | Zahl | Bären je 100 km² Habitat, NULL wenn nicht modelliert |
| signatur | Ganzzahl | 1 auf dem führenden Kreis einer Gruppe, sonst 0 |
| status | Text | modelliert · einzelnachweis · ohne_genotypen · kein_bestand |

Wichtig: `bestand` wiederholt sich innerhalb einer Gruppe. Wer summiert, filtert
vorher auf `signatur = 1`, sonst zählt er Bistrița-Năsăud + Maramureș doppelt.

## kreise-schwerpunkte.geojson — Punkt, 20 Objekte
gruppe (Text) · bestand (Ganzzahl) · dichte (Zahl) · signaturen (Ganzzahl, bestand/100)
· status (Text) · kreise (Ganzzahl, Zahl der Kreise in der Einheit)

## begegnungen.geojson — Punkt, 6 Objekte
art (siedlung | fuetterung | huette | vorfall) · name · hinweis

## nationalparks.geojson — Punkt, 11 Objekte
name · beschriftet (0/1 — Empfehlung des Blatts, nicht Teil der Quelle)

## staedte.geojson — Punkt, 15 Objekte
name · name_dt (deutscher Name, leer wenn keiner) · rang (1–4)

## Herkunft

Kreisgeometrien: Eurostat GISCO, NUTS 2021, 1:3 Mio., Maßstabsstufe 03M.
Bestandszahlen: genetische Landeszählung 2022–2025 (MMAP), Endbericht 12/2025.
Punktdaten: für Blatt 16 von Hand gesetzt — Ortslagen auf ±1 km genau, keine
amtliche Quelle. Siehe Abschnitt „Was aus Daten kommt und was nicht" der Anleitung.
