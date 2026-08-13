<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Erfassungsformular für QField — Hanfkontrolle
  Passt auf das Schema aus themen/brandenburg-hanf/skripte/kontrolllayer.py.
  Laden: Layereigenschaften → Attributformular → Stil laden (Kategorien Felder + Formulare).

  Feldreihenfolge folgt dem Ablauf draußen, nicht der Datenbanklogik:
  zuerst was ohnehin schon feststeht (Schlag), dann die eine Frage, für die
  man hingefahren ist (richtung_ist), dann Bestand, Foto, Notiz.
-->
<qgis version="3.28" styleCategories="Fields|Forms">
<fieldConfiguration>
<field name="flik" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map"/></config></editWidget></field>
<field name="sorte_bez" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map"/></config></editWidget></field>
<field name="richtung_ist" configurationFlags="None"><editWidget type="ValueMap"><config><Option type="Map">
<Option name="map" type="List">
<Option type="Map"><Option name="Faser (Stängel geerntet)" type="QString" value="faser"/></Option>
<Option type="Map"><Option name="Korn (Drusch)" type="QString" value="korn"/></Option>
<Option type="Map"><Option name="Doppelnutzung" type="QString" value="dual"/></Option>
<Option type="Map"><Option name="Blüte / Cannabinoide" type="QString" value="cbd"/></Option>
<Option type="Map"><Option name="unklar — nicht entscheidbar" type="QString" value="unklar"/></Option>
</Option></Option></config></editWidget></field>
<field name="richtung_woher" configurationFlags="None"><editWidget type="ValueMap"><config><Option type="Map">
<Option name="map" type="List">
<Option type="Map"><Option name="Betriebsleiter gesagt" type="QString" value="auskunft"/></Option>
<Option type="Map"><Option name="am Bestand erkannt" type="QString" value="bestand"/></Option>
<Option type="Map"><Option name="Erntespuren" type="QString" value="ernte"/></Option>
<Option type="Map"><Option name="vermutet" type="QString" value="vermutet"/></Option>
</Option></Option></config></editWidget></field>
<field name="bestand" configurationFlags="None"><editWidget type="ValueMap"><config><Option type="Map">
<Option name="map" type="List">
<Option type="Map"><Option name="geschlossen" type="QString" value="geschlossen"/></Option>
<Option type="Map"><Option name="lückig" type="QString" value="lueckig"/></Option>
<Option type="Map"><Option name="verunkrautet" type="QString" value="verunkrautet"/></Option>
<Option type="Map"><Option name="Fehlstellen (Nässe/Wild)" type="QString" value="fehlstellen"/></Option>
</Option></Option></config></editWidget></field>
<field name="hoehe_cm" configurationFlags="None"><editWidget type="Range"><config><Option type="Map">
<Option name="Min" type="int" value="0"/><Option name="Max" type="int" value="350"/>
<Option name="Step" type="int" value="10"/><Option name="Style" type="QString" value="SpinBox"/>
</Option></config></editWidget></field>
<field name="bbch" configurationFlags="None"><editWidget type="Range"><config><Option type="Map">
<Option name="Min" type="int" value="0"/><Option name="Max" type="int" value="99"/>
<Option name="Step" type="int" value="1"/><Option name="Style" type="QString" value="SpinBox"/>
</Option></config></editWidget></field>
<field name="foto" configurationFlags="None"><editWidget type="ExternalResource"><config><Option type="Map">
<Option name="DocumentViewer" type="int" value="1"/><Option name="RelativeStorage" type="int" value="1"/>
<Option name="StorageMode" type="int" value="0"/>
<Option name="PropertyCollection" type="Map"><Option name="properties"/><Option name="type" type="QString" value="collection"/></Option>
</Option></config></editWidget></field>
<field name="notiz" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map">
<Option name="IsMultiline" type="bool" value="true"/><Option name="UseHtml" type="bool" value="false"/>
</Option></config></editWidget></field>
<field name="datum" configurationFlags="None"><editWidget type="DateTime"><config><Option type="Map">
<Option name="allow_null" type="bool" value="false"/><Option name="calendar_popup" type="bool" value="true"/>
<Option name="display_format" type="QString" value="dd.MM.yyyy HH:mm"/>
<Option name="field_format" type="QString" value="yyyy-MM-dd HH:mm:ss"/>
</Option></config></editWidget></field>
<field name="gps_genauigkeit" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map"/></config></editWidget></field>
<field name="erfasser" configurationFlags="None"><editWidget type="TextEdit"><config><Option type="Map"/></config></editWidget></field>
</fieldConfiguration>
<aliases>
<alias field="flik" name="Feldblock (FLIK)" index="0"/>
<alias field="sorte_bez" name="Sorte laut Antrag" index="1"/>
<alias field="richtung_ist" name="Nutzungsrichtung tatsächlich" index="2"/>
<alias field="richtung_woher" name="Woher weiß ich das" index="3"/>
<alias field="bestand" name="Bestand" index="4"/>
<alias field="hoehe_cm" name="Höhe (cm)" index="5"/>
<alias field="bbch" name="BBCH-Stadium" index="6"/>
<alias field="foto" name="Foto" index="7"/>
<alias field="notiz" name="Notiz" index="8"/>
<alias field="datum" name="Wann" index="9"/>
<alias field="gps_genauigkeit" name="GPS-Genauigkeit (m)" index="10"/>
<alias field="erfasser" name="Erfasser" index="11"/>
</aliases>
<defaults>
<default field="datum" expression="now()" applyOnUpdate="0"/>
<default field="richtung_woher" expression="'bestand'" applyOnUpdate="0"/>
<default field="gps_genauigkeit" expression="coalesce(format_number(@gnss_horizontal_accuracy, 1), 'ohne GPS')" applyOnUpdate="0"/>
<default field="erfasser" expression="@user_full_name" applyOnUpdate="0"/>
</defaults>
<constraints>
<constraint field="richtung_ist" exp_strength="0" constraints="1" notnull_strength="1" unique_strength="0"/>
<constraint field="richtung_woher" exp_strength="0" constraints="1" notnull_strength="1" unique_strength="0"/>
<constraint field="datum" exp_strength="0" constraints="1" notnull_strength="1" unique_strength="0"/>
</constraints>
<constraintExpressions>
<constraint field="richtung_ist" exp="" desc="Ohne diese Angabe war die Fahrt umsonst — „unklar“ ist erlaubt."/>
<constraint field="richtung_woher" exp="" desc="Trennt Auskunft von Vermutung. Das entscheidet später den Belegstatus."/>
</constraintExpressions>
<editforlayout>generatedlayout</editforlayout>
</qgis>
