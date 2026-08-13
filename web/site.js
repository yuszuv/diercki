// site.js — the web edition of the atlas.
//
// Three strands, equal in weight: Blätter (showcase), Register (reference work),
// Werkstatt (journal). Everything is read AT RUNTIME — the sheet list from the
// README, the name register from register.csv, the prose from the .md files. No
// build step, following the rule in CLAUDE.md: a correction in a file shows up
// immediately, and there is no derived copy that can quietly go stale.
//
// Where something is missing, nothing is guessed: a sheet without a README entry
// gets its own visible class, exactly like a hemp variety without a table row on
// the map sheet.
//
// Note on language: identifiers and comments are English, user-visible strings and
// DOM class names are German — the latter are shared vocabulary with site.css and
// the markup.

import { renderMarkdown, headings } from './md.js';

const $ = (sel, root = document) => root.querySelector(sel);
const el = (tag, cls, html) => {
  const n = document.createElement(tag);
  if (cls) n.className = cls;
  if (html != null) n.innerHTML = html;
  return n;
};
const esc = (s) =>
  String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

const fetchText = async (path) => {
  const r = await fetch(path, { cache: 'no-cache' });
  if (!r.ok) throw new Error(`${r.status} ${path}`);
  return r.text();
};

const fetchJson = async (path) => {
  try {
    const r = await fetch(path, { cache: 'no-cache' });
    return r.ok ? await r.json() : [];
  } catch {
    return [];
  }
};

