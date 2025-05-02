@testset "factorials" begin
    @test factorial(7, 3) == 7 * 6 * 5 * 4
    @test_throws DomainError factorial(3, 7)
    @test_throws DomainError factorial(-3, -7)
    @test_throws DomainError factorial(-7, -3)
    @test_throws DomainError factorial(big"3", big"7")
    @test_throws DomainError factorial(big"-3", big"7")
    @test_throws DomainError factorial(big"3", big"-7")
    #JuliaLang/julia#9943
    @test factorial(big(100), (80)) == 1303995018204712451095685346159820800000
    #JuliaLang/julia#9950
    @test_throws OverflowError factorial(1000, 80)

    # derangement
    @test derangement(4) == subfactorial(4) == 9
    @test derangement(0) == 1
    @test derangement(1) == 0
    @test derangement(24) == parse(BigInt, "228250211305338670494289")
    @test_throws DomainError derangement(-1)

    # partialderangement
    @test partialderangement(7, 3) == 315
    @test_throws DomainError partialderangement(8, 9)
    @test_throws DomainError partialderangement(-8, 0)

    # doublefactorial
    @test doublefactorial(70) == parse(BigInt, "355044260642859198243475901411974413130137600000000")
    @test_throws DomainError doublefactorial(-1)

    # hyperfactorial
    @test hyperfactorial(8) == parse(BigInt, "55696437941726556979200000")
    @test hyperfactorial(0) == parse(BigInt, "1")
    @test hyperfactorial(1) == parse(BigInt, "1")
    @test hyperfactorial(2) == parse(BigInt, "4")

    # multifactorial
    @test multifactorial(40, 2) == doublefactorial(40)
    @test_throws DomainError multifactorial(-1, 1)

    @testset "multinomial" begin
        # > For k=0,1, the multinomial coefficient is defined to be 1
        # https://dlmf.nist.gov/26.4#i.p1
        @test multinomial() == 1
        @test multinomial(0) == 1

        @test multinomial(1, 4, 4, 2) == 34650
        # wolfram:  Multinomial[10, 10, 10, 5]
        @test multinomial(10, 10, 10, 5) == 1_802_031_190_366_286_880

        # checked_mul overflowed for type Int64
        @test_throws OverflowError multinomial(10, 10, 10, 6)
        @test_throws OverflowError multinomial(10, 10, 10, 10)
        # binomial(200, 100) overflows
        @test_throws OverflowError multinomial(100, 100)  
    end

    # primorial
    @test primorial(17) == 510510
    @test_throws DomainError primorial(-1)

end
