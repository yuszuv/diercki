# Sternprodukt — Recherche-Notizen (für Pitch-Deck & Präsen)

Stand: 2026-08-07. Quellen: Wikipedia (Sternprodukt, Konzewitschs Formel), nLab
(C*-algebraic deformation quantization), EMS/Oberwolfach-Report „between formal
and strict", arXiv 1502.00097 (Recent Developments), 1604.05873 (Gutt),
1809.07953 (Wick-Typ), DPG 2007 Heidelberg (MP-Programm).

## Kernidee
- Klassische Mechanik: Observablen = C^∞(M) auf dem Phasenraum (Poisson-Mannigfaltigkeit),
  kommutativ, punktweises Produkt ·. QM: nichtkommutative Observablenalgebra.
- Deformationsquantisierung: statt Hilberträume zu bauen, wird die *Algebra* deformiert.
  f ⋆ g = f·g + λC₁(f,g) + λ²C₂(f,g) + … ; C_n Bidifferentialoperatoren,
  λ ≙ iℏ/2 bzw. ℏ. Assoziativ, nicht mehr kommutativ.
- Axiome: C₀(f,g) = fg; C₁(f,g) − C₁(g,f) = i{f,g} — erste Ordnung ist die
  Poisson-Klammer. Klassischer Limes ℏ→0 ist eingebaut, nicht nachgereicht.
- Warum nicht kanonisch quantisieren? Groenewold–van Hove: eine „vollständige"
  kanonische Quantisierung ist ausgeschlossen. Deformation umgeht das.

## Meilensteine
- 1927/1946/1949: Weyl, Groenewold, Moyal — Moyal-Produkt auf R²ⁿ (der Prototyp).
- 1978: Bayen–Flato–Frønsdal–Lichnerowicz–Sternheimer — Programm „Quantisierung
  ist Deformation" (Ann. Phys. 111).
- 1983: De Wilde–Lecomte — Existenz auf jeder symplektischen Mannigfaltigkeit.
- ~1994: Fedosov — geometrische, konstruktive Variante (Fedosov-Konstruktion).
- 1997: Kontsevich — Formalitätstheorem: jede Poisson-Mannigfaltigkeit ist
  quantisierbar; Formel über Graphen-Gewichte; Klassifikation der
  Äquivalenzklassen. (Fields-Medaille 1998.)

## Formal vs. strikt — genau Jans Thema
- Formale DQ: ⋆ lebt in C^∞(M)[[ℏ]], formale Potenzreihen. Algebraisch sauber,
  aber physikalisch unbefriedigend: man kann ℏ = 1.05×10⁻³⁴ nicht *einsetzen* —
  Konvergenz ungeklärt.
- Strikte / C*-algebraische DQ (Rieffel, Landsman): stetiges Feld von
  C*-Algebren über ℏ ∈ [0,ε); ‖f‖_ℏ stetig in ℏ; bei ℏ=0 die kommutative
  Algebra; ‖(f⋆g − g⋆f)/iℏ − {f,g}‖ → 0. „Stetigkeit von Sternprodukten"
  = der Brückenschlag: Konvergenz der formalen Reihe auf geeigneten
  Unteralgebren in geeigneter (lokalkonvexer/Fréchet-)Topologie zeigen,
  dann vervollständigen — im besten Fall bis zur C*-Algebra.
- Offen bis heute: keine geschlossene Theorie; welche formalen Produkte
  konvergieren, ist Einzelfallarbeit (Moyal, Gutt, Wick-Typ auf koadjungierten
  Bahnen, kombinatorische Produkte …). Rieffels Ansatz deckt z. B. die S²
  mit SO(3)-invarianter symplektischer Struktur nicht ab.
## Darstellungstheorie & GNS — wie der Hilbertraum zurückkommt
Der Einwand gegen den algebraischen Zugang lautet: wo ist der Hilbertraum
geblieben? Antwort: er wird nicht vorausgesetzt, sondern *konstruiert* — und
zwar aus der Algebra plus einem Zustand. Das ist die Pointe, die die
Deformationsquantisierung mit der C*-Welt teilt.

- **Zustand** = positives lineares Funktional ω auf der Observablenalgebra A,
  normiert (ω(1)=1). Physikalisch: die Vorschrift, die jeder Observablen ihren
  Erwartungswert zuordnet. Kein Vektor, kein Strahl — nur eine Abbildung.
- **GNS (Gelfand–Naimark–Segal)**: aus (A, ω) wird
  1. eine Sesquilinearform ⟨a,b⟩ := ω(a*b) auf A;
  2. der Gelfand-Ideal J_ω = {a : ω(a*a)=0} — die Nullrichtungen der Form;
  3. der Quotient A/J_ω, darauf ist ⟨·,·⟩ positiv definit → Prä-Hilbertraum;
  4. Vervollständigung H_ω, und A wirkt darauf durch Linksmultiplikation:
     π_ω(a)[b] = [ab]. Dazu der zyklische Vektor Ω = [1] mit
     ω(a) = ⟨Ω, π_ω(a) Ω⟩.
