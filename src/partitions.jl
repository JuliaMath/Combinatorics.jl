#Partitions

export
    integer_partitions,
    ncpartitions,
    partitions,
    prevprod
    #nextprod,


#integer partitions

struct IntegerPartitions
    n::Int
end

Base.length(p::IntegerPartitions) = npartitions(p.n)
Base.eltype(p::IntegerPartitions) = Vector{Int}

function Base.iterate(p::IntegerPartitions, xs = Int[])
    length(xs) == p.n && return
    xs = nextpartition(p.n,xs)
    (xs, xs)
end

"""
    partitions(n)

Generate all integer arrays that sum to `n`. Because the number of partitions can be very
large, this function returns an iterator object. Use `collect(partitions(n))` to get an
array of all partitions. The number of partitions to generate can be efficiently computed
using `length(partitions(n))`.
"""
partitions(n::Integer) = IntegerPartitions(n)



function nextpartition(n, as)
    isempty(as) && return Int[n]

    xs = similar(as, 0)
    sizehint!(xs, length(as) + 1)

    for i = 1:length(as)-1
        if as[i+1] == 1
            x = as[i]-1
            push!(xs, x)
            n -= x
            while n > x
                push!(xs, x)
                n -= x
            end
            push!(xs, n)

            return xs
        end
        push!(xs, as[i])
        n -= as[i]
    end
    push!(xs, as[end]-1)
    push!(xs, 1)

    xs
end

let _npartitions = Dict{Int,Int}()
    global npartitions
    function npartitions(n::Int)
        if n < 0
            0
        elseif n < 2
            1
        elseif (np = get(_npartitions, n, 0)) > 0
            np
        else
            np = 0
            sgn = 1
            for k = 1:n
                np += sgn * (npartitions(n - (k*(3k-1)) >> 1) + npartitions(n - (k*(3k+1)) >> 1))
                sgn = -sgn
            end
            _npartitions[n] = np
        end
    end
end

# Algorithm H from TAoCP 7.2.1.4
# Partition n into m parts
# in colex order (lexicographic by reflected sequence)

struct FixedPartitions
    n::Int
    m::Int
end

Base.length(f::FixedPartitions) = npartitions(f.n,f.m)
Base.eltype(f::FixedPartitions) = Vector{Int}

"""
    partitions(n, m)

Generate all arrays of `m` integers that sum to `n`. Because the number of partitions can
be very large, this function returns an iterator object. Use `collect(partitions(n, m))` to
get an array of all partitions. The number of partitions to generate can be efficiently
computed using `length(partitions(n, m))`.
"""
partitions(n::Integer, m::Integer) =
    n >= 1 && m >= 1 ?
        FixedPartitions(n, m) :
        throw(DomainError((n, m), "n and m must be positive"))

function Base.iterate(f::FixedPartitions, s::Vector{Int} = Int[])
    f.m <= f.n || return
    if !isempty(s)
        (f.m == 1 || s[1]-1 <= s[end]) && return
    end

    xs = nextfixedpartition(f.n,f.m,s)
    (xs, xs)
end

function nextfixedpartition(n, m, bs)
    as = copy(bs)
    if isempty(as)
        # First iteration
        as = ones(Int, m); as[1] = n - m + 1
    elseif as[2] < as[1]-1
        # Most common iteration
        as[1] -= 1
        as[2] += 1
    else
        # Iterate
        j = 0
        s = as[1]+as[2]-1
        for jj = 3:m # TODO: use `for outer j = ...` on 0.7
            j = jj
            as[jj] < as[1]-1 && break
            s += as[jj]
        end
        x = as[j] += 1
        for k = j-1:-1:2
            as[k] = x
            s -= x
        end
        as[1] = s
    end

    return as
end

let _nipartitions = Dict{Tuple{Int,Int},Int}()
    global npartitions
    function npartitions(n::Int, m::Int)
        if n < m || m == 0
            0
        elseif n == m
            1
        elseif (np = get(_nipartitions, (n,m), 0)) > 0
            np
        else
            _nipartitions[(n, m)] = npartitions(n-1, m-1) + npartitions(n-m, m)
        end
    end
end

# Algorithm H from TAoCP 7.2.1.5
# Set partitions

struct SetPartitions{T<:AbstractVector}
    s::T
end

Base.length(p::SetPartitions) = nsetpartitions(length(p.s))
Base.eltype(p::SetPartitions) = Vector{Vector{eltype(p.s)}}

"""
    partitions(s::AbstractVector)

Generate all set partitions of the elements of an array `s`, represented as arrays of
arrays. Because the number of partitions can be very large, this function returns an
iterator object. Use `collect(partitions(s))` to get an array of all partitions. The
number of partitions to generate can be efficiently computed using
`length(partitions(s))`.
"""
partitions(s::AbstractVector) = SetPartitions(s)

