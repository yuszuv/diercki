// Sternprodukt-Atlas — Typenscale
// Eine Staffel für alle Blätter. Vorher trug ein einzelnes Blatt 26 Grade
// zwischen 4,8 und 12 pt, viele davon 0,1 pt auseinander — das erzeugt keine
// Hierarchie, sondern Streuung. Sieben Stufen genügen; wer eine achte braucht,
// hat meist ein Inhaltsproblem, kein Typografieproblem.
//
// Werte in px bei 96 dpi (1 px = 0,2646 mm). Die pt-Angabe ist der Druckwert.
// UNTERGRENZE 5,5 pt: darunter schließt Lasertoner die Punzen — aus einem e
// wird ein Fleck. Gilt ausnahmslos, auch für Gradnetzzahlen und Exonyme.

export const T = {
  //         px     pt    wofür
  klein:     7.3, //  5,5  Exonyme, Gradnetz, Randvermerke, Nebenkarten-Kennung
  mono:      8.0, //  6,0  Mono-Zusatz: Kreiswerte, Koordinaten, Maßstabszahlen
  situation: 8.7, //  6,5  Regelschrift im Kartenfeld: kleine Orte, Landschaften
  legende:   9.5, //  7,1  Zeichenerklärung, mittlere Orte, Erläuterungen
  gross:    10.7, //  8,0  große Orte, Vorspann, Nebenkarten-Titel
  kopf:     12.0, //  9,0  Spaltenüberschriften, Hauptstadt
  titel:    15.3, // 11,5  Blattkopf
};

// pt-Werte zur Kontrolle beim Prüfen
export const TPT = Object.fromEntries(Object.entries(T).map(([k, v]) => [k, +(v * 0.75).toFixed(1)]));

// Untergrenze — jede abgeleitete Größe (z. B. Exonym = 0,78 × Ortsname)
// muss hier durch, sonst rutscht sie unbemerkt darunter.
export const MIN = T.klein;
export const clamp = px => Math.max(MIN, px);

// Schriftfamilien und Auszeichnung, damit die Blätter sie nicht je einzeln setzen.
export const SERIF = "'Gentium Book Plus','Noto Serif',serif";
export const MONO = "'Noto Sans Mono',monospace";

// Rolle → fertige Attribute. Mono kennt nur 400 und 500; ein synthetisches 700
// gibt es nicht, Betonung trägt dort Versalabstand und Farbe.
export const ROLLE = {
  ort:        { family: SERIF, size: T.situation, weight: 400 },
  ortGross:   { family: SERIF, size: T.gross, weight: 600 },
  hauptstadt: { family: SERIF, size: T.kopf, weight: 600, letterSpacing: '.02em' },
  exonym:     { family: SERIF, size: T.klein, weight: 400, style: 'italic' },
  landschaft: { family: SERIF, size: T.situation, weight: 400, style: 'italic', letterSpacing: '.12em' },
  gewaesser:  { family: SERIF, size: T.situation, weight: 400, style: 'italic' },
  staat:      { family: SERIF, size: T.gross, weight: 600, letterSpacing: '.14em' },
  technik:    { family: MONO, size: T.mono, weight: 500, letterSpacing: '.05em' },
  gradnetz:   { family: MONO, size: T.klein, weight: 500, letterSpacing: '.06em' },
  legende:    { family: SERIF, size: T.legende, weight: 400 },
  legendeKopf:{ family: SERIF, size: T.kopf, weight: 600 },
  vorspann:   { family: SERIF, size: T.gross, weight: 400, style: 'italic' },
  blattkopf:  { family: SERIF, size: T.titel, weight: 600, letterSpacing: '-.02em' },
  blattnummer:{ family: MONO, size: T.klein, weight: 500, letterSpacing: '.08em' },
};

// Für D3: .call(setzen, ROLLE.ort)
export const setzen = (sel, r) => sel
  .attr('font-family', r.family).attr('font-size', r.size)
  .attr('font-weight', r.weight ?? 400)
  .attr('font-style', r.style ?? 'normal')
  .attr('letter-spacing', r.letterSpacing ?? 'normal');

// Als CSS-Deklaration, für die HTML-Teile der Blätter
export const css = r => `font-family:${r.family};font-size:${r.size}px;font-weight:${r.weight ?? 400}`
  + (r.style ? `;font-style:${r.style}` : '')
  + (r.letterSpacing ? `;letter-spacing:${r.letterSpacing}` : '');
