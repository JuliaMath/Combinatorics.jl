using Combinatorics
using Base.Test

# derangement
@test derangement(4) == 9
@test derangement(24) == parse(BigInt,"228250211305338670494289")

# doublefactorial
@test doublefactorial(70) == parse(BigInt,"355044260642859198243475901411974413130137600000000")

# hyperfactorial
@test hyperfactorial(8) == parse(BigInt,"55696437941726556979200000")

# multifactorial
@test multifactorial(40,2) == doublefactorial(40)

# multinomial
@test multinomial(1,4,4,2) == 34650

# primorial
@test primorial(17) == 510510


