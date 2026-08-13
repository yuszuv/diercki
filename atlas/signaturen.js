// Sternprodukt-Atlas — Signaturenkatalog (Datenmodul)
// Alle Maße in mm (Druck); Umrechnung 1 mm = 96/25.4 px erfolgt im Renderer.
import { F } from './farben.js';

const L = (n, s, layers, x = {}) => ({ n, s, k: 'line', layers, ...x });
const P = (n, s, spec) => ({ n, s, k: 'point', ...spec });
const A = (n, s, fill, x = {}) => ({ n, s, k: 'area', fill, ...x });
const S = (n, s, raw) => ({ n, s, k: 'svg', raw });
const T = (n, s, t, st) => ({ n, s, k: 'text', t, st });
const MM = 96 / 25.4;
const SERIF = `'Gentium Book Plus','Noto Serif',serif`;
const MONO = `'Noto Sans Mono',monospace`;

// ——— Raw-SVG-Bausteine (viewBox 0 0 104 26, Historie 0 0 104 40)
const rep = (x0, x1, step, fn) => { let out = ''; for (let x = x0; x <= x1; x += step) out += fn(x); return out; };
// Stilisierter Brokkoli — die Hanf-Signatur (Silhouette: Kopf aus drei Bögen, kurzer Strunk).
const brok = (cx, cy, s, color) => `<g transform="translate(${cx} ${cy}) scale(${s})"><path d="M-1.3 1 L-1.8 4.6 L1.8 4.6 L1.3 1 Z M0 -5.6 c1.9 0 3.4 1.2 3.6 2.8 c1.3 .3 2.2 1.3 2.2 2.5 c0 1.4 -1.3 2.5 -2.9 2.5 l-5.8 0 c-1.6 0 -2.9 -1.1 -2.9 -2.5 c0 -1.2 .9 -2.2 2.2 -2.5 c.2 -1.6 1.7 -2.8 3.6 -2.8 z" fill="${color}"/></g>`;
// Klassisches Hanfblatt — sieben lanzettliche Finger, kurzer Stiel.
const blatt = (cx, cy, s, color) => {
  const leaf = (ang, l) => { const w = l * .17; return `<path transform="rotate(${ang})" d="M0 .4 C ${w} ${-l * .3} ${w * 1.05} ${-l * .72} 0 ${-l} C ${-w * 1.05} ${-l * .72} ${-w} ${-l * .3} 0 .4 Z" fill="${color}"/>`; };
  let g = `<g transform="translate(${cx} ${cy + 1.2}) scale(${s})">`;
  [[0, 6.6], [-34, 5.9], [34, 5.9], [-65, 4.8], [65, 4.8], [-98, 3.1], [98, 3.1]].forEach(([a, l]) => { g += leaf(a, l); });
  g += `<path d="M0 0 L0 3.4" stroke="${color}" stroke-width=".7" fill="none"/></g>`;
  return g;
};
const hanfGlyph = (v, cx, cy, s, color) => v === 'hanfblatt' ? blatt(cx, cy, s, color)
  : v === 'hquer' ? `<text x="${cx}" y="${cy + 12 * s * .36}" text-anchor="middle" font-family="${SERIF}" font-size="${12 * s}" fill="${color}">\u210f</text>`
  : brok(cx, cy, s, color);
export const hanfRaws = v => ({
  rohstoff: `<circle cx="52" cy="13" r="6.9" fill="#fdfdfd" stroke="${F.oliv}" stroke-width="2.1"/>` + hanfGlyph(v, 52, 13.5, .82, F.oliv),
  industrie: `<rect x="20.7" y="7.7" width="10.6" height="10.6" fill="${F.hanf}"/>` + hanfGlyph(v, 44, 13.3, .72, F.tinte),
  anbau: `<rect x="2" y="2.5" width="100" height="21" fill="${F.hanf}"/>` + rep(11, 95, 21, x => hanfGlyph(v, x, 9.5, .48, F.olivDeep)) + rep(21.5, 95, 21, x => hanfGlyph(v, x, 18, .48, F.olivDeep)),
});
const HR = hanfRaws('brokkoli');

