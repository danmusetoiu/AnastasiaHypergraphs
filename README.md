# AnastasiaHypergraphs

Material educațional pentru un stagiu de cercetare la **UCD Dublin** (vara 2026, între anul 3 și 4 chimie) — focus pe **hypergraphuri** și **Julia** ca fundament pentru *machine learning aplicat la proteine*.

## Pentru cine e

Studentă/student de chimie cu fundament matematic solid dar **zero experiență de programare**. Predarea pornește de la "ce e o variabilă" și ajunge la *Hypergraph Neural Networks* aplicate la rețele de complexe proteice — în 4 notebook-uri Jupyter executabile.

## Conținut

| # | Notebook | Ce înveți |
|---|----------|-----------|
| 01 | [`01_julia_basics.ipynb`](notebooks/01_julia_basics.ipynb) | Julia de la zero: variabile, vectori, matrici, funcții, `struct`, multiple dispatch — toate exemplificate cu chimie. Primele plot-uri cu `Plots.jl`. |
| 02 | [`02_hypergraphs.ipynb`](notebooks/02_hypergraphs.ipynb) | Teoria hypergraphurilor ([Berge 1973], [Ouvrard 2020]). `HyperGraphs.jl` pentru construcție. Rețea de fosforilare ca hypergraph → matrice de stoichiometrie → simulare ODE cu `OrdinaryDiffEq.jl`. |
| 03 | [`03_ml_intro.ipynb`](notebooks/03_ml_intro.ipynb) | Intro ML: notații matematice Unicode, regresie liniară (Beer-Lambert), gradient descent, rețele neuronale, MLP cu `Flux.jl` + animație live a training-ului. |
| 04 | [`04_protein_ml.ipynb`](notebooks/04_protein_ml.ipynb) | **Hypergraph Neural Networks** [Feng 2019]: matematica formulei, implementare manuală pe complexe proteice, animație message passing, vizualizare 3D proteine cu `Bio3DView.jl` (CDK2), survey aplicații în proteomică. |

Total: ~190 celule, toate testate end-to-end (vezi `scripts/validate_nb.jl`).

## Quickstart

### 1. Instalează Julia

**macOS:**
```bash
curl -fsSL https://install.julialang.org | sh
```
Sau cu Homebrew: `brew install juliaup`.

**Windows (PowerShell):**
```powershell
winget install julia -s msstore
```

Verifică: `julia --version` → `julia version 1.12.x`.

### 2. Clonează repo-ul

```bash
git clone https://github.com/danmusetoiu/AnastasiaHypergraphs.git
cd AnastasiaHypergraphs
```

### 3. Instalează IJulia + Jupyter

În REPL Julia:
```julia
using Pkg
Pkg.add("IJulia")
```
IJulia detectează automat dacă există Jupyter pe sistem; dacă nu, instalează o mini-conda dedicată (~50 MB).

### 4. Lansează notebook-ul

Din REPL Julia:
```julia
using IJulia
notebook()
```
Browser-ul se deschide automat. Click pe `notebooks/01_julia_basics.ipynb` și pornești.

> **Notă:** primele pachete grele (`Flux`, `OrdinaryDiffEq`, `Plots`) durează câteva minute la prima rulare (precompilare). Răbdare — apoi e instant.

## Structura repo-ului

```
AnastasiaHypergraphs/
├── README.md                        ← acest fișier
├── PLAN.md                          ← plan de proiect detaliat (intern)
├── notebooks/                       ← cele 4 notebook-uri (rulează în ordine)
│   ├── 01_julia_basics.ipynb
│   ├── 02_hypergraphs.ipynb
│   ├── 03_ml_intro.ipynb
│   └── 04_protein_ml.ipynb
├── scripts/                         ← utilități cross-platform
│   ├── install_ijulia.jl            ← Pkg.add("IJulia")
│   ├── install_jupyter.jl           ← forțează instalare Jupyter via Conda.jl
│   ├── check_setup.jl               ← verifică instalare end-to-end
│   ├── validate_nb.jl <path>        ← validează structura JSON a unui notebook
│   └── inspect_nb.jl <path>         ← afișează output-urile cheie ale unui notebook
└── Hypergraphs/                     ← PDF-uri sursă
    ├── 2002.05014v1.pdf             ← Ouvrard 2020 (review teoretic)
    └── btac347_supplementary_data.pdf  ← Diaz & Stumpf 2022 (HyperGraphs.jl)
```

## Pachete Julia folosite

| Pachet | Notebook | Folosire |
|--------|----------|----------|
| `IJulia` | toate | kernel Jupyter |
| `Plots` | 01–04 | vizualizări, animații |
| `HyperGraphs` | 02, 04 | construcție hypergraphuri |
| `OrdinaryDiffEq` | 02 | simulare ODE |
| `Flux` | 03 | rețele neuronale + autodiff |
| `Bio3DView` | 04 | vizualizare 3D proteine (PDB) |
| `LinearAlgebra` (stdlib) | 04 | calcul HGNN manual |

## Referințe-cheie

Toate notebook-urile au secțiuni `Referințe` complete. Esențiale:

- **Bezanson et al. 2017** — *Julia: A fresh approach to numerical computing*. [DOI](https://doi.org/10.1137/141000671)
- **Berge 1973** — *Graphs and Hypergraphs*.
- **Ouvrard 2020** — *Hypergraphs: an introduction and review*. [arXiv:2002.05014](https://arxiv.org/abs/2002.05014)
- **Diaz & Stumpf 2022** — *HyperGraphs.jl*. [DOI](https://doi.org/10.1093/bioinformatics/btac347)
- **Feng et al. 2019** — *Hypergraph Neural Networks*. [arXiv:1809.09401](https://arxiv.org/abs/1809.09401)
- **Kipf & Welling 2017** — *Semi-Supervised Classification with GCN*. [arXiv:1609.02907](https://arxiv.org/abs/1609.02907)
- **Jumper et al. 2021** — *AlphaFold*. [DOI](https://doi.org/10.1038/s41586-021-03819-2)

## Context

Pregătit pentru **Anastasia Mușetoiu** pentru stagiul ei la UCD Dublin (vara 2026). Coordonată cu tatăl ei — fără pretenții de exhaustivitate, doar fundament solid pentru ce urmează.

## Licență

Material educațional. Folosește, modifică, distribuie liber.
