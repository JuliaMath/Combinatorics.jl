@test [combinations([])...] == []
@test [combinations(['a', 'b', 'c'])...] == [['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]

@test [combinations("abc",3)...] == [['a','b','c']]
@test [combinations("abc",2)...] == [['a','b'],['a','c'],['b','c']]
@test [combinations("abc",1)...] == [['a'],['b'],['c']]
@test [combinations("abc",0)...] == [[]]
@test [combinations("abc",-1)...] == []

@test filter(x->iseven(x[1]),[combinations([1,2,3],2)...]) == Any[[2,3]]

# multiset_combinations
@test [multiset_combinations("aabc", 5)...] == Any[]
@test [multiset_combinations("aabc", 2)...] == Any[['a','a'],['a','b'],['a','c'],['b','c']]
@test [multiset_combinations("aabc", 1)...] == Any[['a'],['b'],['c']]
@test [multiset_combinations("aabc", 0)...] == Any[Char[]]
@test [multiset_combinations("aabc", -1)...] == Any[]
@test [multiset_combinations("", 1)...] == Any[]
@test [multiset_combinations("", 0)...] == Any[Char[]]
@test [multiset_combinations("", -1)...] == Any[]

# with_replacement_combinations
@test [with_replacement_combinations("abc", 2)...] == Any[['a','a'],['a','b'],['a','c'],
                                                              ['b','b'],['b','c'],['c','c']]
@test [with_replacement_combinations("abc", 1)...] == Any[['a'],['b'],['c']]
@test [with_replacement_combinations("abc", 0)...] == Any[Char[]]
@test [with_replacement_combinations("abc", -1)...] == Any[]
@test [with_replacement_combinations("", 1)...] == Any[]
@test [with_replacement_combinations("", 0)...] == Any[Char[]]
@test [with_replacement_combinations("", -1)...] == Any[]


#cool-lex iterator
@test_throws DomainError [CoolLexCombinations(-1, 1)...]
@test_throws DomainError [CoolLexCombinations(5, 0)...]
@test [CoolLexCombinations(4,2)...] == Vector[[1,2], [2,3], [1,3], [2,4], [3,4], [1,4]]
@test isa(iterate(CoolLexCombinations(1000, 20))[2], Combinatorics.CoolLexIterState{BigInt})


# multichoose
@test multichoose(0, 1) == 0
@test multichoose(0, 2) == 0
@test multichoose(0, 3) == 0
@test multichoose(1, 1) == 1
@test multichoose(1, 2) == 1
@test multichoose(1, 3) == 1
@test multichoose(2, 1) == 2
@test multichoose(2, 2) == 3
@test multichoose(2, 3) == 4
@test multichoose(3, 0) == 1
@test multichoose(3, 1) == 3
@test multichoose(3, 2) == 6
@test multichoose(3, 3) == 10
@test multichoose(10, 8) == 24310

# multicombinations
@test [multicombinations("abc", 0)...] == [Char[]]
@test [multicombinations("abc", 1)...] == [['a'], ['b'], ['c']]
@test [multicombinations("abc", 2)...] == [['a','a'], ['a','b'], ['a','c'], ['b','b'], ['b','c'], ['c','c']]
@test [multicombinations("abc", 3)...] == [['a','a','a'], ['a','a','b'], ['a','a','c'], ['a','b','b'],
    ['a','b','c'], ['a','c','c'], ['b','b','b'], ['b','b','c'], ['b','c','c'], ['c','c','c']]
    
# Power set
@test collect(powerset([])) == Any[[]]
@test collect(powerset(['a', 'b', 'c'])) == Any[[],['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]
@test collect(powerset(['a', 'b', 'c'], 1)) == Any[['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]
@test collect(powerset(['a', 'b', 'c'], 1, 2)) == Any[['a'],['b'],['c'],['a','b'],['a','c'],['b','c']]
