VERSION < v"0.7.0-beta2.199" && __precompile__()

module Combinatorics

using Polynomials

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("multinomials.jl")
include("youngdiagrams.jl")

end #module
