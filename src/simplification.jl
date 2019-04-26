struct Mesh
    vertices::Array{Point{3, Float32}}
    edges::Set{Tuple{Int, Int}}
end

"""
    distance(v1::Point, v2::Point)

Calculate the distance beteen two points

"""
function distance(v1::Point, v2::Point)
    return sqrt(reduce(+, map((x,y)->(y-x)^2, v1, v2)))
end
    

function select_valid_pairs(mesh::Mesh, threshold::Real)
    rs = Set{Tuple{Int, Int}}()
    for i in 1:length(mesh.vertices), e in mesh.edges
        if i in e
            push!(rs, e)
        end
    end
    for i in 1:length(mesh.vertices), j in 1:length(mesh.vertices)
        if i != j && distance(mesh.vertices[i], mesh.vertices[j]) <= threshold
            if !((j,i) in rs)
                push!(rs, (i, j))
            end
        end
    end
    return rs
end


function get_edges_from_face(face::Face)
    return (face[1], face[2]), (face[1], face[3]), (face[2], face[3])
end


function convert_from_homogenous(mesh::HomogenousMesh)
    edges =Set{Tuple{Int, Int}}()
    for f in mesh.faces
        edges = union(edges, get_edges_from_face(f))
    end
    return Mesh(mesh.vertices, edges)
end
 

function fundamental_error_quadric(p::SVector{4,T}) where {T<:Real}
    return [p[1]^2 p[1]*p[2] p[1]*p[3] p[1]*p[4];
            p[1]*p[2] p[2]^2 p[2]*p[3] p[2]*p[4];
            p[1]*p[3] p[2]*p[3] p[3]^2 p[3]*p[4];
            p[1]*p[4] p[2]*p[4] p[3]*p[4] p[4]^2] 
end
