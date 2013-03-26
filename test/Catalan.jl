using Catalan
using Test

@test catalan(5) == 42
@test catalan(30) == BigInt("3814986502092304")
@test derangement(4) == 9
@test derangement(24) == BigInt("228250211305338670494289")
@test doublefactorial(70) == BigInt("355044260642859198243475901411974413130137600000000")
@test fibonacci(5) == 5
@test fibonacci(101) == BigInt("573147844013817084101")
@test hyperfactorial(15) == BigInt("55696437941726556979200000")
@test legendresymbol(1001,9907) == jacobisymbol(1001,9907)
@test lucas(10) == 123
@test lucas(100) == BigInt("792070839848372253127")
@test multifactorial(40,2) == doublefactorial(40)
@test multinomial(1,4,4,2) == 34650
@test primorial(17) == 510510
@test sum([abs(stirlings1(8, i)) for i = 0:8]) == factorial(8)
