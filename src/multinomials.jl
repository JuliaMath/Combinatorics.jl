# Multinomial theorem
# https://en.wikipedia.org/wiki/Multinomial_theorem

export multiexponents

immutable MultiExponents{T}
    c::Combinations{T}
    nterms::Int
end

start(m::MultiExponents) = start(m.c)

# Standard stars and bars:
# https://en.wikipedia.org/wiki/Stars_and_bars_(combinatorics)
function next(m::MultiExponents, s)
    stars, ss = next(m.c, s)

    # stars minus their consecutive
    # position becomes their index
    result = zeros(Int, m.nterms)
    for (i,s) in enumerate(stars)
      result[s-i+1] += 1
    end

    result, ss
end

done(m::MultiExponents, s) = done(m.c, s)

length(m::MultiExponents) = length(m.c)

"""
    multiexponents(m, n)

Returns the exponents in the multinomial expansion (x₁ + x₂ + ... + xₘ)ⁿ.

For example, the expansion (x₁ + x₂ + x₃)² = x₁² + x₁x₂ + x₁x₃ + ...
has the exponents:

    julia> collect(multiexponents(3, 2))

    6-element Array{Any,1}:
     [2, 0, 0]
     [1, 1, 0]
     [1, 0, 1]
     [0, 2, 0]
     [0, 1, 1]
     [0, 0, 2]
"""
function multiexponents(m, n)
    # number of stars and bars = m+n-1
    c = combinations(1:m+n-1, n)

    MultiExponents(c, m)
end
