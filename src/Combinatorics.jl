module Combinatorics

using Compat, Polynomials, Iterators

import Base: start, next, done, length, eltype

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("youngdiagrams.jl")

end #module
