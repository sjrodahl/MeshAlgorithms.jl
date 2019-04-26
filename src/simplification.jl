struct Mesh
    vertices::Array{Point{3, Float32}}
    edges::Set{Tuple{Int, Int}}
    faces::Array{Face{3,Any}}
end

"""
    distance(v1::Point, v2::Point)

Calculate the distance between two points

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


function calculate_contraction_position(v1::Point, v2::Point)
    return Point{3}((v1.+v2)./2)
end


function calculate_contraction_cost(mesh::HomogenousMesh, v1::Point, v2::Point)
    v_bar = contract_vertices(v1, v2)
    cost = Q(mesh, v1)+Q(mesh, v2)
    return cost
end

function get_edges_from_face(face::Face)
    return (face[1], face[2]), (face[1], face[3]), (face[2], face[3])
end


function get_faces_from_vertex(mesh::HomogenousMesh, v_ind::Int)
    return [f for f in mesh.faces if v_ind in f]
end

function Q(mesh::HomogenousMesh, v_ind::Int)
    neighboring_faces = get_faces_from_vertex(mesh, v_ind)
    plane_reps = [get_plane_representation(mesh, f) for f in neighboring_faces]
    error_quadrics = [fundamental_error_quadric(p) for p in plane_reps]
    return reduce(+, error_quadrics)
end

    

function normalize(n::Vector)
    sq_sum = reduce(+, map(x->x^2, n))
    sq_sum == 0 && error("Can't normalize the 0-vector")
    return map(x->x/(sqrt(sq_sum)), n)
end

function get_plane_representation(mesh::HomogenousMesh, face::Face)
    points_in_plane = mesh.vertices[face]
    v1 = Vector(points_in_plane[2].-points_in_plane[1])
    v2 = Vector(points_in_plane[3].-points_in_plane[1])
    n = v1 × v2
    n = normalize(n)
    d = -points_in_plane[1][1]*n[1] - points_in_plane[1][2]*n[2] - points_in_plane[1][3]*n[3]
    append!(n,d)
    return SVector{4}(n)
end


function convert_from_homogenous(mesh::HomogenousMesh)
    edges =Set{Tuple{Int, Int}}()
    for f in mesh.faces
        edges = union(edges, get_edges_from_face(f))
    end
    return Mesh(mesh.vertices, edges, mesh.faces)
end
 

function fundamental_error_quadric(p::SVector{4,T}) where {T<:Real}
    return [p[1]^2 p[1]*p[2] p[1]*p[3] p[1]*p[4];
            p[1]*p[2] p[2]^2 p[2]*p[3] p[2]*p[4];
            p[1]*p[3] p[2]*p[3] p[3]^2 p[3]*p[4];
            p[1]*p[4] p[2]*p[4] p[3]*p[4] p[4]^2] 
end
