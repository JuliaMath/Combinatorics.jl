# This is a julia version of the VectorPartitions function for sage by Amritanshu Prasad (2013)
# AUTHORS: Stefan Rigger, Gudmund Pammer (2017)

export vector_partitions

function find_min(vector::Array{Int64})
    "Return a string of 0's with one 1 at the location where the list
     'vector' has its last entry which is not equal to 0.
     INPUT:
     -"vector" -- An Int64-Array
     OUTPUT:
     A list of the same length with 0's everywhere, except for a 1
     at the last position where "vector" has an entry not equal to 0.
     EXAMPLES::
         julia> find_min([2, 1])
         [0, 1]
         julia> find_min([2, 1, 0])
         [0, 1, 0]
    "
    min = zeros(Int64,length(vector))
    if vector != min
        min[maximum(find(vector))] = 1
    end

    return min

end

function componentwise_minors(vector::Array{Int64},min=zeros(Int64,length(vector)))

  " Return array of integer vectors which are componentwise
    less than or equal to "vector" and lexicographically greater than or equal
    to "min".
    INPUT:
    - "vector" -- A list of non-negative integers
    - "min" -- A list of non-negative integers dominated lexicographically by "vector"
    OUTPUT:
    An array in lexicographic order of all integer arrays which are
    dominated elementwise by "vector" and are greater than or equal to "min" in
    lexicographic order.
    EXAMPLES::
         julia> componentwise_minors([1, 1]))
         4-element Array{Any,1}:
         [0,0]
         [0,1]
         [1,0]
         [1,1]
         julia> componentwise_minors([3,2],[2,4])
         3-element Array{Any,1}:
         [3,0]
         [3,1]
         [3,2]
  "
  minors = []
  difference = vector - min

  if difference == zeros(Int64,length(difference))
      minors = [vector]
  elseif length(vector) == 1
      minors =[[k] for k in min[1]:vector[1]]
  else
      # test if min is lexicographically less than vector
      if (difference[minimum(find(difference))] < 0)
          minors = []
      else
          for vec in componentwise_minors(vector[2:end],min[2:end])
              unshift!(vec,min[1])
              push!(minors,vec)
          end
          for j in (min[1]+1):vector[1]
              for vec in componentwise_minors(vector[2:end])
                  unshift!(vec,j)
                  push!(minors,vec)
              end
          end
      end
  end

  return minors
end

function vector_partitions(vector::Array{Int64},min=zeros(Int64,length(vector)))

    " Creates all vector partitions of "vector" with all parts greater than
      or equal to "min" in lexicographic order recursively.
      A vector partition of "vec" is a list of vectors with non-negative
      integer entries whose sum is "vec".
      INPUT:
      - "vec" -- a list of non-negative integers.
      EXAMPLES:
      If "min" is not specified, then the class of all vector partitions of
      "vec" is created::
         julia> vector_partitions([2, 2])
         9-element Array{Any,1}:
          Array{Int64,1}[[1,0],[1,0],[0,1],[0,1]]
          Array{Int64,1}[[2,0],[0,1],[0,1]]
          Array{Int64,1}[[1,1],[1,0],[0,1]]
          Array{Int64,1}[[2,1],[0,1]]
          Array{Int64,1}[[1,0],[1,0],[0,2]]
          Array{Int64,1}[[2,0],[0,2]]
          Array{Int64,1}[[1,2],[1,0]]
          Array{Int64,1}[[1,1],[1,1]]
          Array{Int64,1}[[2,2]]
   
      If "min" is specified, then the array lists those vector
      partitions whose parts are all greater than or equal to "min" in
      lexicographic order::
            julia> vector_partitions([2,2],[1,0])
            3-element Array{Any,1}:
            Array{Int64,1}[[1,2],[1,0]]
            Array{Int64,1}[[1,1],[1,1]]
            Array{Int64,1}[[2,2]]
  "  
  vpartitions=[]

  if min == zeros(Int64,length(vector))
      min = find_min(vector)
  end

  if vector == zeros(Int64,length(vector))
      vpartitions = []
  else
      for vec in componentwise_minors(vector,min)
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
