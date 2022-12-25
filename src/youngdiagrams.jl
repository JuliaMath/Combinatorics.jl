################################################################################
# Young diagrams, partitions of unity and characters of the symmetric group Sn #
################################################################################

struct Partition
    x::Vector{Int}
end
Base.length(p::Partition) = length(p.x)
Base.getindex(p::Partition, i::Integer) = getindex(p.x, i)

struct SkewDiagram
    λ::Partition
    μ::Partition

    function SkewDiagram(λ::Partition, μ::Partition)
        m, n = length(λ), length(μ)
        n > m && throw(ArgumentError("Cannot construct skew diagram with partition lengths $m, $n"))
        new(λ, μ)
    end
end
SkewDiagram(λ::Vector{Int}, μ::Vector{Int}) = SkewDiagram(Partition(λ), Partition(μ))
SkewDiagram(t::Union{NTuple{2,Partition},NTuple{2,Vector{Int}}}) = SkewDiagram(t...)

export Partition,
       SkewDiagram,  #skew diagrams
       partitionsequence,
       isrimhook,    #Check if skew diagram is rim hook
       leglength,
       character     #Computes character of irrep of Sn

#################
# Skew diagrams #
#################

# This uses a very simple internal representation for skew diagrams
Base.:\(λ::Partition, μ::Partition) = SkewDiagram(λ, μ)

"""
    isrimhook(ξ::SkewDiagram)
    isrimhook(λ::Partition, μ::Partition)

Check whether the given skew diagram is a rim hook.
"""
isrimhook(λ::Partition, μ::Partition) = isrimhook(λ \ μ)
function isrimhook(ξ::SkewDiagram)
    λ = ξ.λ
    μ = ξ.μ
    m, n = length(λ), length(μ)
    n > m && error("Cannot construct skew diagram")
    #Construct matrix representation of diagram
    #XXX This is a horribly inefficient way of checking condition 1!
    l = maximum(λ.x)
    youngdiagram = zeros(Int, m, l)
    for i = 1:n
        youngdiagram[i, μ[i]+1:λ[i]] .= 1
    end
    for i = n+1:m
        youngdiagram[i, 1:λ[i]] .= 1
    end
    #Condition 1. Must be edgewise connected
    youngdiagramList = Any[]
    for i = 1:m
        for j = 1:l
            if youngdiagram[i, j] == 1
                push!(youngdiagramList, (i, j))
            end
        end
    end
    for k = 1:length(youngdiagramList)
        i, j = youngdiagramList[k]
        numNeighbors = 0
        for kp = 1:length(youngdiagramList)
            ip, jp = youngdiagramList[kp]
            if abs(i-ip) + abs(j-jp) == 1
                numNeighbors += 1
            end
        end
        if numNeighbors == 0 #Found a cell with no adjacent neighbors
            return false
        end
    end
    #Condition 2. Must not contain 2x2 square of cells
    for i = 1:m-1
        for j = 1:l-1
            if youngdiagram[i, j] == 0
                continue
            end
            if youngdiagram[i, j+1] == youngdiagram[i+1, j] == youngdiagram[i+1, j+1] == 1
                return false
            end
        end
    end
    return true
end


"""
    leglength(ξ::SkewDiagram)
    leglength(λ::Partition, μ::Partition)

Compute the leg length for the given skew diagram.

!!! note
    Strictly speaking, the leg length is defined for rim hooks only, but here we define
    it for all skew diagrams.
"""
leglength(λ::Partition, μ::Partition) = leglength(λ \ μ)
function leglength(ξ::SkewDiagram)
    λ = ξ.λ
    μ = ξ.μ
    m, n = length(λ), length(μ)
    #Construct matrix representation of diagram
    m == 0 && return -1
    l = maximum(λ.x)
    youngdiagram = zeros(Int, m, l)
    for i = 1:n
        youngdiagram[i, μ[i]+1:λ[i]] .= 1
    end
    for i = n+1:m
        youngdiagram[i, 1:λ[i]] .= 1
    end
    for i = m:-1:1
        any(==(1), youngdiagram[i,:]) && return i-1
    end
    return -1 #If entire matrix is empty