function Base.iterate(p::SetPartitions)
    n = length(p.s)
    iterate(p, (zeros(Int32, n), ones(Int32, n-1), n, 1))
end
function Base.iterate(p::SetPartitions, s)
    s[1][1] > 0 && return
    nextsetpartition(p.s, s...)
end

function nextsetpartition(s::AbstractVector, a, b, n, m)
    function makeparts(s, a, m)
        temp = [similar(s, 0) for k = 0:m]
        for i = 1:n
            push!(temp[a[i]+1], s[i])
        end
        filter!(!isempty, temp)
    end

    if isempty(s);  return ([s], (eltype(a)[1], eltype(b)[], n, 1));  end

    part = makeparts(s,a,m)

    if a[end] != m
        a[end] += 1
    else
        j = 0
        for jj = n-1:-1:1
            j = jj
            a[jj] == b[jj] || break
        end
        a[j] += 1
        m = Int(b[j]) + (a[j] == b[j])
        for k = j+1:n-1
            a[k] = 0
            b[k] = m
        end
        a[end] = 0
    end

    return (part, (a,b,n,m))
end

let _nsetpartitions = Dict{Int,Int}()
    global nsetpartitions
    function nsetpartitions(n::Int)
        if n < 0
            0
        elseif n < 2
            1
        elseif (wn = get(_nsetpartitions, n, 0)) > 0
            wn
        else
            wn = 0
            for k = 0:n-1
                wn += binomial(n-1,k)*nsetpartitions(n-1-k)
            end
            _nsetpartitions[n] = wn
        end
    end
end

struct FixedSetPartitions{T<:AbstractVector}
    s::T
    m::Int
end

Base.length(p::FixedSetPartitions) = nfixedsetpartitions(length(p.s),p.m)
Base.eltype(p::FixedSetPartitions) = Vector{Vector{eltype(p.s)}}

"""
    partitions(s::AbstractVector, m::Int)

Generate all set partitions of the elements of an array `s` into exactly `m` subsets,
represented as arrays of arrays. Because the number of partitions can be very large,
this function returns an iterator object. Use `collect(partitions(s, m))` to get
an array of all partitions. The number of partitions into `m` subsets is equal to the
Stirling number of the second kind, and can be efficiently computed using
`length(partitions(s, m))`.
"""
partitions(s::AbstractVector, m::Int) =
    length(s) >= 1 && m >= 1 ?
        FixedSetPartitions(s, m) :
        throw(DomainError((length(s), m), "length(s) and m must be positive"))

function Base.iterate(p::FixedSetPartitions)
    n = length(p.s)
    m = p.m
    state = m <= n ? (vcat(ones(Int, n-m),1:m), vcat(1:1,n-m+2:n), n) : (Int[], Int[], n)
    # state consists of:
    # vector a of length n describing to which partition every element of s belongs
    # vector b of length n describing the first index b[i] that belongs to partition i
    # integer n

    iterate(p, state)
end

function Base.iterate(p::FixedSetPartitions, s)
    (isempty(s[1]) || s[1][1] > 1) && return
    nextfixedsetpartition(p.s,p.m, s...)
end

function nextfixedsetpartition(s::AbstractVector, m, a, b, n)
    function makeparts(s, a)
        local part = [ similar(s,0) for k = 1:m ]
        for i = 1:n
            push!(part[a[i]], s[i])
        end
        return part
    end

    part = makeparts(s,a)

    if m == 1
        a[1] = 2
        return (part, (a, b, n))
    end

    if a[end] != m
        a[end] += 1
    else
        j = k = 0
        for jj = n-1:-1:1
            j = jj
            if a[j] < m && b[a[j]+1] < j
                break
            end
        end
        if j > 1
            a[j] += 1
            for p = j+1:n
                if b[a[p]] != p
                    a[p] = 1
                end
            end
        else
            for kk = m:-1:2
                k = kk
                if b[k-1] < b[k] - 1
                    break
                end
            end
            b[k] -= 1
            b[k+1:m] = n-m+k+1:n
            a[1:n] .= 1
            a[b] = 1:m
        end
    end

    return (part, (a,b,n))
end

function nfixedsetpartitions(n::Int, m::Int)
    numpart = 0
    for k = 0:m
        numpart += (-1)^(m-k) * binomial(m, k) * (k^n)
    end
    numpart = div(numpart, factorial(m))
    return numpart
end

