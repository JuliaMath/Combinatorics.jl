
module Combinatorics

# `Base.GMP.libgmp` was added in Julia 1.9
const libgmp = isdefined(Base.GMP, :libgmp) ? Base.GMP.libgmp : :libgmp

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("multinomials.jl")
include("youngdiagrams.jl")

end #module
