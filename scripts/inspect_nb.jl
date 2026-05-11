using JSON

nb_path = isempty(ARGS) ? "notebooks/01_julia_basics.ipynb" : ARGS[1]
nb = JSON.parsefile(nb_path)
println("=== Outputs from key cells in $nb_path ===\n")

keywords = isempty(get(ENV, "KW", "")) ?
    ["X_new", "Features finale", "Specia hub", "Discuție: H"] :
    split(ENV["KW"], ",")
for (i, c) in enumerate(nb["cells"])
    c["cell_type"] == "code" || continue
    src = c["source"] isa Vector ? join(c["source"]) : c["source"]
    if any(k -> occursin(k, src), keywords)
        println("--- Cell #$i ---")
        for out in c["outputs"]
            if get(out, "output_type", "") == "stream"
                txt = out["text"]; txt isa Vector && (txt = join(txt))
                println("  >>> ", replace(txt, "\n" => "\n  >>> "))
            elseif haskey(out, "data") && haskey(out["data"], "text/plain")
                txt = out["data"]["text/plain"]; txt isa Vector && (txt = join(txt))
                println("  >>> ", replace(txt, "\n" => "\n  >>> "))
            end
        end
        println()
    end
end
