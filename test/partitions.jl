@testset "partitions" begin

    @testset "partitions(n::Integer)" begin
        @test_broken collect(partitions(0)) == [[]]
        @test collect(partitions(1)) == [[1]]
        @test collect(partitions(2)) == [[2], [1, 1]]
        @test collect(partitions(3)) == [[3], [2, 1], [1, 1, 1]]
        @test collect(partitions(4)) == [[4], [3, 1], [2, 2], [2, 1, 1], [1, 1, 1, 1]]

        # Partition function p(n):  https://oeis.org/A000041
        @test length(partitions(-1)) == 0
        @test length(partitions(0)) == 1
        @test length(partitions(1)) == 1
        @test length(partitions(40)) == 37338
        @test length(partitions(49)) == 173525
        @test length(collect(partitions(30))) == length(partitions(30))

        # Type stable
        @inferred first(partitions(4))
        @test isa(collect(partitions(4)), Vector{Vector{Int}})
    end

    @testset "partitions(n::Integer, m::Integer)" begin
        @test collect(partitions(8, 1)) == [[8]]
        @test collect(partitions(8, 3)) == [[6, 1, 1], [5, 2, 1], [4, 3, 1], [4, 2, 2], [3, 3, 2]]
        @test collect(partitions(8, 8)) == [ones(Int, 8)]
        @test collect(partitions(8, 9)) == []
        @test collect(partitions(90, 90)) == [ones(Int, 90)]
        @test collect(partitions(90, 91)) == []

        # legnth
        @test length(partitions(8, 1)) == 1
        @test length(partitions(8, 3)) == 5
        @test length(partitions(8, 8)) == 1
        @test length(partitions(8, 9)) == 0
        @test length(partitions(90, 1)) == 1
        # gap> NrPartitions(90, 4);
        @test length(partitions(90, 4)) == 5231
        @test length(collect(partitions(90, 4))) == length(partitions(90, 4))
        @test length(partitions(90, 90)) == 1

        # Type stable
        @inferred first(partitions(8, 3))
        @test isa(collect(partitions(8, 3)), Vector{Vector{Int}})

        # errors
        @test_throws DomainError partitions(-1, 1)
        @test_throws DomainError partitions(8, 0)
        @test_throws DomainError partitions(8, -1)
    end

    @testset "partitions(s::AbstractVector)" begin
        @test collect(partitions([1])) == [[[1]]]
        @test collect(partitions([1, 2])) == [[[1, 2]], [[1], [2]]]
        @test collect(partitions([1, 2, 3])) == [[[1, 2, 3]], [[1, 2], [3]], [[1, 3], [2]], [[1], [2, 3]], [[1], [2], [3]]]
        @test collect(partitions(1:3)) == collect(partitions([1, 2, 3]))
        @test collect(partitions('a':'b')) == [[['a', 'b']], [['a'], ['b']]]

        # length:  https://oeis.org/A000110
        @test length(partitions(1:10)) == 115975
        @test length(partitions(1:20)) == 51724158235372
        @test length(collect(partitions('a':'h'))) == length(partitions('a':'h'))

        # Type stable
        @inferred first(partitions([1, 2, 3]))
        @test isa(collect(partitions([1, 2, 3])), Vector{Vector{Vector{Int}}})
    end

    @testset "partitions(s::AbstractVector, m::Int)" begin
        @test collect(partitions(1:3, 2)) == [
            [[1, 2], [3]],
            [[1, 3], [2]],
            [[1], [2, 3]],
        ]
        @test collect(partitions([1, 2, 3, 4], 1)) == [[[1, 2, 3, 4]]]
        @test collect(partitions([1, 2, 3, 4], 3)) == [
            [[1, 2], [3], [4]], [[1, 3], [2], [4]], [[1], [2, 3], [4]],
            [[1, 4], [2], [3]], [[1], [2, 4], [3]], [[1], [2], [3, 4]]
        ]
        @test collect(partitions([1, 2, 3, 4], 4)) == [[[1], [2], [3], [4]]]
        @test collect(partitions([1, 2, 3, 4], 5)) == []

        # length: Stirling numbers of the second kind
        #   https://dlmf.nist.gov/26.8#T2
        @test length(partitions(1:3, 2)) == 3
        @test length(partitions([1, 2, 3, 4], 3)) == 6
        @test length(partitions(1:10, 4)) == 34105
        @test length(partitions(1:10, 5)) == 42525
        @test length(partitions(1:10, 5)) == stirlings2(10, 5)
        @test length(partitions(1:10, 6)) == 22827
        @test length(collect(partitions('a':'h', 5))) == length(partitions('a':'h', 5))

        # Type stable
        @inferred first(partitions([1, 2, 3, 4], 3))
        @test isa(collect(partitions([1, 2, 3, 4], 3)), Vector{Vector{Vector{Int}}})
    end

    @testset "integer partitions" begin
        @test_broken integer_partitions(0) == [[]]
        @test integer_partitions(1) == [[1]]
        @test integer_partitions(2) == [[1, 1], [2]]
        @test integer_partitions(3) == [[1, 1, 1], [2, 1], [3]]
        # gap> Partitions( 5 );
        @test integer_partitions(5) == [
            [1, 1, 1, 1, 1],
            [2, 1, 1, 1],
            [2, 2, 1],
            [3, 1, 1],
            [3, 2],
            [4, 1],
            [5]
        ]
        # integer_partitions <--> partitions(::Integer)
        @test Set(integer_partitions(5)) == Set(partitions(5))

        @test_throws DomainError integer_partitions(-1)
    end

    @testset "prevprod" begin
        @test prevprod([2, 3, 5], 30) == 30         # 30 = 2 * 3 * 5
        @test prevprod([2, 3, 5], 33) == 32         # 32 = 2^5
        @test prevprod([2, 3, 5, 7], 420) == 420    # 420 = 2^2 * 3 * 5 * 7

        # prime factor:  https://en.wikipedia.org/wiki/Table_of_prime_factors
        prime_factors = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
        @test prevprod(prime_factors, 37) == 37
        @test prevprod(prime_factors, 97) == 96     # 96 = 2^5 * 3
        @test prevprod(prime_factors, 149) == 148   # 148 = 2^2 * 37
        @test prevprod(prime_factors, 911) == 910   # 910 = 2 * 5 * 7 * 13
        @test prevprod(prime_factors, 4999) == 4998 # 4998 = 2 * 3 * 7^2 * 17

        # errors
        @test_throws ArgumentError prevprod([2, 3, 5], Int128(typemax(Int)) + 1)
    end

    @testset "noncrossing partitions" begin
        @test ncpartitions(0) == []
        @test ncpartitions(1) == [[[1]]]
        @test ncpartitions(2) == [[[1], [2]], [[1, 2]]]
        # The 14 noncrossing partitions of a 4-element set ordered in a Hasse diagram
        #   https://commons.wikimedia.org/wiki/File:Noncrossing_partitions_4;_Hasse.svg
        @test ncpartitions(4) == [
            [[1], [2], [3], [4]],
            [[1], [2], [3, 4]],
            [[1], [2, 3], [4]],
            [[1], [2, 4], [3]],
            [[1], [2, 3, 4]],
            [[1, 2], [3], [4]],
            [[1, 2], [3, 4]],
            [[1, 3], [2], [4]],
            [[1, 4], [2], [3]],
            [[1, 4], [2, 3]],
            [[1, 2, 3], [4]],
            [[1, 3, 4], [2]],
            [[1, 2, 4], [3]],
            [[1, 2, 3, 4]],
        ]

        for n in 1:8
            @test length(ncpartitions(n)) == catalannum(n)
        end
    end

end
