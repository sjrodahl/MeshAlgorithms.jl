module MeshAlgorithms

using GeometryTypes
using StaticArrays
using LinearAlgebra

export 
    Mesh,
    convert_from_homogenous,
    distance,
    fundamental_error_quadric


include("simplification.jl")

end # module
