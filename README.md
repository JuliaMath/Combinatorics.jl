# Combinatorics

[![Build Status](https://travis-ci.org/JuliaMath/Combinatorics.jl.svg?branch=master)](https://travis-ci.org/JuliaMath/Combinatorics.jl)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://gdalle.github.io/Combinatorics.jl/dev)
[![Coverage Status](https://coveralls.io/repos/github/JuliaMath/Combinatorics.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaMath/Combinatorics.jl?branch=master)
[![Codecov](https://codecov.io/gh/JuliaMath/Combinatorics.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaMath/Combinatorics.jl)

A combinatorics library for Julia, focusing mostly (as of now) on enumerative
combinatorics and permutations.  As overflows are expected even for low values,
most of the functions always return `BigInt`, and are marked as such below.

## Installation

In the Julia REPL, type `]add Combinatorics` and then `using Combinatorics` to access the below functions.

## Documentation

Go to https://gdalle.github.io/Combinatorics.jl/dev to see the list of exported functions and their meanings.