@test factorial(7,3) == 7*6*5*4
@test_throws DomainError factorial(3,7)
@test_throws DomainError factorial(-3,-7)
@test_throws DomainError factorial(-7,-3)
#JuliaLang/julia#9943
@test factorial(big(100), (80)) == 1303995018204712451095685346159820800000
#JuliaLang/julia#9950
@test_throws OverflowError factorial(1000,80)

# derangement
@test derangement(4) == subfactorial(4) == 9
@test derangement(24) == parse(BigInt,"228250211305338670494289")

# partialderangement
@test partialderangement(7, 3) == 315
@test_throws DomainError partialderangement(8, 9)
@test_throws DomainError partialderangement(-8, 0)

# doublefactorial
@test doublefactorial(70) == parse(BigInt,"355044260642859198243475901411974413130137600000000")
@test_throws DomainError doublefactorial(-1)

# hyperfactorial
@test hyperfactorial(8) == parse(BigInt,"55696437941726556979200000")

# multifactorial
@test multifactorial(40,2) == doublefactorial(40)
@test_throws DomainError multifactorial(-1,1)

# multinomial
@test multinomial(1,4,4,2) == 34650

# primorial
@test primorial(17) == 510510
@test_throws DomainError primorial(-1)
