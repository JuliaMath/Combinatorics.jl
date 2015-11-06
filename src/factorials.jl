#Factorials and elementary coefficients

export
    derangement,
    subfactorial,
    doublefactorial,
    hyperfactorial,
    multifactorial,
    gamma,
    primorial,
    multinomial

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
        (Ptr{BigInt}, UInt), &z, @compat(UInt(n)))
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
        (Ptr{BigInt}, UInt, UInt), &z, @compat(UInt(n)), @compat(UInt(m)))
    return z
end

function primorial(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_primorial_ui, :libgmp), Void,
        (Ptr{BigInt}, UInt), &z, @compat(UInt(n)))
    return z
end

#Multinomial coefficient where n = sum(k)
function multinomial(k...)
    s = 0
    result = 1
    for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end


