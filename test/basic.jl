using Combinatorics
using Base.Test

# catalan
@test catalannum(5) == 42
@test catalannum(30) == parse(BigInt,"3814986502092304")

#combinations
@test collect(Combinatorics.combinations([])) == []
@test collect(Combinatorics.combinations(['a', 'b', 'c'])) == Vector{Char}[['a'],['b'],['c'],['a','b'],['a','c'],['b','c'],['a','b','c']]

# derangement
@test derangement(4) == 9
@test derangement(24) == parse(BigInt,"228250211305338670494289")

# doublefactorial
@test doublefactorial(70) == parse(BigInt,"355044260642859198243475901411974413130137600000000")

# fibonacci
@test fibonaccinum(5) == 5
@test fibonaccinum(101) == parse(BigInt,"573147844013817084101")

# hyperfactorial
@test hyperfactorial(8) == parse(BigInt,"55696437941726556979200000")

# lassalle
@test lassallenum(14) == parse(BigInt,"270316008395632253340")

# legendresymbol
@test legendresymbol(1001,9907) == jacobisymbol(1001,9907) == -1

# lucas
@test lucasnum(10) == 123
@test lucasnum(100) == parse(BigInt,"792070839848372253127")

# multifactorial
@test multifactorial(40,2) == doublefactorial(40)

# multinomial
@test multinomial(1,4,4,2) == 34650

# primorial
@test primorial(17) == 510510

# stirlings1
@test sum([abs(stirlings1(8, i)) for i = 0:8]) == factorial(8)

# bell
@test bellnum(7) == 877
@test bellnum(42) == parse(BigInt,"35742549198872617291353508656626642567")
@test_throws DomainError bellnum(-1)

# integer_partitions
@test integer_partitions(5) == Any[[1, 1, 1, 1, 1], [2, 1, 1, 1], [2, 2, 1], [3, 1, 1], [3, 2], [4, 1], [5]]
@test_throws DomainError integer_partitions(-1)
