<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Basisstil (themenneutral)
  Geometrie : Punkt
  Felder    : rang (Ganzzahl 1–5) · name (Text) · name_dt (Text, darf leer sein)

  Die fünf Ortsgrößen des Atlas (Stand Signaturenkatalog 08/2026):
  1 über 1 Mio. (Grundriss, kreuzschraffiert — braucht basis/svg/stadt-grundriss.svg im SVG-Pfad)
  2 500 000–1 Mio. · 3 100 000–500 000 · 4 25 000–100 000 (Kreise) · 5 unter 25 000 (Punkt)

  REGELBASIERT, nicht kategorisiert — weil nur Regeln Maßstabsgrenzen je Klasse
  tragen. Ohne sie zeichnen bei kleinem Maßstab alle fünf Größen gleichzeitig und
  das Kartenfeld läuft voll. Die Auswahl ist Generalisierung, kein Filter:

    Rang 1   immer
    Rang 2   bis 1:6 000 000
    Rang 3   bis 1:3 000 000
    Rang 4   bis 1:1 500 000
    Rang 5   bis 1:600 000

  Beschriftungsrang statt Gleichrang: 10 · 8 · 6 · 4 · 2. București verdrängt das
  Dorf, nicht umgekehrt. Schriftgrade aus atlas/typenscale.js (9 · 8 · 7,1 · 6,5 · 5,5 pt),
  Untergrenze 5,5 pt — darunter läuft Toner in die Punzen.

  referencescale=2500000: die Millimetermaße hängen am Blattmaßstab. Beim Druck in
  anderem Maßstab skalieren Signatur und Schrift mit, statt zu zerfallen.

  Auffangregel „ohne Rang" fängt NULL und Fremdwerte ab — sonst verschwinden
  Objekte stumm.
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="1" referencescale="2500000">
<rules key="{a71c0000-0000-0000-0000-00000000ffff}">
<rule key="{a71c0000-0000-0000-0000-000000000001}" filter="&quot;rang&quot; = 1" label="über 1 Mio. Einwohner" symbol="0"/>
<rule key="{a71c0000-0000-0000-0000-000000000002}" filter="&quot;rang&quot; = 2" label="500 000 – 1 Mio." symbol="1" scalemaxdenom="6000000"/>
<rule key="{a71c0000-0000-0000-0000-000000000003}" filter="&quot;rang&quot; = 3" label="100 000 – 500 000" symbol="2" scalemaxdenom="3000000"/>
<rule key="{a71c0000-0000-0000-0000-000000000004}" filter="&quot;rang&quot; = 4" label="25 000 – 100 000" symbol="3" scalemaxdenom="1500000"/>
<rule key="{a71c0000-0000-0000-0000-000000000005}" filter="&quot;rang&quot; = 5" label="unter 25 000" symbol="4" scalemaxdenom="600000"/>
<rule key="{a71c0000-0000-0000-0000-000000000009}" filter="&quot;rang&quot; IS NULL OR &quot;rang&quot; NOT IN (1,2,3,4,5)" label="ohne Rang (prüfen)" symbol="5" scalemaxdenom="1500000"/>
</rules>
<symbols>
<symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SvgMarker" enabled="1" locked="0" pass="0"><prop k="name" v="stadt-grundriss.svg"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_width" v="0.45"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="3.4"/><prop k="size_unit" v="MM"/><prop k="angle" v="0"/><prop k="offset" v="0,0"/><prop k="horizontal_anchor_point" v="1"/><prop k="vertical_anchor_point" v="1"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.5"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="2.3"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="2" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.45"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="1.9"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="3" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="253,253,253,255"/><prop k="outline_color" v="42,35,28,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.4"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="1.5"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="4" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="42,35,28,255"/><prop k="outline_color" v="253,253,253,255"/><prop k="outline_style" v="solid"/><prop k="outline_width" v="0.25"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="1.2"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="marker" name="5" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleMarker" enabled="1" locked="0" pass="0"><prop k="name" v="circle"/><prop k="color" v="0,0,0,0"/><prop k="outline_color" v="168,58,40,255"/><prop k="outline_style" v="dash"/><prop k="outline_width" v="0.35"/><prop k="outline_width_unit" v="MM"/><prop k="size" v="1.8"/><prop k="size_unit" v="MM"/><prop k="offset" v="0,0"/><data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"></Option><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="rule-based">
<rules key="{b71c0000-0000-0000-0000-00000000ffff}">
<rule key="{b71c0000-0000-0000-0000-000000000001}" filter="&quot;rang&quot; = 1" description="über 1 Mio. Einwohner">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="9" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot; || if(&quot;name_dt&quot; = '', '', '\n' || &quot;name_dt&quot;)" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.8" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="10" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" obstacleFactor="2" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
<rule key="{b71c0000-0000-0000-0000-000000000002}" filter="&quot;rang&quot; = 2" description="500 000 – 1 Mio." scalemaxdenom="6000000">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="8" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot; || if(&quot;name_dt&quot; = '', '', '\n' || &quot;name_dt&quot;)" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.6" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="8" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" obstacleFactor="2" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
<rule key="{b71c0000-0000-0000-0000-000000000003}" filter="&quot;rang&quot; = 3" description="100 000 – 500 000" scalemaxdenom="3000000">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="7.1" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot; || if(&quot;name_dt&quot; = '', '', '\n' || &quot;name_dt&quot;)" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.5" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="6" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" obstacleFactor="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
<rule key="{b71c0000-0000-0000-0000-000000000004}" filter="&quot;rang&quot; = 4" description="25 000 – 100 000" scalemaxdenom="1500000">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="6.5" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot; || if(&quot;name_dt&quot; = '', '', '\n' || &quot;name_dt&quot;)" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.3" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="4" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" obstacleFactor="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
<rule key="{b71c0000-0000-0000-0000-000000000005}" filter="&quot;rang&quot; = 5" description="unter 25 000" scalemaxdenom="600000">
<settings calloutType="simple">
<text-style fontFamily="Gentium Book Plus" fontSize="5.5" fontSizeUnit="Point" fontWeight="50" fontItalic="0" textColor="42,35,28,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" fieldName="&quot;name&quot; || if(&quot;name_dt&quot; = '', '', '\n' || &quot;name_dt&quot;)" isExpression="1" allowHtml="0" legendString="Aa">
<families><family name="Gentium Book Plus"/><family name="Gentium Plus"/><family name="Noto Serif"/></families><text-buffer bufferDraw="1" bufferSize="0.8" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.85" bufferJoinStyle="128" bufferNoFill="1"/><text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties></text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" autoWrapLength="0" decimals="3"/>
<placement placement="0" polygonPlacementFlags="2" dist="1.1" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" quadOffset="4" centroidInside="1" priority="2" overlapHandling="PreventOverlap" fitInPolygonOnly="0"/>
<rendering scaleVisibility="0" drawLabels="1" obstacle="1" obstacleFactor="1" labelPerPart="0" upsidedownLabels="0" unplacedVisibility="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
</rules>
</labeling>
<layerGeometryType>0</layerGeometryType>
</qgis>