# TODO: Base.DSP is no longer a thing in Julia 0.7
#This function is still defined in Base because it is being used by Base.DSP
#"""
#Next integer not less than `n` that can be written as $\prod k_i^{p_i}$ for integers $p_1$, $p_2$, etc.
#
#For a list of integers i1, i2, i3, find the smallest
#    i1^n1 * i2^n2 * i3^n3 >= x
#for integer n1, n2, n3
#"""
#function nextprod(a::Vector{Int}, x)
#    if x > typemax(Int)
#        throw(ArgumentError("unsafe for x > typemax(Int), got $x"))
#    end
#    k = length(a)
#    v = ones(Int, k)                  # current value of each counter
#    mx = [nextpow(ai,x) for ai in a]  # maximum value of each counter
#    v[1] = mx[1]                      # start at first case that is >= x
#    p::widen(Int) = mx[1]             # initial value of product in this case
#    best = p
#    icarry = 1
#
#    while v[end] < mx[end]
#        if p >= x
#            best = p < best ? p : best  # keep the best found yet
#            carrytest = true
#            while carrytest
#                p = div(p, v[icarry])
#                v[icarry] = 1
#                icarry += 1
#                p *= a[icarry]
#                v[icarry] *= a[icarry]
#                carrytest = v[icarry] > mx[icarry] && icarry < k
#            end
#            if p < x
#                icarry = 1
#            end
#        else
#            while p < x
#                p *= a[1]
#                v[1] *= a[1]
#            end
#        end
#    end
#    best = mx[end] < best ? mx[end] : best
#    return Int(best)  # could overflow, but best to have predictable return type
#end

"""
    prevprod(a::Vector{Int}, x)

Previous integer not greater than `x` that can be written as ``\\prod k_i^{p_i}`` for
integers ``p_1``, ``p_2``, etc.

For integers ``i_1``, ``i_2``, ``i_3``, this is equivalent to finding the largest ``x``
such that
```math
i_1^n_1 i_2^n_2 i_3^n_3 \\leq x
```
for integers ``n_1``, ``n_2``, ``n_3``.
"""
function prevprod(a::Vector{Int}, x)
    if x > typemax(Int)
        throw(ArgumentError("unsafe for x > typemax(Int), got $x"))
    end
    k = length(a)
    v = ones(Int, k)                  # current value of each counter
    mx = [nextpow(ai,x) for ai in a]  # allow each counter to exceed p (sentinel)
    first = Int(prevpow(a[1], x))     # start at best case in first factor
    v[1] = first
    p::widen(Int) = first
    best = p
    icarry = 1

    while v[end] < mx[end]
        while p <= x
            best = p > best ? p : best
            p *= a[1]
            v[1] *= a[1]
        end
        if p > x
            carrytest = true
            while carrytest
                p = div(p, v[icarry])
                v[icarry] = 1
                icarry += 1
                p *= a[icarry]
                v[icarry] *= a[icarry]
                carrytest = v[icarry] > mx[icarry] && icarry < k
            end
            if p <= x
                icarry = 1
            end
        end
    end
    best = x >= p > best ? p : best
    return Int(best)
end


"""
    integer_partitions(n)

List the partitions of the integer `n`.

!!! note
    The order of the resulting array is consistent with that produced by the computational
    discrete algebra software GAP.
"""
function integer_partitions(n::Integer)
    if n < 0
        throw(DomainError(n, "n must be nonnegative"))
    elseif n == 0
        return Vector{Int}[]
    elseif n == 1
        return Vector{Int}[[1]]
    end

    list = Vector{Int}[]

    for p in integer_partitions(n-1)
        push!(list, [p; 1])
        if length(p) == 1 || p[end] < p[end-1]
            push!(list, [p[1:end-1]; p[end]+1])
        end
    end

    list
end



#Noncrossing partitions

const _cmp = cmp

#Produces noncrossing partitions of length n
function ncpartitions(n::Int)
    partitions = Vector{Vector{Int}}[]
    _ncpart!(1,n,n,Vector{Int}[], partitions)
    partitions
end

function _ncpart!(a::Int, b::Int, nn::Int, x::Vector, partitions::Vector)
    n = b - a + 1
    for k = 1:n, root in CoolLexCombinations(n, k)
        root .+= a - 1
        #Abort if construction is out of lex order
        !isempty(x) && _cmp(x[end], root) == 1 && return

        #Save if we've filled all the holes
        sofar = Vector{Int}[x..., root]
        ssofaru = sort!(union(sofar...))
        if length(ssofaru) == nn && ssofaru == collect(1:nn)
            push!(partitions, sofar)
            return
        end

        #otherwise patch all remaining holes
        blob = [ssofaru; nn + 1]
        for l = 1:length(blob)-1
            ap, bp = blob[l] + 1, blob[l+1] - 1
            ap <= bp && _ncpart!(ap, bp, nn, sofar, partitions)
        end
    end
end
