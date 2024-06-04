export composition, weak_composition

abstract type AbstractComposition end

# iterator for generating (strong) compositions of n into k parts
# uses an iterator for generating k - 1 combinations of n - 1
struct Composition <: AbstractComposition

    # data
    n::Int
    k::Int
    combination::Combinations

    # constructor
    Composition(n, k) = new(n, k, Combinations(n - 1, k - 1))

end

# iterator for generating weak compositions of n into k parts
# uses an iterator for generating k - 1 combinations of n + k - 1
struct WeakComposition <: AbstractComposition

    # data
    n::Int
    k::Int
    combination::Combinations

    # constructor
    WeakComposition(n, k) = new(n, k, Combinations(n + k - 1, k - 1))

end

# Base.iterate specializations
function Base.iterate(c::AbstractComposition)

    # get the next combination (and state)
    next = iterate(c.combination)

    # return the corresponding composition (and state)
    return next_composition(c, next)

end
function Base.iterate(c::AbstractComposition, state)

    # get the next combination (and state)
    next = iterate(c.combination, state)

    # return the corresponding composition (and state)
    return next_composition(c, next)

end

# common functionality for generating next (strong) composition
function next_composition(c::Composition, next)

    # if we are out of combinations, we are done
    next === nothing && return

    # extract the combination and state
    combination, state = next

    # set up storage for the composition
    q = Vector{Int}(undef, c.k)

    if c.k == 1

        # k == 1 is a special case, there is one composition n
        q[1] = c.n

    else

        # general case - calculate each element of the composition from the
        # combination
        q[1] = combination[1] 
        for i in 2 : c.k - 1
            q[i] = combination[i] - combination[i - 1]
        end
        q[c.k] = c.n - combination[c.k - 1]

    end

    # return the composition and state
    return q, state

end

# common functionality for generating next weak composition
function next_composition(w::WeakComposition, next)

    # if we are out of combinations, we are done
    next === nothing && return

    # extract the combination and state
    combination, state = next

    # set up storage for the composition
    q = Vector{Int}(undef, w.k)

    if w.k == 1

        # k == 1 is a special case, there is one composition n
        q[1] = w.n

    else

        # general case - calculate each element of the composition from the
        # combination
        q[1] = combination[1] - 1
        for i in 2 : w.k - 1
        q[i] = combination[i] - combination[i - 1] - 1
        end
        q[w.k] = w.n + w.k - combination[w.k - 1] - 1

    end

    # return the composition and state
    return q, state

end

# Base.length specializations
Base.length(c::Composition)     = binomial(c.n - 1, c.k - 1)
Base.length(w::WeakComposition) = binomial(w.n + w.k - 1, w.n)

# Base.eltype specialization
Base.eltype(::Type{<:AbstractComposition}) = Vector{Int}

"""
    composition(n, k)
    
Generate all arrays of `k` positive integers that sum to `n`, i.e., (strong)
compositions of `n` into `k` parts.  Because the number of compositions can be 
very large, this function returns an iterator object.  Use 
`collect(composition(n, k))` to get an array of all compositions.  The number of 
compositions to generate can be efficiently computed using 
`length(compositions(n, k))`.
"""
function composition(n, k)

    # check that n and k are valid
    n < k && throw(DomainError(n, "n must be greater than or equal to k"))
    k < 1 && throw(DomainError(k, "k must be positive"))

    # return iterator object
    return Composition(n, k)
    
end

"""
    weak_composition(n, k)

Generate all arrays of `k` non-negative integers that sum to `n`, i.e., weak
compositions of `n` into `k` parts.  Because the number of weak compositions can 
be very large, this function returns an iterator object.  Use 
`collect(weak_composition(n, k))` to get an array of all weak compositions.  The 
number of weak compositions to generate can be efficiently computed using 
`length(weak_compositions(n, k))`.
"""
function weak_composition(n, k)
    
    # check that n and k are valid
    n < 0 && throw(DomainError(n, "n must be non-negative"))
    k < 1 && throw(DomainError(k, "k must be positive"))
    
    # return iterator object
    return WeakComposition(n, k)

end
