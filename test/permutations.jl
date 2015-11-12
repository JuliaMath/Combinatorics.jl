using Combinatorics
using Base.Test

# permutations
@test collect(permutations("abc")) == Any[['a','b','c'],['a','c','b'],['b','a','c'],
                                          ['b','c','a'],['c','a','b'],['c','b','a']]

@test collect(filter(x->(iseven(x[1])),permutations([1,2,3]))) == Any[[2,1,3],[2,3,1]]
@test collect(filter(x->(iseven(x[3])),permutations([1,2,3]))) == Any[[1,3,2],[3,1,2]]

@test length(permutations(0)) == 1

@test collect(permutations("abc", 4)) == Any[]
@test collect(permutations("abc", 2)) == Any[['a','b'],['a','c'],['b','a'],
                                             ['b','c'],['c','a'],['c','b']]
@test collect(permutations("abc", 0)) == Any[Char[]]
@test collect(permutations("abc", -1)) == Any[]
@test collect(permutations("", 1)) == Any[]
@test collect(permutations("", 0)) == Any[Char[]]
@test collect(permutations("", -1)) == Any[]

# multiset_permutations
@test collect(multiset_permutations("aabc", 5)) == Any[]
@test collect(multiset_permutations("aabc", 2)) == Any[['a','a'],['a','b'], ['a','c'],['b','a'],
                                                       ['b','c'],['c','a'],['c','b']]
@test collect(multiset_permutations("aabc", 0)) == Any[Char[]]
@test collect(multiset_permutations("aabc", -1)) == Any[]
@test collect(multiset_permutations("", 1)) == Any[]
@test collect(multiset_permutations("", 0)) == Any[Char[]]
@test collect(multiset_permutations("", -1)) == Any[]
@test length(multiset_permutations("aaaaaaaaaaaaaaaaaaaaab", 21)) == 22

#nthperm!
for n = 0:7, k = 1:factorial(n)
    p = nthperm!([1:n;], k)
    @test isperm(p)
    @test nthperm(p) == k
end
#Euler Problem #24
@test nthperm!([0:9;],1000000) == [2,7,8,3,9,1,5,4,6,0]

@test nthperm([0,1,2],3) == [1,0,2]

@test_throws ArgumentError parity([0])
@test_throws ArgumentError parity([1,2,3,3])
@test levicivita([1,1,2,3]) == 0
@test levicivita([1]) == 1 && parity([1]) == 0
@test map(levicivita, collect(permutations([1,2,3]))) == [1, -1, -1, 1, 1, -1]
@test let p = [3, 4, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == 1 && parity(p) == 0; end
@test let p = [4, 3, 6, 10, 5, 2, 1, 7, 8, 9]; levicivita(p) == -1 && parity(p) == 1; end

@test Combinatorics.nsetpartitions(-1) == 0
@test collect(permutations([])) == Vector[[]]
