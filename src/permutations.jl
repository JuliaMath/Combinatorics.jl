#Permutations

export
    levicivita,
    nthperm!,
    nthperm,
    parity,
    permutations

#The basic permutations iterator

immutable Permutations{T}
    a::T
end

"""
Generate all permutations of an indexable object. Because the number of permutations can be very large, this function returns an iterator object. Use `collect(permutations(array))` to get an array of all permutations.
"""
permutations(a) = Permutations(a)

eltype{T}(::Type{Permutations{T}}) = Vector{eltype(T)}

length(p::Permutations) = factorial(length(p.a))

start(p::Permutations) = [1:length(p.a);]
function next(p::Permutations, s)
    perm = [p.a[si] for si in s]
    if isempty(p.a)
        # special case to generate 1 result for len==0
        return (perm,[1])
    end
    s = copy(s)
    k = length(s)-1
    while k > 0 && s[k] > s[k+1];  k -= 1;  end
    if k == 0
        s[1] = length(s)+1   # done
    else
        l = length(s)
        while s[k] >= s[l];  l -= 1;  end
        s[k],s[l] = s[l],s[k]
        reverse!(s,k+1)
    end
    (perm,s)
end
done(p::Permutations, s) = !isempty(s) && s[1] > length(p.a)


"In-place version of nthperm."
function nthperm!(a::AbstractVector, k::Integer)
    k -= 1 # make k 1-indexed
    k < 0 && throw(ArgumentError("permutation k must be ≥ 0, got $k"))
    n = length(a)
    n == 0 && return a
    f = factorial(oftype(k, n-1))
    for i=1:n-1
        j = div(k, f) + 1
        k = k % f
        f = div(f, n-i)

        j = j+i-1
        elt = a[j]
        for d = j:-1:i+1
            a[d] = a[d-1]
        end
        a[i] = elt
    end
    a
end

"Compute the kth lexicographic permutation of the vector a."
nthperm(a::AbstractVector, k::Integer) = nthperm!(copy(a),k)

"Return the `k` that generated permutation `p`. Note that `nthperm(nthperm([1:n], k)) == k` for `1 <= k <= factorial(n)`."
function nthperm{T<:Integer}(p::AbstractVector{T})
    isperm(p) || throw(ArgumentError("argument is not a permutation"))
    k, n = 1, length(p)
    for i = 1:n-1
        f = factorial(n-i)
        for j = i+1:n
            k += ifelse(p[j] < p[i], f, 0)
        end
    end
    return k
end


# Parity of permutations

const levicivita_lut = cat(3, [0 0  0;  0 0 1; 0 -1 0],
                              [0 0 -1;  0 0 0; 1  0 0],
                              [0 1  0; -1 0 0; 0  0 0])

"""
Levi-Civita symbol of a permutation.

Returns 1 is the permutation is even, -1 if it is odd and 0 otherwise.

The parity is computed by using the fact that a permutation is odd if and
only if the number of even-length cycles is odd.
"""
function levicivita{T<:Integer}(p::AbstractVector{T})
    n = length(p)

    if n == 3
        @inbounds valid = (0 < p[1] <= 3) * (0 < p[2] <= 3) * (0 < p[3] <= 3)
        return valid ? levicivita_lut[p[1], p[2], p[3]] : 0
    end

    todo = trues(n)
    first = 1
    cycles = flips = 0

    while cycles + flips < n
        first = findnext(todo, first)
        (todo[first] $= true) && return 0
        j = p[first]
        (0 < j <= n) || return 0
        cycles += 1
        while j ≠ first
            (todo[j] $= true) && return 0
            j = p[j]
            (0 < j <= n) || return 0
            flips += 1
        end
    end

    return iseven(flips) ? 1 : -1
end

"""
Computes the parity of a permutation using the levicivita function,
so you can ask iseven(parity(p)). If p is not a permutation throws an error.
"""
function parity{T<:Integer}(p::AbstractVector{T})
    epsilon = levicivita(p)
    epsilon == 0 && throw(ArgumentError("Not a permutation"))
    epsilon == 1 ? 0 : 1
end

