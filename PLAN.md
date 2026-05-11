# Plan: Material educațional Julia + Hypergraphs pentru stagiul Anastasiei la UCD

> **Status:** draft pentru aprobare · **Autor:** Dan (cu Claude) · **Destinatar:** Anastasia
> **Context:** stagiu de vară UCD Dublin (între anul 3 și anul 4 chimie), pregătire pentru master de chimie nucleară. Tema exactă a stagiului e confidențială academic, dar pare să fie ML aplicat pe proteine. Cerință explicită din partea coordonatorului: înțelegere Julia + hypergraphs.
>
> **Platforme:** Dan dezvoltă pe Windows 11; Anastasia rulează pe MacBook. Toate instrucțiunile de instalare și comenzile de shell trebuie să acopere ambele platforme.

---

## 1. Obiective pedagogice

La final, Anastasia trebuie să poată:

1. **Instala și folosi** Julia + Jupyter (kernel IJulia) pe Windows.
2. **Citi și scrie** cod Julia idiomatic — cu accent pe diferențele față de Python.
3. **Înțelege matematic** ce este un hypergraf, ce tipuri există și de ce sunt utile pentru relații de ordin înalt (vs. grafuri clasice).
4. **Construi și manipula** hypergraphuri în Julia folosind `HyperGraphs.jl`.
5. **Aplica** hypergraphuri la modelarea unui sistem biochimic concret (rețea de reacții de fosforilare) — folosind interoperabilitatea cu `ModelingToolkit.jl` și `DifferentialEquations.jl`.
6. **Identifica** unde se folosesc hypergraphuri în ML-ul pentru proteine și care sunt arhitecturile relevante (Hypergraph Neural Networks).

## 2. Public-țintă (profil Anastasia)

- Studentă chimie, anul 3 (intrând în 4) — fundament matematic solid (calcul, algebră liniară), biochimie, chimie fizică.
- **Programare: ZERO experiență prealabilă.** Notebookurile predau programarea de la absolut zero, prin Julia. NU folosim comparații cu Python sau alte limbaje — ar fi o referință inutilă pentru cineva care nu cunoaște niciun limbaj.
- **Cititoare critică:** se așteaptă la rigoare academică — de aici insistența pe citații.
- **Principiu de ton (regulă Dan):** *"să înțeleagă și să nu se sperie"*. Accesibilitatea bate completitudinea. Dacă o secțiune sună intimidant, o simplificăm sau o spargem.

## 3. Format și structură repository

```
anastasia/
├── PLAN.md                              ← acest document
├── README.md                            ← cum se folosește (install + parcurgere)
├── Hypergraphs/                         ← PDF-uri sursă (deja existente)
│   ├── 2002.05014v1.pdf                 (Ouvrard 2020)
│   └── btac347_supplementary_data.pdf   (Diaz & Stumpf 2022 SI)
├── notebooks/
│   ├── 01_julia_basics.ipynb            ← Setup + Julia fundamente (cu exemple chimie)
│   ├── 02_hypergraphs.ipynb             ← Teoria hypergraphurilor + HyperGraphs.jl + simulare ODE fosforilare
│   ├── 03_ml_intro.ipynb                ← Intro ML: regresie liniară, GD, MLP cu Flux.jl, convoluții
│   └── 04_protein_ml.ipynb              ← HGNN + aplicații proteomică + handoff stagiu
├── code/                                ← scripturi Julia standalone (rulabile fără notebook)
│   └── (populate ulterior)
└── data/                                ← date pentru exemple (dacă nevoie)
```

## 4. Convenții pentru notebook-uri

