@testset "compositions" begin

    # test (strong) compositions
    @testset "composition" begin

        # n = 1, k = 1
        @test collect(composition(1, 1)) == [[1]]
        @test length(composition(1, 1))  == 1

        # n = 2, k = 1
        @test collect(composition(2, 1)) == [[2]]
        @test length(composition(2, 1))  == 1

        # n = 2, k = 2
        @test collect(composition(2, 2)) == [[1, 1]]
        @test length(composition(2, 2))  == 1

        # n = 3, k = 1
        @test collect(composition(3, 1)) == [[3]]
        @test length(composition(3, 1))  == 1

        # n = 3, k = 2
        @test collect(composition(3, 2)) == [[1, 2], [2, 1]]
        @test length(composition(3, 2))  == 2

        # n = 3, k = 3
        @test collect(composition(3, 3)) == [[1, 1, 1]]
        @test length(composition(3, 3))  == 1

        # n = 4, k = 1
        @test collect(composition(4, 1)) == [[4]]
        @test length(composition(4, 1))  == 1

        # n = 4, k = 2
        @test collect(composition(4, 2)) == [[1, 3], [2, 2], [3, 1]]
        @test length(composition(4, 2))  == 3

        # n = 4, k = 3
        @test collect(composition(4, 3)) == [[1, 1, 2], [1, 2, 1], [2, 1, 1]]
        @test length(composition(4, 3))  == 3

        # n = 4, k = 4
        @test collect(composition(4, 4)) == [[1, 1, 1, 1]]
        @test length(composition(4, 4))  == 1

        # n = 5, k = 1
        @test collect(composition(5, 1)) == [[5]]
        @test length(composition(5, 1))  == 1

        # n = 5, k = 2
        @test collect(composition(5, 2)) == [[1, 4,], [2, 3], [3, 2], [4, 1]]
        @test length(composition(5, 2))  == 4

        # n = 5, k = 3
        @test collect(composition(5, 3)) == [[1, 1, 3], 
                                             [1, 2, 2], 
                                             [1, 3, 1],
                                             [2, 1, 2],
                                             [2, 2, 1],
                                             [3, 1, 1]]
        @test length(composition(5, 3))  == 6

        # n = 5, k = 4
        @test collect(composition(5, 4)) == [[1, 1, 1, 2],
                                             [1, 1, 2, 1],
                                             [1, 2, 1, 1],
                                             [2, 1, 1, 1]]
        @test length(composition(5, 4))  == 4

        # n = 5, k = 5
        @test collect(composition(5, 5)) == [[1, 1, 1, 1, 1]]
        @test length(composition(5, 5))  == 1 

        # check n less than k throws an error
        @test_throws DomainError composition(1, 2)

        # check non-positive k throws an error
        @test_throws DomainError composition(1, 0)

        # test eltype
        @test eltype(composition(1, 1)) == Vector{Int}

    end

    # test weak compositions
    @testset "weak_composition" begin

        # n = 0, k = 1
        @test collect(weak_composition(0, 1)) == [[0]]
        @test length(weak_composition(0, 1))  == 1

        # n = 0, k = 2
        @test collect(weak_composition(0, 2)) == [[0, 0]]
        @test length(weak_composition(0, 2))  == 1

        # n = 0, k = 3
        @test collect(weak_composition(0, 3)) == [[0, 0, 0]]
        @test length(weak_composition(0, 3))  == 1

        # n = 1, k = 1
        @test collect(weak_composition(1, 1)) == [[1]]
        @test length(weak_composition(1, 1))  == 1

        # n = 1, k = 2
        @test collect(weak_composition(1, 2)) == [[0, 1], [1, 0]]
        @test length(weak_composition(1, 2))  == 2

        # n = 1, k = 3
        @test collect(weak_composition(1, 3)) == [[0, 0, 1], 
                                                  [0, 1, 0], 
                                                  [1, 0, 0]]
        @test length(weak_composition(1, 3))  == 3

        # n = 2, k = 1
        @test collect(weak_composition(2, 1)) == [[2]]
        @test length(weak_composition(2, 1))  == 1

        # n = 2, k = 2
        @test collect(weak_composition(2, 2)) == [[0, 2], [1, 1], [2, 0]]
        @test length(weak_composition(2, 2))  == 3

        # n = 2, k = 3
        @test collect(weak_composition(2, 3)) == [[0, 0, 2], 
                                                  [0, 1, 1], 
                                                  [0, 2, 0],
                                                  [1, 0, 1], 
                                                  [1, 1, 0],
                                                  [2, 0, 0]]
        @test length(weak_composition(2, 3))  == 6

        # n = 3, k = 1
        @test collect(weak_composition(3, 1)) == [[3]]
        @test length(weak_composition(3, 1))  == 1

        # n = 3, k = 2
        @test collect(weak_composition(3, 2)) == [[0, 3], 
                                                  [1, 2], 
                                                  [2, 1], 
                                                  [3, 0]]
        @test length(weak_composition(3, 2))  == 4

        # n = 3, k = 3
        @test collect(weak_composition(3, 3)) == [[0, 0, 3], 
                                                  [0, 1, 2], 
                                                  [0, 2, 1], 
                                                  [0, 3, 0],
                                                  [1, 0, 2],
                                                  [1, 1, 1],
                                                  [1, 2, 0],
                                                  [2, 0, 1],
                                                  [2, 1, 0],
                                                  [3, 0, 0]]
        @test length(weak_composition(3, 3)) == 10

        # check negative n throws an error
        @test_throws DomainError weak_composition(-1, 1)

        # check non-positive k throws an error
        @test_throws DomainError weak_composition(1, 0)

        # test eltype
        @test eltype(weak_composition(1, 1)) == Vector{Int}

    end

end
