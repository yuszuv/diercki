# handarbeit/ — was von Hand entsteht

Hier leben QGIS-Projekte (`.qgz`), Erfassungs-GeoPackages und Exporte.
Pfade in den `.qgz` relativ halten, dann funktioniert der Klon überall.

## Warum das Projekt hier nicht schreibt

Nicht aus Höflichkeit, sondern weil es nicht kann, ohne Schaden anzurichten.

Dateien in diesem Ordner leben an **zwei Orten gleichzeitig**: hier und auf deinem
Rechner, in QGIS oder QField. Eine `.qgz` oder ein `.gpkg` ist binär — ein Agent
kann sie nicht zusammenführen, nur überschreiben. Hättest du gerade daran gearbeitet,
wäre die Arbeit weg, ohne dass es jemandem auffiele. Bei einer Textdatei sähe man den
Konflikt; bei einem GeoPackage nicht.

**Geschützt ist also der Dateityp, nicht der Ordner.** Was hier zufällig liegt und
nirgendwo sonst bearbeitet wird — eine Notiz, ein Wireframe — darf das Projekt
anfassen. Was du außerhalb bearbeitest, nicht:

    .qgz  .qgs  .qgd     QGIS-Projekte und -Sicherungen
    .gpkg .gpkg-wal      GeoPackages, auch die Journaldateien
    .shp  .dbf  .shx     Shapefile-Sätze

Umgekehrt gilt: Präsentationen, Kartenblätter und Doku gehören **nicht** hierher.
Sie leben nur im Projekt, es gibt nichts zu schützen, und sie standen hier bisher
nur aus Versehen. Ihr Platz ist `praesentationen/` bzw. das Wurzelverzeichnis.
