#Permutations

export
    derangements,
    levicivita,
    multiset_permutations,
    nthperm!,
    nthperm,
    parity,
    permutations


struct Permutations{T}
    data::T
    length::Int
end

function Base.iterate(p::Permutations, state::Vector{Int} = collect(eachindex(p.data)))
    (!isempty(state) && max(state[1], p.length) > length(p.data) || (isempty(state) && p.length > 0)) && return
    nextpermutation!(p.data, p.length , state)
end

function Base.length(p::Permutations)::Union{Int, BigInt}
    length(p.data) < p.length && return 0
    length(p.data) < 21       && return Int(prod(length(p.data) - p.length + 1:length(p.data)))
    return prod(big(length(p.data) - p.length + 1):big(length(p.data)))
end

Base.eltype(::Type{Permutations{T}}) where T = Vector{eltype(T)}

Base.IteratorSize(p::Permutations) = Base.HasLength()

"""
    permutations(a)

Generate all permutations of an indexable object `a` in index-based lexicographic order. 
Because the number of permutations can be very large, this function returns an iterator object.
Use `collect(permutations(a))` to get an array of all permutations.
Only works for `a` with defined length.

# Examples
```jldoctest
julia> permutations(1:2)
Combinatorics.Permutations{Vector{Int64}}([1, 2], 2)

julia> collect(permutations(1:2))
2-element Vector{Vector{Int64}}:
 [1, 2]
 [2, 1]

julia> collect(permutations(1:3))
6-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [1, 3, 2]
 [2, 1, 3]
 [2, 3, 1]
 [3, 1, 2]
 [3, 2, 1]
```
"""
permutations(a) = permutations(a, length(a))

"""
    permutations(a, t)

Generate all size `t` permutations of an indexable object `a`.
Only works for `a` with defined length.
If `(t <= 0) || (t > length(a))`, then returns an empty vector of eltype of `a`

# Examples
```jldoctest
julia> [ (len, permutations(1:3, len)) for len in -1:4 ]
6-element Vector{Tuple{Int64, Combinatorics.Permutations{Vector{Int64}}}}:
 (-1, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 4))
 (0, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 0))
 (1, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 1))
 (2, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 2))
 (3, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 3))
 (4, Combinatorics.Permutations{Vector{Int64}}([1, 2, 3], 4))

julia> [ (len, collect(permutations(1:3, len))) for len in -1:4 ]
6-element Vector{Tuple{Int64, Vector{Vector{Int64}}}}:
 (-1, [])
 (0, [[]])
 (1, [[1], [2], [3]])
 (2, [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]])
 (3, [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]])
 (4, [])
```
"""
function permutations(a, t::Int)
    if t < 0
        t = length(a) + 1
    end
    data = eltype(a)[]
    sizehint!(data, length(a))
    for i in eachindex(a)
        @inbounds push!(data, a[i])  # `push!` to a `Vector` flattens `a`
    end
    return Permutations(data, t)
end


function nextpermutation!(m::Vector, t::Int, state::Vector{Int})
    perm = m[@view state[1:t]]
    n = length(state)
    if t ≤ 0
        return (perm, [n + 1])
    end
    if t < n
        j = t + 1
        @inbounds while j ≤ n && state[t] ≥ state[j]
            j += 1
        end
    end
    @inbounds if t < n && j ≤ n
        state[t], state[j] = state[j], state[t]
    else
        if t < n
            reverse!(state, t + 1)
        end
        i = t - 1
        while i ≥ 1 && state[i] ≥ state[i+1]
            i -= 1
        end
        if i > 0
            j = n
            while j > i && state[i] ≥ state[j]
                j -= 1
            end
            state[i], state[j] = state[j], state[i]
            reverse!(state, i + 1)
        else
            state[1] = n + 1
        end
    end
    return (perm, state)
end


struct MultiSetPermutations{T}
    m::T
    f::Vector{Int}
    t::Int
    ref::Vector{Int}
end

Base.eltype(::Type{MultiSetPermutations{T}}) where {T} = Vector{eltype(T)}

function Base.length(c::MultiSetPermutations)
    t = c.t
    if t > length(c.ref)
        return 0
    end
    if t > 20
        g = factorial.(big.(0:t))
    else
        g = factorial.(0:t)
    end
    p = [g[t+1]; zeros(Float64, t)]
    for i in 1:length(c.f)
        f = c.f[i]
        if i == 1
            for j in 1:min(f, t)
                p[j+1] = g[t+1] / g[j+1]
            end
        else
            for j in t:-1:1
                q = 0
                for k in (j+1):-1:max(1, j + 1 - f)
                    q += p[k] / g[j+2-k]
                end
                p[j+1] = q
            end
        end
    end
    return round(p[t+1] > typemax(Int) ? BigInt : Int, p[t+1])
