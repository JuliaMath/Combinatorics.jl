using Combinatorics
using Base.Test

# catalan
@test catalannum(5) == 42
@test catalannum(30) == parse(BigInt,"3814986502092304")
@test_throws DomainError catalannum(-1)

# fibonacci
@test fibonaccinum(5) == 5
@test fibonaccinum(101) == parse(BigInt,"573147844013817084101")
@test_throws DomainError fibonaccinum(-1)

# lassalle
@test lassallenum(14) == parse(BigInt,"270316008395632253340")

# legendresymbol
@test legendresymbol(1001,9907) == jacobisymbol(1001,9907) == -1

# lucas
@test lucasnum(10) == 123
@test lucasnum(100) == parse(BigInt,"792070839848372253127")
@test_throws DomainError lucasnum(-1)

# stirlings1
@test sum([abs(stirlings1(8, i)) for i = 0:8]) == factorial(8)

# bell
@test bellnum(7) == 877
@test bellnum(42) == parse(BigInt,"35742549198872617291353508656626642567")
@test_throws DomainError bellnum(-1)


