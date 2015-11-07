#Partitions

export
    cool_lex,
    integer_partitions,
    ncpartitions,
    partitions,
    prevprod
    #nextprod,


#integer partitions

immutable IntegerPartitions
    n::Int
end

length(p::IntegerPartitions) = npartitions(p.n)

start(p::IntegerPartitions) = Int[]
done(p::IntegerPartitions, xs) = length(xs) == p.n
next(p::IntegerPartitions, xs) = (xs = nextpartition(p.n,xs); (xs,xs))

"""
Generate all integer arrays that sum to `n`. Because the number of partitions can be very large, this function returns an iterator object. Use `collect(partitions(n))` to get an array of all partitions. The number of partitions to generate can be efficiently computed using `length(partitions(n))`.
"""
partitions(n::Integer) = IntegerPartitions(n)



function nextpartition(n, as)
    if isempty(as);  return Int[n];  end

    xs = similar(as,0)
    sizehint!(xs,length(as)+1)

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
                np += sgn * (npartitions(n-k*(3k-1)>>1) + npartitions(n-k*(3k+1)>>1))
                sgn = -sgn
            end
            _npartitions[n] = np
        end
    end
end

# Algorithm H from TAoCP 7.2.1.4
# Partition n into m parts
# in colex order (lexicographic by reflected sequence)

immutable FixedPartitions
    n::Int
    m::Int
end

length(f::FixedPartitions) = npartitions(f.n,f.m)

"""
Generate all arrays of `m` integers that sum to `n`. Because the number of partitions can be very large, this function returns an iterator object. Use `collect(partitions(n,m))` to get an array of all partitions. The number of partitions to generate can be efficiently computed using `length(partitions(n,m))`.
"""
partitions(n::Integer, m::Integer) = n >= 1 && m >= 1 ? FixedPartitions(n,m) : throw(DomainError())

start(f::FixedPartitions) = Int[]
function done(f::FixedPartitions, s::Vector{Int})
    f.m <= f.n || return true
    isempty(s) && return false
    return f.m == 1 || s[1]-1 <= s[end]
end
next(f::FixedPartitions, s::Vector{Int}) = (xs = nextfixedpartition(f.n,f.m,s); (xs,xs))

function nextfixedpartition(n, m, bs)
    as = copy(bs)
    if isempty(as)
        # First iteration
        as = [n-m+1; ones(Int, m-1)]
    elseif as[2] < as[1]-1
        # Most common iteration
        as[1] -= 1
        as[2] += 1
    else
        # Iterate
        local j
        s = as[1]+as[2]-1
        for j = 3:m
            if as[j] < as[1]-1; break; end
            s += as[j]
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
    function npartitions(n::Int,m::Int)
        if n < m || m == 0
            0
        elseif n == m
            1
        elseif (np = get(_nipartitions, (n,m), 0)) > 0
            np
        else
            _nipartitions[(n,m)] = npartitions(n-1,m-1) + npartitions(n-m,m)
        end
    end
end

# Algorithm H from TAoCP 7.2.1.5
# Set partitions

immutable SetPartitions{T<:AbstractVector}
    s::T
end

length(p::SetPartitions) = nsetpartitions(length(p.s))

"""
Generate all set partitions of the elements of an array, represented as arrays of arrays. Because the number of partitions can be very large, this function returns an iterator object. Use `collect(partitions(array))` to get an array of all partitions. The number of partitions to generate can be efficiently computed using `length(partitions(array))`.
"""
partitions(s::AbstractVector) = SetPartitions(s)

start(p::SetPartitions) = (n = length(p.s); (zeros(Int32, n), ones(Int32, n-1), n, 1))
done(p::SetPartitions, s) = s[1][1] > 0
next(p::SetPartitions, s) = nextsetpartition(p.s, s...)

function nextsetpartition(s::AbstractVector, a, b, n, m)
    function makeparts(s, a, m)
        temp = [ similar(s,0) for k = 0:m ]
        for i = 1:n
            push!(temp[a[i]+1], s[i])
        end
        filter!(x->!isempty(x), temp)
    end

    if isempty(s);  return ([s], ([1], Int[], n, 1));  end

    part = makeparts(s,a,m)

    if a[end] != m
        a[end] += 1
    else
        local j
        for j = n-1:-1:1
            if a[j] != b[j]
                break
            end
        end
        a[j] += 1
        m = b[j] + (a[j] == b[j])
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

immutable FixedSetPartitions{T<:AbstractVector}
    s::T
    m::Int
end

length(p::FixedSetPartitions) = nfixedsetpartitions(length(p.s),p.m)

