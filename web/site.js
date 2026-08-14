// site.js — progressive enhancement for the web edition. Nothing here is load-bearing.
//
// The server delivers every page complete: the sheet list, all 272 register rows,
// the workshop documents. This file adds two things the browser is simply better
// placed to do, and the page stands without both.
//
// Note on language, as in the rest of web/: identifiers and comments are English,
// user-visible strings and DOM class names are German — the latter are shared
// vocabulary with site.css, Muster.dc.html and the templates.

// ---------------------------------------------------------------------------
// 1 · Signatures
//
// atlas/signaturen.js is the catalogue, drawn in the design UI and imported by
// every map sheet. The browser is its natural reader: a second parser in Ruby
// would be a second place that can disagree with the first, over a file this
// project treats as the single source for what a signature looks like.
//
// The sheet → signature mapping is a cartographic decision, not a technical one,
// which is why it is written out rather than derived from the file name.
// ---------------------------------------------------------------------------

const SIGNATUR = {
  'Rumaenien-Physisch.html': ['relief', 'Schummerung'],
  'Rumaenien-Wirtschaft.html': ['energie', 'Erdölleitung'],
  'Rumaenien-Verkehr.html': ['bahnen', 'Bahnhof, Haltepunkt'],
  'Banat-Liniennetz.dc.html': ['bevoelkerung', 'Pendlerverflechtung'],
  'Rumaenien-Braunbaer.html': ['umwelt', 'Nationalpark'],
  'Rumaenien-Landschaften.html': ['politisch', 'Staatsfläche: Grenzkolorit'],
  'Brandenburg-Klima.html': ['klima', 'Klimastation'],
  'Loreley-Relief.html': ['relief', 'Böschung, Steilstufe'],
  'Zeichenerklaerung.dc.html': ['chrome', 'Maßstabsbalken'],
  'QGIS-Kartensatz.dc.html': ['chrome', 'Gradnetz'],
};

// Original size 104×26: signatures are calibrated in millimetres and not scaled.
const VIEWBOX = { w: 104, h: 26 };

async function drawSignatures() {
  const slots = document.querySelectorAll('.blatt-sig[data-signatur]');
  if (!slots.length) return;

  let catalogue;
  try {
    catalogue = await import('/atlas/signaturen.js');
  } catch (e) {
    // A missing catalogue leaves the slots empty, which is what they already are.
    console.error('Signaturenkatalog nicht ladbar:', e);
    return;
  }
  if (!catalogue.KATALOG) return;

  for (const slot of slots) {
    const raw = signatureFor(catalogue, slot.dataset.signatur);
    if (!raw) continue;
    slot.innerHTML =
      `<svg viewBox="0 0 ${VIEWBOX.w} ${VIEWBOX.h}" width="${VIEWBOX.w}" height="${VIEWBOX.h}" aria-hidden="true">${raw}</svg>`;
  }
}

function signatureFor(catalogue, file) {
  // The agriculture sheet draws its own hemp signature rather than picking one
  // from a family — same call the sheet itself makes.
  if (file === 'Brandenburg-Landwirtschaft.html') {
    return catalogue.hanfRaws ? catalogue.hanfRaws('brokkoli').anbau : null;
  }
  const map = SIGNATUR[file];
  if (!map) return null;
  const entry = (catalogue.KATALOG[map[0]] || []).find((x) => x.n === map[1]);
  // Only raw SVG entries can be placed without the legend renderer.
  return entry && entry.k === 'svg' ? entry.raw : null;
}

// ---------------------------------------------------------------------------
// 2 · Register filter
//
// The server already filtered and rendered; the form works on its own and every
// filtered view is a real address. This hides rows as you type, so the 272-row
// table answers without a round trip. It never fetches and never rewrites the
// URL — pressing Enter still submits the form and lands on a linkable page.
// ---------------------------------------------------------------------------

function wireRegisterFilter() {
  const form = document.querySelector('[data-register-filter]');
  const table = document.getElementById('registertabelle');
  const counter = document.getElementById('treffer');
  if (!form || !table) return;

  const rows = [...table.tBodies[0].rows];
  const total = rows.filter((r) => !r.classList.contains('anmerkung')).length;

  const draw = () => {
    const q = form.querySelector('#suche').value.trim().toLowerCase();
    const art = form.querySelector('#art').value;
    const status = form.querySelector('#status').value;

    let hits = 0;
    let lastVisible = false;

    for (const row of rows) {
      // A note row follows its entry and shares its fate.
      if (row.classList.contains('anmerkung')) {
        row.hidden = !lastVisible;
        continue;
      }
      const show =
        (!q || row.dataset.name.includes(q)) &&
        (!art || row.dataset.art === art) &&
        (!status || row.dataset.status === status);
      row.hidden = !show;
      lastVisible = show;
      if (show) hits++;
    }

    if (counter) counter.textContent = `${hits} von ${total}`;
  };

  form.addEventListener('input', draw);
  form.addEventListener('change', draw);
}

drawSignatures();
wireRegisterFilter();
