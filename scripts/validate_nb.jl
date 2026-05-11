using Pkg
Pkg.add("JSON"; io=devnull)

using JSON

# Path notebook: din ARGS[1] dacă e dat, altfel default
nb_path = isempty(ARGS) ? "notebooks/01_julia_basics.ipynb" : ARGS[1]

if !isfile(nb_path)
    println("ERROR: fișierul nu există: $nb_path")
    println("Usage: julia scripts/validate_nb.jl <path-to-notebook.ipynb>")
    exit(1)
end

nb = JSON.parsefile(nb_path)

println("=== JSON validation: $nb_path ===")
println("✓ JSON parses")
println("Cells total: ", length(nb["cells"]))

md_count = count(c -> c["cell_type"] == "markdown", nb["cells"])
code_count = count(c -> c["cell_type"] == "code", nb["cells"])
println("  markdown: ", md_count)
println("  code:     ", code_count)

println("\n=== Metadata ===")
println("Kernel name:    ", nb["metadata"]["kernelspec"]["name"])
println("Kernel display: ", nb["metadata"]["kernelspec"]["display_name"])
println("nbformat:       ", nb["nbformat"], ".", nb["nbformat_minor"])
