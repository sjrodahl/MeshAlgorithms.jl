module MeshAlgorithms

using GeometryTypes

export 
    Mesh,
    convert_from_homogenous,
    distance


include("simplification.jl")

end # module
