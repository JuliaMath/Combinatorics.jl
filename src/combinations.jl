export combinations, CoolLexCombinations

#The Combinations iterator

immutable Combinations{T}
    a::T
    t::Int
end

start(c::Combinations) = [1:c.t;]
function next(c::Combinations, s)
    comb = [c.a[si] for si in s]
    if c.t == 0
        # special case to generate 1 result for t==0
        return (comb,[length(c.a)+2])
    end
    s = copy(s)
    for i = length(s):-1:1
        s[i] += 1
        if s[i] > (length(c.a) - (length(s)-i))
            continue
        end
        for j = i+1:endof(s)
            s[j] = s[j-1]+1
        end
        break
    end
    (comb,s)
end
done(c::Combinations, s) = !isempty(s) && s[1] > length(c.a)-c.t+1

length(c::Combinations) = binomial(length(c.a),c.t)

eltype{T}(::Type{Combinations{T}}) = Vector{eltype(T)}

"Generate all combinations of `n` elements from an indexable object. Because the number of combinations can be very large, this function returns an iterator object. Use `collect(combinations(array,n))` to get an array of all combinations.
"
function combinations(a, t::Integer)
    if t < 0
        # generate 0 combinations for negative argument
        t = length(a)+1
    end
    Combinations(a, t)
end


"""
generate combinations of all orders, chaining of order iterators is eager,
but sequence at each order is lazy
"""
combinations(a) = chain([combinations(a,k) for k=1:length(a)]...)



# cool-lex combinations iterator

"""
Produces (n,k)-combinations in cool-lex order

Implements the cool-lex algorithm to generate (n,k)-combinations
@article{Ruskey:2009fk,
	Author = {Frank Ruskey and Aaron Williams},
	Doi = {10.1016/j.disc.2007.11.048},
	Journal = {Discrete Mathematics},
	Month = {September},
	Number = {17},
	Pages = {5305-5320},
	Title = {The coolest way to generate combinations},
	Url = {http://www.sciencedirect.com/science/article/pii/S0012365X07009570},
	Volume = {309},
	Year = {2009}}
"""
immutable CoolLexCombinations
    n :: Int
    t :: Int
end

immutable CoolLexIterState{T<:Integer}
    R0:: T
    R1:: T
    R2:: T
    R3:: T
end

function start(C::CoolLexCombinations)
    if C.n < 0
        throw(DomainError())
    end
    if C.t ≤ 0
        throw(DomainError())
    end

    #What integer size should I use?
    if C.n < 8sizeof(Int)
        T = Int
    else
        T = BigInt
    end

    CoolLexIterState{T}(0, 0, T(1) << C.n, (T(1) << C.t) - 1)
end

function next(C::CoolLexCombinations, S::CoolLexIterState)
    R0 = S.R0
    R1 = S.R1
    R2 = S.R2
    R3 = S.R3

    R0 = R3 & (R3 + 1)
    R1 = R0 $ (R0 - 1)
    R0 = R1 + 1
    R1 &= R3
    R0 = max((R0 & R3) - 1, 0)
    R3 += R1 - R0

    _cool_lex_visit(S.R3), CoolLexIterState(R0, R1, R2, R3)
end

#Converts an integer bit pattern X into a subset
#If X & 2^k == 1, then k is in the subset
function _cool_lex_visit(X::Int)
  subset = Int[]
  n=1
  while X != 0
    if X & 1 == 1 push!(subset, n) end
    X >>= 1
    n += 1
  end
  subset
end

done(C::CoolLexCombinations, S::CoolLexIterState) = (S.R3 & S.R2 != 0)

length(C::CoolLexCombinations) = max(0, binomial(C.n, C.t))
