using Combinatorics
using Base.Test

import Combinatorics: invperm, ipermute!, isperm, levicivita, nthperm, nthperm!, parity, permutations, permute!

p = shuffle([1:1000;])
@test isperm(p)
@test all(invperm(invperm(p)) .== p)

push!(p, 1)
@test !isperm(p)

a = randcycle(10)
@test ipermute!(permute!([1:10;], a),a) == [1:10;]

# PR 12785
let a = 2:-1:1
    @test ipermute!(permute!([1, 2], a), a) == [1, 2]
end

@test collect(permutations("abc")) == Any[['a','b','c'],['a','c','b'],['b','a','c'],
                                          ['b','c','a'],['c','a','b'],['c','b','a']]

@test collect(filter(x->(iseven(x[1])),permutations([1,2,3]))) == Any[[2,1,3],[2,3,1]]
@test collect(filter(x->(iseven(x[3])),permutations([1,2,3]))) == Any[[1,3,2],[3,1,2]]

@test length(permutations(0)) == 1

for n = 0:7, k = 1:factorial(n)
    p = nthperm!([1:n;], k)
    @test isperm(p)
    @test nthperm(p) == k
end

@test_throws ArgumentError parity([0])
@test_throws ArgumentError parity([1,2,3,3])
@test levicivita([1,1,2,3]) == 0
@test levicivita([1]) == 1 && parity([1]) == 0
@test map(levicivita, collect(permutations([1,2,3]))) == [1, -1, -1, 1, 1, -1]
@test let p = [3, 4, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == 1 && parity(p) == 0; end
@test let p = [4, 3, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == -1 && parity(p) == 1; end

@test Combinatorics.nsetpartitions(-1) == 0
@test collect(permutations([])) == Vector[[]]

