#Special named numbers and symbols

export bellnum,
    catalannum,
    fibonaccinum,
    jacobisymbol,
    lassallenum,
    legendresymbol,
    lucasnum,
    stirlings1

# Returns the n-th Bell number
function bellnum(bn::Integer)
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
function catalannum(bn::Integer)
    if bn<0
        throw(DomainError())
    else
        n = BigInt(bn)
    end
    div(binomial(2*n, n), (n + 1))
end

function fibonaccinum(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_fib_ui, :libgmp), Void,
        (Ptr{BigInt}, UInt), &z, @compat(UInt(n)))
    return z
end


function jacobisymbol(a::Integer, b::Integer)
    ba = BigInt(a)
    bb = BigInt(b)
    return ccall((:__gmpz_jacobi, :libgmp), Cint,
        (Ptr{BigInt}, Ptr{BigInt}), &ba, &bb)
end

#Computes Lassalle's sequence
#OEIS entry A180874
function lassallenum(m::Integer)
   A = ones(BigInt,m)
   for n=2:m
       A[n]=(-1)^(n-1) * (catalannum(n) + sum([(-1)^j*binomial(2n-1, 2j-1)*A[j]*catalannum(n-j) for j=1:n-1]))
   end
   A[m]
end

function legendresymbol(a::Integer, b::Integer)
    ba = BigInt(a)
    bb = BigInt(b)
    return ccall((:__gmpz_legendre, :libgmp), Cint,
        (Ptr{BigInt}, Ptr{BigInt}), &ba, &bb)
end

function lucasnum(n::Integer)
    if n < 0
        throw(DomainError())
    end
    z = BigInt()
    ccall((:__gmpz_lucnum_ui, :libgmp), Void,
        (Ptr{BigInt}, UInt), &z, @compat(UInt(n)))
    return z
end

# Returns s(n, k), the signed Stirling number of first kind
function stirlings1(n::Integer, k::Integer)
    p = poly(0:(n-1))
    p[n - k + 1]
end

