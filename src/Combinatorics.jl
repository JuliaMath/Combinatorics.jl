__precompile__(true)

module Combinatorics

using Compat, Polynomials

import Base: start, next, done, length, eltype

#These 8 functions were removed from Julia 0.5 as part of JuliaLang/julia#13897,
#so check if it's necessary to import them to overload the stub methods left in
#Base. Only do this if on a version of Julia post-combinatorics removal.
if isdefined(Base, :combinations) && VERSION >= v"0.5.0-dev+1204"
    import Base: combinations, partitions, prevprod, levicivita, nthperm,
                 nthperm!, parity, permutations
end

include("numbers.jl")
include("factorials.jl")
include("combinations.jl")
include("permutations.jl")
include("partitions.jl")
include("youngdiagrams.jl")
include("iterators.jl")
end #module
