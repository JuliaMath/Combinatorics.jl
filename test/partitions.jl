@test collect(partitions(4)) ==  Any[[4], [3,1], [2,2], [2,1,1], [1,1,1,1]]
@test collect(partitions(8,3)) == Any[[6,1,1], [5,2,1], [4,3,1], [4,2,2], [3,3,2]]
@test collect(partitions(8, 1)) == Any[[8]]
@test collect(partitions(8, 9)) == []
@test collect(partitions([1,2,3])) == Any[Any[[1,2,3]], Any[[1,2],[3]], Any[[1,3],[2]], Any[[1],[2,3]], Any[[1],[2],[3]]]
@test collect(partitions([1,2,3,4],3)) == Any[Any[[1,2],[3],[4]], Any[[1,3],[2],[4]], Any[[1],[2,3],[4]],
                                              Any[[1,4],[2],[3]], Any[[1],[2,4],[3]], Any[[1],[2],[3,4]]]
@test collect(partitions([1,2,3,4],1)) == Any[Any[[1, 2, 3, 4]]]
@test collect(partitions([1,2,3,4],5)) == []

@inferred first(partitions(4))
@inferred first(partitions(8,3))
@inferred first(partitions([1,2,3]))
@inferred first(partitions([1,2,3,4],3))

@test isa(collect(partitions(4)), Vector{Vector{Int}})
@test isa(collect(partitions(8,3)), Vector{Vector{Int}})
@test isa(collect(partitions([1,2,3])), Vector{Vector{Vector{Int}}})
@test isa(collect(partitions([1,2,3,4], 3)), Vector{Vector{Vector{Int}}})

@test length(partitions(0)) == 1
@test length(partitions(-1)) == 0
@test length(collect(partitions(30))) == length(partitions(30))
@test length(collect(partitions(90,4))) == length(partitions(90,4))
@test length(collect(partitions('a':'h'))) == length(partitions('a':'h'))
@test length(collect(partitions('a':'h',5))) == length(partitions('a':'h',5))

# integer_partitions
@test integer_partitions(0) == []
@test integer_partitions(5) == Any[[1, 1, 1, 1, 1], [2, 1, 1, 1], [2, 2, 1], [3, 1, 1], [3, 2], [4, 1], [5]]
@test_throws DomainError integer_partitions(-1)

@test_throws ArgumentError prevprod([2,3,5],Int128(typemax(Int))+1)
@test prevprod([2,3,5],30) == 30
@test prevprod([2,3,5],33) == 32

# noncrossing partitions
let nc4 = ncpartitions(4)
    @test nc4 == Any[Any[[1],[2],[3],[4]], Any[[1],[2],[3,4]], Any[[1],[2,3],[4]], Any[[1],[2,4],[3]], Any[[1],[2,3,4]],
                     Any[[1,2],[3],[4]], Any[[1,2],[3,4]],
                     Any[[1,3],[2],[4]], Any[[1,4],[2],[3]], Any[[1,4],[2,3]],
                     Any[[1,2,3],[4]], Any[[1,3,4],[2]], Any[[1,2,4],[3]],
                     Any[[1,2,3,4]]]
    @test length(nc4) == catalannum(4)
end
