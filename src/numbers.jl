#Special named numbers and symbols

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
"""
function bellnum(n::Integer)
    if n < 0
        throw(DomainError(n))
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

Compute the ``n``th Catalan number.
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
    lobbnum(m,n)

Compute the Lobb number `L(m,n)`, or the generalised Catalan number given by ``\\frac{2m+1}{m+n+1} \\binom{2n}{m+n}``.
Wikipedia : https://en.wikipedia.org/wiki/Lobb_number
"""
function lobbnum(bm::Integer,bn::Integer)
    if !(0 <= bm <= bn)
        throw(DomainError("m and n must be non-negative"))
    else
        m = BigInt(bm)
        n = BigInt(bn)
    end
    div(binomial(2*n, m + n)*(2*m + 1), (m + n + 1))
end

"""
    narayana(n,k)

Compute the Narayana number `N(n,k)`` given by ``\\frac{1}{n}\\binom{n}{k}\\binom{n}{k-1}``
Wikipedia : https://en.wikipedia.org/wiki/Narayana_number
"""
function narayana(bn::Integer,bk::Integer)
    if !(1 <= bk <= bn)
        throw(DomainError("Domain is 1 <= k <= n"))
    else
        n = BigInt(bn)
        k = BigInt(bk)
    end
    div(binomial(n, k)*binomial(n, k - 1) , n)
end

function fibonaccinum(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_fib_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end


function jacobisymbol(a::Integer, b::Integer)
    ba = Ref{BigInt}(a)
    bb = Ref{BigInt}(b)
    return ccall((:__gmpz_jacobi, :libgmp), Cint, (Ref{BigInt}, Ref{BigInt}), ba, bb)
end

"""
    lassallenum(n)

Compute the ``n``th entry in Lassalle's sequence, OEIS entry A180874.
"""
function lassallenum(m::Integer)
    A = ones(BigInt, m)
    for n = 2:m
        A[n] = (-1)^(n-1) * (catalannum(n) + sum(j->(-1)^j*binomial(2n-1, 2j-1)*A[j]*catalannum(n-j), 1:n-1))
    end
    A[m]
end

function legendresymbol(a::Integer, b::Integer)
    ba = Ref{BigInt}(a)
    bb = Ref{BigInt}(b)
    return ccall((:__gmpz_legendre, :libgmp), Cint, (Ref{BigInt}, Ref{BigInt}), ba, bb)
end

function lucasnum(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    end
    z = Ref{BigInt}(0)
    ccall((:__gmpz_lucnum_ui, :libgmp), Cvoid, (Ref{BigInt}, UInt), z, UInt(n))
    return z[]
end

stirlings1cache = Dict()

function stirlings1(n::Integer, k::Integer, signed::Bool=false)
    if signed == true
        return (-1)^(n - k) * stirlings1(n, k)
    end

    if haskey(stirlings1cache, Pair(n, k))
        return stirlings1cache[Pair(n, k)]
    elseif n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == k == 0
        return one(n)
    elseif n == 0 || k == 0
        return zero(n)
    elseif n == k
        return one(n)
    elseif k == 1
        return factorial(n-1)
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == n - 2
        return div((3 * n - 1) * binomial(n, 3), 4)
    elseif k == n - 3
        return binomial(n, 2) * binomial(n, 4)
    end

    ret = (n - 1) * stirlings1(n - 1, k) + stirlings1(n - 1, k - 1)
    stirlings1cache[Pair(n, k)] = ret
    return ret
end

stirlings2cache = Dict()

function stirlings2(n::Integer, k::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif haskey(stirlings2cache, Pair(n, k))
        return stirlings2cache[Pair(n, k)]
    elseif n == k == 0
        return one(n)
    elseif n == 0 || k == 0
        return zero(n)
    elseif k == n - 1
        return binomial(n, 2)
    elseif k == 2
        return 2^(n-1) - 1
    end

    ret = k * stirlings2(n - 1, k) + stirlings2(n - 1, k - 1)
    stirlings2cache[Pair(n, k)] = ret
    ret
end
