# Multinomial theorem
# https://en.wikipedia.org/wiki/Multinomial_theorem

export multiexponents

struct MultiExponents{T}
  c::Combinations{T}
  nterms::Int
end

start(m::MultiExponents) = start(m.c)

function next(m::MultiExponents, s)
    stars, ss = next(m.c, s)

    # stars minus their consecutive
    # position becomes their index
    idx = stars - [0:length(stars)-1;]

    result = zeros(Int, m.nterms)
    for i in idx
      result[i] += 1
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
    # number of symbols = m+n-1
    c = combinations(1:m+n-1, n)

    MultiExponents(c, m)
end