- Ergebnis: **jeder Zustand erzeugt seine eigene Darstellung.** Der Hilbertraum
  ist nicht mehr die Bühne, sondern das Produkt. Verschiedene ω können
  unitär inäquivalente Darstellungen liefern — bei unendlich vielen
  Freiheitsgraden (Feldtheorie) der Normalfall, siehe Haag'sches Theorem;
  in der QM endlich vieler Freiheitsgrade dagegen Stone–von Neumann:
  alle irreduziblen regulären Darstellungen der Weyl-Relationen sind unitär
  äquivalent.
- **Gelfand–Naimark**: jede C*-Algebra ist isometrisch *-isomorph zu einer
  Unteralgebra von B(H) — die algebraische Beschreibung verliert nichts.
  Kommutativer Fall: A ≅ C₀(X) mit X = Spektrum (Gelfand-Dualität) — genau
  der Punkt, an dem „Raum" und „Algebra" dasselbe sagen. Nichtkommutative
  Geometrie beginnt damit, dass man den Raum wegwirft und die Algebra behält.
- **Im formalen Setting** funktioniert das genauso, nur über dem Ring
  C[[λ]] statt C: positive Funktionale mit Werten in formalen Laurent-Reihen,
  GNS liefert Prä-Hilbert-Moduln. Bordemann–Waldmann haben das
  ausgearbeitet — die Deltafunktional-artigen Zustände liefern dabei die
  bekannten Darstellungen (Schrödinger, Bargmann–Fock je nach Ordnung).
  Das Wick-Sternprodukt und die Bargmann–Fock-Darstellung gehören zusammen,
  das Weyl-geordnete Moyal-Produkt und die Schrödinger-Darstellung ebenso.
- **Warum das für die Stetigkeitsfrage zählt**: die GNS-Darstellung ist der
  Ort, an dem eine Norm entsteht — die Operatornorm von π_ω(a) auf H_ω.
  Wer zeigen will, dass ein formales Sternprodukt zu einer C*-Algebra
  vervollständigt, braucht stetige positive Funktionale; deren Existenz ist
  genau der Hebel (vgl. Strict-Quantization-Arbeiten: stetige positive
  Funktionale erlauben die treue Darstellung auf einem Prä-Hilbertraum).
  Stetigkeit des Produkts → Stetigkeit der Darstellung → Norm → C*-Abschluss.

Kette in einem Satz: **Poisson-Mannigfaltigkeit → deformierte Algebra →
Zustand → GNS → Hilbertraum.** Der Hilbertraum steht am Ende, nicht am Anfang.

## Freiburg-Kontext (Waldmann-Gruppe)
- Stefan Waldmann: „Poisson-Geometrie und Deformationsquantisierung"
  (Springer 2007) — das deutschsprachige Lehrbuch; Gruppe in Freiburg
  (später Würzburg). Nikolai Neumaier ebendort; DPG 2007: Neumaier/Waldmann/Weiß,
  „Deformationsquantisierung surjektiver Submersionen".
- Jans Diplomarbeit: Deformationsquantisierung, Stetigkeit von Sternprodukten —
  im Umfeld genau dieser Schule.

## Pitch-Deck-taugliche Pointen
- „Wir verkaufen ein Produkt, das seit 1927 in Entwicklung ist."
- Marktlücke: das punktweise Produkt ist kommutativ — „das reicht heute nicht mehr".
- USP: klassischer Limes serienmäßig (ℏ→0 eingebaut).
- Skalierung: existiert auf *jeder* Poisson-Mannigfaltigkeit (Kontsevich) —
  „total addressable manifold".
- Risiko-Folie: Konvergenz. „Formal sind wir profitabel; strikt arbeiten wir dran."
- Die 137 als Kennzahl-Gag (α⁻¹).
- Wettbewerb: kanonische Quantisierung (Groenewold–van Hove als „Wettbewerber
  ist gescheitert"), geometrische Quantisierung, Pfadintegral.
- „Der Hilbertraum ist bei uns kein Input, sondern ein Output" — GNS als
  Fertigungsschritt statt als Annahme.

## Offener Prüfpunkt Typografie (2026-08-07)
Die `unicode-range` des math-Subsets in `tokens/fonts.css` scheint **U+2208 (∈)
nicht abzudecken** — die Liste springt von `U+21F4-2211` auf `U+2213-2214` und
dann `U+2216-22FF`. Wenn das stimmt, lädt das Subset für ∈ gar nicht erst und
das Zeichen fällt stumm in die Systemkette (Doku behauptet Stufe ②).
Gegenprobe steht aus: cmap-Auslesung der ausgelieferten `.woff2` auf Jans
Arch-System (fonttools), Browsermessung im Sandbox ist wertlos (zu wenige
Systemfonts, Fallback-Referenzen kollabieren).