end


"""
    multiset_permutations(a)

Generate all permutations of an array `a` where `a` may have duplicated elements.
"""
multiset_permutations(a) = multiset_permutations(a, length(a))

"""
    multiset_permutations(a, t)

Generate all permutations of size `t` from an array `a` where `a` may have duplicated elements.

# Examples
```jldoctest
julia> collect(permutations([1,1,1], 2))
6-element Vector{Vector{Int64}}:
 [1, 1]
 [1, 1]
 [1, 1]
 [1, 1]
 [1, 1]
 [1, 1]

julia> collect(multiset_permutations([1,1,1], 2))
1-element Vector{Vector{Int64}}:
 [1, 1]

julia> collect(multiset_permutations([1,1,2], 3))
3-element Vector{Vector{Int64}}:
 [1, 1, 2]
 [1, 2, 1]
 [2, 1, 1]
```
"""
function multiset_permutations(a, t::Integer)
    counts = Dict{eltype(a), Int}()
    m = eltype(a)[]
    @inbounds for i in eachindex(a)
        n = get(counts, a[i], 0) + 1
        counts[a[i]] = n
        isone(n) && push!(m, a[i])
    end
    f = [counts[key] for key in m]
    MultiSetPermutations(m, f, t)
end

function MultiSetPermutations(m::Vector, f::Vector{<:Integer}, t::Integer)
    length(m) == length(f) || error("Lengths of m and f are not the same.")
    ref = length(f) > 0 ? vcat(fill.(1:length(f), f)...) : Int[]
    if t < 0
        t = length(ref) + 1
    end
    MultiSetPermutations(m, f, t, ref)
end

function Base.iterate(p::MultiSetPermutations, state::Vector{Int} = copy(p.ref))
    (!isempty(state) && max(state[1], p.t) > length(p.ref) || (isempty(state) && p.t > 0)) && return
    nextpermutation!(p.m, p.t, state)
end


#Derangements

struct Derangements{T}
    data::T
    order::T
    counts::Vector{Int}
    t::Int
end

mutable struct DerangementsIterState
    idx::Int
    iterstate::Vector{Int}
    perm::Vector{Int}
    counts::Vector{Int}
end

function DerangementsIterState(d::Derangements)
    DerangementsIterState(1, ones(Int, length(d.data)), ones(Int, length(d.data)), copy(d.counts))
end

Base.eltype(::Type{Derangements{T}}) where {T} = Vector{eltype(T)}

Base.IteratorSize(::Derangements) = Base.SizeUnknown()

function Base.iterate(d::Derangements)
    state = (isempty(d.data) || iszero(d.t)) ? DerangementsIterState(0, Int[], Int[], Int[]) : DerangementsIterState(d)
    (d.t > length(d.data) || d.t < 0 || 2maximum([d.counts; 0]) > length(d.data)) && return
    nextderangement(d, state)
end

function Base.iterate(d::Derangements, state::DerangementsIterState)
    derangement, state = nextderangement(d, state)
    iszero(state.idx) ? nothing : (derangement, state)
end

"""
    derangements(a, t)

Generate all derangements of an indexable object `a` of length `t` in index-based lexicographic order.
Because the number of derangements can be very large, this function returns an iterator object.
Use `collect(derangements(a))` to get an array of all derangements.
Only works for `a` with defined length.

# Examples
```jldoctest
julia> derangements(1:4, 4) |> collect
9-element Vector{Vector{Int64}}:
 [2, 1, 4, 3]
 [2, 3, 4, 1]
 [2, 4, 1, 3]
 [3, 1, 4, 2]
 [3, 4, 1, 2]
 [3, 4, 2, 1]
 [4, 1, 2, 3]
 [4, 3, 1, 2]
 [4, 3, 2, 1]

julia> derangements(1:4, 3) |> collect
11-element Vector{Vector{Int64}}:
 [2, 1, 4]
 [2, 3, 1]
 [2, 3, 4]
 [2, 4, 1]
 [3, 1, 2]
 [3, 1, 4]
 [3, 4, 1]
 [3, 4, 2]
 [4, 1, 2]
 [4, 3, 1]
 [4, 3, 2]
```
"""
function derangements(a, t::Int)
    data, order, counts = eltype(a)[], eltype(a)[], Dict{eltype(a), Int}()
    sizehint!(data, length(a))
    for i in eachindex(a)
        n = get(counts, a[i], 0) + 1
        counts[a[i]] = n
        push!(data, a[i])
        isone(n) && push!(order, a[i])
    end
    Derangements(data, order, [counts[key] for key in order], t)
