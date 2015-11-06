#Factorials and elementary coefficients

export
    derangement,
    factorial,
    subfactorial,
    doublefactorial,
    hyperfactorial,
    multifactorial,
    gamma,
    primorial,
    multinomial

import Base: factorial

"computes n!/k!"
function factorial{T<:Integer}(n::T, k::T)
    if k < 0 || n < 0 || k > n
        throw(DomainError())
    end
    f = one(T)
    while n > k
        f = Base.checked_mul(f,n)
        n -= 1
    end
    return f
end
factorial(n::Integer, k::Integer) = factorial(promote(n, k)...)


"The number of permutations of n with no fixed points (subfactorial)"
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
        (Ptr{BigInt}, UInt), &z, UInt(n))
    return z
end

# Hyperfactorial
hyperfactorial(n::Integer) = prod([i^i for i = BigInt(2):n])

function multifactorial(n::Integer, m::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_mfac_uiui, :libgmp), Void,
        (Ptr{BigInt}, UInt, UInt), &z, UInt(n), UInt(m))
    return z
end

function primorial(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_primorial_ui, :libgmp), Void,
        (Ptr{BigInt}, UInt), &z, UInt(n))
    return z
end

"Multinomial coefficient where n = sum(k)"
function multinomial(k...)
    s = 0
    result = 1
    @inbounds for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end


