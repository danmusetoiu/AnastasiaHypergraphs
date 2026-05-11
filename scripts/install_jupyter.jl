using Pkg
Pkg.add("Conda"; io=devnull)

using Conda
println("Installing jupyter via Conda.jl (downloads Miniconda + Jupyter on first run)...")
Conda.add("jupyter")
println("Done.")
println("Jupyter at: ", joinpath(Conda.SCRIPTDIR, "jupyter.exe"))
