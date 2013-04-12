module Catalan
using Polynomial

export  bell,
        catalan,
        derangement,
        doublefactorial,
        fibonacci,
        hyperfactorial,
        jacobisymbol,
        lassalle,
        legendresymbol,
        lucas,
        multifactorial,
        multinomial,
        primorial,
        stirlings1,
        subfactorial

include("youngdiagrams.jl")

# Returns the n-th Bell number
function bell(bn::Integer)
    if bn < 0
        throw(DomainError())
    else
        n = BigInt(bn)
    end
    list = Array(BigInt, div(n*(n+1), 2))
    list[1] = 1
    for i = 2:n
        beg = div(i*(i-1),2)
        list[beg+1] = list[beg]
        for j = 2:i
            list[beg+j] = list[beg+j-1]+list[beg+j-i]
        end
    end
    return list[end]
end

# Returns the n-th Catalan number
function catalan(bn::Integer)
    if bn<0
        throw(DomainError())
    else
        n = BigInt(bn)
    end
    div(binomial(2*n, n), (n + 1))
end

# The number of permutations of n with no fixed points (subfactorial) 
function derangement(sn::Integer)
    n = BigInt(sn)
    return num(factorial(n)*sum([(-1)^k//factorial(k) for k=0:n]))
end
subfactorial(n::Integer) = derangement(n)

function doublefactorial(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_2fac_ui, :libgmp), Void,
        (Ptr{Void}, Uint), z.mpz, uint(n))
    return z
end

function fibonacci(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_fib_ui, :libgmp), Void,
        (Ptr{Void}, Uint), z.mpz, uint(n))
    return z
end

# Hyperfactorial
hyperfactorial(n::Integer) = prod([i^i for i = BigInt(2):n])

function jacobisymbol(a::Integer, b::Integer)
    ba = BigInt(a)
    bb = BigInt(b)
    return ccall((:__gmpz_jacobi, :libgmp), Int,
        (Ptr{Void}, Ptr{Void}), ba.mpz, bb.mpz)
end

#Computes Lassalle's sequence
#OEIS entry A180874
function lassalle(m::Integer)
   A = ones(BigInt,m)
   for n=2:m
       A[n]=(-1)^(n-1) * (catalan(n) + sum([(-1)^j*binomial(2n-1, 2j-1)*A[j]*catalan(n-j) for j=1:n-1]))
   end
   A[m]
end

function legendresymbol(a::Integer, b::Integer)
    ba = BigInt(a)
    bb = BigInt(b)
    return ccall((:__gmpz_legendre, :libgmp), Int,
        (Ptr{Void}, Ptr{Void}), ba.mpz, bb.mpz)
end

function lucas(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_lucnum_ui, :libgmp), Void,
        (Ptr{Void}, Uint), z.mpz, uint(n))
    return z
end

function multifactorial(n::Integer, m::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_mfac_uiui, :libgmp), Void,
        (Ptr{Void}, Uint, Uint), z.mpz, uint(n), uint(m))
    return z
end

# Multinomial coefficient where n = sum(k)
function multinomial(k...)
    s = 0
    result = 1
    for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end

function primorial(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_primorial_ui, :libgmp), Void,
        (Ptr{Void}, Uint), z.mpz, uint(n))
    return z
end

# Returns s(n, k), the signed Stirling number of first kind
function stirlings1(n::Integer, k::Integer)
    p = poly(0:(n-1))
    p[n - k + 1]
end

end
