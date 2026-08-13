<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Layerstil
  Geometrie : Punkt
  Felder    : name (Text)
  Signaturen: aus atlas/qgis/basis/svg/ — Ordner in QGIS als SVG-Pfad eintragen
  Wiederverwenden: Feldnamen im Renderer anpassen, Farben aus basis/paletten/sternprodukt-atlas.gpl
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="singleSymbol" forceraster="0" enableorderby="0" symbollevels="0" referencescale="2500000">
<symbols><symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0">
<prop k="name" v="naturpark.svg"/><prop k="color" v="79,122,74,255"/><prop k="outline_color" v="79,122,74,255"/>
<prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/>
<prop k="size" v="5.2"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/>
<prop k="offset_unit" v="MM"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol></symbols>
</renderer-v2>
<labeling type="simple">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8" fontSizeUnit="Point" fontWeight="50" fontItalic="1" fontUnderline="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" fontLetterSpacing="0" textColor="58,90,54,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" blendMode="0" fieldName="&quot;name&quot;" isExpression="1" useSubstitutions="0" forcedBold="0" forcedItalic="0" capitalization="0" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families>
<text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1" bufferBlendMode="0"/>
<text-mask maskEnabled="0"/>
<background shapeDraw="0"/>
<shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" wrapChar="" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" decimals="3"/>
<placement placement="0" placementFlags="10" polygonPlacementFlags="2" dist="3.2" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidWhole="0" centroidInside="1" preserveRotation="1" priority="6" overlapHandling="PreventOverlap" repeatDistance="0" maxCurvedCharAngleIn="20" maxCurvedCharAngleOut="-20" offsetType="0" rotationAngle="0" fitInPolygonOnly="0" geometryGeneratorEnabled="0" layerType="UnknownGeometry"/>
<rendering scaleVisibility="0" scaleMin="0" scaleMax="0" fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000" drawLabels="1" labelPerPart="0" obstacle="1" obstacleFactor="1" obstacleType="1" zIndex="0" mergeLines="0" minFeatureSize="0" limitNumLabels="0" maxNumLabels="2000" unplacedVisibility="0" upsidedownLabels="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</labeling>
<layerGeometryType>0</layerGeometryType>
</qgis>
