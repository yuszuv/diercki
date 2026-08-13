<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<!--
  Sternprodukt-Atlas · Rasterstil
  Datentyp  : Höhenraster (DGM), einbandig, Werte in m ü. NHN
  Register  : Hypsometrie — Höhenschichtkolorit nach der Atlas-Stufung
  Farben    : hSenke/h0…h5000/gletscher aus atlas/farben.js
  Stufung   : diskret (INTERPOLATED wäre eine Behauptung über Zwischenwerte).
              Die Grenzen sind die Atlas-Grenzen; für ein Blatt mit kleinerer
              Höhenspanne die Grenzen anpassen UND die Zahl der sichtbar belegten
              Stufen in der Zeichenerklärung nennen, nicht die Zahl der definierten.
  Zusammen  : unter diesen Layer die Schummerung legen (relief_schummerung.txt),
              Mischmodus Multiplizieren, Deckkraft der Schummerung ~55 %.
-->
<qgis version="3.28" styleCategories="Symbology">
<pipe>
<rasterrenderer type="singlebandpseudocolor" band="1" opacity="1" alphaBand="-1" nodataColor="" classificationMin="-10" classificationMax="5000">
<rastershader>
<colorrampshader colorRampType="DISCRETE" classificationMode="1" clip="0" minimumValue="-10" maximumValue="5000" labelPrecision="0">
<item value="0"    color="#9db884" alpha="255" label="unter NN"/>
<item value="200"  color="#bcca9a" alpha="255" label="0–200 m"/>
<item value="500"  color="#d4d1a2" alpha="255" label="200–500 m"/>
<item value="1000" color="#dec990" alpha="255" label="500–1000 m"/>
<item value="2000" color="#cfae74" alpha="255" label="1000–2000 m"/>
<item value="3000" color="#b98c5c" alpha="255" label="2000–3000 m"/>
<item value="5000" color="#a1704b" alpha="255" label="3000–5000 m"/>
<item value="inf"  color="#7d5a4e" alpha="255" label="über 5000 m"/>
</colorrampshader>
</rastershader>
</rasterrenderer>
<brightnesscontrast brightness="0" contrast="0" gamma="1"/>
<huesaturation saturation="0" colorizeOn="0" grayscaleMode="0"/>
<rasterresampler maxOversampling="2"/>
</pipe>
</qgis>
