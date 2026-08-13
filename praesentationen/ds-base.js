// Loads the bound Sternprodukt design system (one level below project root).
(() => {
  const base = '../_ds/sternprodukt-design-system-760a3f03-bdcc-480e-bb81-66fc2988f194';
  for (const p of ["styles.css"]) {
    const l = document.createElement('link');
    l.rel = 'stylesheet'; l.href = base + '/' + p;
    document.head.appendChild(l);
  }
  const s = document.createElement('script');
  s.src = base + '/_ds_bundle.js';
  s.onerror = () => console.error('ds-base.js: failed to load ' + s.src);
  document.head.appendChild(s);
})();
