v1 = Point(0,0,0)
v2 = Point(0,0,1)
v3 = Point(1,0,1)
v4 = Point(0,0,2)

@testset "Point distances" begin
    p1 = Point{3, Float32}(0,0,0)
    p2 = Point{3, Float32}(0,0,1)
    @test distance(p1, p2) == 1
end

@testset "Pair selection" begin
    vertices = [v1, v2, v3, v4]
    edges = Set([(1,2), (1,3), (2,3)])
    mesh = MeshAlgorithms.Mesh(vertices, edges, [])
    pairs = MeshAlgorithms.select_valid_pairs(mesh, 1)
    @test pairs == Set([(1,2), (1,3), (2,3), (2, 4)])
end

@testset "Mesh conversion" begin
    f1 = Face(1,2,3)
    normal = Normal(0,1,0)
    test_hm = HomogenousMesh(
            vertices = [v1, v2, v3],
            faces = [f1],
            normals = [normal, normal, normal])
    expected_mesh = Mesh([v1,v2,v3], Set([(1,2), (1,3), (2,3)]), [])
    @test convert_from_homogenous(test_hm).vertices == expected_mesh.vertices
    @test convert_from_homogenous(test_hm).edges == expected_mesh.edges

end
    
@testset "Error Quadrics" begin
    p = SVector{4}([1,2,3,0])
    k_p = fundamental_error_quadric(p)
    @test k_p[1,1] == p[1]^2
    @test k_p[1,2] == p[1]*p[2]
    @test k_p[1,3] == p[1]*p[3]
    @test k_p[1,4] == p[1]*p[4]
    @test k_p[2,1] == p[1]*p[2]
    @test k_p[2,2] == p[2]^2
    @test k_p[2,3] == p[2]*p[3]
    @test k_p[2,4] == p[2]*p[4]
    @test k_p[3,1] == p[1]*p[3]
    @test k_p[3,2] == p[2]*p[3]
    @test k_p[3,3] == p[3]^2
    @test k_p[3,4] == p[3]*p[4]
    @test k_p[4,1] == p[1]*p[4]
    @test k_p[4,2] == p[2]*p[4]
    @test k_p[4,3] == p[3]*p[4]
    @test k_p[4,4] == p[4]^2
end

sq_sum(v::Vector) = reduce(+, map(x->x^2, v))
@testset "Normalize" begin
    n = [Vector([1,2,3]), Vector([0,3,4]), Vector([1,0,0]), Vector([0,0,0])]
    @test MeshAlgorithms.normalize(n[1]) == [1/sqrt(14), 2/sqrt(14), 3/sqrt(14)]
    @test MeshAlgorithms.normalize(n[2]) == [0,3/5, 4/5]
    @test MeshAlgorithms.normalize(n[3]) == [1,0,0]
    @test_throws ErrorException MeshAlgorithms.normalize(n[4])
    @testset "All length 1 $a $b $c" for a in -5.0:0.5:5, b in -5:0.5:5, c in 0.1:0.2:5
        @test sq_sum(MeshAlgorithms.normalize(Vector([a,b,c]))) ≈ 1.0
    end
end
