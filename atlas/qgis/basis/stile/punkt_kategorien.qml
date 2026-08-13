<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Basisstil (themenneutral)
  Geometrie : Punkt
  Felder    : art (Text) · name (Text)
  Vier Kategorien auf `art`. Werte und SVGs im Renderer austauschen;
  weitere Kategorien = weitere <category> plus passendes <symbol>.
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="categorizedSymbol" attr="art" forceraster="0" enableorderby="0" symbollevels="0" referencescale="2500000">
<categories>
<category render="true" value="a" symbol="0" label="Kategorie A"/>
<category render="true" value="b" symbol="1" label="Kategorie B"/>
<category render="true" value="c" symbol="2" label="Kategorie C"/>
<category render="false" value="" symbol="3" label="ohne Angabe"/>
</categories>
<symbols>
<symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0"><prop k="name" v="muellcontainer.svg"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="4.2"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0"><prop k="name" v="verbot-fuettern.svg"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="4.6"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0"><prop k="name" v="beobachtungshuette.svg"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="4.6"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="3" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.4"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="2.4"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols></renderer-v2>
<labeling type="simple"><settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8.5" fontSizeUnit="Point" fontWeight="63" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot;" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="2.2" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="5" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings></labeling>
<layerGeometryType>0</layerGeometryType>
</qgis>
