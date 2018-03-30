#Special named numbers and symbols

export bellnum,
    catalannum,
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
function bellnum(bn::Integer)
    if bn < 0
        throw(DomainError(bn, "n must be nonnegative"))
    else
        n = BigInt(bn)
    end
    list = Vector{BigInt}(undef, div(n*(n+1), 2))
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

function stirlings1(n::Int, k::Int, signed::Bool=false)
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

function stirlings2(n::Int, k::Int)
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
