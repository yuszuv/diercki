<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Basisstil (themenneutral)
  Geometrie : Punkt
  Felder    : wert (Zahl) — Signaturhöhe ∝ √wert · name (Text)
  SVG-Signatur mit datengesteuerter Größe. Das SVG in `<prop k="name">` austauschen
  (alles aus basis/svg/ steht zur Verfügung), Skalierung in der Ausdrucksformel anpassen.
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="singleSymbol" forceraster="0" enableorderby="0" symbollevels="0">
<symbols><symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0"><prop k="name" v="baer.svg"/><prop k="color" v="122,74,43,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="9"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties" type="Map"><Option name="size" type="Map"><Option name="active" type="bool" value="true"/><Option name="expression" type="QString" value="3 + sqrt(&quot;wert&quot;) / 4.8"/><Option name="type" type="int" value="3"/></Option></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol></symbols></renderer-v2>
<labeling type="simple"><settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="7.5" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="format_number(&quot;wert&quot;,0)" isExpression="1" allowHtml="0" legendString="Aa">
<families/><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.4" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="5" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings></labeling>
<layerGeometryType>0</layerGeometryType>
</qgis>
