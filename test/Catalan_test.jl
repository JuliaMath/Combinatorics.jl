using Catalan
using Base.Test

# catalan
@test catalan(5) == 42
@test catalan(30) == BigInt("3814986502092304")

# derangement
@test derangement(4) == 9
@test derangement(24) == BigInt("228250211305338670494289")

# doublefactorial
@test doublefactorial(70) == BigInt("355044260642859198243475901411974413130137600000000")

# fibonacci
@test fibonacci(5) == 5
@test fibonacci(101) == BigInt("573147844013817084101")

# hyperfactorial
@test hyperfactorial(8) == BigInt("55696437941726556979200000")

# lassalle
@test lassalle(14) == BigInt("270316008395632253340")

# legendresymbol
@test legendresymbol(1001,9907) == jacobisymbol(1001,9907)

# lucas
@test lucas(10) == 123
@test lucas(100) == BigInt("792070839848372253127")

# multifactorial
@test multifactorial(40,2) == doublefactorial(40)

# multinomial
@test multinomial(1,4,4,2) == 34650

# primorial
@test primorial(17) == 510510

# stirlings1
@test sum([abs(stirlings1(8, i)) for i = 0:8]) == factorial(8)

# bell
@test bell(7) == 877
@test bell(42) == BigInt("35742549198872617291353508656626642567")
@test_throws bell(-1)

# integer_partitions
@test integer_partitions(5) == {[1, 1, 1, 1, 1], [2, 1, 1, 1], [2, 2, 1], [3, 1, 1], [3, 2], [4, 1], [5]}
@test_throws integer_partitions(-1)

include("youngdiagrams.jl")