// ---------------------------------------------------------------------------
// Signatures. Same approach as Inhalt.dc.html: the catalogue is loaded as a module,
// and only the raw SVG entries (k === 'svg') can be placed without the legend
// renderer. The sheet → signature mapping is taken from there — it is a
// cartographic decision, not a technical one.
// ---------------------------------------------------------------------------
const SIGNATURE = {
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

let catalogue = null;
async function signatureFor(file) {
  if (!catalogue) {
    try {
      catalogue = await import('/atlas/signaturen.js');
    } catch (e) {
      console.error('Signaturenkatalog nicht ladbar:', e);
      catalogue = {};
      return null;
    }
  }
  if (!catalogue.KATALOG) return null;
  if (file === 'Brandenburg-Landwirtschaft.html') {
    return catalogue.hanfRaws ? catalogue.hanfRaws('brokkoli').anbau : null;
  }
  const map = SIGNATURE[file];
  if (!map) return null;
  const entry = (catalogue.KATALOG[map[0]] || []).find((x) => x.n === map[1]);
  return entry && entry.k === 'svg' ? entry.raw : null;
}

// Original size 104×26: the signatures are calibrated in millimetres and not scaled.
const svgWrap = (raw) =>
  `<svg viewBox="0 0 104 26" width="104" height="26" aria-hidden="true">${raw}</svg>`;

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

// The sheet list is the table in the README — deliberately not a second list here.
// Add a sheet and forget the README, and it shows up below as an open case.
function tableAfter(md, headingLine) {
  const lines = md.split('\n');
  let i = lines.findIndex((l) => l.trim() === headingLine);
  if (i < 0) return [];
  const rows = [];
  for (i++; i < lines.length; i++) {
    const l = lines[i];
    if (/^#{1,6}\s/.test(l)) break;
    if (!l.includes('|')) continue;
    if (/^\s*\|?[\s:|-]+$/.test(l)) continue;
    const cells = l.replace(/^\s*\|/, '').replace(/\|\s*$/, '').split('|').map((c) => c.trim());
    if (cells.length < 2) continue;
    const file = cells[0].replace(/`/g, '').trim();
    if (!/\.(html|dc\.html)$/.test(file)) continue;
    rows.push({ file, text: cells[1] });
  }
  return rows;
}

const listing = (path) => fetchJson('/_index/' + path);

// register.csv: comment lines with #, then a header row, semicolon separated.
function parseCsv(text) {
  const lines = text.split('\n').filter((l) => l.trim() && !l.startsWith('#'));
  if (!lines.length) return [];
  const head = lines[0].split(';').map((s) => s.trim());
  return lines.slice(1).map((l) => {
    const cells = l.split(';');
    const row = {};
    head.forEach((k, i) => (row[k] = (cells[i] ?? '').trim()));
    return row;
  });
}

const cache = {};
async function data() {
  if (cache.ready) return cache;
  const [readme, registerRaw, root] = await Promise.all([
    fetchText('/README.md'),
    fetchText('/atlas/register.csv'),
    listing(''),
  ]);

  cache.sheets = [...tableAfter(readme, '## Blätter'), ...tableAfter(readme, '## Weitere Blätter')];
  cache.decks = tableAfter(readme, '## Präsentationen');
  cache.register = parseCsv(registerRaw);

  // Cross-check both ways — both are documentation faults, both stay visible.
  const listed = new Set([...cache.sheets, ...cache.decks].map((s) => s.file));
  cache.withoutEntry = root
    .filter((e) => e.type === 'file' && /\.html$/.test(e.name) && !listed.has(e.name))
    .map((e) => e.name);

  const present = new Set(root.filter((e) => e.type === 'file').map((e) => e.name));
  cache.withoutFile = cache.sheets.filter((s) => !s.file.includes('/') && !present.has(s.file));

  cache.ready = true;
  return cache;
}

// ---------------------------------------------------------------------------
// Views
// ---------------------------------------------------------------------------

const pageHead = (title, lead) =>
  `<h1>${esc(title)}</h1><div class="regel"></div>${lead ? `<p class="vorspann">${lead}</p>` : ''}`;

async function viewHome(target) {
  const d = await data();
  const num = (n) => `<span class="zahl">${n}</span>`;

  target.innerHTML = `
    ${pageHead('Sternprodukt-Atlas', 'Ein Weltatlas nach dem Vorbild des Diercke-Klassikers, gezeichnet mit D3 im Browser. Blätter zu Rumänien und Brandenburg, eine Zeichenerklärung nach Atlas-Vorbild und der QGIS-Kartensatz dahinter.')}
    <div class="straenge">
      <a class="strang" href="#/blaetter">
        <span class="strang-nr">I</span>
        <span class="strang-titel">Blätter</span>
        <span class="strang-text">Der Schaukasten. ${num(d.sheets.length)} Blätter, jedes eine eigenständige Datei, jedes mit der Signatur, die für sein Thema steht.</span>
      </a>
      <a class="strang" href="#/register">
        <span class="strang-nr">II</span>
        <span class="strang-titel">Register</span>
        <span class="strang-text">Das Nachschlagewerk. ${num(d.register.length)} Namen — Orte, Gipfel, Flüsse, Strecken, Kreise — jeder mit seinem Blatt und seinem Belegstatus.</span>
      </a>
      <a class="strang" href="#/werkstatt">
        <span class="strang-nr">III</span>
        <span class="strang-titel">Werkstatt</span>
        <span class="strang-text">Das Gerüst darunter: Quellenregister, Recherche-Notizen, Glossar, die Regeln, nach denen gezeichnet wird.</span>
      </a>
    </div>

    <div class="zufall-block">
      <p>Wer nichts Bestimmtes sucht, fängt irgendwo an.</p>
      <button class="knopf" id="zufall">Zufälliger Einstieg</button>
    </div>

    <div class="hinweis">
      <p><b>Was dieser Atlas anders macht:</b> Jede Zahl auf einer Karte hat eine Zeile im
      Quellenregister, mit einem von drei Status — <em>belegt</em>, <em>abgeleitet</em>,
      <em>unbelegt</em>. Unbelegtes wird auf dem Blatt als solches gekennzeichnet, statt
      still mitzulaufen. Wo eine Zuordnung fehlt, wird sie nicht geraten: der Fall bekommt
      eine eigene, sichtbare Klasse.</p>
    </div>
  `;

  $('#zufall', target).addEventListener('click', () => {
    const all = [
      ...d.sheets.map((s) => ({ kind: 'sheet', to: '/' + s.file })),
      ...d.register
        .filter((r) => r.name)
        .map((r) => ({ kind: 'entry', to: '#/register?q=' + encodeURIComponent(r.name) })),
    ];
    const pick = all[Math.floor(Math.random() * all.length)];
    if (pick.kind === 'sheet') window.open(pick.to, '_blank', 'noopener');
    else location.hash = pick.to.slice(1);
  });
}

async function viewSheets(target) {
  const d = await data();
  target.innerHTML = `
    ${pageHead('Blätter', 'Jedes Blatt ist eine eigenständige Datei und öffnet für sich. Die Liste kommt aus den Blätter-Tabellen der README — sie ist die eine Stelle, an der sie gepflegt wird.')}
    <div id="kasten" class="kasten"></div>
    <h2>Präsentationen und Vorlagen</h2>
    <div id="kasten-p" class="kasten schmal"></div>
    <div id="warnungen"></div>
  `;

  const build = async (list, into) => {
    for (const s of list) {
      const card = el('a', 'blatt');
      card.href = '/' + s.file;
      card.target = '_blank';
      card.rel = 'noopener';
      const raw = await signatureFor(s.file);
      card.innerHTML = `
        <span class="blatt-sig">${raw ? svgWrap(raw) : ''}</span>
        <span class="blatt-text">
          <span class="blatt-kopf">
            <span class="blatt-titel">${esc(s.file.replace(/\.(dc\.)?html$/, '').replace(/-/g, ' '))}</span>
            <span class="blatt-datei">${esc(s.file)}</span>
          </span>
          <span class="blatt-beschreibung">${renderMarkdown(s.text).replace(/^<p>|<\/p>$/g, '')}</span>
        </span>`;
      into.appendChild(card);
    }
  };

  await build(d.sheets, $('#kasten', target));
  await build(d.decks, $('#kasten-p', target));

  const warn = $('#warnungen', target);
  if (d.withoutEntry.length) {
    warn.appendChild(
      el(
        'div',
        'fehlfall',
        `<b>Ohne Eintrag in der README:</b> ${d.withoutEntry
          .map((n) => `<a href="/${esc(n)}" target="_blank" rel="noopener">${esc(n)}</a>`)
          .join(' · ')}
         <br><span class="fehlfall-grund">Diese Dateien liegen im Wurzelverzeichnis, stehen aber in keiner Tabelle. Sie verschwinden hier nicht — sie stehen als offener Fall.</span>`
      )
    );
  }
  if (d.withoutFile.length) {
    warn.appendChild(
      el(
        'div',
        'fehlfall',
        `<b>In der README, aber nicht vorhanden:</b> ${d.withoutFile.map((s) => esc(s.file)).join(' · ')}`
      )
    );
  }
}

// The kinds are listed in the header comment of register.csv — incompletely, though:
// the file also carries pass, grosslandschaft and stausee. What is missing here is
// not swallowed, it is shown raw.
const KIND_LABEL = {
  hauptstadt: 'Hauptstadt', stadt: 'Stadt', ort: 'Ort', gipfel: 'Gipfel',
  gebirge: 'Gebirge', grosslandschaft: 'Großlandschaft', landschaft: 'Landschaft',
  fluss: 'Fluss', stausee: 'Stausee', park: 'Park', pass: 'Pass',
  bahnhof: 'Bahnhof', haltestelle: 'Haltestelle', klimastation: 'Klimastation',
  strecke: 'Strecke', energie: 'Energie', kreis: 'Kreis',
  trachtgebiet: 'Trachtgebiet', begegnung: 'Begegnung', verweis: 'Verweis',
};

async function viewRegister(target, query) {
  const d = await data();
  const kinds = [...new Set(d.register.map((r) => r.art).filter(Boolean))].sort();

  target.innerHTML = `
    ${pageHead('Namensregister', 'Wie im gebundenen Band: jeder Name mit dem Blatt, auf dem er steht. Die Spalte <em>Status</em> gilt dem Eintrag, nicht dem Blatt — sie sagt, ob die Angabe belegt ist.')}
    <div class="filterleiste">
      <input type="search" id="suche" placeholder="Namen suchen …" autocomplete="off" value="${esc(query || '')}">
      <select id="art"><option value="">alle Arten</option>${kinds
        .map((k) => `<option value="${esc(k)}">${esc(KIND_LABEL[k] || k)}</option>`)
        .join('')}</select>
      <select id="status"><option value="">alle Belegstatus</option><option value="belegt">belegt</option><option value="abgeleitet">abgeleitet</option><option value="unbelegt">unbelegt</option></select>
      <span class="treffer" id="treffer"></span>
    </div>
    <div class="tabelle-rahmen"><table class="register">
      <thead><tr><th>Name</th><th>Art</th><th>Blätter</th><th>Feld</th><th>Wert</th><th>Status</th></tr></thead>
      <tbody id="zeilen"></tbody>
    </table></div>
  `;

  const draw = () => {
    const q = $('#suche', target).value.trim().toLowerCase();
    const kind = $('#art', target).value;
    const status = $('#status', target).value;
    const hits = d.register.filter(
      (r) =>
        r.name &&
        (!q || r.name.toLowerCase().includes(q) || (r.variante || '').toLowerCase().includes(q)) &&
        (!kind || r.art === kind) &&
        (!status || r.status === status)
    );
    $('#treffer', target).textContent = `${hits.length} von ${d.register.length}`;
    $('#zeilen', target).innerHTML = hits
      .map((r) => {
        // "Feld offen" only means something where a search grid exists — and only
        // sheet 4 carries one (see the header comment in register.csv). Saying it
        // for the other 157 entries would claim an absence that is not one.
        const onGridSheet = (r.blaetter || '').split(/\s+/).includes('4');
        const feld = r.feld
          ? esc(r.feld)
          : onGridSheet
            ? '<span class="offen">Feld offen</span>'
            : '';
        return `<tr>
          <td class="z-name"><b>${esc(r.name)}</b>${r.variante ? ` <span class="variante">${esc(r.variante)}</span>` : ''}</td>
          <td class="z-art">${esc(KIND_LABEL[r.art] || r.art || '')}</td>
          <td class="z-blatt mono">${esc(r.blaetter || '')}</td>
          <td class="z-feld mono">${feld}</td>
          <td class="z-wert">${esc(r.wert || '')}</td>
          <td class="z-status"><span class="status status-${esc(r.status || 'unbelegt')}">${esc(r.status || '—')}</span></td>
        </tr>${r.anmerkung ? `<tr class="anmerkung"><td colspan="6">${esc(r.anmerkung)}</td></tr>` : ''}`;
      })
      .join('');
  };

  ['#suche', '#art', '#status'].forEach((sel) => {
    $(sel, target).addEventListener('input', draw);
    $(sel, target).addEventListener('change', draw);
  });
  draw();
}

// Fixed entries plus two directories that are listed at runtime.
const WORKSHOP_FIXED = [
  ['Aufbau des Repos', 'README.md'],
  ['Verbindliche Regeln', 'CLAUDE.md'],
  ['Einstieg für Agents', 'AGENTS.md'],
  ['Glossar der Fachbegriffe', 'atlas/GLOSSAR.md'],
  ['Signaturenkatalog — Regeln', 'atlas/SIGNATUREN.md'],
  ['Welches Skript welche Datei erzeugt', 'atlas/geodaten/LIESMICH.md'],
  ['Hanfsorten und Nutzungsrichtung', 'atlas/geodaten/brandenburg/SORTEN.md'],
  ['Klimastationen', 'atlas/geodaten/brandenburg/KLIMA.md'],
  ['Geodaten Brandenburg', 'atlas/geodaten/brandenburg/README.md'],
  ['Was an Daten fehlt', 'DATENBEDARF.md'],
  ['Backlog und lose Enden', 'IDEEN.md'],
  ['Repo-Bindung und Sync-Stand', 'github.md'],
];

async function viewWorkshop(target) {
  const [sources, notes] = await Promise.all([listing('atlas/quellen/'), listing('recherche/')]);
  const onlyMd = (v) => v.filter((e) => e.type === 'file' && e.name.endsWith('.md'));

  const list = (entries) =>
    entries
      .map(
        ([title, path]) => `<a class="dok" href="#/werkstatt/${encodeURIComponent(path)}">
        <span class="dok-titel">${esc(title)}</span>
        <span class="dok-pfad">${esc(path)}</span></a>`
      )
      .join('');

  const prettify = (name) => name.replace(/\.md$/, '').replace(/-/g, ' ');

  target.innerHTML = `
    ${pageHead('Werkstatt', 'Kein Blatt, sondern das Gerüst darunter — Register, Notizen, Regeln. Alles wird aus den Dateien im Repo gelesen; was hier steht, ist der aktuelle Stand und keine Kopie.')}
    <h2>Quellenregister</h2>
    <p class="abschnitt-text">Für jedes Blatt eine Datei. Jede Zahl, die auf einer Karte steht, hat hier eine Zeile mit Status.</p>
    <div class="doks">${list(onlyMd(sources).map((e) => [prettify(e.name), 'atlas/quellen/' + e.name]))}</div>
    <h2>Recherche und Entscheidungen</h2>
    <p class="abschnitt-text">Festgehaltenes aus dem Bauen — warum etwas so ist, wie es ist.</p>
    <div class="doks">${list(onlyMd(notes).map((e) => [prettify(e.name), 'recherche/' + e.name]))}</div>
    <h2>Kataloge, Regeln, Nachschlagen</h2>
    <div class="doks">${list(WORKSHOP_FIXED)}</div>
  `;
}

async function viewDocument(target, path) {
  target.innerHTML = '<p class="laedt">wird geladen …</p>';
  let text;
  try {
    text = await fetchText('/' + path);
  } catch {
    target.innerHTML = `${pageHead('Nicht gefunden', `<code>${esc(path)}</code> gibt es nicht. Das ist ein Doku-Fehler und keine Nebensache — wer den Verweis gesetzt hat, hat ihn nicht geprüft.`)}
      <p><a href="#/werkstatt">zurück zur Werkstatt</a></p>`;
    return;
  }
  const toc = headings(text);
  target.innerHTML = `
    <div class="dokument-kopf">
      <a class="zurueck" href="#/werkstatt">← Werkstatt</a>
      <span class="dok-pfad mono">${esc(path)}</span>
    </div>
    ${toc.length > 2 ? `<nav class="gliederung"><div class="gliederung-titel">Auf dieser Seite</div>${toc.map((h) => `<a href="#${h.id}" class="ebene-${h.level}">${esc(h.text)}</a>`).join('')}</nav>` : ''}
    <article class="prosa">${renderMarkdown(text)}</article>
  `;
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------
const ROUTES = [
  [/^\/?$/, viewHome],
  [/^\/blaetter$/, viewSheets],
  [/^\/register/, viewRegister],
  [/^\/werkstatt$/, viewWorkshop],
  [/^\/werkstatt\/(.+)$/, viewDocument],
];

async function route() {
  const raw = location.hash.replace(/^#/, '') || '/';
  const [path, search] = raw.split('?');
  const target = $('#inhalt');

  document.querySelectorAll('.nav a').forEach((a) => {
    const href = a.getAttribute('href').replace(/^#/, '');
    a.classList.toggle('aktiv', href === path || (href !== '/' && path.startsWith(href)));
  });

  for (const [pattern, view] of ROUTES) {
    const m = path.match(pattern);
    if (!m) continue;
    try {
      const q = new URLSearchParams(search || '').get('q');
      await view(target, m[1] ? decodeURIComponent(m[1]) : q);
    } catch (e) {
      console.error(e);
      target.innerHTML = `${pageHead('Etwas fehlt', 'Eine Datei, die diese Ansicht braucht, ließ sich nicht laden.')}<pre><code>${esc(e.message)}</code></pre>`;
    }
    window.scrollTo(0, 0);
    return;
  }
  target.innerHTML = pageHead('Nichts unter dieser Adresse', 'Zurück zur <a href="#/">Startseite</a>.');
}

window.addEventListener('hashchange', route);
window.addEventListener('DOMContentLoaded', route);
