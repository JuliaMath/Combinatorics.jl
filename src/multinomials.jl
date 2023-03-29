# Multinomial theorem
# https://en.wikipedia.org/wiki/Multinomial_theorem

export multiexponents

struct MultiExponents{T}
    c::T
    nterms::Int
end

# Standard stars and bars:
# https://en.wikipedia.org/wiki/Stars_and_bars_(combinatorics)
function Base.iterate(m::MultiExponents, s = nothing)
    next = s === nothing ? iterate(m.c) : iterate(m.c, s)
    next === nothing && return
    stars, ss = next

    # stars minus their consecutive
    # position becomes their index
    result = zeros(Int, m.nterms)
    for (i, s) in enumerate(stars)
        result[s-i+1] += 1
    end

    result, ss
end

Base.length(m::MultiExponents) = length(m.c)
Base.eltype(::Type{MultiExponents{T}}) where {T} = Vector{Int}

"""
    multiexponents(m, n)

Returns the exponents in the multinomial expansion (x₁ + x₂ + ... + xₘ)ⁿ.

For example, the expansion (x₁ + x₂ + x₃)² = x₁² + x₁x₂ + x₁x₃ + ...
has the exponents:

```julia-repl
julia> collect(multiexponents(3, 2))
6-element Vector{Vector{Int64}}:
 [2, 0, 0]
 [1, 1, 0]
 [1, 0, 1]
 [0, 2, 0]
 [0, 1, 1]
 [0, 0, 2]
```
"""
function multiexponents(m, n)
    # number of stars and bars = m+n-1
    c = combinations(1:m+n-1, n)

    MultiExponents(c, m)
end