const rawWasserfall = `<path d="M2 16 C28 8 62 20 102 12" fill="none" stroke="${F.wasser}" stroke-width="1.9"/><line x1="49" y1="6.5" x2="49" y2="20.5" stroke="${F.wasser}" stroke-width="1.4"/><line x1="53.5" y1="8" x2="53.5" y2="19" stroke="${F.wasser}" stroke-width="0.9"/>`;
const rawHoehenpunkt = `<circle cx="30" cy="14" r="1.6" fill="${F.tinte}"/><text x="36" y="17" font-family="${SERIF}" font-size="10">2544</text><text x="60" y="17" font-family="${SERIF}" font-size="10" font-style="italic" fill="${F.dim}">Moldoveanu</text>`;
const rawSchummerung = `<defs><radialGradient id="g-sch"><stop offset="0" stop-color="#5e544a" stop-opacity=".5"/><stop offset="1" stop-color="#5e544a" stop-opacity="0"/></radialGradient></defs><rect x="2" y="2.5" width="100" height="21" fill="${F.h500}"/><ellipse cx="42" cy="16" rx="34" ry="10" fill="url(#g-sch)"/><ellipse cx="70" cy="8" rx="18" ry="6" fill="#fff" opacity=".25"/>`;
const rawHoehle = `<path d="M46 18 v-6 a6 6 0 0 1 12 0 v6" fill="none" stroke="${F.tinte}" stroke-width="1.1"/><line x1="43" y1="18" x2="61" y2="18" stroke="${F.tinte}" stroke-width="1.1"/>`;
const rawBoeschung = `<path d="M2 12 H102" stroke="${F.tinte}" stroke-width=".9"/>` + rep(6, 98, 4.4, x => `<line x1="${x}" y1="12" x2="${x}" y2="${x % 8.8 < 4 ? 17.5 : 15.5}" stroke="${F.tinte}" stroke-width=".55"/>`);
const rawHauptstadt = `<circle cx="16" cy="12" r="4.6" fill="${F.papier}" stroke="${F.tinte}" stroke-width="1.9"/><circle cx="16" cy="12" r="1.2" fill="${F.tinte}"/><text x="26" y="15.5" font-family="${SERIF}" font-weight="600" font-size="11">Bucure\u0219ti</text><line x1="26" y1="19.5" x2="82" y2="19.5" stroke="${F.orange}" stroke-width="1"/>`;
const rawStaatsgrenze = `<rect x="2" y="13" width="100" height="4.6" fill="${F.pflaume}" opacity=".28"/><path d="M2 13 H102" stroke="${F.tinte}" stroke-width=".55" stroke-dasharray="7 2.2 1 2.2"/>`;
const rawKolorit = `<rect x="14" y="4" width="76" height="18" fill="none"/><path d="M17.5 7.5 h69 v11 h-69 z" fill="none" stroke="${F.pflaume}" stroke-width="5" opacity=".28"/><rect x="15" y="5" width="74" height="16" fill="none" stroke="${F.tinte}" stroke-width=".55" stroke-dasharray="6 2 1 2"/>`;
const rawSchraffKolorit = `<defs><pattern id="g-shr" width="4" height="4" patternTransform="rotate(45)" patternUnits="userSpaceOnUse"><line x1="0" y1="0" x2="0" y2="4" stroke="${F.petrol}" stroke-width="1.1"/></pattern></defs><rect x="15" y="5" width="74" height="16" fill="url(#g-shr)" opacity=".45"/><rect x="15" y="5" width="74" height="16" fill="none" stroke="${F.petrol}" stroke-width=".6" stroke-dasharray="4 1.8"/>`;
const rawPass = `<path d="M44 5 C40 9 40 17 44 21" fill="none" stroke="${F.tinte}" stroke-width="1.1"/><path d="M52 5 C56 9 56 17 52 21" fill="none" stroke="${F.tinte}" stroke-width="1.1"/><text x="62" y="17" font-family="${SERIF}" font-size="10">1109</text>`;
const rawBahnhof = `<path d="M2 13 H102" stroke="${F.tinte}" stroke-width="1.5"/><rect x="47" y="9" width="10" height="8" fill="${F.tinte}"/>`;
const rawSeilbahn = `<path d="M2 13 H102" stroke="${F.tinte}" stroke-width=".5"/>` + rep(10, 96, 12, x => `<line x1="${x - 2.4}" y1="10.6" x2="${x + 2.4}" y2="15.4" stroke="${F.tinte}" stroke-width=".55"/><line x1="${x + 2.4}" y1="10.6" x2="${x - 2.4}" y2="15.4" stroke="${F.tinte}" stroke-width=".55"/>`);
const plane = (cx, cy, s, fill, stroke) => `<path transform="translate(${cx} ${cy}) scale(${s})" d="M0 -9 c1 0 1.6 1.1 1.6 2.5 v3.6 l9.4 4.2 v2.8 l-9.4-2.4 v4.6 l2.8 2.4 v2 l-4.4-1.1 -4.4 1.1 v-2 l2.8-2.4 v-4.6 l-9.4 2.4 v-2.8 l9.4-4.2 v-3.6 c0-1.4 .6-2.5 1.6-2.5 z" ${fill ? `fill="${F.tinte}"` : `fill="none" stroke="${F.tinte}" stroke-width="${1.2 / s}"`}/>`;
const rawFlug = plane(52, 13, 0.95, true);
const rawFlugRegional = plane(52, 13, 0.78, false);
const rawFlugverbindung = `<path d="M6 19 C34 5 70 5 96 15" fill="none" stroke="${F.bleistift}" stroke-width=".45"/><path d="M93 10.5 L100 15.5 L91.5 16.5 z" fill="${F.bleistift}"/>`;
const rawVerkehrsstrom = `<path d="M4 16.5 L82 10.5 L82 5.5 L100 13 L82 20.5 L82 15.5 L4 19.5 z" fill="${F.orange}" opacity=".55"/>`;
const rawOelleitung = `<path d="M2 13 H102" stroke="${F.tinte}" stroke-width=".5"/>` + rep(12, 92, 16, x => `<circle cx="${x}" cy="13" r="1.9" fill="${F.tinte}"/>`);
const rawGasleitung = `<path d="M2 13 H102" stroke="${F.tinte}" stroke-width=".5" stroke-dasharray="5 2"/>` + rep(12, 92, 16, x => `<circle cx="${x}" cy="13" r="1.9" fill="${F.papier}" stroke="${F.tinte}" stroke-width=".6"/>`);
const rawStromWarm = `<path d="M6 16 C30 9 58 17 86 11" fill="none" stroke="${F.orange}" stroke-width="2.6" opacity=".85"/><path d="M84 5.5 L98 10 L86 16.5 z" fill="${F.orange}" opacity=".85"/>`;
const rawStromKalt = `<path d="M6 11 C30 18 58 9 86 15" fill="none" stroke="${F.petrol}" stroke-width="2.6" opacity=".85" stroke-dasharray="7 3"/><path d="M84 9.5 L98 16 L85.5 20.5 z" fill="${F.petrol}" opacity=".85"/>`;
const rawWind = `<path d="M8 13 H88" stroke="${F.tinte}" stroke-width=".8"/><path d="M86 8.5 L98 13 L86 17.5 z" fill="${F.tinte}"/>`;
const rawIsoJuli = `<path d="M2 15 C30 9 66 19 102 11" fill="none" stroke="${F.orangeDeep}" stroke-width=".8"/><rect x="42" y="7" width="21" height="11" fill="${F.papier}"/><text x="44" y="15.5" font-family="${MONO}" font-weight="500" font-size="8.5" fill="${F.orangeDeep}">+20\u00b0</text>`;
const rawIsoJan = `<path d="M2 12 C30 18 66 8 102 15" fill="none" stroke="${F.petrolDeep}" stroke-width=".8"/><rect x="43" y="8" width="19" height="11" fill="${F.papier}"/><text x="45" y="16.5" font-family="${MONO}" font-weight="500" font-size="8.5" fill="${F.petrolDeep}">\u22125\u00b0</text>`;
const rawKlimastation = `<circle cx="22" cy="13" r="1.9" fill="${F.tinte}"/><text x="29" y="16" font-family="${MONO}" font-weight="500" font-size="8.5">Sulina 11,4\u00b0 · 259 mm</text>`;
const rawStadtgroessen = `<circle cx="18" cy="13" r="9" fill="${F.orange}" opacity=".45"/><circle cx="18" cy="13" r="9" fill="none" stroke="${F.orangeDeep}" stroke-width=".5"/><circle cx="44" cy="13" r="5.5" fill="${F.orange}" opacity=".45"/><circle cx="44" cy="13" r="5.5" fill="none" stroke="${F.orangeDeep}" stroke-width=".5"/><circle cx="62" cy="13" r="3" fill="${F.orange}" opacity=".45"/><circle cx="62" cy="13" r="3" fill="none" stroke="${F.orangeDeep}" stroke-width=".5"/><text x="72" y="16" font-family="${MONO}" font-weight="500" font-size="7.5" fill="${F.dim}">2/0,5/0,1 Mio.</text>`;
const rawMigration = `<path d="M4 17 C30 15 60 12 84 10 L83 5.5 L100 10.5 L85.5 17.5 L85 13.5 C60 15.5 30 18.5 4 20.5 z" fill="${F.pflaume}" opacity=".55"/>`;
const rawPendler = `<path d="M8 10 H84" stroke="${F.dim}" stroke-width="1"/><path d="M83 7 L94 10 L83 13 z" fill="${F.dim}"/><path d="M20 17 H96" stroke="${F.dim}" stroke-width="1"/><path d="M21 14 L10 17 L21 20 z" fill="${F.dim}"/>`;
const rawStoerung = `<path d="M2 12 H102" stroke="${F.tinte}" stroke-width=".9"/>` + rep(10, 96, 9, x => `<line x1="${x}" y1="12" x2="${x}" y2="17" stroke="${F.tinte}" stroke-width=".7"/>`);
const rawUeberschiebung = `<path d="M2 15 H102" stroke="${F.tinte}" stroke-width=".9"/>` + rep(12, 94, 16, x => `<path d="M${x - 3.5} 15 L${x} 9.5 L${x + 3.5} 15 z" fill="${F.tinte}"/>`);
const rawDivergent = `<path d="M2 10.8 H102" stroke="${F.petrol}" stroke-width="1.4"/><path d="M2 15.6 H102" stroke="${F.petrol}" stroke-width="1.4"/>`;
const rawKonvergent = `<path d="M2 15 H102" stroke="${F.petrolDeep}" stroke-width="1.2"/>` + rep(12, 94, 14, x => `<path d="M${x - 3.8} 15 L${x} 9 L${x + 3.8} 15 z" fill="${F.petrolDeep}"/>`);
const rawErdbeben = `<circle cx="52" cy="13" r="2.6" fill="${F.tinte}"/><circle cx="52" cy="13" r="6.4" fill="none" stroke="${F.tinte}" stroke-width=".8"/><circle cx="52" cy="13" r="10" fill="none" stroke="${F.tinte}" stroke-width=".5" opacity=".55"/>`;
const rawNationalpark = `<rect x="2" y="13" width="100" height="4.6" fill="${F.oliv}" opacity=".3"/><path d="M2 13 H102" stroke="${F.oliv}" stroke-width=".7"/>`;
const rawOeffGebaeude = `<rect x="2" y="2.5" width="100" height="21" fill="${F.papier}" stroke="${F.umriss}" stroke-width=".4"/><rect x="18" y="8" width="14" height="10" fill="${F.tinte}"/><rect x="46" y="6" width="9" height="12" fill="${F.tinte}"/><rect x="68" y="9" width="16" height="8" fill="${F.tinte}"/>`;
const rawStadion = `<ellipse cx="52" cy="13" rx="16" ry="8" fill="none" stroke="${F.tinte}" stroke-width="1"/><ellipse cx="52" cy="13" rx="9" ry="4" fill="none" stroke="${F.tinte}" stroke-width=".5"/>`;
const rawHbf = `<path d="M2 13 H102" stroke="${F.tinte}" stroke-width="1.5"/><rect x="42" y="7.5" width="20" height="11" fill="${F.tinte}"/><text x="45" y="16" font-family="${MONO}" font-weight="500" font-size="7.5" fill="${F.papier}">Hbf</text>`;
const rawStadtmauer = `<path d="M2 15 H102" stroke="${F.tinte}" stroke-width="1.2"/>` + rep(8, 96, 8, x => `<rect x="${x}" y="10.5" width="3.2" height="4.5" fill="${F.tinte}"/>`);
const rawPlattenrand = `<rect x="8" y="4" width="88" height="18" fill="none" stroke="${F.tinte}" stroke-width="2.2"/><rect x="12.5" y="8.5" width="79" height="9" fill="none" stroke="${F.tinte}" stroke-width=".55"/>`;
const rawMassstab = `<rect x="10" y="11" width="20" height="3.4" fill="${F.tinte}"/><rect x="30" y="11" width="20" height="3.4" fill="${F.papier}" stroke="${F.tinte}" stroke-width=".5"/><rect x="50" y="11" width="20" height="3.4" fill="${F.tinte}"/><rect x="70" y="11" width="20" height="3.4" fill="${F.papier}" stroke="${F.tinte}" stroke-width=".5"/><text x="8" y="9" font-family="${MONO}" font-weight="500" font-size="7">0</text><text x="46" y="9" font-family="${MONO}" font-weight="500" font-size="7">100</text><text x="83" y="9" font-family="${MONO}" font-weight="500" font-size="7">200 km</text>`;
const rawNordpfeil = `<path d="M52 4 L56 20 L52 16.5 L48 20 z" fill="${F.tinte}"/><text x="60" y="12" font-family="${SERIF}" font-size="10">N</text>`;
const rawGradnetz = `<path d="M2 18 C36 14 70 14 102 18" fill="none" stroke="${F.bleistift}" stroke-width=".45" opacity=".6"/><path d="M30 2 C32 11 32 17 30 24" fill="none" stroke="${F.bleistift}" stroke-width=".45" opacity=".6"/><path d="M74 2 C72 11 72 17 74 24" fill="none" stroke="${F.bleistift}" stroke-width=".45" opacity=".6"/><text x="82" y="14" font-family="${MONO}" font-weight="500" font-size="7.5" fill="${F.bleistift}">45\u00b0 N</text>`;
const rawGrenzeGewaesser = `<rect x="2" y="2.5" width="100" height="21" fill="${F.b0}"/><path d="M2 13 H30 M44 13 H72 M86 13 H102" stroke="${F.tinte}" stroke-width=".55" stroke-dasharray="6 2 1 2"/>`;

