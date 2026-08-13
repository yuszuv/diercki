# Rumänien · Braunbär — Quellenregister

Stand der Prüfung: 08/2026.

## Bestandszahlen

| Angabe auf dem Blatt | Status | Quelle / Anmerkung |
|---|---|---|
| über 24 000 DNA-Proben aus 25 Kreisen | belegt | Ministerul Mediului, Apelor și Pădurilor (MMAP), vorläufige Ergebnisse der nationalen Braunbärstudie, April 2025 |
| Bestand 10 419 – 12 770 Tiere | belegt | dieselbe Veröffentlichung |
| Ergebnisse sind **vorläufig**, kein Endbericht | belegt | MMAP spricht ausdrücklich von *preliminary results* |
| frühere Schätzungen 5 000 – 10 000 | belegt | Zusammenstellung aus WWF România, Jagdverbänden und Fachstudien; Methodik uneinheitlich |
| Zählung 2023: 7 536 – 8 093, im Mittel 11 Bären/100 km² | belegt | allgemeine Bärenzählung auf Basis biologischer Proben, Stand April 2023 |
| Ökologen halten rund 5 000 Tiere für verträglich | belegt | mehrfach berichtet, u. a. dpa-Meldung 08/2025 |
| größte Braunbärenpopulation der EU | belegt | außerhalb Russlands hat kein europäisches Land mehr Bären |
| Făgăraș-Ost: 283 Bären, 137 W / 146 M, 17–18 je 100 km² | belegt | genetische Zählung Făgăraș-Ost, Piatra Craiului, Iezer-Păpușa, Leaota; 2023 |
| Modus „Nachweise": 1 256 Fundpunkte, 1970–2026 | belegt | GBIF-API, *Ursus arctos* (taxonKey 2433433), country=RO, nur Funde mit Koordinaten und ohne Geokoordinaten-Fehler; Abzug 2026-08-07 → `daten/baeren-gbif.geojson`. Achtung: Meldedichte, kein Bestand — wo viele Menschen sind, wird mehr gemeldet. Das GPKG im Repo (`baeren_gbif.gpkg`) ist der Arbeitszwilling. |

## Was **nicht** belegt ist — und deshalb auf dem Blatt gekennzeichnet wird

| Angabe | Status | was fehlt |
|---|---|---|
| Kreiswerte (Harghita 1727, Brașov 1329, …) | **unbelegt** | Die Kreistabelle des MMAP-Berichts liegt hier nicht vor. Die Werte in `themen/rumaenien-baer/daten/kreise-baeren.geojson` sind Platzhalter. |
| Kreisdichten (Bären je 100 km² Habitat) | **unbelegt** | dito |
| „höchste Dichte Europas: Brașov 29,9" | **entfernt** | war unbelegt; die Rosette zeigt jetzt die belegte Făgăraș-Zahl |
| Präventionsquote 2024: 426 / getötet 381 | **entfernt** | war unbelegt |
| „Ministerium nennt 4000 als verträgliches Maß" | **entfernt** | belegt ist nur die Aussage von Ökologen zu rund 5 000 |
| „WWF hält die Methodik für nicht ausreichend belegt" | **entfernt** | Kritik an der Methodik ist plausibel, aber in dieser Zuspitzung nicht nachgewiesen |
| Begegnungsorte (Băile Tușnad, Răcădău, Transfăgărășan, Sinaia, Vama Buzăului) | teils belegt | Bärenzulauf in Băile Tușnad und Fütterung am Transfăgărășan sind mehrfach berichtet. Die Punktlagen sind von Hand gesetzt, ±1 km. |
| tödlicher Angriff Jepii Mici / Bucegi, 07/2024 | zu prüfen | Vorfall ist berichtet worden; genaue Ortslage und Datum hier nicht gegenprüft |
| Bärenjahr-Grafik (Winterruhe, Wurf, Paarung, Fettpolster) | abgeleitet | allgemeine Biologie von *Ursus arctos*, keine rumänienspezifische Quelle |
| „Revier 20–300 km² · Männchen bis 300 kg" | abgeleitet | Spannen aus der allgemeinen Artliteratur |

## Imkerei und Wildbienen (qualitative Ebene, seit 08/2026)

Die Ebene trägt **keine Bestandszahlen**. Sie benennt Trachtlandschaften und
Vorkommensschwerpunkte über den Lebensraumtyp — das ist bewusst eine
Aussage über Standorttypen, nicht über Mengen.