"""
Generate all set partitions of the elements of an array into exactly m subsets, represented as arrays of arrays. Because the number of partitions can be very large, this function returns an iterator object. Use `collect(partitions(array,m))` to get an array of all partitions. The number of partitions into m subsets is equal to the Stirling number of the second kind and can be efficiently computed using `length(partitions(array,m))`.
"""
partitions(s::AbstractVector,m::Int) = length(s) >= 1 && m >= 1 ? FixedSetPartitions(s,m) : throw(DomainError())

function start(p::FixedSetPartitions)
    n = length(p.s)
    m = p.m
    m <= n ? (vcat(ones(Int, n-m),1:m), vcat(1,n-m+2:n), n) : (Int[], Int[], n)
end
# state consists of:
# vector a of length n describing to which partition every element of s belongs
# vector b of length n describing the first index b[i] that belongs to partition i
# integer n

done(p::FixedSetPartitions, s) = isempty(s[1]) || s[1][1] > 1
next(p::FixedSetPartitions, s) = nextfixedsetpartition(p.s,p.m, s...)

function nextfixedsetpartition(s::AbstractVector, m, a, b, n)
    function makeparts(s, a)
        part = [ similar(s,0) for k = 1:m ]
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
        local j, k
        for j = n-1:-1:1
            if a[j]<m && b[a[j]+1]<j
                break
            end
        end
        if j>1
            a[j]+=1
            for p=j+1:n
                if b[a[p]]!=p
                    a[p]=1
                end
            end
        else
            for k=m:-1:2
                if b[k-1]<b[k]-1
                    break
                end
            end
            b[k]=b[k]-1
            b[k+1:m]=n-m+k+1:n
            a[1:n]=1
            a[b]=1:m
        end
    end

    return (part, (a,b,n))
end

function nfixedsetpartitions(n::Int,m::Int)
    numpart=0
    for k=0:m
        numpart+=(-1)^(m-k)*binomial(m,k)*(k^n)
    end
    numpart=div(numpart,factorial(m))
    return numpart
end

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

doc"""
Previous integer not greater than `n` that can be written as $\prod k_i^{p_i}$ for integers $p_1$, $p_2$, etc.

For a list of integers i1, i2, i3, find the largest
    i1^n1 * i2^n2 * i3^n3 <= x
for integer n1, n2, n3
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


"Lists the partitions of the number n, the order is consistent with GAP"
function integer_partitions(n::Integer)
    if n < 0
        throw(DomainError())
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

"""
Produces (n,k)-combinations in cool-lex order

Implements the cool-lex algorithm to generate (n,k)-combinations
@article{Ruskey:2009fk,
	Author = {Frank Ruskey and Aaron Williams},
	Doi = {10.1016/j.disc.2007.11.048},
	Journal = {Discrete Mathematics},
	Month = {September},
	Number = {17},
	Pages = {5305-5320},
	Title = {The coolest way to generate combinations},
	Url = {http://www.sciencedirect.com/science/article/pii/S0012365X07009570},
	Volume = {309},
	Year = {2009}}
"""
function cool_lex(n::Integer, t::Integer)
  s = n-t
  if n > 64 error("Not implemented for n > 64") end
  if t < 1 error("Need t>1") end
  R0::Int64=R1::Int64=0
  R2::Int64 = 1 << (s+t)
  R3::Int64 = (1 << t) - 1
  while R3 & R2 == 0
    produce(visit(R3))
    R0 = R3 & (R3 + 1)
    R1 = R0 $ (R0 - 1)
    R0 = R1 + 1
    R1 &= R3
    R0 = max((R0 & R3) - 1, 0)
    R3 += R1 - R0
  end
end

#Converts an integer word X into a subset
#If X & 2^k == 1, then k is in the subset
function visit(X::Integer)
  subset = Int[]
  n::Int=1
  while X != 0
    if X & 1 == 1 push!(subset, n) end
    X >>= 1
    n += 1
  end
  subset
end

#Produces noncrossing partitions of length n
ncpartitions(n::Integer)=ncpart(1,n,n,Any[])
function ncpart(a::Integer, b::Integer, nn::Integer,
    x::Array{Any,1})
  n=b-a+1
  for k=1:n
    for root in @task cool_lex(n, k)
      root += a-1
      #Abort if construction is out of lex order
      if length(x)>0 && x[end] > root return end
      #Produce if we've filled all the holes
      sofar = Any[x..., root]
      ssofaru = sort(union(sofar...))
      if length(ssofaru)==nn && ssofaru==[1:nn]
        produce(sofar)
        return
      end
      #otherwise patch all remaining holes
      blob = [ssofaru; nn+1]
      for l=1:length(blob)-1
        ap, bp = blob[l]+1, blob[l+1]-1
        if ap <= bp ncpart(ap, bp, nn, sofar) end
      end
    end
  end
end
