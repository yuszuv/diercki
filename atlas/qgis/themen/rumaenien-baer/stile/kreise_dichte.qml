<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Layerstil
  Geometrie : Fläche
  Felder    : status (Text: modelliert | einzelnachweis | ohne_genotypen | kein_bestand) · dichte (Zahl, darf NULL sein) · name (Text)
  Signaturen: aus atlas/qgis/basis/svg/ — Ordner in QGIS als SVG-Pfad eintragen
  Wiederverwenden: Feldnamen im Renderer anpassen, Farben aus basis/paletten/sternprodukt-atlas.gpl
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0" referencescale="2500000">
<rules key="{b4e70000-0000-0000-0000-000000000000}">
<rule key="{b4e70000-0000-0000-0000-000000000000}" filter="&quot;status&quot; = 'ohne_genotypen'" label="keine gültigen Genotypen" symbol="0"/>
<rule key="{b4e70000-0000-0000-0000-000000000001}" filter="&quot;status&quot; = 'kein_bestand'" label="nicht modelliert" symbol="1"/>
<rule key="{b4e70000-0000-0000-0000-000000000002}" filter="&quot;status&quot; = 'einzelnachweis'" label="nur Einzelnachweise" symbol="2"/>
<rule key="{b4e70000-0000-0000-0000-000000000003}" filter="&quot;dichte&quot; &lt; 5" label="unter 5 Bären/100 km²" symbol="3"/>
<rule key="{b4e70000-0000-0000-0000-000000000004}" filter="&quot;dichte&quot; &gt;= 5 AND &quot;dichte&quot; &lt; 10" label="5 bis unter 10 Bären/100 km²" symbol="4"/>
<rule key="{b4e70000-0000-0000-0000-000000000005}" filter="&quot;dichte&quot; &gt;= 10 AND &quot;dichte&quot; &lt; 15" label="10 bis unter 15 Bären/100 km²" symbol="5"/>
<rule key="{b4e70000-0000-0000-0000-000000000006}" filter="&quot;dichte&quot; &gt;= 15 AND &quot;dichte&quot; &lt; 20" label="15 bis unter 20 Bären/100 km²" symbol="6"/>
<rule key="{b4e70000-0000-0000-0000-000000000007}" filter="&quot;dichte&quot; &gt;= 20 AND &quot;dichte&quot; &lt; 25" label="20 bis unter 25 Bären/100 km²" symbol="7"/>
<rule key="{b4e70000-0000-0000-0000-000000000008}" filter="&quot;dichte&quot; &gt;= 25" label="25 und mehr Bären/100 km²" symbol="8"/>
</rules>
<symbols>
<symbol type="fill" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="253,253,253,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer>
<layer class="LinePatternFill" enabled="1" locked="0" pass="0">
<prop k="angle" v="45"/><prop k="distance" v="1.8"/><prop k="distance_unit" v="MM"/><prop k="line_width" v="0.22"/>
<prop k="line_width_unit" v="MM"/><prop k="color" v="139,129,115,255"/><prop k="outline_width_unit" v="MM"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="253,253,253,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="245,238,231,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="3" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="240,227,214,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="4" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="220,196,171,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="5" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="196,160,127,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="6" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="169,122,86,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="7" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="138,87,53,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="8" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0">
<prop k="color" v="106,61,31,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/>
<prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="simple">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8" fontSizeUnit="Point" fontWeight="50" fontItalic="0" fontUnderline="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" fontLetterSpacing="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" blendMode="0" fieldName="&quot;name&quot;" isExpression="1" useSubstitutions="0" forcedBold="0" forcedItalic="0" capitalization="0" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families>
<text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1" bufferBlendMode="0"/>
<text-mask maskEnabled="0"/>
<background shapeDraw="0"/>
<shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" wrapChar="" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" decimals="3"/>
<placement placement="4" placementFlags="10" polygonPlacementFlags="2" dist="1.2" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidWhole="0" centroidInside="1" preserveRotation="1" priority="3" overlapHandling="PreventOverlap" repeatDistance="0" maxCurvedCharAngleIn="20" maxCurvedCharAngleOut="-20" offsetType="0" rotationAngle="0" fitInPolygonOnly="0" geometryGeneratorEnabled="0" layerType="UnknownGeometry"/>
<rendering scaleVisibility="0" scaleMin="0" scaleMax="0" fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000" drawLabels="1" labelPerPart="0" obstacle="1" obstacleFactor="1" obstacleType="1" zIndex="0" mergeLines="0" minFeatureSize="0" limitNumLabels="0" maxNumLabels="2000" unplacedVisibility="0" upsidedownLabels="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</labeling>
<blendMode>0</blendMode>
<layerGeometryType>2</layerGeometryType>
</qgis>
