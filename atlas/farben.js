// Sternprodukt-Atlas — Farbsystem
// Gedämpfte Diercke-Systematik auf warmem Sternprodukt-Grund.
// Format je Zeile: schluessel: '#hex', // Klartextname — maschinell geparst für .gpl-Export.
export const F = {
  // —— Grund & Chrome
  papier: '#fdfdfd', // Papier
  papierWarm: '#f1e9d8', // Papier warm (historisch)
  flaecheWarm: '#f7f4ee', // Fläche warm
  tinte: '#2a231c', // Tinte
  umriss: '#828282', // Geometrie-Umriss
  grauHell: '#e5ddce', // Grau hell
  dim: '#8b8173', // Kontext gedimmt
  grauDunkel: '#4a4139', // Grau dunkel
  bleistift: '#434462', // Bleistift-Blauviolett
  auswahl: '#2a7ae2', // Auswahl (nur Bildschirm)
  konflikt: '#a83a28', // Konflikt — einzige Rot-Reserve
  // —— Akzentfamilien (Tint / Base / Deep)
  orangeTint: '#f0dcd0', // Orange Tint
  orange: '#cb5a2a', // Orange Base
  orangeDeep: '#a04620', // Orange Deep
  petrolTint: '#dbe8e8', // Petrol Tint
  petrol: '#2f6f74', // Petrol Base
  petrolDeep: '#22545a', // Petrol Deep
  olivTint: '#e4e4cf', // Oliv Tint
  oliv: '#6f7538', // Oliv Base
  olivDeep: '#54592a', // Oliv Deep
  pflaumeTint: '#e6dbe2', // Pflaume Tint
  pflaume: '#5a3a52', // Pflaume Base
  pflaumeDeep: '#43293d', // Pflaume Deep
  ocker: '#b98e3f', // Ocker Base
  ockerDeep: '#94702f', // Ocker Deep
  // —— Hypsometrie (Höhenschichten, Land)
  hSenke: '#9db884', // Senke unter NN
  h0: '#bcca9a', // 0–200 m
  h200: '#d4d1a2', // 200–500 m
  h500: '#dec990', // 500–1000 m
  h1000: '#cfae74', // 1000–2000 m
  h2000: '#b98c5c', // 2000–3000 m
  h3000: '#a1704b', // 3000–5000 m
  h5000: '#7d5a4e', // über 5000 m
  gletscher: '#eae7e0', // Gletscher, Inlandeis
  // —— Bathymetrie (Meerestiefen)
  b0: '#dce7e4', // Schelf 0–200 m
  b200: '#bdd4d3', // 200–2000 m
  b2000: '#98bcbe', // 2000–4000 m
  b4000: '#71a0a7', // 4000–6000 m
  b6000: '#4d828d', // 6000–8000 m
  b8000: '#35636f', // Tiefseegraben über 8000 m
  wasser: '#35707b', // Gewässerlinie / Küste
  // —— Klimazonen
  kPolar: '#bcc9ce', // Polare Zone
  kSubpolar: '#a3b7ad', // Subpolare Zone
  kGemaessigt: '#8aa574', // Gemäßigte Zone
  kSubtrop: '#c9b264', // Subtropen, winterfeucht
  kTrocken: '#e0cda4', // Trockenklimate, Wüste
  kTropWechsel: '#c98d4e', // Tropen, wechselfeucht
  kTropFeucht: '#6f8f5a', // Tropen, immerfeucht
  // —— Landwirtschaft & Bodennutzung
  acker: '#e7dcab', // Ackerland
  sonderkultur: '#d9b96e', // Sonderkulturen, Dauerkulturen
  reis: '#b7cdb4', // Nassreis
  gruenland: '#ccd5a9', // Grünland, Weide
  weideExt: '#dfdfc4', // Extensive Weide, Steppe
  wald: '#a9ba8b', // Wald, Forstwirtschaft
  plantage: '#b09a63', // Tropische Plantage
  hanf: '#9aab63', // Hanfanbau
  oedland: '#e8dfcc', // Ödland, Wüste
  tundra: '#cfd4c5', // Tundra, Kältesteppe
  // —— Stadtplan
  bebaut: '#ddd3c4', // Geschlossen bebaut
  bebautLocker: '#eae3d7', // Aufgelockert bebaut
  gewerbe: '#d3d1da', // Industrie- und Gewerbefläche
  wegHell: '#c9c0ae', // Wegenetz im Grundriss (Fußwege, Wirtschaftswege)
  gewaesserFlaeche: '#a8c4d4', // Wasserfläche im Grundriss (Teich, Becken)
  // —— Geologie (Erdzeitalter)
  quartaer: '#efe6bf', // Quartär
  neogen: '#e3cf8d', // Neogen
  palaeogen: '#d9b678', // Paläogen
  kreide: '#a9c295', // Kreide
  jura: '#8fb0b8', // Jura
  trias: '#a98ba6', // Trias
  perm: '#b57f66', // Perm
  karbon: '#8d8a7f', // Karbon
  devon: '#ab8f6b', // Devon
  silur: '#9aa98d', // Silur
  ordovizium: '#6f8f86', // Ordovizium
  kambrium: '#6b8577', // Kambrium
  praekambrium: '#c78f80', // Präkambrium
  // —— Bevölkerung (sequentiell, Pflaume)
  p1: '#efe9ed', // Dichte Stufe 1
  p2: '#d9c4d3', // Dichte Stufe 2
  p3: '#b897ac', // Dichte Stufe 3
  p4: '#8f6484', // Dichte Stufe 4
  p5: '#5a3a52', // Dichte Stufe 5
  // —— Thematische Einzelfarben
  baer: '#7a4a2b', // Bär
  schutzgebiet: '#4f7a4a', // Schutzgebiet
  // —— Divergierend (Petrol ↔ Orange)
  d1: '#2f6f74', // Divergierend −2
  d2: '#8db4b6', // Divergierend −1
  d3: '#efe9dc', // Divergierend 0 (warm-neutral)
  d4: '#dfa27c', // Divergierend +1
  d5: '#cb5a2a', // Divergierend +2
};
