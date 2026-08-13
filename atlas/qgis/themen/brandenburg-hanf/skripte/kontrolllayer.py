# -*- coding: utf-8 -*-
"""
Sternprodukt-Atlas · Erfassungslayer für die Hanfkontrolle.

In der QGIS-Python-Konsole ausführen. Legt `hanf-kontrolle.gpkg` neben dem
geöffneten Projekt an und lädt den Layer ins Projekt.

Das Skript erzeugt eine *leere Hülle*, keine abgeleiteten Daten — deshalb ist es
hier erlaubt: ohne Schema gibt es kein Attributformular, und ein Schema von Hand
zu klicken ist zwölfmal dieselbe Fehlerquelle. Nichts, was es schreibt, kann
veralten; die Inhalte kommen vom Telefon.

    exec(open('/pfad/zu/kontrolllayer.py').read())
"""

import os

from qgis.core import (
    QgsCoordinateReferenceSystem, QgsField, QgsFields, QgsProject,
    QgsVectorFileWriter, QgsVectorLayer, QgsWkbTypes,
)
from qgis.PyQt.QtCore import QMetaType, QVariant

# EPSG:25833 — ETRS89 / UTM 33N. Meter, damit Flächen direkt rechenbar sind;
# dasselbe System wie der Agrarantrag Brandenburg.
CRS = QgsCoordinateReferenceSystem('EPSG:25833')

SCHEMA = [
    ('flik',            QVariant.String, 20),
    ('sorte_bez',       QVariant.String, 40),
    ('richtung_ist',    QVariant.String, 12),
    ('richtung_woher',  QVariant.String, 12),
    ('bestand',         QVariant.String, 16),
    ('hoehe_cm',        QVariant.Int,     0),
    ('bbch',            QVariant.Int,     0),
    ('foto',            QVariant.String, 200),
    ('notiz',           QVariant.String, 500),
    ('datum',           QVariant.DateTime, 0),
    ('gps_genauigkeit', QVariant.String, 16),
    ('erfasser',        QVariant.String, 60),
]


def kontrolllayer(pfad=None, name='hanf_kontrolle'):
    """Erzeugt das GeoPackage und gibt den geladenen Layer zurück."""
    projekt = QgsProject.instance()
    if pfad is None:
        basis = os.path.dirname(projekt.fileName() or os.path.expanduser('~'))
        pfad = os.path.join(basis, 'hanf-kontrolle.gpkg')

    if os.path.exists(pfad):
        layer = QgsVectorLayer(f'{pfad}|layername={name}', name, 'ogr')
        if layer.isValid():
            projekt.addMapLayer(layer)
            print(f'{pfad} war schon da — Layer geladen, {layer.featureCount()} Objekte.')
            return layer

    felder = QgsFields()
    for feldname, typ, laenge in SCHEMA:
        felder.append(QgsField(feldname, typ, len=laenge) if laenge else QgsField(feldname, typ))

    opt = QgsVectorFileWriter.SaveVectorOptions()
    opt.driverName = 'GPKG'
    opt.layerName = name
    opt.fileEncoding = 'UTF-8'
    fehler = QgsVectorFileWriter.create(
        pfad, felder, QgsWkbTypes.Point, CRS,
        projekt.transformContext(), opt,
    )
    if fehler.hasError():
        raise RuntimeError(f'GeoPackage nicht angelegt: {fehler.errorMessage()}')
    del fehler  # Writer schließen, sonst bleibt die Datei gesperrt

    layer = QgsVectorLayer(f'{pfad}|layername={name}', name, 'ogr')
    if not layer.isValid():
        raise RuntimeError(f'Layer nicht ladbar: {pfad}')
    projekt.addMapLayer(layer)
    print(f'→ {pfad}\n  Layer „{name}" angelegt, {len(SCHEMA)} Felder, EPSG:25833.')
    print('  Weiter: Layereigenschaften → Attributformular → Stil laden →')
    print('  themen/brandenburg-hanf/qfield/hanf_kontrolle.qml')
    return layer


if __name__ == '__console__':
    kontrolllayer()
