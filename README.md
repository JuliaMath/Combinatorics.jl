catalan
=======

Catalan: a combinatorics library for Julia, focusing mostly (as of now) on enumerative combinatorics and permutations.
Loading and using `bigint.jl` as arguments is extremely recommended, as these functions overflow easily.

Implements the following functions, with yet no real regard for performance:
 - `catalan(n)`: returns the n-th Catalan number;
 - `derangement(n)`/`subfactorial(n)`: returns the number of permutations of n with no fixed points;
 - `fibonacci(n)`: the n-th Fibonacci number, uses precomputed table for `n` upto 92 (i.e. the largest Fibonacci number which fits in a `Int64`;
 - `hyperfactorial(n)`: the n-th hyperfactorial, i.e. prod([i^i for i = 2:n];
 - `multinomial(k...)`: receives a tuple of `k_1, ..., k_n` and calculates the multinomial coefficient `(n k)`, where `n = sum(k)`;
 - `stirlings1(n, k)`: the signed `(n,k)`-th Stirling number of the first kind.