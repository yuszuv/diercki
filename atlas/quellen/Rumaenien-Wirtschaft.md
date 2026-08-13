# Rumänien · Wirtschaft — Quellenregister

Stand der Prüfung: 08/2026.

| Angabe auf dem Blatt | Status | Quelle / Anmerkung |
|---|---|---|
| Bodennutzung, acht Flächenklassen | belegt | CORINE Land Cover 2018 (Copernicus, kostenfreie Registrierung), zugeschnitten und je Klasse vereinigt/vereinfacht mit `atlas/geodaten/rumaenien-nutzung.rb` (Zuordnung CLC-Code → Atlasklasse im Skript, `CLASSES`). Generalisierung ≈ 1,5 km — Blattmaßstab, keine Parzellenschärfe |
| Ackerland als Grundton | abgeleitet | nicht als Ebene gezeichnet, sondern Restfläche unter den acht Klassen; der Export `nutzung-acker.geojson` liegt für QGIS bei, deckt aber nur CLC 211 — der Grundton behauptet mehr als der Export |
| Rückfallebene der Bodennutzung | unbelegt | Handzeichnung in `nutzung-daten.js`, nur bei Ladefehler sichtbar; der Quellenvermerk am Blattfuß wechselt dann auf „von Hand nachgezeichnet — unbelegt" |
| Industrie-, Rohstoff-, Energiestandorte | abgeleitet | eigene Zusammenstellung nach Diercke-Vorbild; Ort und Branche plausibel (Galați, Slatina, Ploiești …), Betriebsgrößen-Staffelung gesetzt, nicht statistisch hergeleitet |
| Hanf-Anbauregionen 1980 | abgeleitet | Literaturaussage „RSR größter Erzeuger Europas, ≈ 45 000 ha" regional von Hand verteilt (Banat, Moldau, Sathmar, Oltenien); Flächenumriss unbelegt |
| Hanf heute (Streusignatur, < 2 000 ha) | unbelegt | zwei gesetzte Punkte; belegbar erst mit Betriebs- oder Behördendaten |
| Küsten, Staaten, Grenzen | belegt | Natural Earth 1:50 M (world-atlas 2.0.2) |
| Flüsse | belegt | OSM-Abzug (`verkehr-daten.js`, Blatt 15), nach Rang gefiltert |
| Donaudelta: Arme und Ortslagen | abgeleitet | Arme von Hand generalisiert, Feuchtfläche aus CORINE; Biosphärenreservat-Umriss von Hand, Status „seit 1990" belegt (UNESCO) |
| Ortslagen und Rangstufen | abgeleitet | Koordinaten von Hand, Rangstufen nach Einwohnerklassen ohne Datensatz |

## Was gebraucht wird

1. **Standortliste Industrie/Energie mit Quelle** — hebt die Zeichenebene von
   abgeleitet auf belegt (z. B. Ministerium für Wirtschaft, Transelectrica).
2. **Hanfflächen Rumänien heute** (Eurostat `apro_cpsh1` oder MADR) — ersetzt
   die zwei gesetzten Streupunkte.
