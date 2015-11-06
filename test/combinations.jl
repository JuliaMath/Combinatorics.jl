using Combinatorics
using Base.Test

import Combinatorics: combinations


@test collect(combinations([])) == []
@test collect(combinations(['a', 'b', 'c'])) == Any[['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]

@test collect(combinations("abc",3)) == Any[['a','b','c']]
@test collect(combinations("abc",2)) == Any[['a','b'],['a','c'],['b','c']]
@test collect(combinations("abc",1)) == Any[['a'],['b'],['c']]
@test collect(combinations("abc",0)) == Any[Char[]]
@test collect(combinations("abc",-1)) == Any[]

@test collect(filter(x->(iseven(x[1])),combinations([1,2,3],2))) == Any[[2,3]]

