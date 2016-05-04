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
