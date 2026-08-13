<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Layerstil
  Geometrie : Linie (Isohypsen, z. B. aus Raster → Konturen oder amtlicher Lieferung)
  Felder    : hoehe (Zahl, m ü. NHN) — Feldname im Renderer anpassen, wenn er anders heißt
  Regel     : Zähllinie alle 100 m stärker und beschriftet, Zwischenlinien fein.
              Bei kleiner Maßstabszahl fallen die Zwischenlinien weg — das ist
              Generalisierung als Maßstabsauswahl, nicht als Attributfilter.
  Farben    : Ocker aus atlas/farben.js über basis/paletten/sternprodukt-atlas.gpl
-->
<qgis version="3.28" styleCategories="Symbology|Labeling">
<renderer-v2 type="RuleRenderer" forceraster="0" enableorderby="0" symbollevels="1" referencescale="25000">
<rules key="{d1e00000-0000-0000-0000-000000000000}">
<rule key="{d1e00000-0000-0000-0000-000000000001}" filter="&quot;hoehe&quot; % 100 = 0" label="Zähllinie (100 m)" symbol="0"/>
<rule key="{d1e00000-0000-0000-0000-000000000002}" filter="&quot;hoehe&quot; % 100 != 0" label="Isohypse (20 m)" symbol="1" scalemaxdenom="50000"/>
</rules>
<symbols>
<symbol type="line" name="0" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleLine" enabled="1" locked="0" pass="2">
<prop k="line_color" v="148,112,47,255"/><prop k="line_width" v="0.3"/><prop k="line_width_unit" v="MM"/>
<prop k="line_style" v="solid"/><prop k="capstyle" v="round"/><prop k="joinstyle" v="round"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
<symbol type="line" name="1" alpha="1" clip_to_extent="1" force_rhr="0"><layer class="SimpleLine" enabled="1" locked="0" pass="1">
<prop k="line_color" v="185,142,63,215"/><prop k="line_width" v="0.14"/><prop k="line_width_unit" v="MM"/>
<prop k="line_style" v="solid"/><prop k="capstyle" v="round"/><prop k="joinstyle" v="round"/>
<data_defined_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></data_defined_properties></layer></symbol>
</symbols>
</renderer-v2>
<labeling type="rule-based">
<rules key="{d1e00000-0000-0000-0000-00000000000a}">
<rule key="{d1e00000-0000-0000-0000-00000000000b}" description="nur Zähllinien beschriften" filter="&quot;hoehe&quot; % 100 = 0" scalemaxdenom="80000">
<settings calloutType="simple">
<text-style fontFamily="Noto Sans Mono" fontSize="6" fontSizeUnit="Point" fontWeight="50" fontItalic="0" fontUnderline="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" fontLetterSpacing="0" textColor="148,112,47,255" textOpacity="1" namedStyle="Regular" multilineHeight="1.1" blendMode="0" fieldName="format_number(&quot;hoehe&quot;, 0)" isExpression="1" useSubstitutions="0" forcedBold="0" forcedItalic="0" capitalization="0" allowHtml="0" legendString="Aa">
<families><family name="Noto Sans Mono"/><family name="DejaVu Sans Mono"/></families>
<text-buffer bufferDraw="1" bufferSize="0.7" bufferSizeUnits="MM" bufferColor="253,253,253,255" bufferOpacity="0.9" bufferJoinStyle="128" bufferNoFill="1" bufferBlendMode="0"/>
<text-mask maskEnabled="0"/><background shapeDraw="0"/><shadow shadowDraw="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</text-style>
<text-format formatNumbers="0" plussign="0" addDirectionSymbol="0" multilineAlign="3" wrapChar="" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" decimals="0"/>
<placement placement="2" placementFlags="1" dist="0" distUnits="MM" xOffset="0" yOffset="0" offsetUnits="MM" preserveRotation="1" priority="4" overlapHandling="PreventOverlap" repeatDistance="60" repeatDistanceUnits="MM" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" rotationAngle="0" geometryGeneratorEnabled="0" layerType="LineGeometry"/>
<rendering scaleVisibility="0" scaleMin="0" scaleMax="0" fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000" drawLabels="1" labelPerPart="0" obstacle="1" obstacleFactor="1" obstacleType="1" zIndex="0" mergeLines="1" minFeatureSize="0" limitNumLabels="0" maxNumLabels="2000" unplacedVisibility="0" upsidedownLabels="0"/>
<dd_properties><Option type="Map"><Option name="name" type="QString" value=""/><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option></dd_properties>
</settings>
</rule>
</rules>
</labeling>
<blendMode>0</blendMode>
<layerGeometryType>1</layerGeometryType>
</qgis>
