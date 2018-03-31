__precompile__(true)

module Combinatorics

using Compat
using Polynomials
using IterTools

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("multinomials.jl")
include("youngdiagrams.jl")

end #module
