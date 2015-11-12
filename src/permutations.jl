#Permutations

export
    levicivita,
    multiset_permutations,
    nthperm!,
    nthperm,
    parity,
    permutations


immutable Permutations{T}
    a::T
    t::Int
end

eltype{T}(::Type{Permutations{T}}) = Vector{eltype(T)}

length(p::Permutations) = (0 <= p.t <= length(p.a))?factorial(length(p.a), length(p.a)-p.t):0

"""
Generate all permutations of an indexable object. Because the number of permutations can be very large, this function returns an iterator object. Use `collect(permutations(array))` to get an array of all permutations.
"""
permutations(a) = Permutations(a, length(a))

"""
Generate all size t permutations of an indexable object.
"""
function permutations(a, t::Integer)
    if t < 0
        t = length(a) + 1
    end
    Permutations(a, t)
end

start(p::Permutations) = [1:length(p.a);]
next(p::Permutations, s) = nextpermutation(p.a, p.t ,s)

function nextpermutation(m, t, s)
    perm = [m[s[i]] for i in 1:t]
    n = length(s)
    if t <= 0
        return(perm, [n+1])
    end
    s = copy(s)
    if t < n
        j = t + 1
        while j <= n &&  s[t] >= s[j]; j+=1; end
    end
    if t < n && j <= n
        s[t], s[j] = s[j], s[t]
    else
        if t < n
            reverse!(s, t+1)
        end
        i = t - 1
        while i>=1 && s[i] >= s[i+1]; i -= 1; end
        if i > 0
            j = n
            while j>i && s[i] >= s[j]; j -= 1; end
            s[i], s[j] = s[j], s[i]
            reverse!(s, i+1)
        else
            s[1] = n+1
        end
    end
    return(perm, s)
end

done(p::Permutations, s) = !isempty(s) && max(s[1], p.t) > length(p.a) ||  (isempty(s) && p.t > 0)

immutable MultiSetPermutations{T}
    m::T
    f::Vector{Int}
    t::Int
    ref::Vector{Int}
end

eltype{T}(::Type{MultiSetPermutations{T}}) = Vector{eltype(T)}

function length(c::MultiSetPermutations)
    t = c.t
    if t > length(c.ref)
        return 0
    end
    if t > 20
        g = [factorial(big(i)) for i in 0:t]
    else
        g = [factorial(i) for i in 0:t]
    end
    p = [g[t+1]; zeros(Float64,t)]
    for i in 1:length(c.f)
        f = c.f[i]
        if i == 1
            for j in 1:min(f, t)
                p[j+1] = g[t+1]/g[j+1]
            end
        else
            for j in t:-1:1
                q = 0
                for k in (j+1):-1:max(1,j+1-f)
                    q += p[k]/g[j+2-k]
                end
                p[j+1] = q
            end
        end
    end
    return round(Int, p[t+1])
end

"generate all permutations of size t from an array a with possibly duplicated elements."
function multiset_permutations{T<:Integer}(m, f::Vector{T}, t::Integer)
    length(m) == length(f) || error("Lengths of m and f are not the same.")
    ref = length(f) > 0 ? vcat([[i for j in 1:f[i] ] for i in 1:length(f)]...) : Int[]
    if t < 0
        t = length(ref) + 1
    end
    MultiSetPermutations(m, f, t, ref)
end

function multiset_permutations{T}(a::T, t::Integer)
    m = unique(collect(a))
    f = [sum([c == x for c in a]) for x in m]
    multiset_permutations(m, f, t)
end

start(p::MultiSetPermutations) = p.ref
next(p::MultiSetPermutations, s) = nextpermutation(p.m, p.t, s)
done(p::MultiSetPermutations, s) =
    !isempty(s) && max(s[1], p.t) > length(p.ref) ||  (isempty(s) && p.t > 0)



"In-place version of nthperm."
function nthperm!(a::AbstractVector, k::Integer)
    k -= 1 # make k 1-indexed
    k < 0 && throw(ArgumentError("permutation k must be ≥ 0, got $k"))
    n = length(a)
    n == 0 && return a
    f = factorial(oftype(k, n-1))
    for i=1:n-1
        j = div(k, f) + 1
        k = k % f
        f = div(f, n-i)

        j = j+i-1
        elt = a[j]
        for d = j:-1:i+1
            a[d] = a[d-1]
        end
        a[i] = elt
    end
    a
end

"Compute the kth lexicographic permutation of the vector a."
nthperm(a::AbstractVector, k::Integer) = nthperm!(copy(a),k)

"Return the `k` that generated permutation `p`. Note that `nthperm(nthperm([1:n], k)) == k` for `1 <= k <= factorial(n)`."
function nthperm{T<:Integer}(p::AbstractVector{T})
    isperm(p) || throw(ArgumentError("argument is not a permutation"))
    k, n = 1, length(p)
    for i = 1:n-1
        f = factorial(n-i)
        for j = i+1:n
            k += ifelse(p[j] < p[i], f, 0)
        end
    end
    return k
end


# Parity of permutations

const levicivita_lut = cat(3, [0 0  0;  0 0 1; 0 -1 0],
                              [0 0 -1;  0 0 0; 1  0 0],
                              [0 1  0; -1 0 0; 0  0 0])

"""
Levi-Civita symbol of a permutation.

Returns 1 is the permutation is even, -1 if it is odd and 0 otherwise.

The parity is computed by using the fact that a permutation is odd if and
only if the number of even-length cycles is odd.
"""
function levicivita{T<:Integer}(p::AbstractVector{T})
    n = length(p)

    if n == 3
        @inbounds valid = (0 < p[1] <= 3) * (0 < p[2] <= 3) * (0 < p[3] <= 3)
        return valid ? levicivita_lut[p[1], p[2], p[3]] : 0
    end

    todo = trues(n)
    first = 1
    cycles = flips = 0

    while cycles + flips < n
        first = findnext(todo, first)
        (todo[first] $= true) && return 0
        j = p[first]
        (0 < j <= n) || return 0
        cycles += 1
        while j ≠ first
            (todo[j] $= true) && return 0
            j = p[j]
            (0 < j <= n) || return 0
            flips += 1
        end
    end

    return iseven(flips) ? 1 : -1
end

"""
Computes the parity of a permutation using the levicivita function,
so you can ask iseven(parity(p)). If p is not a permutation throws an error.
"""
function parity{T<:Integer}(p::AbstractVector{T})
    epsilon = levicivita(p)
    epsilon == 0 && throw(ArgumentError("Not a permutation"))
    epsilon == 1 ? 0 : 1
end
