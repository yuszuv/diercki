---
name: belegstatus
description: >
  Hält den Belegstatus jeder fachlichen Aussage sichtbar — belegt, abgeleitet oder
  unbelegt — in Karten, Dokumenten, Präsentationen und im Chat. Nutze diesen Skill,
  wenn Zahlen, Kategorien, Standort- oder Rechtsaussagen in ein Deliverable gehen,
  wenn eine Zuordnungstabelle gepflegt werden muss (Sorten, Codelisten,
  Klassengrenzen), oder wenn eine Antwort auf Plausibilität statt auf einer Quelle
  beruht. Auch bei beiläufigem "kannst du das kurz einordnen", "wie viel ist das
  ungefähr", "welche Sorte ist das". NICHT für Gestaltungsfragen ohne Faktenbezug.
---

# Belegstatus

Eine Karte, ein Bericht oder eine Chat-Antwort ist nur so gut wie die Auskunft
darüber, woher sie weiß, was sie behauptet. Dieser Skill hält drei Dinge zusammen:
das Vokabular, die Ablage, und die Regel, was bei fehlendem Wissen passiert.

## Das Vokabular — drei Stufen, keine vierte

| Status | heißt | Beispiel |
|---|---|---|
| **belegt** | benennbare Quelle, nachprüfbar: Datensatz, Amt, Referenzperiode | "InVeKoS/NN-Auswertung MLEUV, Antragjahr 2026, dl-de/by-2-0" |
| **abgeleitet** | aus Belegtem geschlossen, mit angebbarer Begründung | Nutzungsrichtung aus dem Zuchtziel der Sorte |
| **unbelegt** | gesetzt, geschätzt, erinnert oder generalisiert | Höhenangaben eines konstruierten Geländemodells |

„Ungefähr richtig" ist kein Status. Wer eine Größenordnung aus dem Gedächtnis
setzt, setzt **unbelegt** — auch wenn die Zahl stimmt.

## Die Ablage: ein Register je Deliverable

Zu jedem Blatt, Bericht oder Deck gehört eine Datei `quellen/<Name>.md` mit einer
Zeile **je Angabe**, nicht je Datensatz:

    | Angabe auf dem Blatt | Status | Quelle / Anmerkung |

Was in die Anmerkung gehört: bei *belegt* der Datensatz samt Stand und Lizenz; bei
*abgeleitet* die Schlussregel, angreifbar formuliert; bei *unbelegt* der Weg zum
Beleg. Ein Register ohne diesen Weg ist eine Ausrede.

Zwei Statusarten für dieselbe Sache trennen, wenn sie auseinanderfallen können:
eine Station kann eine **belegte Lage** und **unbelegte Messwerte** haben. Dann
zwei Spalten, nicht ein Kompromiss.

## Die Regel: bei fehlendem Wissen eine sichtbare Klasse

Fehlt ein Eintrag, wird **nicht geraten**. Der Fall bekommt eine eigene Klasse mit
eigenem Namen und eigener Signatur:

- Karte: „Nutzungsrichtung ungeklärt" in Grau mit Fragezeichen, eigene Zeile in der
  Zeichenerklärung, Sortennamen ausgeschrieben
- Ort ohne geprüfte Koordinate: gestrichelter Ring, Vermerk „Ort nicht verifiziert"
- Zahlenreihe ohne Quelle: Vermerk am Diagramm, Zählung in der Zeichenerklärung
  („4 von 6 Orten ohne geprüfte Reihe")

Eine plausible Farbe für einen ungeklärten Fall ist der teuerste Fehler dieser
Klasse, weil er sich nicht wiederfindet.

## Korrekturwege ohne Build-Schritt

Eine Zuordnungstabelle, die ein Mensch pflegen soll, wird **zur Laufzeit** gelesen:

| Ort | Mechanismus |
|---|---|
| HTML-Blatt | `fetch` der CSV beim Laden, Parsen im Blatt |
| QGIS | CSV als Nicht-Geometrie-Layer, Layereigenschaften → Verknüpfungen |
| QField | dieselbe CSV als Wertliste im Attributformular |

**Keine abgeleitete Zwischendatei.** Sie veraltet still, sobald das Exportskript
nicht lief, und die Karte zeigt weiter den alten Stand, ohne zu mucken. Skripte
dürfen *prüfen* und *berichten*; erzeugen nur, wo die Rohdaten sonst unbenutzbar
wären (GDAL-Pipelines auf 1-GB-Lieferungen).

Ein Prüfskript beantwortet drei Fragen und schreibt nichts:
1. Welche Werte stehen in den Daten, aber nicht in der Tabelle?
2. Welche Zeilen der Tabelle sind tote Fracht?
3. Wie viel Menge hängt an ungeklärten Zeilen — lohnt die Recherche?

## Im Chat gilt dasselbe

Beruht eine Antwort auf Plausibilität, Namensmuster oder allgemeiner
Kategorienkenntnis statt auf einer benennbaren Quelle, steht das **im selben Satz**
— nicht in einer Fußnote. Lieber „das habe ich abgeleitet, hier ist die Begründung,
hier wäre der Beleg zu holen" als eine glatte Auskunft.

Besonders betroffen: Sortenkunde, Standort- und Bodenaussagen, Erntemengen,
rechtliche Fristen, Zuschreibungen an Fachliteratur („nach Lehmann 1799" — erinnert
oder geprüft?).

## Der Vorbehalt, der oft fehlt

Manche Ableitung ist strukturell schwach, nicht nur unbelegt. Das gehört gesagt:
die Sorte legt die Nutzungsrichtung *nahe*, entscheidet sie aber nicht — was ein
Hanfbestand wird, bestimmen Erntezeitpunkt und Schnitthöhe. Eine Karte, die nach
Sorte färbt, zeigt die **Anlage**, nicht das Ergebnis. Solche Sätze gehören in die
Fußzeile des Deliverables, nicht nur ins Register.
