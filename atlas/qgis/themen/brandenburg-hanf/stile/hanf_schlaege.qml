<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Layerstil
  Geometrie : Fläche (Hanfschläge aus dem NN-Auszug, hanf-2026.geojsonl)
  Felder    : sorte_bez (Text) · groesse (Zahl, ha) · oekoregel (Text)
              sorten_gruppe (Text) — VERKNÜPFT aus sorten.csv, nicht in den Rohdaten
  Voraussetzung: Verknüpfung sorte_bez ↔ sorten.sorte, Präfix leer (siehe README).
              Fehlt die Verknüpfung, greift die ELSE-Regel — der Schlag erscheint
              als „Nutzungsrichtung ungeklärt" statt in einer geratenen Farbe.
  Farben    : aus atlas/farben.js über basis/paletten/sternprodukt-atlas.gpl
  Texturen  : Schraffur für Öko-Regelung liegt in dieser Datei, nicht in der Palette
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="1" referencescale="25000">
<rules key="{c1f70000-0000-0000-0000-000000000000}">
<rule key="{c1f70000-0000-0000-0000-000000000001}" filter="&quot;sorten_gruppe&quot; = 'korn'" label="Körnerhanf" symbol="0"/>
<rule key="{c1f70000-0000-0000-0000-000000000002}" filter="&quot;sorten_gruppe&quot; = 'dual'" label="Doppelnutzung" symbol="1"/>
<rule key="{c1f70000-0000-0000-0000-000000000003}" filter="&quot;sorten_gruppe&quot; = 'faser'" label="Faserhanf" symbol="2"/>
<rule key="{c1f70000-0000-0000-0000-000000000004}" filter="ELSE" label="Nutzungsrichtung ungeklärt" symbol="3"/>
<rule key="{c1f70000-0000-0000-0000-000000000005}" filter="&quot;oekoregel&quot; LIKE '%6%' OR &quot;oekoregel&quot; LIKE '%7%'" label="mit Öko-Regelung 6/7" symbol="4"/>
</rules>
<symbols>
<symbol type="fill" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="1">
<prop k="color" v="84,89,42,205"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.2"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="1">
<prop k="color" v="185,142,63,205"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.2"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="1">
<prop k="color" v="47,111,116,205"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.2"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="3" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="1">
<prop k="color" v="139,129,115,150"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="dash"/>
<prop k="outline_width" v="0.26"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer>
<layer class="PointPatternFill" enabled="1" locked="0" pass="1">
<prop k="distance_x" v="2.2"/><prop k="distance_x_unit" v="MM"/><prop k="distance_y" v="2.2"/><prop k="distance_y_unit" v="MM"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties>
<symbol type="marker" name="@3@1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0">
<prop k="name" v="circle"/><prop k="color" v="42,35,28,255"/><prop k="outline_style" v="no"/>
<prop k="size" v="0.5"/><prop k="size_unit" v="MM"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol></layer></symbol>
<symbol type="fill" name="4" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="LinePatternFill" enabled="1" locked="0" pass="2">
<prop k="angle" v="135"/><prop k="distance" v="1.6"/><prop k="distance_unit" v="MM"/><prop k="line_width" v="0.2"/>
<prop k="line_width_unit" v="MM"/><prop k="color" v="42,35,28,190"/><prop k="outline_width_unit" v="MM"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="simple">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8" fontSizeUnit="Point" fontWeight="50" fontItalic="0" fontUnderline="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" fontLetterSpacing="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.15" blendMode="0" fieldName="&quot;sorte_bez&quot; || '\n' || format_number(&quot;groesse&quot;, 1) || ' ha'" isExpression="1" useSubstitutions="0" forcedBold="0" forcedItalic="0" capitalization="0" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families>
<text-buffer bufferDraw="1" bufferSize="0.9" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.9" bufferJoinStyle="128" bufferNoFill="1" bufferBlendMode="0"/>
<text-mask maskEnabled="0"/>
<background shapeDraw="0"/>
<shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" wrapChar="" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" decimals="1"/>
<placement placement="4" placementFlags="10" polygonPlacementFlags="2" dist="0" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidWhole="0" centroidInside="1" preserveRotation="1" priority="5" overlapHandling="PreventOverlap" repeatDistance="0" maxCurvedCharAngleIn="20" maxCurvedCharAngleOut="-20" offsetType="0" rotationAngle="0" fitInPolygonOnly="0" geometryGeneratorEnabled="0" layerType="UnknownGeometry"/>
<rendering scaleVisibility="1" scaleMin="0" scaleMax="60000" fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000" drawLabels="1" labelPerPart="0" obstacle="1" obstacleFactor="1" obstacleType="1" zIndex="0" mergeLines="0" minFeatureSize="0" limitNumLabels="0" maxNumLabels="2000" unplacedVisibility="0" upsidedownLabels="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</labeling>
<blendMode>0</blendMode>
<layerGeometryType>2</layerGeometryType>
</qgis>
