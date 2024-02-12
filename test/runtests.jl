using Combinatorics
using Test
using PyCall: pyimport
pyitertools = pyimport("itertools")

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("multinomials.jl")
include("youngdiagrams.jl")
