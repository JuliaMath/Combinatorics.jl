export combinations,
       CoolLexCombinations,
       multiset_combinations,
       with_replacement_combinations,
       powerset

#The Combinations iterator
struct Combinations
    n::Int
    t::Int
end

@inline function Base.iterate(c::Combinations, s = [min(c.t - 1, i) for i in 1:c.t])
    if c.t == 0 # special case to generate 1 result for t==0
        isempty(s) && return (s, [1])
        return
    end
    for i in c.t:-1:1
        s[i] += 1
        if s[i] > (c.n - (c.t - i))
            continue
        end
        for j in i+1:c.t
            s[j] = s[j-1] + 1
        end
        break
    end
    s[1] > c.n - c.t + 1 && return
    (s, s)
end

Base.length(c::Combinations) = binomial(c.n, c.t)

Base.eltype(::Type{Combinations}) = Vector{Int}

"""
    combinations(a, n)

Generate all combinations of `n` elements from an indexable object `a`. Because the number
of combinations can be very large, this function returns an iterator object.
Use `collect(combinations(a, n))` to get an array of all combinations.
"""
function combinations(a, t::Integer)
    if t < 0
        # generate 0 combinations for negative argument
        t = length(a) + 1
    end
    reorder(c) = [a[ci] for ci in c]
    (reorder(c) for c in Combinations(length(a), t))
end


"""
    combinations(a)

Generate combinations of the elements of `a` of all orders. Chaining of order iterators
is eager, but the sequence at each order is lazy.
"""
combinations(a) = Iterators.flatten([combinations(a, k) for k = 1:length(a)])



# cool-lex combinations iterator

"""
    CoolLexCombinations

Produce ``(n,k)``-combinations in cool-lex order.

# Reference

Ruskey, F., & Williams, A. (2009). The coolest way to generate combinations.
*Discrete Mathematics*, 309(17), 5305-5320.
"""
struct CoolLexCombinations
    n::Int
    t::Int
end

struct CoolLexIterState{T<:Integer}
    R0::T
    R1::T
    R2::T
    R3::T
end

function Base.iterate(C::CoolLexCombinations)
    if C.n < 0
        throw(DomainError(C.n))
    end
    if C.t ≤ 0
        throw(DomainError(C.t))
    end

    #What integer size should I use?
    if C.n < 8sizeof(Int)
        T = Int
    else
        T = BigInt
    end

    state = CoolLexIterState{T}(0, 0, T(1) << C.n, (T(1) << C.t) - 1)
    iterate(C, state)
end

function Base.iterate(C::CoolLexCombinations, S::CoolLexIterState)
    (S.R3 & S.R2 != 0) && return

    R0 = S.R0
    R1 = S.R1
    R2 = S.R2
    R3 = S.R3

    R0 = R3 & (R3 + 1)
    R1 = xor(R0, R0 - 1)
    R0 = R1 + 1
    R1 &= R3
    R0 = max((R0 & R3) - 1, 0)
    R3 += R1 - R0

    _cool_lex_visit(S.R3), CoolLexIterState(R0, R1, R2, R3)
end

#Converts an integer bit pattern X into a subset
#If X & 2^k == 1, then k is in the subset
function _cool_lex_visit(X::Integer)
    subset = Int[]
    n = 1
    while X != 0
        X & 1 == 1 && push!(subset, n)
        X >>= 1
        n += 1
    end
    subset
end

Base.length(C::CoolLexCombinations) = max(0, binomial(C.n, C.t))


struct MultiSetCombinations{T}
    m::T
    f::Vector{Int}
    t::Int
    ref::Vector{Int}
end

Base.eltype(::Type{MultiSetCombinations{T}}) where {T} = Vector{eltype(T)}

function Base.length(c::MultiSetCombinations)
    t = c.t
    if t > length(c.ref)
        return 0
    end
    p = [1; zeros(Int, t)]
    for i in 1:length(c.f)
        f = c.f[i]
        if i == 1
            for j in 1:min(f, t)
                p[j+1] = 1
            end
        else
            for j in t:-1:1
                p[j+1] = sum(p[max(1,j+1-f):(j+1)])
            end
        end
    end
    return p[t+1]
end

function multiset_combinations(m, f::Vector{<:Integer}, t::Integer)
    length(m) == length(f) || error("Lengths of m and f are not the same.")
    ref = length(f) > 0 ? vcat([[i for j in 1:f[i] ] for i in 1:length(f)]...) : Int[]
    if t < 0
        t = length(ref) + 1
    end
    MultiSetCombinations(m, f, t, ref)
end

"""
    multiset_combinations(a, t)

Generate all combinations of size `t` from an array `a` with possibly duplicated elements.
"""
function multiset_combinations(a, t::Integer)
    m = unique(collect(a))
    f = Int[sum([c == x for c in a]) for x in m]
    multiset_combinations(m, f, t)
end

function Base.iterate(c::MultiSetCombinations, s = c.ref)
    ((!isempty(s) && max(s[1], c.t) > length(c.ref)) || (isempty(s) && c.t > 0)) && return

    ref = c.ref
    n = length(ref)
    t = c.t
    changed = false
    comb = [c.m[s[i]] for i in 1:t]
    if t > 0
        s = copy(s)
        for i in t:-1:1
            if s[i] < ref[i + (n - t)]
                j = 1
                while ref[j] <= s[i]
                    j += 1
                end
                s[i] = ref[j]
                for l in (i+1):t
                    s[l] = ref[j+=1]
                end
                changed = true
                break
            end
        end
        !changed && (s[1] = n+1)
    else
        s = [n+1]
    end
    (comb, s)
end

struct WithReplacementCombinations{T}
    a::T
    t::Int
end

Base.eltype(::Type{WithReplacementCombinations{T}}) where {T} = Vector{eltype(T)}

Base.length(c::WithReplacementCombinations) = binomial(length(c.a) + c.t - 1, c.t)

"""
    with_replacement_combinations(a, t)

Generate all combinations with replacement of size `t` from an array `a`.
"""
with_replacement_combinations(a, t::Integer) = WithReplacementCombinations(a, t)

function Base.iterate(c::WithReplacementCombinations, s = [1 for i in 1:c.t])
    (!isempty(s) && s[1] > length(c.a) || c.t < 0) && return

    n = length(c.a)
    t = c.t
    comb = [c.a[si] for si in s]
    if t > 0
        s = copy(s)
        changed = false
        for i in t:-1:1
            if s[i] < n
                s[i] += 1
                for j in (i+1):t
                    s[j] = s[i]
                end
                changed = true
                break
            end
        end
        !changed && (s[1] = n+1)
    else
        s = [n+1]
    end
    (comb, s)
end

## Power set

"""
    powerset(a, min=0, max=length(a))

Generate all subsets of an indexable object `a` including the empty set, with cardinality
bounded by `min` and `max`. Because the number of subsets can be very large, this function
returns an iterator object. Use `collect(powerset(a, min, max))` to get an array of all
subsets.
"""
function powerset(a, min::Integer=0, max::Integer=length(a))
    itrs = [combinations(a, k) for k = min:max]
    min < 1 && append!(itrs, eltype(a)[])
    Iterators.flatten(itrs)
end
