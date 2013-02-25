using Catalan

@assert catalan(5) == 42
@assert catalan(30) == BigInt("3814986502092304")
@assert derangement(4) == 9
@assert derangement(24) == BigInt("228250211305338670494289")
@assert doublefactorial(70) == BigInt("355044260642859198243475901411974413130137600000000")
@assert fibonacci(5) == 5
@assert fibonacci(101) == BigInt("573147844013817084101")
@assert hyperfactorial(15) == BigInt("808964493720696635283542546544828676197520735416089908518751853288169656424180656111616000000000000000000000000000000")
@assert legendresymbol(1001,9907) == jacobisymbol(1001,9907)
@assert lucas(10) == 123
@assert lucas(100) == BigInt("792070839848372253127")
@assert multifactorial(40,2) == doublefactorial(40)
@assert multinomial(1,4,4,11) == 34650
@assert primorial(17) == 510510
@assert sum([abs(stirlings(8, i)) for i = 0:8]) == factorial(8)

