---
name: atlas-kartenblatt
description: >
  Baut ein Kartenblatt im Atlas-Stil: Kartenfeld mit Rahmen und Gradabtragung,
  Zeichenerklärung, Nebenkarte, Maßstabsbalken, Quellenzeile, A4-Druckgeometrie.
  Nutze diesen Skill für thematische Karten, Übersichtskarten, Schlagkarten,
  Kartodiagramme, Choroplethen, Reliefdarstellungen und Liniennetzplände — auch bei
  beiläufigem "mach mal eine Karte davon", "wie sieht das räumlich aus", "kann man
  das kartieren". NICHT für Slippy Maps im Web (dafür Leaflet) und nicht für die
  Beschaffung der Geodaten.
---

# Atlas-Kartenblatt

Ein Blatt ist eine Druckseite, nicht ein Bildschirm. Es hat einen Rand, einen
Maßstab, eine Zeichenerklärung und eine Quellenzeile — und es trägt genau eine
Aussage.

## Fachvokabular durchgehend

*Signatur* statt „Symbol", *Grundriss* für die flächentreue Stadtdarstellung,
*Situation* für den Karteninhalt ohne Relief, *Schummerung*, *Hypsometrie*,
*Isohypse*, *Äquidistanz*, *Generalisierung* (mit *Zusammenfassen*, *Vereinfachen*,
*Verdrängen*, *Betonen*), *Kartennetzentwurf* bzw. *Abbildung* statt „Projektion" im
deutschen Fließtext, *Maßstabszahl*, *Kartenfeld*, *Kartenrand*, *Nebenkarte*,
*Zeichenerklärung*, *Streusignatur*, *Flächenkolorit*, *Kartogramm*
(flächenwertbezogen) gegenüber *Kartodiagramm* (Diagramme in der Karte),
*Choroplethenkarte*, *Isolinienkarte*, *Anamorphose*. Bei schematischen Netzen:
*Liniennetzplan*, *oktilinear*, *topologietreu*, *lagetreu*.

**Schraffe ≠ Schraffur.** Böschungsschraffen (nach Lehmann) tragen das Relief:
Strichstärke nach Hangneigung, „je steiler, je schwärzer". Eine Schraffur ist ein
gleichmäßiges Flächenmuster und überlagert eine Fläche als Kolorit. Wer das
verwechselt, verwechselt Signatur und Kolorit.

## Aufbau, von außen nach innen

    Blattkopf     Titel, Untertitel mit der Aussage, Atlas-Kennung
    Kartenfeld    Rahmen mit Gradabtragung, Gradnetz, Situation, Thema
                  Nebenkarte(n), Maßstabsbalken, Maßstabszahl
    Randspalte    Zeichenerklärung, Diagramme, erklärender Absatz
    Fußzeile      Quellen, Abbildung mit Standparallelen, Stand

Der Untertitel sagt, **was das Blatt behauptet** — nicht, was darauf zu sehen ist.

## Größe von Signaturen: flächentreu

Trägt die Größe einer Signatur eine Menge, ist die **Fläche** proportional zum
Wert, also **Radius ∝ √Wert**. Das Auge liest die Fläche, nicht den Radius; linear
skalierter Radius lässt die Fläche quadratisch wachsen.

- Keine logarithmische Skala, außer die Spanne ist anders nicht darstellbar — sie
  macht Werte unvergleichbar.
- Die Flannery-Korrektur (Exponent 0,57) ist an **Kreisen** gemessen. Auf ein
  Signaturbild angewandt ist sie eine Vermutung. *Belegstatus der Zuschreibung
  prüfen, nicht behaupten.*
- Bei großer Spanne kollidiert Flächentreue mit Lesbarkeit. Dann **Mindestgröße**
  setzen und sie in der Zeichenerklärung nennen, samt Zahl der betroffenen Objekte.
- Eine **Größenleiter** in der Zeichenerklärung muss maßstabsgleich zum Kartenfeld
  sein. Wird sie skaliert, ist ihre ganze Funktion weg.

## Nebenkarte

Sie beantwortet eine Frage, die die Hauptkarte im Maßstab nicht beantworten kann.
Immer mit: eigenem Maßstabsbalken, eigener Maßstabszahl, Blattschnitt-Fenster auf
der Hauptkarte, und einem Hintergrund, der nicht suggeriert, mehr zu wissen als er
weiß. Ein von Hand generalisierter Hintergrund in 1:145 000 ist eine Behauptung —
so kennzeichnen.

Schematische Nebenkarten (Profile, Blockbilder) tragen den Vermerk **„schematisch,
nicht lagetreu"**.

## Generalisierung ist Auswahl, nicht Filter

Bei kleiner Maßstabszahl fallen Objekte nicht weg, weil sie unwichtig sind, sondern
weil sie nicht mehr lesbar wären. Also: Klassen zusammenfassen, Umrisse
vereinfachen, kollidierende Signaturen verdrängen, das Aussagetragende betonen.
Nicht: nach Attributwert wegfiltern.

## Vier technische Fallen (d3-basierte Blätter)

1. **Wicklungsrichtung.** d3-geo erwartet Außenringe im Uhrzeigersinn; RFC 7946 und
   OSM wickeln entgegengesetzt. Ein falsch gewickelter Ring bedeutet „alles außer
   dieser Fläche" — die Karte wird weltgroß. QGIS und ogr ist die Richtung gleich,
   der Fehler zeigt sich erst im Blatt.
2. **`precision(0)` bei großer Maßstabszahl.** Die adaptive Neuabtastung von
   `d3.geoPath` zerlegt jede Kante, bis der projizierte Fehler unter `precision`
   liegt. Bei einem Fenster von 0,2° in einem Kegelentwurf läuft sie in die
   Singularität: Millionen Stützpunkte, Koordinaten um 1e10, das Blatt ist nicht
   mehr rasterisierbar. Dazu **`clipExtent`** auf das Kartenfeld setzen — ein
   `clip-path` versteckt nur optisch und beseitigt die Layout-Boxen nicht.
3. **Schriftuntergrenze.** 5,5 pt im Druck, darunter ist es Grafik. Auf einem
   1920×1080-Bildschirm nie unter 24 px.
4. **WMS-Hintergründe** liegen in EPSG:3857 — passen nur zu `d3.geoMercator`,
   nicht zu einem Kegelentwurf.

## Ein Blatt, eine Datei

Farben ausschließlich aus dem Farbsystem (`farben.js` o. ä.), Signaturen aus dem
Signaturenkatalog, Schriftgrade aus der Typenscale. Keine neuen Hex-Werte, keine
Ad-hoc-Symbole im einzelnen Blatt — sonst driften die Blätter auseinander und die
QGIS-Artefakte veralten.

Zum Belegstatus jeder Angabe: Skill `belegstatus`.
