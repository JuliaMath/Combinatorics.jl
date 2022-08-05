@testset "numbers" begin
      # catalan
      @test catalannum(5) == 42
      @test catalannum(30) == parse(BigInt, "3814986502092304")
      @test_throws DomainError catalannum(-1)

      # fibonacci
      @test fibonaccinum(5) == 5
      @test fibonaccinum(101) == parse(BigInt, "573147844013817084101")
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
      @test lassallenum(14) == parse(BigInt, "270316008395632253340")

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

      # bell
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

      @test bellnum(42) == parse(BigInt, "35742549198872617291353508656626642567")
      @test_throws DomainError(-1) bellnum(-1)

end