// ——— Katalog
export const KATALOG = {
  gewaesser: [
    L('Fluss, ständig wasserführend', '0,50 mm', [{ w: .5, c: F.wasser }]),
    L('Fluss 2. Ordnung, Bach', '0,28 mm', [{ w: .28, c: F.wasser }]),
    L('Fluss, periodisch', 'Wadi, Trockental', [{ w: .3, c: F.wasser, dash: [1.8, .9] }]),
    L('Kanal, schiffbar', 'gestreckt geführt', [{ w: .42, c: F.wasser }], { straight: 1 }),
    S('Wasserfall, Stromschnelle', 'Quersprosse 1,4 mm', rawWasserfall),
    A('See, ständig', 'Uferlinie 0,3 mm', F.b0, { border: { c: F.wasser, w: .3 } }),
    A('See, periodisch', '', F.b0, { border: { c: F.wasser, w: .3, dash: [1.6, 1] } }),
    A('Salzsee, Salzpfanne', '', F.b0, { border: { c: F.wasser, w: .3 }, pat: { type: 'dots', c: F.pflaume, gap: 3.2, r: .35 } }),
    A('Sumpf, Moor', 'Strichgruppen waagerecht', F.papier, { pat: { type: 'marsh', c: F.wasser } }),
    A('Watt, Gezeitenzone', '', F.b0, { pat: { type: 'dots', c: F.wasser, gap: 2.4, r: .28 } }),
    A('Gletscher, Inlandeis', '', F.gletscher, { border: { c: F.b200, w: .3, dash: [1.4, .9] } }),
    P('Quelle, Brunnen, Oase', '', { shape: 'ring', size: 1.7, c: F.wasser, sw: .4 }),
  ],
  relief: [
    L('Höhenlinie', '0,15 mm, Äquidistanz 100 m', [{ w: .15, c: F.tinte, o: .5 }]),
    L('Zähllinie, beschriftet', '0,30 mm, jede 5. Linie', [{ w: .3, c: F.tinte, o: .6 }]),
    S('Höhenpunkt mit Namen', 'Punkt 0,85 mm', rawHoehenpunkt),
    L('Tiefenlinie', 'Bathymetrie', [{ w: .2, c: F.wasser, dash: [1.3, .8] }]),
    S('Schummerung', 'Multiplizieren 35 %, Licht 315\u00b0', rawSchummerung),
    S('Böschung, Steilstufe', 'Zähnchen bergab', rawBoeschung),
    A('Düne, Sandfläche', '', F.oedland, { pat: { type: 'arcs', c: F.ocker } }),
    S('Höhle, Karstform', '', rawHoehle),
  ],
  siedlung: [
    P('über 1 Mio. Einwohner', 'Grundriss 3,4 mm, kreuzschraffiert', { shape: 'grundriss', size: 3.4, c: F.tinte, sw: .5 }),
    P('500 000 – 1 Mio.', 'Kreis 2,3 mm', { shape: 'circle', size: 2.3, c: F.papier, sw: .5 }),
    P('100 000 – 500 000', 'Kreis 1,9 mm', { shape: 'circle', size: 1.9, c: F.papier, sw: .45 }),
    P('25 000 – 100 000', 'Kreis 1,5 mm', { shape: 'circle', size: 1.5, c: F.papier, sw: .4 }),
    P('unter 25 000', 'Punkt 1,2 mm', { shape: 'dot', size: 1.2, c: F.tinte }),
    S('Hauptstadt', 'Name unterstrichen', rawHauptstadt),
    A('Städtische Fläche', 'ab 1:500 000 als Grundriss', F.bebaut, { border: { c: F.umriss, w: .25 } }),
  ],
  beschriftung: [
    T('Siedlung', 'Serife aufrecht, Größe = Rang', 'BUCURE\u0218TI \u00b7 Craiova', { fontFamily: SERIF, fontWeight: 600, fontSize: '13px', letterSpacing: '.02em' }),
    T('Landschaft, Region', 'Serife kursiv, gesperrt', 'K\u2009A\u2009R\u2009P\u2009A\u2009T\u2009E\u2009N', { fontFamily: SERIF, fontStyle: 'italic', fontSize: '12px', color: F.dim }),
    T('Gewässer', 'Serife kursiv, Gewässerfarbe', 'Dun\u0103rea \u00b7 Donau', { fontFamily: SERIF, fontStyle: 'italic', fontSize: '12.5px', color: F.wasser }),
    T('Staat', 'Versalien, gesperrt', 'R\u2009O\u2009M\u2009\u00c2\u2009N\u2009I\u2009A', { fontFamily: SERIF, fontWeight: 600, fontSize: '12px', letterSpacing: '.14em' }),
    T('Technik, Infrastruktur', 'Mono 500 — nie fett', 'E 60 \u00b7 EPSG:3035 \u00b7 1:2,5 Mio.', { fontFamily: MONO, fontWeight: 500, fontSize: '10px', color: F.bleistift }),
  ],
  grenzen: [
    S('Staatsgrenze', 'Strich-Punkt 0,55 mm + Kolorit innen', rawStaatsgrenze),
    L('Staatsgrenze, umstritten', 'ohne Kolorit', [{ w: .5, c: F.tinte, dash: [2.4, 1.2] }], { straight: 1 }),
    L('Verwaltungsgrenze 1. Ordnung', 'Strich-Punkt 0,35 mm', [{ w: .35, c: F.dim, dash: [5, 1.8, .8, 1.8] }], { straight: 1 }),
    L('Kreis-, Bezirksgrenze', 'Punktreihe', [{ w: .5, c: F.dim, dash: [.1, 1.6], cap: 'round' }], { straight: 1 }),
    L('Demarkations-, Konfliktlinie', 'einzige Rot-Verwendung', [{ w: .5, c: F.konflikt, dash: [2.4, 1.2] }], { straight: 1 }),
    S('Grenze im Gewässer', 'unterbrochen gesetzt', rawGrenzeGewaesser),
  ],
  politisch: [
    S('Staatsfläche: Grenzkolorit', 'Band 2,2 mm, 30 %, innen — Fläche bleibt hell', rawKolorit),
    A('Nachbarstaat, Kontext', 'gedimmt', '#eeeae1', { border: { c: F.dim, w: .3 } }),
    S('Abhängiges Gebiet', 'Schraffur im Kolorit der Verwaltungsmacht', rawSchraffKolorit),
    L('Bündnis, Wirtschaftsraum', 'z. B. EU — Band + Linie', [{ w: 1.6, c: F.petrol, o: .3 }, { w: .35, c: F.petrol }], { straight: 1 }),
    P('Hauptstadt, Regierungssitz', 'Ring + Unterstreichung des Namens', { shape: 'ring', size: 2.4, c: F.tinte, sw: .5, dot: 1 }),
  ],
  strassen: [
    L('Autobahn', 'Casing 1,3 \u00b7 Band 0,95 \u00b7 Mittellinie 0,12', [{ w: 1.3, c: F.tinte }, { w: .95, c: F.orange }, { w: .12, c: F.papier }]),
    L('Autobahn in Bau', '', [{ w: 1.3, c: F.tinte, dash: [3.5, 1.6] }, { w: .95, c: F.orange, dash: [3.5, 1.6] }]),
    L('Fern-, Europastraße', '', [{ w: 1.0, c: F.tinte }, { w: .6, c: F.orange }]),
    L('Hauptstraße', '', [{ w: .8, c: F.tinte }, { w: .5, c: F.ocker }]),
    L('Nebenstraße', '0,30 mm', [{ w: .3, c: F.tinte }]),
    L('Fahrweg, Piste', '', [{ w: .25, c: F.tinte, dash: [1.7, .9] }]),
    L('Straßentunnel', 'Casing hohl', [{ w: .8, c: F.tinte, dash: [2.6, 1.2] }, { w: .45, c: F.papier }]),
    S('Pass mit Höhenangabe', '', rawPass),
  ],
  bahnen: [
    L('Hauptbahn', 'helles Casing, Achse 0,4, Sprossen', [{ w: 1.0, c: F.papier }, { w: .4, c: F.tinte }], { straight: 1, ticks: { every: 3.2, len: 1.5, w: .4, c: F.tinte } }),
    L('Hauptbahn, elektrifiziert', 'Doppelsprosse', [{ w: 1.0, c: F.papier }, { w: .4, c: F.tinte }], { straight: 1, ticks: { every: 4.6, len: 1.5, w: .4, c: F.tinte, pair: .8 } }),
    L('Nebenbahn', '', [{ w: .8, c: F.papier }, { w: .28, c: F.tinte }], { straight: 1, ticks: { every: 4.6, len: 1.1, w: .3, c: F.tinte } }),
    L('Schmalspur-, Museumsbahn', '', [{ w: .28, c: F.tinte, dash: [2.6, 1.2] }], { straight: 1 }),
    L('Bahn in Bau, stillgelegt', '', [{ w: .28, c: F.dim, dash: [1.2, 1.2] }], { straight: 1 }),
    S('Bahnhof, Haltepunkt', '', rawBahnhof),
    S('Zahnrad-, Seilbahn', '', rawSeilbahn),
  ],
  seeLuft: [
    L('Fähre', '', [{ w: .35, c: F.wasser, dash: [2.4, 1.5] }]),
    L('Schifffahrtslinie', 'mit Distanzangabe in sm', [{ w: .25, c: F.wasser }]),
    P('Seehafen', '', { shape: 'ring', size: 2.2, c: F.wasser, sw: .5, dot: 1 }),
    P('Containerhafen', '', { shape: 'square', size: 2.2, c: F.wasser }),
    S('Flughafen, international', '', rawFlug),
    S('Regionalflughafen', 'Umriss statt Füllung', rawFlugRegional),
    S('Flugverbindung', 'Großkreis', rawFlugverbindung),
    S('Verkehrsstrom', 'Bandbreite \u221d Menge', rawVerkehrsstrom),
  ],
  rohstoffe: [
    P('Steinkohle', '', { shape: 'square', size: 4.2, c: F.tinte, glyph: { t: 'C', c: F.papier } }),
    P('Braunkohle', '', { shape: 'squareOpen', size: 4.2, c: F.tinte, glyph: { t: 'C', c: F.tinte } }),
    P('Erdöl', '', { shape: 'square', size: 4.2, c: F.tinte, glyph: { t: '\u00d6l', c: F.papier, fs: 7.5 } }),
    P('Erdgas', '', { shape: 'squareOpen', size: 4.2, c: F.tinte, glyph: { t: 'G', c: F.tinte } }),
    P('Torf', '', { shape: 'squareOpen', size: 4.2, c: F.tinte, glyph: { t: 'T', c: F.tinte } }),
    P('Uran', '', { shape: 'square', size: 4.2, c: F.pflaume, glyph: { t: 'U', c: F.papier } }),
    P('Eisenerz', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Fe' } }),
    P('Kupfer', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Cu' } }),
    P('Blei, Zink', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Pb\u00b7Zn' } }),
    P('Zinn', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Sn' } }),
    P('Nickel', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Ni' } }),
    P('Chrom', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Cr' } }),
    P('Mangan', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'Mn' } }),
    P('Wolfram', '', { shape: 'triangle', size: 4.2, c: F.tinte, label: { t: 'W' } }),
    P('Bauxit', 'Leichtmetalle offen', { shape: 'triangleOpen', size: 4.2, c: F.tinte, label: { t: 'Al' } }),
    P('Titan', '', { shape: 'triangleOpen', size: 4.2, c: F.tinte, label: { t: 'Ti' } }),
    P('Gold', '', { shape: 'circle', size: 4.2, c: F.ocker, label: { t: 'Au' } }),
    P('Silber', '', { shape: 'ring', size: 4.2, c: F.ocker, sw: .55, label: { t: 'Ag' } }),
    P('Platin', '', { shape: 'ring', size: 4.2, c: F.ocker, sw: .55, dot: 1, label: { t: 'Pt' } }),
    P('Steinsalz', '', { shape: 'diamondOpen', size: 4.2, c: F.tinte, label: { t: 'Na' } }),
    P('Kalisalz', '', { shape: 'diamondOpen', size: 4.2, c: F.tinte, label: { t: 'K' } }),
    P('Phosphat', '', { shape: 'diamondOpen', size: 4.2, c: F.tinte, label: { t: 'P' } }),
    P('Schwefel', '', { shape: 'diamond', size: 4.2, c: F.ocker, label: { t: 'S' } }),
    P('Diamanten', '', { shape: 'diamondOpen', size: 4.2, c: F.tinte, dot: 1 }),
    P('Seltene Erden', '', { shape: 'diamondOpen', size: 4.2, c: F.pflaume, label: { t: 'SE' } }),
    Object.assign(S('Hanf', 'nachwachsender Rohstoff \u00b7 Ring 4,20 mm', HR.rohstoff), { hv: 'rohstoff' }),
  ],
  industrie: [
    P('Eisen- und Stahlerzeugung', 'Tiegel — verhüttende Industrie', { shape: 'tiegel', size: 3.4, c: F.bleistift, label: { t: 'Fe' } }),
    P('Buntmetallhütte', 'Tiegel', { shape: 'tiegel', size: 3.4, c: F.ockerDeep, label: { t: 'Cu\u00b7Pb' } }),
    P('Aluminiumhütte', 'Tiegel', { shape: 'tiegel', size: 3.4, c: F.dim, label: { t: 'Al' } }),
    P('Maschinenbau', 'Kreis mit Kennbuchstabe', { shape: 'circle', size: 3.4, c: F.bleistift, glyph: { t: 'M', c: F.papier } }),
    P('Fahrzeugbau', '', { shape: 'circle', size: 3.4, c: F.orange, glyph: { t: 'F', c: F.papier } }),
    P('Schiffbau', '', { shape: 'circle', size: 3.4, c: F.petrol, glyph: { t: 'S', c: F.papier } }),
    P('Chemische Industrie', '', { shape: 'circle', size: 3.4, c: F.pflaume, glyph: { t: 'C', c: F.papier } }),
    P('Raffinerie, Petrochemie', '', { shape: 'circle', size: 3.4, c: F.pflaume, glyph: { t: 'R', c: F.papier } }),
    P('Elektrotechnik, Elektronik', '', { shape: 'circle', size: 3.4, c: F.petrolDeep, glyph: { t: 'E', c: F.papier } }),
    P('Textil, Bekleidung', '', { shape: 'circle', size: 3.4, c: F.ocker, glyph: { t: 'T', c: F.papier } }),
    P('Nahrungs- und Genussmittel', '', { shape: 'circle', size: 3.4, c: F.oliv, glyph: { t: 'N', c: F.papier } }),
    P('Holz, Zellstoff, Papier', '', { shape: 'circle', size: 3.4, c: F.olivDeep, glyph: { t: 'P', c: F.papier } }),
    P('Baustoffe, Zement, Glas', '', { shape: 'circle', size: 3.4, c: F.dim, glyph: { t: 'Z', c: F.papier } }),
    P('Betriebsgröße', 'unter 1000 · 1000–10 000 · über 10 000 Besch.', { shape: 'circle', sizes: [2.2, 3.4, 4.8], c: F.bleistift, sw: .3 }),
    Object.assign(S('Hanfverarbeitung', 'Fasern, Öle, Baustoffe', HR.industrie), { hv: 'industrie' }),
  ],
  energie: [
    P('Wärmekraftwerk', 'Kohle, Gas', { shape: 'doublering', size: 3.4, c: F.tinte, label: { t: 'Th' } }),
    P('Kernkraftwerk', '', { shape: 'doublering', size: 3.4, c: F.pflaume, label: { t: 'Ke' } }),
    P('Wasserkraftwerk', '', { shape: 'doublering', size: 3.4, c: F.petrol, label: { t: 'Wa' } }),
    P('Windpark', 'on-/offshore', { shape: 'doublering', size: 3.4, c: F.petrolDeep, label: { t: 'Wi' } }),
    P('Solarpark', '', { shape: 'doublering', size: 3.4, c: F.ocker, label: { t: 'So' } }),
    P('Geothermie', '', { shape: 'doublering', size: 3.4, c: F.orangeDeep, label: { t: 'Ge' } }),
    S('Erdölleitung', 'Punkt gefüllt', rawOelleitung),
    S('Erdgasleitung', 'Punkt hohl, Linie gestrichelt', rawGasleitung),
    L('Hochspannungsleitung', 'ab 220 kV', [{ w: .28, c: F.bleistift, dash: [4, 1.4, .15, 1.4] }], { straight: 1 }),
  ],
  landwirtschaft: [
    A('Ackerland', 'Getreide, Hackfrüchte', F.acker),
    A('Sonderkulturen', 'Gemüse, Blumen', F.sonderkultur, { pat: { type: 'raster', c: F.olivDeep, gap: 2.4, o: .5 } }),
    A('Weinbau', '', F.sonderkultur, { pat: { type: 'vlines', c: F.pflaume } }),
    A('Obstbau', '', F.sonderkultur, { pat: { type: 'dots', c: F.orangeDeep, gap: 3.4, r: .4 } }),
    A('Nassreis', '', F.reis, { pat: { type: 'hlines', c: F.petrol } }),
    Object.assign(S('Hanfanbau', 'Faser- und Blütenhanf', HR.anbau), { hv: 'anbau' }),
    A('Tropische Plantage', 'Kaffee, Tee, Kakao, Zuckerrohr', F.plantage, { pat: { type: 'dots', c: F.olivDeep, gap: 3.4, r: .4 } }),
    A('Ölfrüchte', 'Oliven, Ölpalme, Raps', F.acker, { pat: { type: 'dots', c: F.oliv, gap: 3.4, r: .4 } }),
    A('Grünland, Weidewirtschaft', '', F.gruenland),
    A('Extensive Weide, Steppe', '', F.weideExt, { pat: { type: 'crosshatch', c: F.oliv, gap: 3.2, w: .22, o: .45 } }),
    P('Obstbau, Streusignatur', 'gering · mittel · vorherrschend', { shape: 'dot', sizes: [1.4, 2.2, 3.2], c: F.orangeDeep }),
    P('Gemüsebau, Streusignatur', 'gering · mittel · vorherrschend', { shape: 'circle', sizes: [1.4, 2.2, 3.2], c: F.oliv, sw: .25 }),
    A('Wald, Forstwirtschaft', '', F.wald),
    A('Agroforst, regenerativ', 'Baumreihen im Acker', F.acker, { pat: { type: 'vlines', c: F.olivDeep, gap: 6 } }),
    A('Bewässerungsland', '', F.acker, { pat: { type: 'hatch', c: F.petrol } }),
    A('Ödland, Wüste', '', F.oedland, { pat: { type: 'dots', c: F.dim, gap: 4.6, r: .3 } }),
    A('Tundra, Kältesteppe', '', F.tundra),
  ],
  klima: [
    S('Isotherme Juli', 'Meeresniveau reduziert', rawIsoJuli),
    S('Isotherme Januar', '', rawIsoJan),
    L('Isohyete', 'Jahresniederschlag in mm', [{ w: .3, c: F.petrol, dash: [2.6, 1.1] }]),
    S('Meeresströmung, warm', '', rawStromWarm),
    S('Meeresströmung, kalt', 'gestrichelt', rawStromKalt),
    S('Hauptwindrichtung', 'Passat, Monsun', rawWind),
    L('Baumgrenze', '', [{ w: .5, c: F.oliv, dash: [.1, 1.7], cap: 'round' }]),
    A('Dauerfrostboden', 'Permafrost', F.papier, { pat: { type: 'hatch', c: F.bleistift, o: .5 } }),
    S('Klimastation', 'Jahresmittel, Jahressumme', rawKlimastation),
  ],
  bevoelkerung: [
    S('Stadtgrößen, proportional', 'Fläche \u221d Einwohnerzahl', rawStadtgroessen),
    A('Ballungsraum, Agglomeration', '', F.orangeTint, { border: { c: F.orange, w: .4, dash: [2.4, 1.2] } }),
    S('Wanderung, Migration', 'Band \u221d Personenzahl', rawMigration),
    S('Pendlerverflechtung', '', rawPendler),
  ],
  geologie: [
    S('Störung, Verwerfung', 'Zähnchen zur Tiefscholle', rawStoerung),
    S('Überschiebung, Deckengrenze', 'Dreiecke zur Hangendscholle', rawUeberschiebung),
    S('Plattengrenze, divergent', 'mittelozeanischer Rücken', rawDivergent),
    S('Plattengrenze, konvergent', 'Subduktion', rawKonvergent),
    L('Transformstörung', '', [{ w: .5, c: F.petrolDeep, dash: [3, 1.5] }], { straight: 1 }),
    P('Vulkan, aktiv', '', { shape: 'triangle', size: 3.2, c: F.orangeDeep }),
    P('Vulkan, erloschen', '', { shape: 'triangleOpen', size: 3.2, c: F.tinte }),
    S('Erdbebenherd', 'Ringe \u221d Magnitude', rawErdbeben),
    L('Vereisungsgrenze', 'Weichsel-/Würm-Maximum', [{ w: .4, c: F.bleistift, dash: [5, 1.8, .8, 1.8] }]),
  ],
  umwelt: [
    S('Nationalpark', 'Kolorit + Linie, innen', rawNationalpark),
    L('Naturschutzgebiet', '', [{ w: .4, c: F.oliv, dash: [2.6, 1.2] }], { straight: 1 }),
    L('Biosphärenreservat', '', [{ w: .55, c: F.oliv, dash: [.1, 1.8], cap: 'round' }], { straight: 1 }),
    L('Natura 2000, FFH', 'Band + Linie', [{ w: 1.4, c: F.petrol, o: .3 }, { w: .3, c: F.petrol, dash: [2.6, 1.2] }], { straight: 1 }),
    A('Wasserschutzgebiet', '', F.papier, { pat: { type: 'dots', c: F.petrol, gap: 3, r: .3 }, border: { c: F.petrol, w: .3, dash: [1.6, 1] } }),
    A('Desertifikationsgefahr', '', F.oedland, { pat: { type: 'hatch', c: F.ockerDeep } }),
    A('Waldrodung, -degradation', '', F.wald, { pat: { type: 'hatch', c: F.orangeDeep } }),
    A('Überschwemmungsgefährdet', '', F.papier, { pat: { type: 'hlines', c: F.petrol } }),
  ],
  stadt: [
    A('Geschlossen bebaute Fläche', '', F.bebaut, { border: { c: F.umriss, w: .25 } }),
    A('Aufgelockerte Bebauung', '', F.bebautLocker, { border: { c: F.umriss, w: .25 } }),
    A('Industrie- und Gewerbefläche', '', F.gewerbe, { pat: { type: 'raster', c: F.dim, gap: 2.2, o: .55 }, border: { c: F.umriss, w: .25 } }),
    S('Öffentliches Gebäude', 'als Grundriss, gefüllt', rawOeffGebaeude),
    A('Park, Grünanlage', '', F.gruenland),
    A('Friedhof', '', F.gruenland, { pat: { type: 'plus', c: F.tinte } }),
    S('Stadion, Sportanlage', '', rawStadion),
    S('Hauptbahnhof', '', rawHbf),
    P('U-/S-Bahn-Station', '', { shape: 'ring', size: 2.6, c: F.bleistift, sw: .5, glyph: { t: 'U', c: F.bleistift, fs: 8 } }),
    L('Fußgängerzone', '', [{ w: .55, c: F.orange, dash: [.1, 1.6], cap: 'round' }], { straight: 1 }),
    S('Historischer Kern, Stadtmauer', '', rawStadtmauer),
    P('Sehenswürdigkeit', '\u22c6 aus dem math-Subset', { shape: 'none', glyph: { t: '\u22c6', f: SERIF, c: F.bleistift, fs: 15 } }),
  ],
  chrome: [
    S('Plattenrand', 'außen 0,8 mm, innen 0,2 mm', rawPlattenrand),
    S('Gradnetz', '0,15 mm, alle 1\u00b0/5\u00b0 je Maßstab', rawGradnetz),
    S('Maßstabsbalken', 'statt Maßstabszahl', rawMassstab),
    L('Blattschnitt, Übersichtsrahmen', '', [{ w: .35, c: F.dim, dash: [3, 1.5] }], { straight: 1 }),
    S('Nordpfeil', 'nur auf gedrehten Karten', rawNordpfeil),
  ],
};

// ——— Farbrampen (Legendenkeile)
export const RAMPEN = {
  hypso: [
    { c: F.gletscher, l: 'Gletscher, Firn' }, { c: F.h5000, l: 'über 5000 m' }, { c: F.h3000, l: '3000–5000 m' },
    { c: F.h2000, l: '2000–3000 m' }, { c: F.h1000, l: '1000–2000 m' }, { c: F.h500, l: '500–1000 m' },
    { c: F.h200, l: '200–500 m' }, { c: F.h0, l: '0–200 m' }, { c: F.hSenke, l: 'Senke unter NN' },
  ],
  bathy: [
    { c: F.b0, l: 'Schelf, 0–200 m' }, { c: F.b200, l: '200–2000 m' }, { c: F.b2000, l: '2000–4000 m' },
    { c: F.b4000, l: '4000–6000 m' }, { c: F.b6000, l: '6000–8000 m' }, { c: F.b8000, l: 'über 8000 m' },
  ],
  klima: [
    { c: F.kPolar, l: 'Polare Zone' }, { c: F.kSubpolar, l: 'Subpolare Zone' }, { c: F.kGemaessigt, l: 'Gemäßigte Zone' },
    { c: F.kSubtrop, l: 'Subtropen' }, { c: F.kTrocken, l: 'Trockenklimate' }, { c: F.kTropWechsel, l: 'Tropen, wechselfeucht' },
    { c: F.kTropFeucht, l: 'Tropen, immerfeucht' },
  ],
  dichte: [
    { c: F.p1, l: 'unter 10' }, { c: F.p2, l: '10–50' }, { c: F.p3, l: '50–150' },
    { c: F.p4, l: '150–500' }, { c: F.p5, l: 'über 500 Ew./km\u00b2' },
  ],
  entwicklung: [
    { c: F.d1, l: 'stark abnehmend' }, { c: F.d2, l: 'abnehmend' }, { c: F.d3, l: 'stabil' },
    { c: F.d4, l: 'zunehmend' }, { c: F.d5, l: 'stark zunehmend' },
  ],
  geologie: [
    { c: F.quartaer, l: 'Quartär' }, { c: F.neogen, l: 'Neogen' }, { c: F.palaeogen, l: 'Paläogen' },
    { c: F.kreide, l: 'Kreide' }, { c: F.jura, l: 'Jura' }, { c: F.trias, l: 'Trias' },
    { c: F.perm, l: 'Perm' }, { c: F.karbon, l: 'Karbon' }, { c: F.devon, l: 'Devon' },
    { c: F.silur, l: 'Silur' }, { c: F.ordovizium, l: 'Ordovizium' }, { c: F.kambrium, l: 'Kambrium' },
    { c: F.praekambrium, l: 'Präkambrium' },
  ],
};

// ——— Historie: Signaturen im Wandel (Zellen viewBox 0 0 104 40)
const hachures = () => {
  let s = `<path d="M8 32 C34 18 66 14 96 10" fill="none" stroke="${F.tinte}" stroke-width=".5" opacity=".7"/>`;
  for (let i = 0; i < 15; i++) {
    const t = i / 14, x = 8 + t * 88, y = 32 - t * 22 + Math.sin(i * 2.1) * 1.2;
    const dx = 3.6 + Math.sin(i * 1.3) * 1.2, dy = 5.5 + Math.cos(i * .9) * 1.5;
    s += `<line x1="${(x - dx).toFixed(1)}" y1="${(y + dy).toFixed(1)}" x2="${x.toFixed(1)}" y2="${y.toFixed(1)}" stroke="${F.tinte}" stroke-width="${(0.9 - t * .5).toFixed(2)}" opacity=".75"/>`;
    s += `<line x1="${x.toFixed(1)}" y1="${y.toFixed(1)}" x2="${(x + dx * .8).toFixed(1)}" y2="${(y - dy * .7).toFixed(1)}" stroke="${F.tinte}" stroke-width=".35" opacity=".5"/>`;
  }
  return s;
};
const kuestenSchraffur = () => {
  let s = `<path d="M2 14 C30 8 70 20 102 12" fill="none" stroke="${F.tinte}" stroke-width=".8"/>`;
  [[3, .5, .8], [7, .35, .6], [11.5, .25, .4], [16.5, .18, .28]].forEach(([off, w, o]) => {
    s += `<path d="M2 ${14 + off} C30 ${8 + off} 70 ${20 + off} 102 ${12 + off}" fill="none" stroke="${F.tinte}" stroke-width="${w}" opacity="${o}"/>`;
  });
  return s;
};
const bathySteps = `<rect x="2" y="6" width="100" height="30" fill="${F.b0}"/><path d="M2 14 C30 12 70 18 102 13 L102 36 L2 36 z" fill="${F.b200}"/><path d="M2 22 C30 20 70 26 102 21 L102 36 L2 36 z" fill="${F.b2000}"/><path d="M2 30 C30 28 70 33 102 29 L102 36 L2 36 z" fill="${F.b4000}"/><path d="M2 6 C30 4 70 8 102 5" fill="none" stroke="${F.wasser}" stroke-width=".7"/>`;
const bahnKreuz = `<path d="M2 20 H102" stroke="${F.tinte}" stroke-width=".7"/>` + rep(10, 96, 9, x => `<line x1="${x - 2}" y1="17" x2="${x + 2}" y2="23" stroke="${F.tinte}" stroke-width=".5"/><line x1="${x + 2}" y1="17" x2="${x - 2}" y2="23" stroke="${F.tinte}" stroke-width=".5"/>`);
const bahnSchwarzweiss = `<path d="M2 20 H102" stroke="${F.tinte}" stroke-width="2.2"/>` + rep(2, 94, 16, x => `<rect x="${x + 8}" y="18.9" width="8" height="2.2" fill="${F.papier}" stroke="${F.tinte}" stroke-width=".35"/>`);
const bahnModern = `<path d="M2 20 H102" stroke="${F.papier}" stroke-width="4"/><path d="M2 20 H102" stroke="${F.tinte}" stroke-width="1.5"/>` + rep(8, 98, 12, x => `<line x1="${x}" y1="17" x2="${x}" y2="23" stroke="${F.tinte}" stroke-width="1.5"/>`);
const grenze1883 = `<rect x="2" y="20" width="100" height="7" fill="${F.pflaume}" opacity=".25"/><rect x="2" y="22" width="100" height="3" fill="${F.pflaume}" opacity=".2"/>` + rep(4, 100, 4.4, x => `<circle cx="${x}" cy="20" r=".8" fill="${F.tinte}"/>`);
const grenze1957 = `<rect x="2" y="4" width="100" height="16" fill="${F.orangeTint}"/><rect x="2" y="20" width="100" height="16" fill="${F.petrolTint}"/><path d="M2 20 H102" stroke="${F.tinte}" stroke-width=".6" stroke-dasharray="6 2 1.4 2"/>`;
const grenze2026 = `<rect x="2" y="20" width="100" height="5" fill="${F.pflaume}" opacity=".28"/><path d="M2 20 H102" stroke="${F.tinte}" stroke-width=".55" stroke-dasharray="7 2.2 1 2.2"/>`;
const ort1883 = `<circle cx="30" cy="20" r="3.4" fill="${F.tinte}"/><text x="40" y="24" font-family="${SERIF}" font-style="italic" font-weight="600" font-size="12">Bukarest</text>`;
const ort1957 = `<circle cx="30" cy="20" r="4.4" fill="${F.papier}" stroke="${F.tinte}" stroke-width="1.2"/><circle cx="30" cy="20" r="1.6" fill="${F.tinte}"/><text x="40" y="24" font-family="${SERIF}" font-weight="600" font-size="11">BUKAREST</text>`;
const ort2026 = `<circle cx="30" cy="20" r="4.6" fill="${F.papier}" stroke="${F.tinte}" stroke-width="1.9"/><circle cx="30" cy="20" r="1.2" fill="${F.tinte}"/><text x="40" y="23" font-family="${SERIF}" font-weight="600" font-size="11">Bucure\u0219ti</text><line x1="40" y1="27" x2="94" y2="27" stroke="${F.orange}" stroke-width="1"/>`;
const relief1957 = `<rect x="2" y="4" width="100" height="32" fill="${F.h500}"/><defs><radialGradient id="g-h57"><stop offset="0" stop-color="#4a4139" stop-opacity=".55"/><stop offset="1" stop-color="#4a4139" stop-opacity="0"/></radialGradient></defs><ellipse cx="45" cy="24" rx="36" ry="12" fill="url(#g-h57)"/>`;
const relief2026 = `<rect x="2" y="4" width="100" height="32" fill="${F.h0}"/><path d="M14 36 C30 12 44 8 58 14 C74 20 88 30 102 28 L102 36 z" fill="${F.h1000}"/><path d="M34 36 C44 18 54 16 64 22 C74 27 80 32 86 34 L86 36 z" fill="${F.h2000}"/><defs><radialGradient id="g-h26"><stop offset="0" stop-color="#4a4139" stop-opacity=".4"/><stop offset="1" stop-color="#4a4139" stop-opacity="0"/></radialGradient></defs><ellipse cx="56" cy="26" rx="30" ry="9" fill="url(#g-h26)"/>`;
const meer1957 = `<rect x="2" y="4" width="100" height="32" fill="#b8cfd4"/><path d="M2 8 C30 6 70 10 102 7" fill="none" stroke="${F.tinte}" stroke-width=".6"/>`;

export const HISTORIE = [
  { thema: 'Relief', sub: 'Schraffen \u2192 Schummerung \u2192 Höhenschichten + Schummerung', epochen: [hachures(), relief1957, relief2026] },
  { thema: 'Meer', sub: 'Küstenschraffur des Kupferstichs \u2192 Blaufläche \u2192 Tiefenstufen', epochen: [kuestenSchraffur(), meer1957, bathySteps] },
  { thema: 'Ortssignatur', sub: 'Vollpunkt \u2192 Größenklassen \u2192 Ringsignatur, Hauptstadt unterstrichen', epochen: [ort1883, ort1957, ort2026] },
  { thema: 'Eisenbahn', sub: 'Kreuzsprossen \u2192 Schwarzweißband \u2192 Casing + Sprossen', epochen: [bahnKreuz, bahnSchwarzweiss, bahnModern] },
  { thema: 'Staatsgrenze', sub: 'Punktreihe + Handkolorit \u2192 Flächenfarbe \u2192 Grenzkolorit innen', epochen: [grenze1883, grenze1957, grenze2026] },
];
export const EPOCHEN = ['1883 \u00b7 Kupferstich', '1957 \u00b7 Offsetdruck', '2026 \u00b7 dieses System'];