end

"""
    derangements(a)

Generate all derangements of an indexable object `a` in index-based lexicographic order.
Because the number of derangements can be very large, this function returns an iterator object.
Use `collect(derangements(a))` to get an array of all derangements.
Only works for `a` with defined length.

# Examples
```jldoctest
julia> derangements("julia") |> collect
44-element Vector{Vector{Char}}:
 ['u', 'j', 'i', 'a', 'l']
 ['u', 'j', 'a', 'l', 'i']
 ['u', 'l', 'j', 'a', 'i']
 ['u', 'l', 'i', 'a', 'j']
 ['u', 'l', 'a', 'j', 'i']
 ['u', 'i', 'j', 'a', 'l']
 ['u', 'i', 'a', 'j', 'l']
 ['u', 'i', 'a', 'l', 'j']
 ['u', 'a', 'j', 'l', 'i']
 ['u', 'a', 'i', 'j', 'l']
 ⋮
 ['a', 'j', 'i', 'l', 'u']
 ['a', 'l', 'j', 'u', 'i']
 ['a', 'l', 'u', 'j', 'i']
 ['a', 'l', 'i', 'j', 'u']
 ['a', 'l', 'i', 'u', 'j']
 ['a', 'i', 'j', 'u', 'l']
 ['a', 'i', 'j', 'l', 'u']
 ['a', 'i', 'u', 'j', 'l']
 ['a', 'i', 'u', 'l', 'j']
```
"""
derangements(a) = derangements(a, length(a))

############################################################################################
# `nextderangement` is a iterative translation of a pruned-dfs with backtracking algoritm. #
# The iteration state is kept in `state` where: `idx` is the depth, `iterstate` is the     #
# position of the for loop at each depth, `perm` is the sort permutation used to slice     #
# `d.order`, and `counts[i]` is the remaining number of elements from `d.order[i]` that    #
# still need to be accounted for in the derangment.                                        #
# The source of the original algorithm is at https://arxiv.org/pdf/1009.4214               #
############################################################################################

function nextderangement(d::Derangements, state::DerangementsIterState)
    ordlen = length(d.order)
    while 0 < state.idx
        depth = state.idx
        @inbounds for i in state.iterstate[state.idx]:ordlen
            state.iterstate[state.idx] = i + 1
            if state.counts[i] ≥ 1 && d.order[i] ≠ d.data[state.idx] # If true, candidate element for position idx has been found
                state.perm[state.idx] = i
                state.counts[i] -= 1
                state.idx += 1
                break
            end
        end
        @inbounds if state.idx > d.t # If true, a derangement of length `t` has been found
            state.idx -= 1
            state.counts[state.perm[state.idx]] += 1
            return d.order[@view state.perm[1:d.t]], state
        elseif state.iterstate[state.idx] == ordlen + 1 && depth == state.idx # If true, the for loop at this depth has terminated
            state.iterstate[state.idx] = 1
            state.idx -= 1
            !iszero(state.idx) && (state.counts[state.perm[state.idx]] += 1) 
        end
    end
    eltype(d.data)[], state # Termination of algorithm
end


# nthperm

"""
    nthperm!(a, k)

In-place version of [`nthperm`](@ref); the array `a` is overwritten.

# Examples
```jldoctest
julia> a = [1, 2, 3];

julia> collect(permutations(a))
6-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [1, 3, 2]
 [2, 1, 3]
 [2, 3, 1]
 [3, 1, 2]
 [3, 2, 1]

julia> nthperm!(a, 3); a
3-element Vector{Int64}:
 2
 1
 3

julia> nthperm!(a, 4); a
3-element Vector{Int64}:
 1
 3
 2

julia> nthperm!(a, 0)
ERROR: ArgumentError: permutation k must satisfy 0 < k ≤ 6, got 0
[...]
```
"""
function nthperm!(a::AbstractVector, k::Integer)
    n = length(a)
    n == 0 && return a
    f = factorial(oftype(k, n))
    0 < k <= f || throw(ArgumentError("permutation k must satisfy 0 < k ≤ $f, got $k"))
    k -= 1 # make k 1-indexed
    for i = 1:n-1
        f ÷= n - i + 1
        j = k ÷ f
        k -= j * f
        j += i
        elt = a[j]
        for d = j:-1:i+1
            a[d] = a[d-1]
        end
        a[i] = elt
    end
    a
