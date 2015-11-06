# Combinatorics

[![Combinatorics](http://pkg.julialang.org/badges/Combinatorics_0.3.svg)](http://pkg.julialang.org/?pkg=Combinatorics&ver=0.3)
[![Combinatorics](http://pkg.julialang.org/badges/Combinatorics_0.4.svg)](http://pkg.julialang.org/?pkg=Combinatorics&ver=0.4)
[![Build Status](https://travis-ci.org/JuliaLang/Combinatorics.jl.svg?branch=master)](https://travis-ci.org/JuliaLang/Combinatorics.jl)
[![Coverage Status](https://coveralls.io/repos/JuliaLang/Combinatorics.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaLang/Combinatorics.jl?branch=master)
[![codecov.io](https://codecov.io/github/JuliaLang/Combinatorics.jl/coverage.svg?branch=master)](https://codecov.io/github/JuliaLang/Combinatorics.jl?branch=master)

A combinatorics library for Julia, focusing mostly (as of now) on enumerative
combinatorics and permutations.  As overflows are expected even for low values,
most of the functions always return `BigInt`, and are marked as such below.

This library provides the following functions:
 - `bell(n)`: returns the n-th Bell number; always returns a `BigInt`;
 - `catalan(n)`: returns the n-th Catalan number; always returns a `BigInt`;
  - `combinations(a)`: returns combinations of all order by chaining calls to `Base.combinations(a,n);
 - `derangement(n)`/`subfactorial(n)`: returns the number of permutations of n with no fixed points; always returns a `BigInt`;
 - `doublefactorial(n)`: returns the double factorial n!!; always returns a `BigInt`;
 - `fibonacci(n)`: the n-th Fibonacci number; always returns a `BigInt`;
 - `hyperfactorial(n)`: the n-th hyperfactorial, i.e. prod([i^i for i = 2:n]; always returns a `BigInt`;
 - `integer_partitions(n)`: returns a `Vector{Int}` consisting of the partitions of the number `n`.
 - `jacobisymbol(a,b)`: returns the Jacobi symbol (a/b);
 - `lassalle(n)`: returns the nth Lassalle number A<sub>n</sub> defined in [arXiv:1009.4225](http://arxiv.org/abs/1009.4225) ([OEIS A180874](http://oeis.org/A180874)); always returns a `BigInt`;
 - `legendresymbol(a,p)`: returns the Legendre symbol (a/p);
 - `lucas(n)`: the n-th Lucas number; always returns a `BigInt`;
 - `multifactorial(n)`: returns the m-multifactorial n(!^m); always returns a `BigInt`;
 - `multinomial(k...)`: receives a tuple of `k_1, ..., k_n` and calculates the multinomial coefficient `(n k)`, where `n = sum(k)`; returns a `BigInt` only if given a `BigInt`;
 - `primorial(n)`: returns the product of all positive prime numbers <= n; always returns a `BigInt`;
 - `stirlings1(n, k)`: the signed `(n,k)`-th Stirling number of the first kind; returns a `BigInt` only if given a `BigInt`.

Young diagrams
--------------
Limited support for working with Young diagrams is provided.

- `partitionsequence(a)`: computes partition sequence for an integer partition `a`
- `x = a \ b` creates the skew diagram for partitions (tuples) `a`, `b`
- `isrimhook(x)`: checks if skew diagram `x` is a rim hook
- `leglength(x)`: computes leg length of rim hook `x`
- `character(a, b)`: computes character the partition `b` in the `a`th irrep of Sn
