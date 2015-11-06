################################################################################
# Young diagrams, partitions of unity and characters of the symmetric group Sn #
################################################################################

typealias Partition Vector{Int64}
typealias YoungDiagram Array{Int64,2}
typealias SkewDiagram Tuple{Partition, Partition}

export Partition,
       YoungDiagram, #represents shape of Young diagram
       SkewDiagram,  #skew diagrams
       partitionsequence,
       isrimhook,    #Check if skew diagram is rim hook
       leglength,
       character     #Computes character of irrep of Sn

import Base.\

#################
# Skew diagrams #
#################

#This uses a very simple internal representation for skew diagrams
\(λ::Partition, μ::Partition) = MakeSkewDiagram(λ, μ)
function MakeSkewDiagram(λ::Partition, μ::Partition)
    m, n = length(λ), length(μ)
    if n>m error("Cannot construct skew diagram") end
    (λ, μ)
end

#Checks if skew diagram is a rim hook
isrimhook(λ::Partition, μ::Partition)=isrimhook(λ \ μ)
function isrimhook(ξ::SkewDiagram)
    λ, μ = ξ
    m, n = length(λ), length(μ)
    if n>m error("Cannot construct skew diagram") end
    #Construct matrix representation of diagram
    #XXX This is a horribly inefficient way of checking condition 1!
    l = maximum(λ)
    youngdiagram=zeros(Int64, m, l)
    for i=1:n
        youngdiagram[i, μ[i]+1:λ[i]]=1
    end
    for i=n+1:m
        youngdiagram[i, 1:λ[i]]=1
    end
    #Condition 1. Must be edgewise connected
    youngdiagramList=[]
    for i=1:m
        for j=1:l
            if youngdiagram[i, j]==1 youngdiagramList = [youngdiagramList; (i, j)] end
        end
    end
    for k=1:length(youngdiagramList)
        i, j = youngdiagramList[k]
        numNeighbors = 0
        for kp=1:length(youngdiagramList)
            ip,jp= youngdiagramList[kp]
            if abs(i-ip) + abs(j-jp) == 1 numNeighbors += 1 end
        end
        if numNeighbors == 0 return false end #Found a cell with no adjacent neighbors
    end
    #Condition 2. Must not contain 2x2 square of cells
    for i=1:m-1
        for j=1:l-1
            if youngdiagram[i, j]== 0 continue end
            if youngdiagram[i, j+1] == youngdiagram[i+1, j] == youngdiagram[i+1, j+1] == 1
                return false
            end
        end
    end
    return true
end


#Strictly speaking, defined for rim hook only, but here we define it for all skew diagrams
leglength(λ::Partition, μ::Partition)=leglength((λ \ μ))
function leglength(ξ::SkewDiagram)
    λ, μ = ξ
    m, n = length(λ), length(μ)
    #Construct matrix representation of diagram
    l = maximum(λ)
    youngdiagram=zeros(Int64, m, l)
    for i=1:n
        youngdiagram[i, μ[i]+1:λ[i]]=1
    end
    for i=n+1:m
        youngdiagram[i, 1:λ[i]]=1
    end
    for i=m:-1:1
        if any([x==1 for x in youngdiagram[i,:]]) return i-1 end
    end
    return -1 #If entire matrix is empty
end


#######################
# partition sequences #
#######################

#Computes essential part of the partition sequence of lambda
function partitionsequence(lambda::Partition)
    Λ▔ = Int64[]
    λ = [lambda; 0]
    m = length(lambda)
    for i=m:-1:1
        for k=1:(λ[i]-λ[i+1])
            Λ▔ = [Λ▔; 1]
        end
        Λ▔ = [Λ▔ ; 0]
    end
    Λ▔
end

#This takes two elements of a partition sequence, with a to the left of b
isrimhook(a::Int64, b::Int64) = (a==1) && (b==0)


#############################
# Character of irreps of Sn #
#############################

#Computes recursively using the Murnaghan-Nakayama rule.
function MN1inner(R::Vector{Int64}, T::Dict, μ::Partition, t::Integer)
    s=length(R)
    χ::Integer=1
    if t<=length(μ)
        χ, σ::Integer = 0, 1
        for j=1:μ[t]-1
            if R[j]==0 σ=-σ end
        end
        for i=1:s-μ[t]
            if R[i] != R[i+μ[t]-1] σ=-σ end
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

#Computes character $χ^λ(μ)$ of the partition μ in the λth irrep of the
#symmetric group $S_n$
#
#Implements the Murnaghan-Nakayama algorithm as described in:
#    Dan Bernstein,
#    "The computational complexity of rules for the character table of Sn",
#    Journal of Symbolic Computation, vol. 37 iss. 6 (2004), pp 727-748.
#    doi:10.1016/j.jsc.2003.11.001
function character(λ::Partition, μ::Partition)
    T = @compat Dict{Any,Any}(()=>0) #Sparse array implemented as dict
    Λ▔ = partitionsequence(λ)
    MN1inner(Λ▔, T, μ, 1)
end