- **Limbă:** română pentru text narativ. Termeni tehnici în engleză cu traducere prima dată (e.g. *hyperedge* — muchie generalizată).
- **Citații inline:** stilul autor-an, `[Ouvrard, 2020]`, cu link către secțiunea de referințe.
- **Referințe finale:** secțiune `## References` în fiecare notebook cu DOI/arXiv/URL clickabile.
- **Cod:** comentarii minime, dar fiecare bloc precedat de celulă markdown cu obiectivul. Output-uri salvate pentru ca notebook-ul să fie lizibil chiar și fără rulare.
- **Exerciții:** la finalul fiecărei secțiuni majore, cu soluții ascunse (collapsed cell sau secțiune separată la final).
- **Egalități matematice:** LaTeX inline `$...$` și display `$$...$$`.

---

## 5. Notebook 01 — Julia basics

**Obiectiv:** de la instalare la a putea citi cod Julia idiomatic.

### 5.1 Setup (Cap. 0)

- De ce Julia? Trei argumente scurte: viteză C-like, sintaxă Python-like, ecosistem științific. Citație: [Bezanson et al., 2017].
- **Instalare cross-platform via `juliaup`** (managerul oficial — recomandat pentru ambele OS-uri):
  - **macOS (Anastasia):**
    ```bash
    curl -fsSL https://install.julialang.org | sh
    ```
    Alternativ Homebrew: `brew install juliaup`. Verificare: `julia --version` în Terminal.
  - **Windows (Dan):**
    ```powershell
    winget install julia -s msstore
    ```
    Alternativ: download direct de pe [julialang.org/downloads](https://julialang.org/downloads/). Verificare: `julia --version` în PowerShell.
  - **De ce `juliaup`?** Manager oficial de versiuni Julia (analog `pyenv`/`rustup`) — permite instalare versiuni multiple, switch ușor, upgrade.
- **IJulia + Jupyter** (identic pe ambele OS-uri):
  - Din REPL Julia: `using Pkg; Pkg.add("IJulia")`.
  - IJulia instalează automat un mini-conda cu Jupyter dacă nu există local. Alternativ: dacă există Jupyter pe sistem (e.g. Anaconda), îl folosește pe acela.
  - Lansare notebook: `using IJulia; notebook()` din REPL, sau `jupyter notebook` din terminal după ce kernelul Julia e înregistrat.
- **VS Code (opțional dar recomandat, cross-platform):** extensia Julia oficială pentru autocomplete + debugging.
- **Mediu izolat per proiect:** `Pkg.activate(".")` + `Project.toml` — explicat ca echivalentul `venv`/`requirements.txt` din Python.
- **Notă cale fișiere:** notebook-urile folosesc căi relative (`./data/...`) ca să fie portabile între Windows și macOS.

### 5.2 Primii pași în Julia (Cap. 1)

> **Audiență:** primul contact cu programarea. Nu presupunem nimic.

- **Ce este un limbaj de programare?** Mini-analogie: e ca o rețetă chimică foarte strictă — fiecare pas trebuie scris exact, calculatorul îl execută literal. Diferența: rezultatul e o valoare numerică sau o transformare, nu o substanță.
- **Ce e REPL?** "Read–Eval–Print Loop" — fereastra în care scrii o expresie, Julia o evaluează, vezi rezultatul imediat. Analog cu un calculator științific avansat. *Demo:* `1 + 1`, `√2`, `sin(π)`, `2^10`.
- **Notebook = REPL + text.** O secvență de celule: unele cu cod (rulabile), altele cu text explicativ (markdown ca acest document). Asta vei folosi tot stagiul.
- **Cum se "spune" ceva în Julia:** sintaxă esențială introdusă vizual, fără jargon:
  - Atribuire: `m = 18.015`  *(masa molară a apei)*
  - Apel funcție: `log(2.718)`
  - Comentariu: `# textul care urmează e ignorat de Julia`
- **Caractere matematice native:** Julia acceptă unicode în nume. Putem scrie `α = 0.5`, `Δt = 0.01`, `μ_H2O = 18.015`. Tastate cu `\alpha<Tab>`, `\Delta<Tab>` în REPL/notebook. *Util pentru chimie* — formule arată ca pe hârtie.
- **Pachetele:** ca un set de instrumente specializate. Le instalezi o dată (`using Pkg; Pkg.add("Plots")`), le folosești ori de câte ori (`using Plots`). Analogie chimie: e ca atunci când scoți un reactiv din dulap înainte să-l folosești.

**Filozofie pedagogică pentru această secțiune:** fiecare concept e introdus prin **un exemplu de chimie**, niciodată prin "fizz-buzz" sau exemple sterile. Variabilele țin mase molare, funcțiile calculează concentrații, vectorii țin spectre.

### 5.3 Fundamente Julia (Cap. 2)

**Regulă:** fiecare concept introdus mai întâi prin **ce face** (exemplu de chimie), apoi numit. Jargonul vine la final, nu la început.

- **Numere și operații.** Întregi, fracționari, exponentiere (`6.022e23`). Operatori uzuali (`+`, `-`, `*`, `/`, `^`).
- **Containere de valori — vectori și matrici.**
  - Vector: o listă ordonată. Exemplu: masele atomice ale primelor 4 elemente — `[1.008, 4.003, 6.941, 9.012]`.
  - Indexare: `m[1]` = primul element. (Julia numără de la 1, nu de la 0 — menționăm asta scurt, fără tabel comparativ.)
  - Matrice: tablou bidimensional. Exemplu: matricea de stoichiometrie a unei reacții.
- **A face același lucru pe toate elementele simultan** (operator `.` — "broadcasting"). În loc să scriem o buclă, scriem `m .* 2` și fiecare element se înmulțește cu 2. Pedagogic: introducem cu un singur exemplu, fără să spunem "broadcasting" în prima propoziție.
- **Funcții — bucăți de cod reutilizabile.**
  - Sintaxă scurtă: `f(x) = x^2`
  - Sintaxă bloc: `function ph(H); -log10(H); end`
  - Exemplu central: o funcție `concentrație_finală(c0, V0, V_adăugat)` care implementează formula diluției.
- **Aceeași funcție pentru tipuri diferite** (conceptul care în Julia se numește *multiple dispatch* — îl numim doar la final). Exemplu: o funcție `masa(x)` care știe să calculeze masa atât pentru un atom, cât și pentru o moleculă (sumă peste atomi). Aceeași comandă, comportament adaptat.
- **Structuri — date custom.** `struct Atom; simbol::Symbol; masă::Float64; end`. Folosit pentru a defini propriile tipuri de obiecte (atomi, molecule, reacții).
- **Decizii și repetare:** `if`/`else`, `for`, `while`. Introduse pe exemple chimice (ex: "dacă pH < 7, soluția e acidă, altfel bazică").
- **Comenzi speciale care încep cu `@`** (macro-uri). Doar două sunt importante acum:
  - `@show x` — afișează numele și valoarea unei variabile (util pentru debugging).
  - `@time expresie` — măsoară cât durează o calculație.
  Le numim "macro-uri" doar pentru terminologie corectă; nu intrăm în mecanică internă.

**Exerciții (cu soluții la final):**
1. Definiți un vector cu masele molare ale apei, etanolului și acetonei. Calculați masa medie.
2. Scrieți o funcție `pH(concentrație_H_plus)` și o aplicați pe o listă de concentrații.
3. Definiți `struct Molecule` cu un câmp `atoms::Vector{Atom}` și o funcție `masa_totală(m::Molecule)`.
4. Pentru reacția $2H_2 + O_2 \rightarrow 2H_2O$: scrieți vectorul coeficienților stoichiometrici și verificați conservarea masei.

---

## 6. Notebook 02 — Hypergraphs (teorie + Julia + aplicație biochimie)

**Obiectiv:** de la definiție matematică la simularea unei rețele de reacții.

### 6.1 De ce hypergraphuri? (Cap. 3 intro)

- Graphurile codifică relații **binare**: muchia conectează **două** vârfuri.
- Multe sisteme naturale au relații de **ordin înalt**: o reacție chimică implică ≥2 reactanți + ≥1 produs, o colaborare științifică implică ≥2 autori, un complex proteic implică ≥3 subunități.
- **Hypergraph** = generalizare: o *hyperedge* poate lega oricâte vârfuri.
- Diagramă vizuală: graph vs hypergraph pentru aceeași rețea de reacții.

Citație: [Berge, 1973] — prima formalizare; [Ouvrard, 2020] — review modern.

### 6.2 Definiții formale (Cap. 3 teorie)

Pe baza Ouvrard 2020, Sec. 1-2:

- Hypergraph $\mathcal{H} = (V, E)$ cu $V$ mulțime de vârfuri și $E$ mulțime de hyperedges, fiecare $e_j \subseteq V$, $e_j \neq \emptyset$.
- **Funcție de incidență** $\iota: E \to \mathcal{P}(V)$ — definiția alternativă PoDef (Stell 2012).
- **Definiție MuRelDef:** relație binară $\varphi$ care unifică vârfurile și muchiile.
- Tipuri particulare:
  - **Simple:** fără hyperedges repetate sau incluse una în alta.
  - **Linear:** simplu + orice două hyperedges au ≤1 vârf comun.
  - **Multi-hypergraph:** se permit muchii repetate.
  - **Sub-hypergraph** vs **partial hypergraph** — distincție subtilă, exemplificată grafic.
- **Matricea de incidență** $H \in \{0,1\}^{|V| \times |E|}$, $H_{ij} = 1$ dacă $v_i \in e_j$.
- Generalizări: **directed hypergraphs**, **weighted hypergraphs** — relevante pentru biochimie (cinetică).

**Exerciții:**
1. Dată o mică rețea chimică, scrie hypergraph-ul ca $(V, E)$ și matricea de incidență.
2. Demonstrează că un graf clasic este un caz particular de hypergraph (toate muchiile au cardinalitate 2).

### 6.3 HyperGraphs.jl — partea practică (Cap. 4)

- Instalare: `Pkg.add(url="https://github.com/lpmdiaz/HyperGraphs.jl")` (verificăm dacă e încă pe Git sau dacă e în General registry).
- API-ul de bază (din Diaz & Stumpf 2022, Tabel 1):
  - `HyperEdge`, `ChemicalHyperEdge`
  - `HyperGraph`, `ChemicalHyperGraph`
  - `nv(X)`, `nhe(X)` — număr vârfuri / hyperedges.
  - `incidence_matrix(X)`.
  - `vertices(X)`, `hyperedges(X)`.
- Reproducerea exemplului A.1 din SI: o rețea simplă de fosforilare ca `ChemicalHyperGraph`.
- Comparație cu `SimpleHypergraphs.jl` (alternativă):
  - SimpleHypergraphs folosește matricea de incidență ca reprezentare internă → mai puțin general (pierde info la multiplicități).
  - HyperGraphs.jl folosește structuri compose-abile → mai general, dar mai puțin matur.
  - Citații: [Diaz & Stumpf, 2022] vs [Antelmi et al., 2020].

### 6.4 Aplicație: rețea de fosforilare ca hypergraph + simulare cinetică (Cap. 5)

Reproducerea exemplului A.2 din SI (Diaz & Stumpf 2022):

- Construire hypergraph pentru cascada fosforilare/defosforilare a unei enzime $E$ pe un substrat $M$ (formare complex $E_M$ → fosforilat $pE_M$ → eliberare $pE$).
- Conversie automată la sistem ODE prin `ModelingToolkit.jl`.
- Rezolvare cu `OrdinaryDiffEq.jl` (algoritmul `Tsit5()`).
- Vizualizare cu `Plots.jl`.
- **Punctul didactic central:** hypergraph-ul nu e doar o structură de date — devine *sursa de adevăr* din care derivăm modelul matematic.

Citații: [Rackauckas & Nie, 2017] (DifferentialEquations.jl), [Ma et al., 2021] (ModelingToolkit.jl).

**Exerciții:**
1. Modificați constantele de viteză și observați cum se schimbă curbele.
2. Adăugați o a doua etapă de fosforilare (pe un al doilea sit) — construiți hyperedges noi.
3. Calculați matricea de incidență manual și verificați-o cu `incidence_matrix(X)`.

---

## 7. Notebook 03 — Intro în Machine Learning și Rețele Neuronale

**Obiectiv:** baza ML pentru ca tot ce urmează (notebook 04 HGNN) să aibă sens. Audiență zero ML, exact ca la zero programare în nb 01.

### 7.1 Ce e ML? Vocabular esențial
- Programare clasică vs ML — diferența conceptuală.
- Features, labels, model, loss, training, parametri, inference.
- Supervised vs unsupervised (focus pe supervised).

### 7.2 Regresie liniară — cel mai simplu model ML
- **Exemplu chimie centrală: legea Beer-Lambert** ($A = \varepsilon c \ell$).
- Date sintetice cu zgomot, recuperare $\varepsilon$ prin least squares.
- Funcția de cost (MSE) introdusă natural.
- Verificare: recuperează $\varepsilon$ cu ~1% eroare.

### 7.3 Gradient Descent — metoda universală
- Intuiție geometrică (valea, pasul spre fund).
- Formula: $\theta_{t+1} = \theta_t - \eta \nabla_\theta L$.
- Implementare manuală pe regresia liniară, comparație cu soluția analitică.
- Setup pentru tot ce urmează — orice training ML face fundamental același lucru.

### 7.4 De la regresie la rețele neuronale
- Un neuron = regresie liniară + activare neliniară ($\sigma$).
- MLP = neuroni stratificați; $\vec{x} \to W_1 \to \sigma \to \ldots \to \vec{y}$.
- De ce neliniaritatea contează (intuitiv).
- Teorema de aproximare universală [Cybenko, 1989].

### 7.5 Flux.jl — un MLP real în Julia
- Instalare + sintaxa `Chain(Dense(...))`.
- Date sintetice neliniare ($y = \sin x + 0.5x$) ca demonstrație că MLP poate ce regresia liniară nu poate.
- Training loop modern (Flux v0.14+): `setup`, `gradient`, `update!`.
- Vizualizare: loss curve + predicție vs date.
- **Punctul didactic:** loss-ul scade de ~200×, predicția urmărește curba — model învățat din date.

### 7.6 Convoluții specializate (overview)
- **CNN** pentru imagini [LeCun 1998, Krizhevsky 2012] — translation equivariance.
- **GCN** pentru grafuri [Kipf & Welling, 2017] — formula spectrală.
- **HGNN** pentru hypergraphuri — **forward pointer la notebook 04**.

**Exerciții:**
1. Antrenare MLP pe $y = x^2$ (parabolă). Câte epoci pentru loss < 0.01?
2. Capacitatea modelului — antrenare cu 2, 16, 64 neuroni ascunși și comparație.
3. Regresie liniară vs MLP pe date neliniare — MLP iese de ~22× mai bun.

---

## 8. Notebook 04 — HGNN și aplicații în proteomică

**Obiectiv:** punte între ce a învățat în notebook-urile 1-3 și ce ar putea fi tema reală a stagiului.

### 8.1 Reprezentări moleculare pentru ML

- De la SMILES → graf molecular → message passing.
- Limitări ale grafurilor binare: nu surprind relații de tip "trei atomi formează un unghi", "patru atomi formează un dihedral", "un sit catalitic implică 5+ reziduuri".
- Hypergraphurile rezolvă natural aceste relații de ordin înalt.
- Pentru **proteine** în particular:
  - Interacțiuni reziduu-reziduu sunt rareori binare (motive structurale, situri allosterice).
  - Complexe proteice multi-subunitate.
  - PPI (protein-protein interactions) în rețele biologice.

### 8.2 Hypergraph Neural Networks (Cap. 6 metode)

- **HGNN** [Feng et al., 2019]: extinde GCN la hypergraphuri folosind matricea de incidență și convoluție spectrală.
  - Formula: $X^{(l+1)} = \sigma(D_v^{-1/2} H W D_e^{-1} H^T D_v^{-1/2} X^{(l)} \Theta)$
- **HyperGCN** [Yadati et al., 2019]: reducție la graf clasic via "mediating vertices".
- **AllSet / AllSetTransformer** [Chien et al., 2022]: framework unificator, state-of-the-art.
- **Message Passing Neural Networks** [Gilmer et al., 2017] — fundalul conceptual din care derivă toate.
- Diagramă comparativă GCN vs HGNN.

### 8.3 Aplicații curente în proteomică (Cap. 6 aplicații)

- **AlphaFold 2** [Jumper et al., 2021] — nu e hypergraph, dar e contextul în care orice ML pe proteine se discută în 2024+.
- **ESM-2 / ESMFold** [Lin et al., 2023] — modele de limbaj pentru secvențe.
- Hypergraph-uri pentru:
  - Predicție de interfețe proteină-proteină ([Liu et al., 2022] și lucrări recente).
  - Proiectare de proteine *de novo*.
  - Predicție de funcție (Gene Ontology).
- **Notă importantă:** confirmare cu Anastasia care e direcția exactă a stagiului — putem adapta acest capitol post-hoc.

### 8.4 Resurse pentru aprofundare (Cap. 7)

- Cărți: Bretto 2013 (matematică), Murphy 2022 (PML), Bronstein et al. 2021 (Geometric Deep Learning).
- Cursuri: Stanford CS224W (Machine Learning with Graphs), MIT 6.S898 (Deep Learning).
- Comunități: JuliaLang Discourse, Julia Slack #biology channel, BioJulia organization.
- Conferințe: ICLR, NeurIPS, ICML — track Graph Learning.

---

## 9. Bibliografie completă (preliminară)

### Julia language
- Bezanson, J., Edelman, A., Karpinski, S., & Shah, V. B. (2017). Julia: A fresh approach to numerical computing. *SIAM Review*, 59(1), 65–98. [DOI: 10.1137/141000671](https://doi.org/10.1137/141000671)
- Julia official documentation: <https://docs.julialang.org/>
- "Think Julia: How to Think Like a Computer Scientist" (Lauwens & Downey, free online): <https://benlauwens.github.io/ThinkJulia.jl/latest/book.html> — manual gratuit pentru începători absoluți.
- Julia Academy (cursuri video gratuite): <https://juliaacademy.com/>

### Hypergraph theory
- Berge, C. (1973). *Graphs and Hypergraphs*. North-Holland Publishing Company.
- Bretto, A. (2013). *Hypergraph Theory: An Introduction*. Springer. [DOI: 10.1007/978-3-319-00080-0](https://doi.org/10.1007/978-3-319-00080-0)
- Ouvrard, X. (2020). Hypergraphs: an introduction and review. *arXiv preprint*. [arXiv:2002.05014](https://arxiv.org/abs/2002.05014)
- Stell, J. G. (2012). Relational granularity for hypergraphs. *Rough Sets and Current Trends in Computing*. Springer.

### Julia hypergraph packages
- Diaz, L. P. M., & Stumpf, M. P. H. (2022). HyperGraphs.jl: representing higher-order relationships in Julia. *Bioinformatics*, 38(15), 3795–3797. [DOI: 10.1093/bioinformatics/btac347](https://doi.org/10.1093/bioinformatics/btac347) · Repo: <https://github.com/lpmdiaz/HyperGraphs.jl>
- Antelmi, A., Cordasco, G., Spagnuolo, C., & Szufel, P. (2020). SimpleHypergraphs.jl — Novel software framework for modelling and analysis of hypergraphs. *arXiv:2002.04654*. [arXiv link](https://arxiv.org/abs/2002.04654) · Repo: <https://github.com/pszufe/SimpleHypergraphs.jl>

### SciML ecosystem
- Rackauckas, C., & Nie, Q. (2017). DifferentialEquations.jl — A Performant and Feature-Rich Ecosystem for Solving Differential Equations in Julia. *Journal of Open Research Software*, 5(1). [DOI: 10.5334/jors.151](https://doi.org/10.5334/jors.151)
- Ma, Y., et al. (2021). ModelingToolkit: A Composable Graph Transformation System For Equation-Based Modeling. *arXiv:2103.05244*. [arXiv link](https://arxiv.org/abs/2103.05244)

### Hypergraph Neural Networks
- Feng, Y., You, H., Zhang, Z., Ji, R., & Gao, Y. (2019). Hypergraph Neural Networks. *AAAI*. [arXiv:1809.09401](https://arxiv.org/abs/1809.09401)
- Yadati, N., et al. (2019). HyperGCN: A New Method for Training Graph Convolutional Networks on Hypergraphs. *NeurIPS*. [arXiv:1809.02589](https://arxiv.org/abs/1809.02589)
- Chien, E., Pan, C., Peng, J., & Milenkovic, O. (2022). You are AllSet: A Multiset Function Framework for Hypergraph Neural Networks. *ICLR*. [arXiv:2106.13264](https://arxiv.org/abs/2106.13264)
- Gilmer, J., Schoenholz, S. S., Riley, P. F., Vinyals, O., & Dahl, G. E. (2017). Neural Message Passing for Quantum Chemistry. *ICML*. [arXiv:1704.01212](https://arxiv.org/abs/1704.01212)
- Bronstein, M. M., Bruna, J., Cohen, T., & Veličković, P. (2021). Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges. *arXiv:2104.13478*. [arXiv link](https://arxiv.org/abs/2104.13478)

### Protein structure & ML
- Jumper, J., et al. (2021). Highly accurate protein structure prediction with AlphaFold. *Nature*, 596, 583–589. [DOI: 10.1038/s41586-021-03819-2](https://doi.org/10.1038/s41586-021-03819-2)
- Lin, Z., et al. (2023). Evolutionary-scale prediction of atomic-level protein structure with a language model. *Science*, 379(6637), 1123–1130. [DOI: 10.1126/science.ade2574](https://doi.org/10.1126/science.ade2574)

> Notă: bibliografia se va extinde după ce confirmăm cu Anastasia direcția exactă a stagiului (interfețe PPI, design de novo, predicție de funcție, etc.).

---

## 10. Decizii finalizate vs. în așteptare

**Finalizate (per feedback Dan):**
- ✅ Setup cross-platform Windows + macOS în Cap. 1.1.
- ✅ FĂRĂ comparații Python ↔ Julia — Anastasia nu vine din Python; predăm Julia de la zero, cu exemple chimice.
- ✅ Profunzime matematică: definițiile formale Ouvrard (PoDef, MuRelDef) rămân — Anastasia are fundament matematic.
- ✅ Comentarii în cod: engleză. Text narativ: română.
- ✅ Exerciții: cu soluții la final.
- ✅ Principiu de ton: "să înțeleagă și să nu se sperie". Aplicat global.
- ✅ **Restructurare 4 notebook-uri** (post-feedback): nb 03 ML intro inserat ca podea pentru nb 04 HGNN — fără el, HGNN era zid pentru cineva fără background ML.
- ✅ **Notebook 02 simulare ODE inclusă** (post-feedback): formula `du/dt = S·v(c)` rezolvată numeric cu OrdinaryDiffEq, plot inline, conservare verificată — *nu* skip pe motiv "intimidant".

**Rămase deschise:**
- ⏳ **Focus Cap. 7.3/8.3 (aplicații pe proteine)** — Dan încearcă să afle de la Anastasia direcția exactă a stagiului (PPI? design *de novo*? predicție funcție?). Până atunci, scriu generic cu mai multe direcții acoperite la nivel introductiv.
- ⏳ **Fix-uri cross-platform pe scripts/** — `check_setup.jl` (calea Windows hardcodată) și `validate_nb.jl` (path notebook hardcodat). De rezolvat înainte de a trimite repo-ul Anastasiei.