end


#######################
# partition sequences #
#######################

"""
    partitionsequence(lambda::Partition)

Compute essential part of the partition sequence of `lambda`.
"""
function partitionsequence(lambda::Partition)
    Λ▔ = Int[]
    λ = [lambda.x; 0]
    m = length(lambda)
    for i = m:-1:1
        for k = 1:(λ[i]-λ[i+1])
            push!(Λ▔, 1)
        end
        push!(Λ▔, 0)
    end
    Λ▔
end

"""
    isrimhook(a::Int, b::Int)

Take two elements of a partition sequence, with `a` to the left of `b`.
"""
isrimhook(a::Int, b::Int) = (a == 1) && (b == 0)


#############################
# Character of irreps of Sn #
#############################

"""
Recursively compute the character of the partition `μ` using the Murnaghan-Nakayama rule.
"""
function MN1inner(R::Vector{Int}, T::Dict, μ::Partition, t::Integer)
    s = length(R)
    χ::Integer = 1
    if t <= length(μ)
        χ, σ::Integer = 0, 1
        for j = 1:μ[t]-1
            if R[j] == 0
                σ = -σ
            end
        end
        for i = 1:s-μ[t]
            if R[i] != R[i+μ[t]-1]
                σ = -σ
            end
            if isrimhook(R[i], R[i+μ[t]])
                R[i], R[i+μ[t]] = R[i+μ[t]], R[i]
                rhohat = R[i:i+μ[t]]
                if !haskey(T, rhohat) #Cache result in lookup table
                    T[rhohat] = MN1inner(R, T, μ, t+1)
                end
                χ += σ * T[rhohat]
                R[i], R[i+μ[t]] = R[i+μ[t]], R[i]
            end
        end
    end
    χ
end

"""
    character(λ::Partition, μ::Partition)

Compute the character ``\\chi^{\\lambda(\\mu)}`` of the partition `μ` in the `λ`th
irreducible representation ("irrep") of the symmetric group ``S_n``.

Implements the Murnaghan-Nakayama algorithm as described in:

    Dan Bernstein,
    "The computational complexity of rules for the character table of Sn",
    Journal of Symbolic Computation, vol. 37 iss. 6 (2004), pp 727-748.
    doi:10.1016/j.jsc.2003.11.001
"""
character(λ::Partition, μ::Partition) =
    MN1inner(partitionsequence(λ), Dict{Any,Int}(()=>0), μ, 1)

## Deprecations
# Previously these were defined in terms of Base types. It's not possible to deprecate
# the use of `\` for the old-style `Partition`s though, since it's hardcore type piracy
# to overwrite `Base.:\(::Vector, ::Vector)` to begin with, let alone overwrite it with
# a deprecation.

using Base: @deprecate, @deprecate_binding

@deprecate isrimhook(λ::Vector{Int}, μ::Vector{Int}) isrimhook(Partition(λ), Partition(μ))
@deprecate isrimhook(ξ::NTuple{2,Vector{Int}})       isrimhook(SkewDiagram(ξ))
@deprecate leglength(λ::Vector{Int}, μ::Vector{Int}) leglength(Partition(λ), Partition(μ))
@deprecate leglength(ξ::NTuple{2,Vector{Int}})       leglength(SkewDiagram(ξ))
@deprecate character(λ::Vector{Int}, μ::Vector{Int}) character(Partition(λ), Partition(μ))
@deprecate partitionsequence(λ::Vector{Int})         partitionsequence(Partition(λ))

# This isn't actually used anywhere and is not a particularly useful alias
# TODO: Perhaps revisit YoungDiagram as its own type should the need arise
@deprecate_binding YoungDiagram Matrix{Int}
