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

import Base: factorial, binomial
	
"Returns the n-th Bell number"
function bellnum(n::Integer)
    if n < 0
        throw(DomainError())
    end
    list = Array(BigInt, n)
    list[1] = 1
    for i = 2:n
        list[i] = list[1]
        for j = 1:i - 1
            list[i - j] += list[i - j + 1]
        end
    end
    return list[1]
end

"Returns the n-th Catalan number"
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
        (Ptr{BigInt}, UInt), &z, UInt(n))
    return z
end


function jacobisymbol(a::Integer, b::Integer)
    ba = BigInt(a)
    bb = BigInt(b)
    return ccall((:__gmpz_jacobi, :libgmp), Cint,
        (Ptr{BigInt}, Ptr{BigInt}), &ba, &bb)
end

"""
Computes Lassalle's sequence
OEIS entry A180874
"""
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
        (Ptr{BigInt}, UInt), &z, UInt(n))
    return z
end

function stirlings1(n::Int, k::Int, signed::Bool=false)
    if signed == true
        return (-1)^(n - k) * stirlings1(n, k)
    end
    
    if n < 0
        throw(DomainError())
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
        throw(DomainError())
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
