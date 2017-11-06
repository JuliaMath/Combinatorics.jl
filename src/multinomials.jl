# Multinomial theorem
# https://en.wikipedia.org/wiki/Multinomial_theorem

export multiexponents

"""
    multiexponents(m, n)

Returns the exponents in the multinomial expansion (x₁ + x₂ + ... + xₘ)ⁿ.

For example, the expansion (x₁ + x₂ + x₃)² = x₁² + x₁x₂ + x₁x₃ + ...
has the exponents:

    julia> multiexponents(3, 2)

    6x3 Array{Int64,2}:
     2  0  0
     1  1  0
     1  0  1
     0  2  0
     0  1  1
     0  0  2
"""
function multiexponents(m, n)
    # standard stars and bars
    nsymbols = m+n-1
    stars = combinations(1:nsymbols, n)

    N = length(stars)
    result = zeros(Int, N, m)
    for (i,star) in enumerate(stars)
        # stars minus their consecutive
        # position becomes their index
        idx = star - [0:n-1;]
        for j in idx
            result[i,j] += 1
        end
    end

    result
end
