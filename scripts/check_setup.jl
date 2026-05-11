using IJulia

println("=== IJulia setup check ===")
println("IJulia version: ", pkgversion(IJulia))

# Cross-platform path pentru kernel-urile Jupyter
kernel_dir = if Sys.iswindows()
    joinpath(homedir(), "AppData", "Roaming", "jupyter", "kernels")
elseif Sys.isapple()
    joinpath(homedir(), "Library", "Jupyter", "kernels")
else  # Linux & alte unix-uri
    joinpath(homedir(), ".local", "share", "jupyter", "kernels")
end

println("Kernel dir:    ", kernel_dir)
if isdir(kernel_dir)
    println("Registered Jupyter kernels: ", readdir(kernel_dir; join=false))
else
    println("(Kernel dir nu există încă — IJulia poate că nu și-a înregistrat încă kernelul.)")
end

println("\n=== Jupyter availability ===")
try
    jp = IJulia.find_jupyter_subcommand("notebook")
    println("Jupyter found at: ", jp[1])
    println("STATUS: ready to launch")
catch e
    println("Jupyter NOT found on system PATH.")
    println("To install Jupyter via miniconda, run: IJulia.installkernel(\"Julia\")")
    println("Or use Conda.jl: using Conda; Conda.add(\"jupyter\")")
end
