using LinearAlgebra

@testset "multinomials" begin
    # degenerate cases (x₁ + x₂ + ⋯ + xₘ)¹
    @test [multiexponents(1, 1)...] == [[1]]
    @test [multiexponents(2, 1)...] == [[1, 0], [0, 1]]
    @test [multiexponents(3, 1)...] == [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    @test hcat([multiexponents(10, 1)...]...) == Matrix{Float64}(I, 10, 10)

    # degenerate cases (x₁ + x₂ + ⋯ + xₘ)⁰
    @test [multiexponents(1, 0)...] == [[0]]
    @test [multiexponents(2, 0)...] == [[0, 0]]
    @test [multiexponents(3, 0)...] == [[0, 0, 0]]
    @test [multiexponents(10, 0)...] == [zeros(Int, 10)]

    # degenerate cases (x₁)ⁿ
    @test [multiexponents(1, 1)...] == [[1]]
    @test [multiexponents(1, 2)...] == [[2]]
    @test [multiexponents(1, 3)...] == [[3]]
    @test [multiexponents(1, 10)...] == [[10]]

    # general cases
    @test [multiexponents(3, 2)...] == [[2, 0, 0], [1, 1, 0], [1, 0, 1], [0, 2, 0], [0, 1, 1], [0, 0, 2]]
    @test [multiexponents(2, 3)...] == [[3, 0], [2, 1], [1, 2], [0, 3]]
    @test [multiexponents(2, 2)...] == [[2, 0], [1, 1], [0, 2]]
    @test [multiexponents(3, 3)...] == [[3, 0, 0], [2, 1, 0], [2, 0, 1], [1, 2, 0], [1, 1, 1], [1, 0, 2], [0, 3, 0], [0, 2, 1], [0, 1, 2], [0, 0, 3]]

    @test length(multiexponents(1, 1)) == 1
    @test length(multiexponents(2, 2)) == 3

    # type-stability
    @test typeof([multiexponents(1, 1)...]) == Vector{Vector{Int}}
    @test eltype(multiexponents(1, 1)) == Vector{Int}
end
