#Generative algorithms

export cool_lex, integer_partitions, ncpartitions

# Lists the partitions of the number n, the order is consistent with GAP
function integer_partitions(n::Integer)
    if n < 0
        throw(DomainError())
    elseif n == 0
        return Vector{Int}[]
    elseif n == 1
        return Vector{Int}[[1]]
    end

    list = Vector{Int}[]

    for p in integer_partitions(n-1)
        push!(list, [p; 1])
        if length(p) == 1 || p[end] < p[end-1]
            push!(list, [p[1:end-1]; p[end]+1])
        end
    end

    list
end

# Produces (n,k)-combinations in cool-lex order
#
#Implements the cool-lex algorithm to generate (n,k)-combinations
#@article{Ruskey:2009fk,
#	Author = {Frank Ruskey and Aaron Williams},
#	Doi = {10.1016/j.disc.2007.11.048},
#	Journal = {Discrete Mathematics},
#	Month = {September},
#	Number = {17},
#	Pages = {5305-5320},
#	Title = {The coolest way to generate combinations},
#	Url = {http://www.sciencedirect.com/science/article/pii/S0012365X07009570},
#	Volume = {309},
#	Year = {2009}}
function cool_lex(n::Integer, t::Integer)
  s = n-t
  if n > 64 error("Not implemented for n > 64") end
  if t < 1 error("Need t>1") end
  R0::Int64=R1::Int64=0
  R2::Int64 = 1 << (s+t)
  R3::Int64 = (1 << t) - 1
  while R3 & R2 == 0
    produce(visit(R3))
    R0 = R3 & (R3 + 1)
    R1 = R0 $ (R0 - 1)
    R0 = R1 + 1
    R1 &= R3
    R0 = max((R0 & R3) - 1, 0)
    R3 += R1 - R0
  end
end

#Converts an integer word X into a subset
#If X & 2^k == 1, then k is in the subset
function visit(X::Integer)
  subset = Int[]
  n::Int=1
  while X != 0
    if X & 1 == 1 push!(subset, n) end
    X >>= 1
    n += 1
  end
  subset
end

#Produces noncrossing partitions of length n
ncpartitions(n::Integer)=ncpart(1,n,n,Any[])
function ncpart(a::Integer, b::Integer, nn::Integer,
    x::Array{Any,1})
  n=b-a+1
  for k=1:n
    for root in @task cool_lex(n, k)
      root += a-1
      #Abort if construction is out of lex order
      if length(x)>0 && x[end] > root return end
      #Produce if we've filled all the holes
      sofar = Any[x..., root]
      ssofaru = sort(union(sofar...))
      if length(ssofaru)==nn && ssofaru==[1:nn]
        produce(sofar)
        return
      end
      #otherwise patch all remaining holes
      blob = [ssofaru; nn+1]
      for l=1:length(blob)-1
        ap, bp = blob[l]+1, blob[l+1]-1
        if ap <= bp ncpart(ap, bp, nn, sofar) end
      end
    end
  end
end
