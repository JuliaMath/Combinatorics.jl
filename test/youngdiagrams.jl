@test ([5,4,2,2]\[2,1]) == ([5, 4, 2, 2],[2, 1])
@test isrimhook([4,3,2], [2,2,2])
@test !isrimhook([4,3,2], [2,2,1])
@test !isrimhook([4,3,2], [1,1])
λ = [5,4,2,1]
@test partitionsequence(λ) == [1, 0, 1, 0, 1, 1, 0, 1, 0]
@test character(λ, [4,3,2,2,1]) == 0
@test character([1], [1]) == 1

