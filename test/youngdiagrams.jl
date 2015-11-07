using Combinatorics
using Base.Test

@test ([5,4,2,2]\[2,1]) == ([5, 4, 2, 2],[2, 1])

@test leglength([5,4,2,2], [2,1]) == leglength(([5, 4, 2, 2],[2, 1])) == 3
@test leglength([1], [1]) == -1
@test leglength(Int[], Int[]) == -1

@test isrimhook([4,3,2], [2,2,2])
@test !isrimhook([4,3,2], [2,2,1])
@test !isrimhook([4,3,2], [1,1])

let λ = [5,4,2,1]
    @test partitionsequence(λ) == [1, 0, 1, 0, 1, 1, 0, 1, 0]
    @test character(λ, [4,3,2,2,1]) == 0
end
@test character([1], [1]) == 1

