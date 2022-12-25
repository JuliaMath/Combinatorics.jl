let λ = Partition([5,4,2,2]), μ = Partition([2,1])
    @test λ \ μ == SkewDiagram(λ, μ)
    @test leglength(λ, μ) == leglength(λ \ μ) == 3
end
@test leglength(Partition(Int[]), Partition(Int[])) == -1

@test isrimhook(Partition([4,3,2]), Partition([2,2,2]))
@test !isrimhook(Partition([4,3,2]), Partition([2,2,1]))
@test !isrimhook(Partition([4,3,2]), Partition([1,1]))

let λ = Partition([5,4,2,1]), μ = Partition([4,3,2,2,1])
    @test partitionsequence(λ) == [1, 0, 1, 0, 1, 1, 0, 1, 0]
    @test character(λ, μ) == 0
end

let λ = μ = Partition([1])
    @test leglength(λ, μ) == -1
    @test character(λ, μ) == 1
end
