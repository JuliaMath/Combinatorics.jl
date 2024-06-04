#Factorials and elementary coefficients

export
    derangement,
    partialderangement,
    factorial,
    subfactorial,
    doublefactorial,
    hyperfactorial,
    multifactorial,
    gamma,
    primorial,
    multinomial

# TODO: This should really live in Base, otherwise it's type piracy
"""
    factorial(n, k)

Compute ``n!/k!``.
"""
function Base.factorial(n::T, k::T) where T<:Integer
    if k < 0 || n < 0 || k > n
        throw(DomainError((n, k), "n and k must be nonnegative with k ≤ n"))
    end
    f = one(T)
    while n > k
        f = Base.checked_mul(f, n)
        n -= 1
    end
    return f
end
Base.factorial(n::Integer, k::Integer) = factorial(promote(n, k)...)


"""
    derangement(n)

Compute the number of permutations of `n` with no fixed points, also known as the
subfactorial. An alias `subfactorial` for this function is provided for convenience.
"""
function derangement(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n <= 1
        return BigInt(1-n)
    end
    d = BigInt(0)
    for i in 2:n
        # d = i * d + (iseven(i) ? 1 : -1)
        Base.GMP.MPZ.mul_ui!(d, i)
        if iseven(i)
            Base.GMP.MPZ.add_ui!(d, 1)
        else
            Base.GMP.MPZ.sub_ui!(d, 1)
        end
    end
    return d
end
const subfactorial = derangement

function doublefactorial(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_2fac_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end

"""
    partialderangement(n, k)
    
Compute the number of permutations of `n` with exactly k fixed points.
"""
function partialderangement(n::Integer, k::Integer)
    if n < 0
        throw(DomainError(n))
    end
    if k < 0 || k > n
        throw(DomainError(k))
    end
    a = BigInt(n)
    b = BigInt(k)
    return subfactorial(a - b) * binomial(a, b)
end

# Hyperfactorial
hyperfactorial(n::Integer) = n==0 ? BigInt(1) : prod(i->i^i, BigInt(1):n)


function multifactorial(n::Integer, m::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_mfac_uiui, :libgmp), Cvoid, (Ref{BigInt}, UInt, UInt), z, UInt(n), UInt(m))
    return z[]
end

function primorial(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_primorial_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end

"""
    multinomial(k...)

Multinomial coefficient where `n = sum(k)`.
"""
function multinomial(k...)
    s = 0
    result = 1
    @inbounds for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end
