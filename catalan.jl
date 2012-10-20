module Catalan

import Base.*
export catalan, derangement, fibonacci, hyperfactorial, multinomial, stirlings1, subfactorial

include("extras/bigint.jl")
include("extras/poly.jl")

# Multinomial coefficient where n = sum(k)
function multinomial(k...)
    s = 0
    result = 1
    for i in k
        s += i
        result *= binomial(s, i)
    end
    result
end

# The number of permutations of n with no fixed points (subfactorial) 
function derangement(n::Integer)
    return num(factorial(n)*sum([(-1)^k//factorial(k) for k=0:n]))
end
subfactorial(n::Integer) = derangement(n)

# Returns s(n, k), the signed Stirling number of first kind
function stirlings1(n::Integer, k::Integer)
    p = poly(0:(n-1))
    p[n - k + 1]
end

# Hyperfactorial
hyperfactorial(n::Integer) = prod([i^i for i = 2:n])

# Returns the n-th Catalan number
function catalan(bn::Integer)
    if bn<0
        throw(DomainError())
    else
        n = BigInt(bn)
    end
    div(binomial(2*n, n), (n + 1))
end

function fibonacci(bn::BigInt)
    z = _jl_bigint_init()
    if bn<0
        return BigInt(0)
    else
        n = uint(bn)
    end
    ccall(dlsym(_jl_libgmp_wrapper, :_jl_mpz_fib_ui), Void,
        (Ptr{Void}, Uint), z, n)
    BigInt(z)
end

# Overflows Int64 for n = 93+
# Overflows Int32 for n = 47+
function fibonacci(n::Integer)
    if n > 92
        error("Fibonacci over 92 overflows Int64, use the BigInt method")
    elseif n < 0
        return 0
    else
        return int64(FIBONACCI[n + 1])
    end
end

const FIBONACCI = [ "0"
                    "1"
                    "1"
                    "2"
                    "3"
                    "5"
                    "8"
                    "13"
                    "21"
                    "34"
                    "55"
                    "89"
                    "144"
                    "233"
                    "377"
                    "610"
                    "987"
                    "1597"
                    "2584"
                    "4181"
                    "6765"
                    "10946"
                    "17711"
                    "28657"
                    "46368"
                    "75025"
                    "121393"
                    "196418"
                    "317811"
                    "514229"
                    "832040"
                    "1346269"
                    "2178309"
                    "3524578"
                    "5702887"
                    "9227465"
                    "14930352"
                    "24157817"
                    "39088169"
                    "63245986"
                    "102334155"
                    "165580141"
                    "267914296"
                    "433494437"
                    "701408733"
                    "1134903170"
                    "1836311903"
                    "2971215073"
                    "4807526976"
                    "7778742049"
                    "12586269025"
                    "20365011074"
                    "32951280099"
                    "53316291173"
                    "86267571272"
                    "139583862445"
                    "225851433717"
                    "365435296162"
                    "591286729879"
                    "956722026041"
                    "1548008755920"
                    "2504730781961"
                    "4052739537881"
                    "6557470319842"
                    "10610209857723"
                    "17167680177565"
                    "27777890035288"
                    "44945570212853"
                    "72723460248141"
                    "117669030460994"
                    "190392490709135"
                    "308061521170129"
                    "498454011879264"
                    "806515533049393"
                    "1304969544928657"
                    "2111485077978050"
                    "3416454622906707"
                    "5527939700884757"
                    "8944394323791464"
                    "14472334024676221"
                    "23416728348467685"
                    "37889062373143906"
                    "61305790721611591"
                    "99194853094755497"
                    "160500643816367088"
                    "259695496911122585"
                    "420196140727489673"
                    "679891637638612258"
                    "1100087778366101931"
                    "1779979416004714189"
                    "2880067194370816120"
                    "4660046610375530309"
                    "7540113804746346429"]

end