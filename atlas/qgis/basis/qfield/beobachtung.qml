<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Erfassungsformular für QField
  Passt auf das Schema aus basis/skripte/atlas.py → erfassungslayer().
  Laden: Layereigenschaften → Attributformular → Stil laden (Kategorien Felder + Formulare).
-->
<qgis version="3.28" styleCategories="Fields|Forms">
<fieldConfiguration>
<field name="art" configurationFlags="None"><editWidget type="ValueMap"><config><Option type="Map">
<Option name="map" type="List"><Option type="Map"><Option name="Sichtung" type="QString" value="sichtung"/></Option><Option type="Map"><Option name="Spur oder Losung" type="QString" value="spur"/></Option><Option type="Map"><Option name="Schaden" type="QString" value="schaden"/></Option><Option type="Map"><Option name="Fütterungsstelle" type="QString" value="fuetterung"/></Option><Option type="Map"><Option name="Müllcontainer" type="QString" value="muell"/></Option><Option type="Map"><Option name="Sonstiges" type="QString" value="sonstiges"/></Option></Option>
</Option></config></editWidget></field>
<field name="datum" configurationFlags="None"><editWidget type="DateTime"><config><Option type="Map">
<Option name="allow_null" type="bool" value="false"/><Option name="calendar_popup" type="bool" value="true"/>
<Option name="display_format" type="QString" value="dd.MM.yyyy HH:mm"/>
<Option name="field_format" type="QString" value="yyyy-MM-dd HH:mm:ss"/>
</Option></config></editWidget></field>
<field name="anzahl" configurationFlags="None"><editWidget type="Range"><config><Option type="Map">
<Option name="Min" type="int" value="1"/><Option name="Max" type="int" value="20"/>
<Option name="Step" type="int" value="1"/><Option name="Style" type="QString" value="SpinBox"/>
</Option></config></editWidget></field>
<field name="sicherheit" configurationFlags="None"><editWidget type="ValueMap"><config><Option type="Map">
<Option name="map" type="List"><Option type="Map"><Option name="sicher" type="QString" value="sicher"/></Option><Option type="Map"><Option name="wahrscheinlich" type="QString" value="wahrscheinlich"/></Option><Option type="Map"><Option name="unsicher" type="QString" value="unsicher"/></Option></Option>
</Option></config></editWidget></field>
<field name="foto" configurationFlags="None"><editWidget type="ExternalResource"><config><Option type="Map">
<Option name="DocumentViewer" type="int" value="1"/><Option name="RelativeStorage" type="int" value="1"/>
<Option name="StorageMode" type="int" value="0"/>
<Option name="PropertyCollection" type="Map"><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option>
</Option></config></editWidget></field>
<field name="notiz" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map">
<Option name="IsMultiline" type="bool" value="true"/><Option name="UseHtml" type="bool" value="false"/>
</Option></config></editWidget></field>
<field name="erfasser" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map"/></config></editWidget></field>
</fieldConfiguration>
<aliases>
<alias field="art" name="Was" index="0"/>
<alias field="datum" name="Wann" index="1"/>
<alias field="anzahl" name="Wie viele" index="2"/>
<alias field="sicherheit" name="Bestimmung" index="3"/>
<alias field="foto" name="Foto" index="4"/>
<alias field="notiz" name="Notiz" index="5"/>
<alias field="erfasser" name="Erfasser" index="6"/>
</aliases>
<defaults>
<default field="datum" expression="now()" applyOnUpdate="0"/>
<default field="anzahl" expression="1" applyOnUpdate="0"/>
<default field="sicherheit" expression="'sicher'" applyOnUpdate="0"/>
<default field="erfasser" expression="@user_full_name" applyOnUpdate="0"/>
</defaults>
<constraints>
<constraint field="art" exp_strength="0" constraints="1" notnull_strength="1" unique_strength="0"/>
<constraint field="datum" exp_strength="0" constraints="1" notnull_strength="1" unique_strength="0"/>
</constraints>
<editforlayout>generatedlayout</editforlayout>
</qgis>