| Angabe auf dem Blatt | Status | Anmerkung |
|---|---|---|
| Wanderimkerei folgt der Blüte: Robinie (Mai, Tiefland) → Sonnenblume (Sommer) → Wald- und Blütentracht im Gebirge | belegt | Das Verfahren (*stupărit pastoral*) ist in Rumänien die verbreitete Betriebsform; die Trachtfolge ergibt sich aus den Blühzeiten der genannten Arten. |
| Robinien-Trachtlandschaften: Banater Heide, Oltenische Sande | abgeleitet | Robinienbestände auf Sandböden des westlichen Tieflands und der Olt-Donau-Sande. Die Signaturlagen sind gesetzt, nicht aus einem Datensatz übernommen. |
| Sonnenblumen-Trachtlandschaften: Bărăgan, Dobrudscha | abgeleitet | Beide sind Hauptanbaugebiete der Sonnenblume; Standortwahl der Signatur von Hand. |
| Ostkarpaten: Wald- und Blütentracht | abgeleitet | Sommer- und Spättracht im Gebirge, Standortwahl von Hand. |
| Verlauf des Wanderwegs (Linienzug West → Süd → Ost → Gebirge) | **abgeleitet, schematisch** | Der Linienzug ist eine Darstellung des Prinzips, keine erfasste Route. |
| Wildbienen-Schwerpunkte: Măcin, Süddobrudscha, Siebenbürgisches Becken, Donausande, Eisernes Tor, subkarpatische Halbtrockenrasen | abgeleitet | Ausgewählt nach Lebensraumtyp — Steppen-, Trocken- und Lössrasen sind die artenreichsten Wildbienenlebensräume Südosteuropas. Keine Rasterdaten, keine Artenzahlen. |
| Nutzungskonflikt Honigbiene ↔ Wildbiene um Tracht | belegt (allgemein) | Trachtkonkurrenz bei hoher Stockdichte ist in der Bestäuberökologie gut belegt; für Rumänien liegt hier keine spezifische Studie vor. |
| Bienenstöcke als häufiger Gegenstand von Bärenschäden | belegt (allgemein) | Schadensmeldungen an Bienenständen sind in Bärengebieten Standard; keine rumänische Statistik hier geprüft. |

### Nebenkarte „Mohn-Mauerbiene" (Profilschnitt, ohne Maßstab)

| Angabe | Status | Quelle |
|---|---|---|
| *Hoplitis papaveris*, Familie Megachilidae, Gruppe der Mauerbienen | belegt | de.wikipedia, „Mohn-Mauerbiene" |
| kleidet die Brutzelle mit Stückchen von Klatschmohn-Blütenblättern aus, bis zu 40 Stück je Nest | belegt | Stiftung Mensch und Umwelt / oekolandbau.de, „Wildbiene des Monats" 05/2023 |
| gräbt einen Gang von etwa 7 cm Tiefe, nur eine Brutzelle je Nest | belegt | ebd.; wildbienen.info |
| Blütenblatt-Zipfel stehen während des Nestbaus wie Zinnen aus dem Eingang | belegt | oekolandbau.de, ebd. |
| Flugzeit Mai bis Juli, an die Mohnblüte gebunden | belegt | ebd. |
| trockenwarme Standorte: Flugsandfelder, Magerrasen, Sandgruben, sonnige Waldränder | belegt | ebd. |
| von West- bis Osteuropa verbreitet | belegt | de.wikipedia, ebd. |
| in Deutschland auf der Roten Liste als „Vom Aussterben bedroht" geführt | belegt | de.wikipedia, ebd. — **gilt für Deutschland, nicht für Rumänien**; deshalb steht der Gefährdungsstatus nicht auf dem Blatt |
| Vorkommen in Rumänien konkret | **nicht geprüft** | Die Nebenkarte zeigt die Art als Lebensweise-Beispiel für die Gilde der Trockenstandort-Wildbienen, nicht als rumänischen Nachweis. |


1. **Bienenstock-Register** (ANSVSA/APIA) je Kreis — dann wird aus Signaturen ein Kartogramm.
2. **Wildbienen-Rasterdaten** aus GBIF (Familien Andrenidae, Halictidae, Megachilidae) — dann wird aus dem Lebensraumargument ein Nachweis.
3. **Schadensstatistik** an Bienenständen aus den Kreisumweltbehörden.
4. **GBIF-Abzug zu *Hoplitis papaveris*, country=RO** — dann wird aus der Lebensweise-Nebenkarte ein belegtes Vorkommen.



## Was gebraucht wird

1. **Die Kreistabelle** aus dem MMAP-Bericht (Abundanz je județ). Damit wird aus der
   Modellskizze eine Karte.
2. Die **Zahlen zu Entnahme und Prävention** 2024/2025 aus der amtlichen Quote.
3. Ein belegter **Vorfallsdatensatz** (Ort, Datum, Ausgang), sonst bleibt der Zackenstern raus.