end

"""
    nthperm(a, k)

Compute the `k`th lexicographic permutation of the vector `a`.

# Examples
```jldoctest
julia> collect(permutations([1,2]))
2-element Vector{Vector{Int64}}:
 [1, 2]
 [2, 1]

julia> nthperm([1,2], 1)
2-element Vector{Int64}:
 1
 2

julia> nthperm([1,2], 2)
2-element Vector{Int64}:
 2
 1

julia> nthperm([1,2], 3)
ERROR: ArgumentError: permutation k must satisfy 0 < k ≤ 2, got 3
[...]
```
"""
nthperm(a::AbstractVector, k::Integer) = nthperm!(collect(a), k)

"""
    nthperm(p)

Return the integer `k` that generated permutation `p`. Note that
`nthperm(nthperm([1:n], k)) == k` for `1 <= k <= factorial(n)`.

# Examples
```jldoctest
julia> nthperm(nthperm([1:3...], 4))
4

julia> collect(permutations([1, 2, 3]))
6-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [1, 3, 2]
 [2, 1, 3]
 [2, 3, 1]
 [3, 1, 2]
 [3, 2, 1]

julia> nthperm([1, 2, 3])
1

julia> nthperm([3, 2, 1])
6

julia> nthperm([1, 1, 1])
ERROR: ArgumentError: argument is not a permutation
[...]

julia> nthperm(collect(1:10))
1

julia> nthperm(collect(10:-1:1))
3628800
```
"""
function nthperm(p::AbstractVector{<:Integer})
    isperm(p) || throw(ArgumentError("argument is not a permutation"))
    k, n = 1, length(p)
    for i = 1:n-1
        f = factorial(n - i)
        for j = i+1:n
            k += ifelse(p[j] < p[i], f, 0)
        end
    end
    return k
end


# Parity of permutations

const levicivita_lut = cat([0 0 0; 0 0 1; 0 -1 0],
                           [0 0 -1; 0 0 0; 1 0 0],
                           [0 1 0; -1 0 0; 0 0 0];
                           dims=3)

"""
    levicivita(p)

Compute the Levi-Civita symbol of a permutation `p`. Returns 1 if the permutation
is even, -1 if it is odd, and 0 otherwise.

The parity is computed by using the fact that a permutation is odd if and
only if the number of even-length cycles is odd.

# Examples
```jldoctest
julia> levicivita([1, 2, 3])
1

julia> levicivita([3, 2, 1])
-1

julia> levicivita([1, 1, 1])
0

julia> levicivita(collect(1:100))
1

julia> levicivita(ones(Int, 100))
0
```
"""
function levicivita(p::AbstractVector{<:Integer})
    n = length(p)

    if n == 3
        @inbounds valid = (0 < p[1] <= 3) * (0 < p[2] <= 3) * (0 < p[3] <= 3)
        return valid ? levicivita_lut[p[1], p[2], p[3]] : 0
    end

    todo = trues(n)
    first = 1
    cycles = flips = 0

    while cycles + flips < n
        first = coalesce(findnext(todo, first), 0)
        (todo[first] = !todo[first]) && return 0
        j = p[first]
        (0 < j <= n) || return 0
        cycles += 1
        while j ≠ first
            (todo[j] = !todo[j]) && return 0
            j = p[j]
            (0 < j <= n) || return 0
            flips += 1
        end
    end

    return iseven(flips) ? 1 : -1
end

"""
    parity(p)

Compute the parity of a permutation `p` using the [`levicivita`](@ref) function,
permitting calls such as `iseven(parity(p))`. If `p` is not a permutation then an
error is thrown.

# Examples
```jldoctest
julia> parity([1, 2, 3])
0

julia> parity([3, 2, 1])
1

julia> parity([1, 1, 1])
ERROR: ArgumentError: Not a permutation
[...]

julia> parity((collect(1:100)))
0
```
"""
function parity(p::AbstractVector{<:Integer})
    epsilon = levicivita(p)
    epsilon == 0 && throw(ArgumentError("Not a permutation"))
    epsilon == 1 ? 0 : 1
end
