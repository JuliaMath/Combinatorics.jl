using Combinatorics
using Base.Test

import Combinatorics: combinations


@test collect(combinations([])) == []
@test collect(combinations(['a', 'b', 'c'])) == Any[['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]

@test collect(combinations("abc",3)) == Any[['a','b','c']]
@test collect(combinations("abc",2)) == Any[['a','b'],['a','c'],['b','c']]
@test collect(combinations("abc",1)) == Any[['a'],['b'],['c']]
@test collect(combinations("abc",0)) == Any[[]]
@test collect(combinations("abc",-1)) == []

@test collect(filter(x->(iseven(x[1])),combinations([1,2,3],2))) == Any[[2,3]]

#cool-lex iterator
@test_throws DomainError collect(CoolLexCombinations(-1, 1))
@test_throws DomainError collect(CoolLexCombinations(5, 0))
@test collect(CoolLexCombinations(4,2)) == Vector[[1,2], [2,3], [1,3], [2,4], [3,4], [1,4]]
@test isa(start(CoolLexCombinations(1000, 20)), Combinatorics.CoolLexIterState{BigInt})

