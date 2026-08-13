<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Basisstil (themenneutral)
  Geometrie : Linie
  Felder    : rang (Ganzzahl 1–3: Magistrale | Hauptbahn | Nebenbahn) · name (Text)
  Leitersignatur der Bahn. Für Straßen die Casing-Symbole aus basis/symbole/sternprodukt_atlas.xml
  („atlas autobahn", „atlas schnellstraße") laden — gleicher Aufbau, andere Farben.
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="categorizedSymbol" attr="rang" forceraster="0" enableorderby="0" symbollevels="1" referencescale="2500000">
<categories>
<category render="true" value="1" symbol="0" label="Magistrale"/>
<category render="true" value="2" symbol="1" label="Hauptbahn"/>
<category render="true" value="3" symbol="2" label="Nebenbahn"/>
</categories>
<symbols>
<symbol type="line" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleLine" enabled="1" locked="0" pass="0"><prop k="line_color" v="42,35,28,255"/><prop k="line_style" v="solid"/><prop k="line_width" v="0.58"/><prop k="line_width_unit" v="MM"/><prop k="capstyle" v="butt"/><prop k="joinstyle" v="round"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer><layer class="SimpleLine" enabled="1" locked="0" pass="0"><prop k="line_color" v="253,253,253,255"/><prop k="line_style" v="dash"/><prop k="customdash" v="1.9;1.9"/><prop k="customdash_unit" v="MM"/><prop k="use_custom_dash" v="1"/><prop k="line_width" v="0.34"/><prop k="line_width_unit" v="MM"/><prop k="capstyle" v="butt"/><prop k="joinstyle" v="round"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="line" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleLine" enabled="1" locked="0" pass="0"><prop k="line_color" v="42,35,28,255"/><prop k="line_style" v="solid"/><prop k="line_width" v="0.34"/><prop k="line_width_unit" v="MM"/><prop k="capstyle" v="butt"/><prop k="joinstyle" v="round"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer><layer class="SimpleLine" enabled="1" locked="0" pass="0"><prop k="line_color" v="253,253,253,255"/><prop k="line_style" v="dash"/><prop k="customdash" v="1.3;1.3"/><prop k="customdash_unit" v="MM"/><prop k="use_custom_dash" v="1"/><prop k="line_width" v="0.2"/><prop k="line_width_unit" v="MM"/><prop k="capstyle" v="butt"/><prop k="joinstyle" v="round"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="line" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleLine" enabled="1" locked="0" pass="0"><prop k="line_color" v="107,97,86,255"/><prop k="line_style" v="solid"/><prop k="line_width" v="0.18"/><prop k="line_width_unit" v="MM"/><prop k="capstyle" v="square"/><prop k="joinstyle" v="round"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols></renderer-v2>
<labeling type="simple"><settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="7.5" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot;" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="3" polygonPlacementFlags="2" dist="1" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="7" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings></labeling>
<layerGeometryType>1</layerGeometryType>
</qgis>
