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
    mesh = MeshAlgorithms.Mesh(vertices, edges)
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
    expected_mesh = Mesh([v1,v2,v3], Set([(1,2), (1,3), (2,3)]))
    @test convert_from_homogenous(test_hm).vertices == expected_mesh.vertices
    @test convert_from_homogenous(test_hm).edges == expected_mesh.edges

end
    

