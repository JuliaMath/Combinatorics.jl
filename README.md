catalan
=======

Catalan: a combinatorics library for Julia, focusing mostly (as of now) on enumerative combinatorics and permutations.
Loading and using `bigint.jl` as arguments is extremely recommended, as these functions overflow easily.

Implements the following functions, with yet no real regard for performance:
 - `catalan(n)`: returns the n-th Catalan number; always returns a `BigInt`;
 - `derangement(n)`/`subfactorial(n)`: returns the number of permutations of n with no fixed points; always returns a `BigInt`;
 - `doublefactorial(n)`: returns the double factorial n!!; always returns a `BigInt`;
 - `fibonacci(n)`: the n-th Fibonacci number; always returns a `BigInt`;
 - `hyperfactorial(n)`: the n-th hyperfactorial, i.e. prod([i^i for i = 2:n]; always returns a `BigInt`;
 - `jacobisymbol(a,b)`: returns the Jacobi symbol (a/b);
 - `legendresymbol(a,p)`: returns the Legendre symbol (a/p);
 - `lucas(n)`: the n-th Lucas number; always returns a `BigInt`;
 - `multifactorial(n)`: returns the m-multifactorial n(!^m); always returns a `BigInt`;
 - `multinomial(k...)`: receives a tuple of `k_1, ..., k_n` and calculates the multinomial coefficient `(n k)`, where `n = sum(k)`; returns a `BigInt` only if given a `BigInt`;
 - `primorial(n)`: returns the product of all positive prime numbers <= n; always returns a `BigInt`;
 - `stirlings1(n, k)`: the signed `(n,k)`-th Stirling number of the first kind; returns a `BigInt` only if given a `BigInt`.
