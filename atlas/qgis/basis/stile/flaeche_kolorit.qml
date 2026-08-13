<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Basisstil (themenneutral)
  Geometrie : Fläche
  Felder    : wert (Zahl, darf NULL sein) · status (Text) · name (Text)
  Sechsstufiges Kolorit über `wert`. Klassengrenzen im Renderer anpassen (5/10/15/20/25),
  Feldnamen `wert` und `status` per Suchen-Ersetzen auf das eigene Schema umbiegen.
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="0" referencescale="2500000">
<rules key="{a0000000-0000-0000-0000-00000000aa00}">
<rule key="{a0000000-0000-0000-0000-00000000aa01}" filter="&quot;status&quot; = 'ohne_daten'" label="keine Daten" symbol="0"/>
<rule key="{a0000000-0000-0000-0000-00000000aa02}" filter="&quot;wert&quot; IS NULL AND &quot;status&quot; &lt;&gt; 'ohne_daten'" label="ohne Wert" symbol="1"/>
<rule key="{a0000000-0000-0000-0000-00000000ab00}" filter=""wert" &lt; 5" label="Klasse 1" symbol="2"/>
<rule key="{a0000000-0000-0000-0000-00000000ab01}" filter=""wert" &gt;= 5 AND "wert" &lt; 10" label="Klasse 2" symbol="3"/>
<rule key="{a0000000-0000-0000-0000-00000000ab02}" filter=""wert" &gt;= 10 AND "wert" &lt; 15" label="Klasse 3" symbol="4"/>
<rule key="{a0000000-0000-0000-0000-00000000ab03}" filter=""wert" &gt;= 15 AND "wert" &lt; 20" label="Klasse 4" symbol="5"/>
<rule key="{a0000000-0000-0000-0000-00000000ab04}" filter=""wert" &gt;= 20 AND "wert" &lt; 25" label="Klasse 5" symbol="6"/>
<rule key="{a0000000-0000-0000-0000-00000000ab05}" filter=""wert" &gt;= 25" label="Klasse 6" symbol="7"/>
</rules>
<symbols>
<symbol type="fill" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer>
<layer class="LinePatternFill" enabled="1" locked="0" pass="0"><prop k="angle" v="45"/><prop k="distance" v="1.8"/><prop k="distance_unit" v="MM"/><prop k="line_width" v="0.22"/><prop k="line_width_unit" v="MM"/><prop k="color" v="139,129,115,255"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="240,227,214,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="3" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="220,196,171,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="4" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="196,160,127,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="5" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="169,122,86,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="6" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="138,87,53,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="fill" name="7" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleFill" enabled="1" locked="0" pass="0"><prop k="color" v="106,61,31,255"/><prop k="outline_color" v="139,129,115,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.16"/><prop k="outline_width_unit" v="MM"/><prop k="style" v="solid"/><prop k="joinstyle" v="miter"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="simple"><settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot;" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="4" polygonPlacementFlags="2" dist="1.4" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="5" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings></labeling>
<layerGeometryType>2</layerGeometryType>
</qgis>
