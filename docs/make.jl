using Documenter, MeshAlgorithms

makedocs(;
    modules=[MeshAlgorithms],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/sjrodahl/MeshAlgorithms.jl/blob/{commit}{path}#L{line}",
    sitename="MeshAlgorithms.jl",
    authors="Sondre Rodahl",
#   assets=[],
)

#deploydocs(;
#    repo="github.com/sjrodahl/MeshAlgorithms.jl",
#)
