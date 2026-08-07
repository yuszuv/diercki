# -*- coding: utf-8 -*-
"""
Sternprodukt-Atlas · drei Helfer für die QGIS-Python-Konsole.

    exec(open('/pfad/zu/atlas/qgis/basis/skripte/atlas.py').read())

    pruefen()                                  # Projekt gegen den Feldvertrag prüfen
    streuung('kreise-baeren', 'bestand', 100)  # eine Signatur je 100 Tiere
    erfassungslayer('/pfad/beobachtungen.gpkg')

Kein Plugin, keine Abhängigkeit außer QGIS selbst. Absichtlich klein.
"""

import random
from qgis.core import (QgsProject, QgsVectorLayer, QgsField, QgsFeature,
                       QgsGeometry, QgsPointXY, QgsVectorFileWriter)
from qgis.PyQt.QtCore import QVariant

# Feldvertrag der Stile — beim eigenen Thema hier ergänzen
VERTRAG = {
    'flaeche_kolorit':          ['wert', 'status', 'name'],
    'punkt_signatur_groesse':   ['wert'],
    'punkt_kategorien':         ['art', 'name'],
    'punkt_ort':                ['rang', 'name', 'name_dt'],
    'linie_verkehr':            ['rang', 'name'],
    'kreise_dichte':            ['status', 'dichte', 'name'],
    'kreise_schwerpunkte_baer': ['status', 'bestand'],
    'begegnungen':              ['art', 'name', 'hinweis'],
    'staedte':                  ['rang', 'name', 'name_dt'],
}

FALSCH = {'EPSG:3380': 'Timbalai 1948 / RSO Borneo — gemeint ist fast immer EPSG:3844'}


def pruefen(soll_crs='EPSG:3844'):
    """Sagt, was der Karte fehlt, bevor sie leer bleibt."""
    p = QgsProject.instance()
    crs = p.crs().authid()
    print('— Projekt —')
    print('  CRS:', crs, '' if crs == soll_crs else '  ← erwartet: ' + soll_crs)
    if crs in FALSCH:
        print('  ACHTUNG:', FALSCH[crs])
    print('— Layer —')
    for lyr in p.mapLayers().values():
        if not isinstance(lyr, QgsVectorLayer):
            continue
        felder = [f.name() for f in lyr.fields()]
        kurz = lyr.name().lower().replace('-', '_')
        print(' ', lyr.name(), '·', lyr.featureCount(), 'Objekte ·', lyr.crs().authid())
        for stil, noetig in VERTRAG.items():
            if stil.split('_')[0] not in kurz:
                continue
            fehlt = [f for f in noetig if f not in felder]
            if fehlt:
                print('    Stil', stil, 'braucht noch:', ', '.join(fehlt))
        probe = list(lyr.getFeatures())[:50]
        leer = [f for f in felder if probe and all(ft[f] in (None, '') for ft in probe)]
        if leer:
            print('    durchgehend leer:', ', '.join(leer))
    print('— fertig —')


def streuung(layername, feld, je=100, hoehe=None, min_abstand=8000, ziel='Streuung'):
    """Eine Signatur je `je` Einheiten, zufällig im Polygon.

    hoehe: Name eines Höhenrasters. Ist es gesetzt, fallen Punkte unter 230 m weg und
    solche um 1050 m werden bevorzugt — die Gewichtung der HTML-Blätter.
    """
    p = QgsProject.instance()
    treffer = p.mapLayersByName(layername)
    if not treffer:
        print('Layer nicht gefunden:', layername)
        return
    quelle = treffer[0]
    dgm = None
    if hoehe and p.mapLayersByName(hoehe):
        dgm = p.mapLayersByName(hoehe)[0]

    ziel_lyr = QgsVectorLayer('Point?crs=' + quelle.crs().authid(), ziel, 'memory')
    dp = ziel_lyr.dataProvider()
    dp.addAttributes([QgsField('quelle', QVariant.String)])
    ziel_lyr.updateFields()
    schluessel = quelle.fields()[0].name()

    def gewicht(pt):
        if dgm is None:
            return 1.0
        v, ok = dgm.dataProvider().sample(pt, 1)
        if not ok or v < 230:
            return 0.0
        return max(0.07, 2.71828 ** (-(((v - 1050) / 640.0) ** 2)))

    rnd = random.Random(9173)
    neu = []
    for f in quelle.getFeatures():
        n = int(round((f[feld] or 0) / float(je)))
        if n <= 0:
            continue
        geom = f.geometry()
        bb = geom.boundingBox()
        gesetzt = []
        for _ in range(n * 400):
            if len(gesetzt) >= n:
                break
            pt = QgsPointXY(rnd.uniform(bb.xMinimum(), bb.xMaximum()),
                            rnd.uniform(bb.yMinimum(), bb.yMaximum()))
            if not geom.contains(QgsGeometry.fromPointXY(pt)):
                continue
            if rnd.random() > gewicht(pt):
                continue
            if any(pt.distance(q) < min_abstand for q in gesetzt):
                continue
            gesetzt.append(pt)
        for pt in gesetzt:
            nf = QgsFeature(ziel_lyr.fields())
            nf.setGeometry(QgsGeometry.fromPointXY(pt))
            nf['quelle'] = str(f[schluessel])
            neu.append(nf)
    dp.addFeatures(neu)
    ziel_lyr.updateExtents()
    p.addMapLayer(ziel_lyr)
    print(len(neu), 'Signaturen gestreut — jetzt baeren_streuung.qml darauf laden.')


def erfassungslayer(pfad, crs='EPSG:3844'):
    """Leerer Punktlayer für die Feldbegehung, Schema passend zu qfield/beobachtung.qml."""
    lyr = QgsVectorLayer('Point?crs=' + crs, 'beobachtungen', 'memory')
    dp = lyr.dataProvider()
    dp.addAttributes([
        QgsField('art', QVariant.String),
        QgsField('datum', QVariant.DateTime),
        QgsField('anzahl', QVariant.Int),
        QgsField('sicherheit', QVariant.String),
        QgsField('foto', QVariant.String),
        QgsField('notiz', QVariant.String),
        QgsField('erfasser', QVariant.String),
    ])
    lyr.updateFields()
    opt = QgsVectorFileWriter.SaveVectorOptions()
    opt.driverName = 'GPKG'
    opt.layerName = 'beobachtungen'
    QgsVectorFileWriter.writeAsVectorFormatV3(
        lyr, pfad, QgsProject.instance().transformContext(), opt)
    print('geschrieben:', pfad, '— jetzt beobachtung.qml als Stil laden.')
