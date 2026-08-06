# Special named numbers and symbols

export bellnum,
    catalannum,
    lobbnum,
    narayana,
    fibonaccinum,
    jacobisymbol,
    lassallenum,
    legendresymbol,
    lucasnum,
    stirlings1,
    stirlings2

"""
    bellnum(n)

Compute the ``n``th Bell number.

# Examples
```jldoctest
julia> [ bellnum(i) for i in 0:5 ]
6-element Vector{Signed}:
  1
  1
  2
  5
 15
 52

julia> bellnum(-1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Bell number - Wikipedia](https://en.wikipedia.org/wiki/Bell_number)
- [DLMF: §26.7 Set Partitions: Bell Numbers](https://dlmf.nist.gov/26.7)
"""
function bellnum(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n < 2
        return 1
    end
    list = Vector{BigInt}(undef, n)
    list[1] = 1
    for i = 2:n
        for j = 1:i - 2
            list[i - j - 1] += list[i - j]
        end
        list[i] = list[1] + list[i - 1]
    end
    return list[n]
end


"""
    catalannum(n)

Compute the ``n``th Catalan number given by:
```math
C_n = \\frac{1}{n+1} \\binom{2n}{n}
```

# Examples
```jldoctest
julia> [ catalannum(i) for i in 0:5 ]
6-element Vector{BigInt}:
  1
  1
  2
  5
 14
 42

julia> catalannum(-1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Catalan number - Wikipedia](https://en.wikipedia.org/wiki/Catalan_number)
- [DLMF: §26.5 Lattice Paths: Catalan Numbers](https://dlmf.nist.gov/26.5)
"""
function catalannum(bn::Integer)
    if bn < 0
        throw(DomainError(bn, "n must be nonnegative"))
    else
        n = BigInt(bn)
    end
    div(binomial(2*n, n), (n + 1))
end

"""
    lobbnum(m, n)

Compute the Lobb number `L(m,n)`, or the generalised Catalan number given by:
```math
L_{m,n} = \\frac{2m+1}{m+n+1} \\binom{2n}{m+n}
```
For `m = 0`, we get the ``n``-th Catalan number.

See also: [`catalannum`](@ref).

# Examples
```jldoctest
julia> [ [lobbnum(m, n) for m in 0:n] for n in 0:5 ]
6-element Vector{Vector{BigInt}}:
 [1]
 [1, 1]
 [2, 3, 1]
 [5, 9, 5, 1]
 [14, 28, 20, 7, 1]
 [42, 90, 75, 35, 9, 1]

julia> lobbnum(0, 25) == catalannum(25)
true

julia> lobbnum(-1, 1)
ERROR: DomainError with (m = -1, n = 1):
m and n must be non-negative and m <= n
Stacktrace:
[...]

julia> lobbnum(5, 1)
ERROR: DomainError with (m = 5, n = 1):
m and n must be non-negative and m <= n
Stacktrace:
[...]
```

# References
- [Lobb number - Wikipedia](https://en.wikipedia.org/wiki/Lobb_number)
"""
function lobbnum(bm::Integer, bn::Integer)
    if !(0 <= bm <= bn)
        throw(DomainError((m=bm, n=bn), "m and n must be non-negative and m <= n"))
    else
        m = BigInt(bm)
        n = BigInt(bn)
    end
    div(binomial(2*n, m + n)*(2*m + 1), (m + n + 1))
end

"""
    narayana(n,k)

Compute the Narayana number `N(n,k)` given by ``\\frac{1}{n}\\binom{n}{k}\\binom{n}{k-1}``,
where ``1 \\leq k \\leq n``.

# Examples
```jldoctest
julia> narayana(1, 1)
1

julia> narayana(8, 5)
490

julia> [ [narayana(n, k) for k in 1:n] for n in 1:6 ]
6-element Vector{Vector{BigInt}}:
 [1]
 [1, 1]
 [1, 3, 1]
 [1, 6, 6, 1]
 [1, 10, 20, 10, 1]
 [1, 15, 50, 50, 15, 1]

julia> narayana(3, 4)
ERROR: DomainError with (n = 3, k = 4):
n and k must be 1 <= k <= n
Stacktrace:
[...]
```

# References
- [Narayana number - Wikipedia](https://en.wikipedia.org/wiki/Narayana_number)
- [DLMF: §26.6 Narayana Number](https://dlmf.nist.gov/26.6#Px3)
"""
function narayana(bn::Integer,bk::Integer)
    if !(1 <= bk <= bn)
        throw(DomainError((n=bn, k=bk), "n and k must be 1 <= k <= n"))
    else
        n = BigInt(bn)
        k = BigInt(bk)
    end
    div(binomial(n, k)*binomial(n, k - 1) , n)
end

"""
    fibonaccinum(n)

Compute the ``n``th Fibonacci number, ``F_n``, given by:
```math
F_0 = 0
\\\\
F_1 = 1
\\\\
F_n = F_{n-1} + F_{n-2}
```

# Examples
```jldoctest
julia> [ fibonaccinum(i) for i in 0:5 ]
6-element Vector{BigInt}:
 0
 1
 1
 2
 3
 5

julia> fibonaccinum(13)
233

julia> fibonaccinum(-1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Fibonacci sequence - Wikipedia](https://en.wikipedia.org/wiki/Fibonacci_sequence)
- [DLMF: §26.11 Fibonacci number](https://dlmf.nist.gov/26.11#p4)
"""
function fibonaccinum(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_fib_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end


"""
    jacobisymbol(a, b)

Compute the Jacobi symbol ``\\left(\\tfrac{a}{b}\\right)`` for odd ``b``.
Returns ``-1``, ``0``, or ``1``.

# Examples
```jldoctest
julia> jacobisymbol.(2:4, 3)
3-element Vector{Int32}:
 -1
  0
  1

julia> jacobisymbol.(-2:2, 1)  # (a|1) = 1
5-element Vector{Int32}:
 1
 1
 1
 1
 1

julia> [jacobisymbol(a, n) for n in (1,3,5,7,9), a in 1:9]
5×9 Matrix{Int32}:
 1   1   1  1   1   1   1   1  1
 1  -1   0  1  -1   0   1  -1  0
 1  -1  -1  1   0   1  -1  -1  1
 1   1  -1  1  -1  -1   0   1  1
 1   1   0  1   1   0   1   1  0

julia> jacobisymbol(1001, 9907)
-1
```

# References
- [Jacobi symbol - Wikipedia](https://en.wikipedia.org/wiki/Jacobi_symbol)
- [DLMF: §27.9 Jacobi symbol](https://dlmf.nist.gov/27.9#p3)
"""
function jacobisymbol(a::Integer, b::Integer)
    ba = Ref{BigInt}(a)
    bb = Ref{BigInt}(b)
    return ccall((:__gmpz_jacobi, :libgmp), Cint, (Ref{BigInt}, Ref{BigInt}), ba, bb)
end

"""
    lassallenum(n)

Compute the ``n``th entry in Lassalle's sequence, OEIS entry A180874.

# Examples
```jldoctest
julia> lassallenum.(1:5)
5-element Vector{BigInt}:
    1
    1
    5
   56
 1092

julia> lassallenum(14)
270316008395632253340
```

# References
- Lassalle, M. (2012). Two integer sequences related to Catalan numbers.
  *Journal of Combinatorial Theory*, Series A, 119(4), 923-935.
- [OEIS A180874](https://oeis.org/A180874)
"""
function lassallenum(m::Integer)
    A = ones(BigInt, m)
    for n = 2:m
        A[n] = (-1)^(n-1) * (catalannum(n) + sum(j->(-1)^j*binomial(2n-1, 2j-1)*A[j]*catalannum(n-j), 1:n-1))
    end
    A[m]
end

"""
    legendresymbol(a, p)

Compute the Legendre symbol ``\\left(\\tfrac{a}{p}\\right)`` for odd prime ``p``.
Returns ``-1``, ``0``, or ``1``.

# Examples
```jldoctest
julia> legendresymbol.(6:8, 7)
3-element Vector{Int32}:
 -1
  0
  1

julia> [ [legendresymbol.(a, n) for a in 0:(n-1)] for n in (1,3,5,7,9) ]
5-element Vector{Vector{Int32}}:
 [1]
 [0, 1, -1]
 [0, 1, -1, -1, 1]
 [0, 1, 1, -1, 1, -1, -1]
 [0, 1, 1, 0, 1, 1, 0, 1, 1]

julia> legendresymbol(1001, 9907)
-1
```

# References
- [Legendre symbol - Wikipedia](https://en.wikipedia.org/wiki/Legendre_symbol)
- [DLMF: §27.9 Legendre symbol](https://dlmf.nist.gov/27.9)
"""
function legendresymbol(a::Integer, b::Integer)
    ba = Ref{BigInt}(a)
    bb = Ref{BigInt}(b)
    return ccall((:__gmpz_legendre, :libgmp), Cint, (Ref{BigInt}, Ref{BigInt}), ba, bb)
end

"""
    lucasnum(n)

Compute the ``n``th Lucas number, ``L_n``, given by:
```math
L_0 = 2
\\\\
L_1 = 1
\\\\
L_n = L_{n-1} + L_{n-2}
```

# Examples
```jldoctest
julia> [ lucasnum(i) for i in 0:5 ]
6-element Vector{BigInt}:
  2
  1
  3
  4
  7
 11

julia> lucasnum(10)
123

julia> lucasnum(-1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Lucas number - Wikipedia](https://en.wikipedia.org/wiki/Lucas_number)
- [DLMF: §24.15 Lucas numbers](https://dlmf.nist.gov/24.15#iv.p1)
"""
function lucasnum(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_lucnum_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end

"""
    stirlings1(n::Integer, k::Integer, signed::Bool=false)

Compute the Stirling number of the first kind, ``s(n,k)``, for non-negative `n`.

If `signed` is `true`, return the signed value ``(-1)^{n-k} s(n,k)``.

# Examples
```jldoctest
julia> stirlings1(0, 0)
1

julia> stirlings1(5, 5)  # s(n, n) = 1
1

julia> n=9; stirlings1(n, 1) == factorial(n-1)
true

julia> n=233; stirlings1(n, n-1) == binomial(n,2)
true

julia> stirlings1(6, 3, true)
-225

julia> [stirlings1(n,k,true) for n in 1:6, k in 1:6]
6×6 Matrix{Int64}:
    1    0     0    0    0  0
   -1    1     0    0    0  0
    2   -3     1    0    0  0
   -6   11    -6    1    0  0
   24  -50    35  -10    1  0
 -120  274  -225   85  -15  1

julia> stirlings1(-1, 1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Stirling numbers of the first kind - Wikipedia](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_first_kind)
- [DLMF: §26.8 Stirling number of the first kind](https://dlmf.nist.gov/26.8#i.p1)
"""
function stirlings1(n::Integer, k::Integer, signed::Bool=false)
    if signed == true
        return (-1)^(n - k) * stirlings1(n, k)
    end

    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == k == 0
        return 1
    elseif n == 0 || k == 0
        return 0
    elseif n == k
        return 1
    elseif k == 1
        return factorial(n-1)
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == n - 2
        return div((3 * n - 1) * binomial(n, 3), 4)
    elseif k == n - 3
        return binomial(n, 2) * binomial(n, 4)
    end

    return (n - 1) * stirlings1(n - 1, k) + stirlings1(n - 1, k - 1)
end

"""
    stirlings2(n::Integer, k::Integer)

Compute the Stirling number of the second kind, ``S(n,k)``, for non-negative `n`.

# Examples
```jldoctest
julia> stirlings2(0, 0)
1

julia> n=233; stirlings2(n, 0) == 0  # n > 0
true

julia> stirlings2(0, 1)
0

julia> n=13; stirlings2(n, 1) == stirlings2(n, n) == 1  # n > 0
true

julia> n=6; [stirlings2(6, k) for k in 0:6]
7-element Vector{Int64}:
  0
  1
 31
 90
 65
 15
  1

julia> n=6; sum(stirlings2(6, k) for k in 0:6) == bellnum(n)
true

julia> [stirlings2(n,k) for n in 1:6, k in 1:6]
6×6 Matrix{Int64}:
 1   0   0   0   0  0
 1   1   0   0   0  0
 1   3   1   0   0  0
 1   7   6   1   0  0
 1  15  25  10   1  0
 1  31  90  65  15  1

julia> stirlings2(-1, 1)
ERROR: DomainError with -1:
n must be nonnegative
Stacktrace:
[...]
```

# References
- [Stirling numbers of the second kind - Wikipedia](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind)
- [DLMF: §26.8 Stirling number of the second kind](https://dlmf.nist.gov/26.8#i.p3)
"""
function stirlings2(n::Integer, k::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == k == 0
        return 1
    elseif n == 0 || k == 0
        return 0
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == 2
        return 2^(n-1) - 1
    end

    return k * stirlings2(n - 1, k) + stirlings2(n - 1, k - 1)
end
