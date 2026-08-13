<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Layerstil
  Geometrie : Punkt
  Felder    : status (Text) · bestand (Ganzzahl) — Signaturhöhe ∝ √bestand
  Signaturen: aus atlas/qgis/basis/svg/ — Ordner in QGIS als SVG-Pfad eintragen
  Wiederverwenden: Feldnamen im Renderer anpassen, Farben aus basis/paletten/sternprodukt-atlas.gpl
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0" referencescale="2500000">
<rules key="{c1e70000-0000-0000-0000-000000000000}">
<rule key="{c1e70000-0000-0000-0000-000000000001}" filter="&quot;status&quot; = 'modelliert'" label="Kreisbestand — Höhe ∝ √Bestand" symbol="0"/>
<rule key="{c1e70000-0000-0000-0000-000000000002}" filter="&quot;status&quot; = 'einzelnachweis'" label="nur Einzelnachweise" symbol="1"/>
</rules>
<symbols>
<symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0">
<prop k="name" v="baer-fell.svg"/><prop k="color" v="122,74,43,255"/><prop k="outline_color" v="42,35,28,255"/>
<prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/>
<prop k="size" v="9"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/>
<prop k="offset_unit" v="MM"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties" type="Map"><Option name="size" type="Map"><Option name="active" type="bool" value="true"/><Option name="expression" type="QString" value="3 + sqrt(&quot;bestand&quot;) / 4.8"/><Option name="type" type="int" value="3"/></Option></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0">
<prop k="name" v="circle"/><prop k="color" v="92,56,32,255"/><prop k="outline_color" v="253,253,253,255"/>
<prop k="outline_style" v="solid"/><prop k="outline_width" v="0.3"/><prop k="outline_width_unit" v="MM"/>
<prop k="size" v="1.6"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="simple">
<settings calloutType="simple">
<text-style fontFamily="Noto Sans Mono" fontSize="7.5" fontSizeUnit="Point" fontWeight="50" fontItalic="0" fontUnderline="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" fontLetterSpacing="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" blendMode="0" fieldName="format_number(&quot;bestand&quot;,0)" isExpression="1" useSubstitutions="0" forcedBold="0" forcedItalic="0" capitalization="0" allowHtml="0" legendString="Aa">
<families><family name="Noto Sans Mono"/><family name="Noto Mono"/><family name="DejaVu Sans Mono"/></families>
<text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1" bufferBlendMode="0"/>
<text-mask maskEnabled="0"/>
<background shapeDraw="0"/>
<shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" wrapChar="" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" decimals="3"/>
<placement placement="0" placementFlags="10" polygonPlacementFlags="2" dist="1.4" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidWhole="0" centroidInside="1" preserveRotation="1" priority="4" overlapHandling="PreventOverlap" repeatDistance="0" maxCurvedCharAngleIn="20" maxCurvedCharAngleOut="-20" offsetType="0" rotationAngle="0" fitInPolygonOnly="0" geometryGeneratorEnabled="0" layerType="UnknownGeometry"/>
<rendering scaleVisibility="0" scaleMin="0" scaleMax="0" fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000" drawLabels="1" labelPerPart="0" obstacle="1" obstacleFactor="1" obstacleType="1" zIndex="0" mergeLines="0" minFeatureSize="0" limitNumLabels="0" maxNumLabels="2000" unplacedVisibility="0" upsidedownLabels="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</labeling>
<layerGeometryType>0</layerGeometryType>
</qgis>
