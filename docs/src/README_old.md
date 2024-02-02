# Combinatorics

[![CI](https://github.com/JuliaMath/Combinatorics.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaMath/Combinatorics.jl/actions/workflows/CI.yml)
[![Coverage Status](https://coveralls.io/repos/github/JuliaMath/Combinatorics.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaMath/Combinatorics.jl?branch=master)
[![codecov](https://codecov.io/gh/JuliaMath/Combinatorics.jl/graph/badge.svg?token=ov65P61lvZ)](https://codecov.io/gh/JuliaMath/Combinatorics.jl)

A combinatorics library for Julia, focusing mostly (as of now) on enumerative
combinatorics and permutations.  As overflows are expected even for low values,
most of the functions always return `BigInt`, and are marked as such below.

## Installation

In the Julia REPL, type `]add Combinatorics` and then `using Combinatorics` to access the below functions.

## Usage

This library provides the following functions:
 - `bellnum(n)`: returns the n-th Bell number; always returns a `BigInt`;
 - `catalannum(n)`: returns the n-th Catalan number; always returns a `BigInt`;
 - `lobbnum(m,n)`: returns the generalised Catalan number at `m` and `n`; always returns a `BigInt`;
 - `narayana(n,k)`: returns the general Narayana number at any given `n` and `k`; always returns a `BigInt`;
 - `combinations(a,n)`: returns all combinations of `n` elements of indexable object `a`;
 - `combinations(a)`: returns combinations of all order by chaining calls to `combinations(a,n)`;
 - `derangement(n)`/`subfactorial(n)`: returns the number of permutations of n with no fixed points; always returns a `BigInt`;
 - `partialderangement(n, k)`: returns the number of permutations of n with exactly k fixed points; always returns a `BigInt`;
 - `doublefactorial(n)`: returns the double factorial n!!; always returns a `BigInt`;
 - `fibonaccinum(n)`: the n-th Fibonacci number; always returns a `BigInt`;
 - `hyperfactorial(n)`: the n-th hyperfactorial, i.e. prod([i^i for i = 2:n]; always returns a `BigInt`;
 - `integer_partitions(n)`: returns a `Vector{Int}` consisting of the partitions of the number `n`.
 - `jacobisymbol(a,b)`: returns the Jacobi symbol (a/b);
 - `lassallenum(n)`: returns the nth Lassalle number A<sub>n</sub> defined in [arXiv:1009.4225](http://arxiv.org/abs/1009.4225) ([OEIS A180874](http://oeis.org/A180874)); always returns a `BigInt`;
 - `legendresymbol(a,p)`: returns the Legendre symbol (a/p);
 - `lucasnum(n)`: the n-th Lucas number; always returns a `BigInt`;
 - `multifactorial(n)`: returns the m-multifactorial n(!^m); always returns a `BigInt`;
 - `multinomial(k...)`: receives a tuple of `k_1, ..., k_n` and calculates the multinomial coefficient `(n k)`, where `n = sum(k)`; returns a `BigInt` only if given a `BigInt`;
 - `multiexponents(m,n)`: returns the exponents in the multinomial expansion (x₁ + x₂ + ... + xₘ)ⁿ;
 - `primorial(n)`: returns the product of all positive prime numbers <= n; always returns a `BigInt`;
 - `powerset(a)`: returns all subsets of an indexable object `a`
 - `stirlings1(n, k, signed=false)`: returns the `(n,k)`-th Stirling number of the first kind; the number is signed if `signed` is true; returns a `BigInt` only if given a `BigInt`.
 - `stirlings2(n, k)`: returns the `(n,k)`-th Stirling number of the second kind; returns a `BigInt` only if given a `BigInt`.
 - `nthperm(a, k)`: Compute the `k`th lexicographic permutation of the vector `a`.
 - `permutations(a)`: Generate all permutations of an indexable object `a` in lexicographic order.

Young diagrams
--------------
Limited support for working with Young diagrams is provided.

- `partitionsequence(a)`: computes partition sequence for an integer partition `a`
- `x = a \ b` creates the skew diagram for partitions (tuples) `a`, `b`
- `isrimhook(x)`: checks if skew diagram `x` is a rim hook
- `leglength(x)`: computes leg length of rim hook `x`
- `character(a, b)`: computes character the partition `b` in the `a`th irrep of Sn
