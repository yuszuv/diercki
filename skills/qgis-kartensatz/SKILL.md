---
name: qgis-kartensatz
description: >
  Pflegt einen QGIS-Kartensatz und packt QField-Projekte für die Feldbegehung:
  Layerstile (.qml), Symbolbibliothek, Druckzusammenstellung (.qpt), Paletten (.gpl),
  Attributformulare, Offline-Basiskarten, Rücksync. Nutze diesen Skill bei
  Layerstil, Symbologie, Bezugsmaßstab, Maßstabsgrenzen, Beschriftungsrang,
  Feldvertrag, Attributverknüpfung, QFieldSync, Erfassungsschema — auch bei
  beiläufigem "der Stil sieht in QGIS anders aus", "ich fahr morgen raus",
  "QField synct nicht". NICHT für die Gestaltung des gedruckten Kartenblatts
  (dafür atlas-kartenblatt).
---

# QGIS-Kartensatz

## Zwei Ebenen, absichtlich getrennt

    basis/      themenneutral: Stile als Gerüst, Symbolbibliothek, Layout,
                Paletten, Skripte, QField-Grundformular
    themen/     ein Ordner je Blatt: eigene Stile, Daten, Projektdatei

Ein Thema erbt aus `basis/` und überschreibt, was es braucht. Was in `basis/`
steht, darf kein Thema kennen.

## Der Feldvertrag

Jeder Stil nennt im Kopfkommentar, **welche Felder er erwartet** und welchen Typ
sie haben. Ohne diese Zeile ist ein `.qml` nicht wiederverwendbar, weil niemand
weiß, worauf der Renderer zeigt.

    Geometrie : Fläche
    Felder    : status (Text: a|b|c) · dichte (Zahl, darf NULL sein) · name (Text)
    Voraussetzung: Verknüpfung sorte_bez ↔ sorten.sorte, Präfix leer

Verknüpfte Felder heißen `<layername>_<feld>`. Fehlt die Verknüpfung, muss der
Stil das **auffangen** — eine `ELSE`-Regel, die den Fall als eigene, sichtbare
Klasse zeichnet, nicht als leere Fläche.

## Maßstab: drei Dinge, die zusammengehören

1. **Bezugsmaßstab** (`referencescale`) in jedem Stil setzen. Ohne ihn hängen die
   mm-Maße am Ausgabemaßstab und der Stil sieht bei jedem Zoom anders aus.
2. **Maßstabsgrenzen** nur über **regelbasierte** Renderer, nie durch Attributfilter.
   Ortsgrößen bekommen gestaffelte `scalemaxdenom` — das ist Generalisierung als
   Auswahl.
3. **Beschriftungsrang** als Leiter (10/8/7/6/5/4/2), nicht überall `priority="5"`.
   Gleiche Priorität heißt: QGIS entscheidet willkürlich, welches Label wegfällt.

## Schrift

QGIS nutzt installierte Systemfonts, nicht Webfonts. Immer eine
`<families>`-Fallbackkette angeben. Puffer in Papierfarbe statt Weiß, sonst sticht
die Beschriftung aus dem warmen Grund heraus.

## Farben und Paletten

Hex-Werte gehören **nicht** in `.qml`-Dateien als Literale, sondern kommen aus dem
Farbsystem. Die `.gpl`-Paletten werden daraus abgeleitet, nicht von Hand gepflegt.
Eine Palette **je Kartenfamilie**, nicht eine große: eine Themenkarte braucht ihre
Rampe vollständig und sonst wenig.

Texturen (Punktraster, Kreuzschraffur) liegen als Füllsymbole in der
Symbolbibliothek, nicht in der Palette.

## Arbeits-CRS

Metrisch, damit Flächen direkt aus der Geometrie rechenbar sind — und dasselbe
System wie die Behörde, mit der man zu tun hat. In Brandenburg EPSG:25833
(ETRS89/UTM 33N), das System des Agrarantrags.

## QField-Paket

Ein Paket hat **einen Zweck**, und der Zweck ist meistens: eine offene Frage
draußen schließen. Das Erfassungsformular ist um diese Frage herum gebaut.

Reihenfolge beim Packen (QFieldSync):
1. Offline-Raster nur über den **Ausschnitt des Tages** plus Puffer. Landesweite
   DOP-Pakete sprengen den Telefonspeicher.
2. Themenlayer als Kopie, Erfassungslayer als Offline-Bearbeitung.
3. Verknüpfte CSV-Layer **mitpacken** — sonst fehlt draußen die Wertliste.
4. WMS-Layer gehen offline nicht. Vorher als Vektor exportieren.

Formular: Felder in der Reihenfolge des Ablaufs draußen, nicht der Datenbanklogik.
Erst was ohnehin feststeht, dann die eine Frage, für die man hingefahren ist, dann
Bestand, Foto, Notiz. `now()` und `@user_full_name` als Vorbelegung,
`@gnss_horizontal_accuracy` in ein eigenes Feld.

**„unklar" muss eine erlaubte Antwort sein** — und ein zweites Feld fragt, *woher*
die Angabe kommt (Auskunft / am Bestand erkannt / Erntespuren / vermutet). Das
entscheidet später den Belegstatus.

## Nach dem Rücksync

1. Plausibilität: liegt jeder Punkt, wo er liegen soll?
2. Feldaufnahme gegen die abgeleitete Annahme halten. Die Abweichungen sind der
   Ertrag der Begehung.
3. Belegstatus fortschreiben — eine im Feld bestätigte Zeile wechselt von
   *abgeleitet* zu *belegt*, Quelle: die Begehung. Das ist der einzige Weg, auf dem
   eine solche Zeile den Status wechselt.

Bei Sync-Konflikten gilt im Zweifel die Feldaufnahme: sie war näher am Gegenstand.
