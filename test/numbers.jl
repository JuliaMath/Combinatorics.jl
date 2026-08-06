
@testset "numbers" begin
      # bell
      # https://dlmf.nist.gov/26.7#T1
      @test bellnum.(0:10) == [
            1
            1
            2
            5
            15
            52
            203
            877
            4140
            21147
            115975
      ]
      # gap> Bell(42);
      @test bellnum(42) == parse(BigInt, "35742549198872617291353508656626642567")
      @test_throws DomainError bellnum(-1)

      # catalan
      # https://oeis.org/A000108
      @test catalannum.(0:10) == [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796]
      @test catalannum(20) == 6564120420
      @test catalannum(30) == parse(BigInt, "3814986502092304")
      @test_throws DomainError catalannum(-1)

      # fibonacci
      # https://oeis.org/A000045
      # Fibonacci and Lucas Factorizations:  https://mersennus.net/fibonacci/f1000.txt
      @test fibonaccinum.(0:10) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
      @test fibonaccinum(92) == big"7540113804746346429"
      @test fibonaccinum(92) < typemax(Int64) < fibonaccinum(93)
      @test fibonaccinum(101) == parse(BigInt, "573147844013817084101")
      @test fibonaccinum(184) < typemax(Int128) < fibonaccinum(185)
      @test fibonaccinum(233) == (139801 * 25047390419633 * big"631484089583693149557829547141")
      @test_throws DomainError fibonaccinum(-1)

      # lobb
      @test lobbnum(2, 3) == 5
      @test lobbnum(50, 100) == parse(BigInt, "303574146822833458064977353764024400258025594128")
      @test_throws DomainError lobbnum(-1, 2)

      # narayana
      @test narayana(8, 5) == 490
      @test narayana(100, 50) == parse(BigInt, "99794739256977899071474889425225225330079579752931446368")
      @test_throws DomainError narayana(-1, -1)

      # lassalle
      # https://oeis.org/A180874
      @test lassallenum.(1:10) == [1,1,5,56,1092,32670,1387815,79389310,5882844968,548129834616]
      @test lassallenum(14) == parse(BigInt, "270316008395632253340")
      @test lassallenum(17) == parse(BigInt, "4359147487054262623576455600")

      # legendresymbol
      @test legendresymbol(1001, 9907) == jacobisymbol(1001, 9907) == -1

      # lucas
      @test lucasnum(10) == 123
      @test lucasnum(100) == parse(BigInt, "792070839848372253127")
      @test_throws DomainError lucasnum(-1)

      # stirlings1
      @test_throws DomainError stirlings1(-1, 1)
      @test typeof(stirlings1(6, 2)) == Int
      @test stirlings1(0, 0) == 1
      @test stirlings1(1, 1) == 1
      @test stirlings1(2, 6) == 0
      @test stirlings1(6, 0) == 0
      @test stirlings1(6, 0, true) == 0
      @test stirlings1(6, 1) == 120
      @test stirlings1(6, 1, true) == -120
      @test stirlings1(6, 2) == 274
      @test stirlings1(6, 2, true) == 274
      @test stirlings1(6, 3) == 225
      @test stirlings1(6, 3, true) == -225
      @test stirlings1(6, 4) == 85
      @test stirlings1(6, 4, true) == 85
      @test stirlings1(6, 5) == 15
      @test stirlings1(6, 5, true) == -15
      @test stirlings1(6, 6) == 1
      @test stirlings1(6, 6, true) == 1
      @test sum([abs(stirlings1(8, i, true)) for i = 0:8]) == factorial(8)
      @test stirlings1(big"26", 10) == 196928100451110820242880

      # stirlings2
      @test_throws DomainError stirlings2(-1, 1)
      @test typeof(stirlings2(6, 2)) == Int
      @test stirlings2(0, 0) == 1
      @test stirlings2(1, 1) == 1
      @test stirlings2(2, 6) == 0
      @test stirlings2(6, 0) == 0
      @test stirlings2(6, 1) == 1
      @test stirlings2(6, 2) == 31
      @test stirlings2(6, 3) == 90
      @test stirlings2(6, 4) == 65
      @test stirlings2(6, 5) == 15
      @test stirlings2(6, 6) == 1
      @test stirlings2(big"26", 10) == 13199555372846848005

end
