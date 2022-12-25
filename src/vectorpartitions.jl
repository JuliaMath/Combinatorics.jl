
export vector_partitions

function vector_partitions(vector::Vector{Int64},min=zeros(Integer,length(vector)))

    #   Creates all vector partitions of "vector" with all parts greater than
    #   or equal to "min" in lexicographic order recursively.
    #   A vector partition of "vector" is a list of vectors with non-negative
    #   integer entries whose sum is "vector".
    #   EXAMPLES:
    #       julia> vector_partitions([2, 2])
    #       9-element Vector{Any}:
    #       [[1, 0], [1, 0], [0, 1], [0, 1]]
    #       [[2, 0], [0, 1], [0, 1]]
    #       [[1, 1], [1, 0], [0, 1]]
    #       [[2, 1], [0, 1]]
    #       [[1, 0], [1, 0], [0, 2]]
    #       [[2, 0], [0, 2]]
    #       [[1, 2], [1, 0]]
    #       [[1, 1], [1, 1]]
    #       [[2, 2]]
    #
    #       julia> vector_partitions([2,2],[1,0])
    #       3-element Vector{Any}:
    #       [[1, 2], [1, 0]]
    #       [[1, 1], [1, 1]]
    #       [[2, 2]]

    if minimum(min) < 0 
        throw(DomainError(min, "vector must have nonnegative entries"))
    end
    
    if minimum(vector) < 0 
        throw(DomainError(max, "vector must have nonnegative entries"))
    end
  
    vpartitions=[]
  
    if min == zeros(Integer,length(vector))
        min = lexicographic_nonzero_minimum(vector)
    end
  
    if vector == zeros(Integer,length(vector))
        vpartitions=[]
    else
        for vec in lexicographic_summand_range(vector,min)
            if vec == vector
                push!(vpartitions,[vector])
            else
                for part in vector_partitions(vector-vec,vec)
                    push!(part,vec)
                    push!(vpartitions,part)
                end
            end
        end
    end
  
    return vpartitions
    
  end

function lexicographic_summand_range(max::Vector{Int64},min=zeros(Integer,length(max)))

  #  Return array of nonegative integer vectors which are componentwise dominated by
  #  "max" and greater than or equal to "min" in lexicographic order. 
  #  
  #  EXAMPLES::
  #       julia> lexicographic_summand_range([1,1,0],[0,2,0]))
  #       2-element Vector{Any}:
  #       [1, 0, 0]
  #       [1, 1, 0]
  #       julia> lexicographic_summand_range([1,2])
  #       6-element Vector{Any}:
  #       [0, 0]
  #       [0, 1]
  #       [0, 2]
  #       [1, 0]
  #       [1, 1]
  #       [1, 2]

  range = []
  difference = max - min

  if difference == zeros(Integer,length(difference))
      range = [max]
  elseif length(max) == 1
      range =[[k] for k in min[1]:max[1]]
  else
      if (difference[findfirst(x->x!=0, difference)] < 0)
          range = []
      else 
          for vector in lexicographic_summand_range(max[2:end],min[2:end])
              pushfirst!(vector,min[1])
              push!(range,vector)
          end
          for j in (min[1]+1):max[1]
            for vector in lexicographic_summand_range(max[2:end])
                  pushfirst!(vector,j)
                  push!(range,vector)
              end
          end
      end
  end

  return range
end

function lexicographic_nonzero_minimum(vector::Array{Int64})
    # Returns the lexicographically smallest nonzero vector of the same length as 
    # "vector" that is componentwise dominated by "vector". 
    # EXAMPLES::
    #     julia> lexicographic_nonzero_minimum([2, 1])
    #     [0, 1]
    #     julia> lexicographic_nonzero_minimum([2, 1, 0])
    #     [0, 1, 0]

    min = zeros(Integer,length(vector))
    if vector != min
        min[findlast(x->x>0,vector)] = 1
    end

    return min

end