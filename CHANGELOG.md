# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [Unreleased]

> TODO: Rename this section when releasing a new version.  
> Types of changes: Added, Removed, Deprecated, Changed, Fixed

### Added

- Add `multiset_permutations` method that doesn't require length ([#164])
- doc: add more examples and test for partitions ([#181])
- doc: Add CHANGELOG.md [#189]

### Changed

- ci: workaround for tagbot permissions ([#183])

### Fixed

[Unreleased]: https://github.com/JuliaMath/Combinatorics.jl/compare/v1.0.3...HEAD
[#164]: https://github.com/JuliaMath/Combinatorics.jl/pull/164
[#181]: https://github.com/JuliaMath/Combinatorics.jl/pull/181
[#183]: https://github.com/JuliaMath/Combinatorics.jl/pull/183
[#189]: https://github.com/JuliaMath/Combinatorics.jl/pull/189


## [1.0.3] - 2025-05-03

### Added

- doc: Add `powerset(a)` to README.md [#106]
- doc: Add install instructions [#111]
- doc: Setup Documenter [#112]
- doc: add examples for `permutations.jl` [#173]
- ci: MassInstallAction: Install the CI workflow on this repository [#102]
- ci: enable dependabot for GitHub actions [#131]
- ci: MassInstallAction: Install the CompatHelper workflow on this repository [#145]

### Removed

- Remove undef symbol `gamma` [#178]

### Changed

- performance: faster `permutations`, based on what rdeits suggested [#122]
- performance: inline `Base.iterate(c::Combinations, s)` method to avoid allocations [#148]
- performance: Improve performance of `derangement`/`subfactorial` with iterative implementation [#146]
- performance: Make `multiexponents` type stable [#136]
- performance: Improve `factorial(n, k)` performance for BigInt [#149]
- ci: Test on latest Julia release as well [#144]
- ci: reopen doctest [#159]
- ci: update CI workflow (`CI.yml`, `CompatHelper.yml`, `TagBot.yml`) [#160]
- ci: use codecov token [#161]
- ci: run julia with default arch [#174]
- ci: Many dependabot bump pr

### Fixed

- bugfix: Update `hyperfactorial` to handle the 0 and 1 condition [#107]
- bugfix: Check overflow in `multinomial` [#172]
- doc: `narayana` and `prevprod` tweaks [#115]
- doc: fix documentation of `multiset_permutations` [#141]
- doc: fix typo in `levicivita` doc [#180]
- ci: fix doc deploy [#153]
- ci: README: Update readme badge [#154]

[1.0.3]: https://github.com/JuliaMath/Combinatorics.jl/compare/v1.0.2...v1.0.3
[#102]: https://github.com/JuliaMath/Combinatorics.jl/pull/102
[#106]: https://github.com/JuliaMath/Combinatorics.jl/pull/106
[#107]: https://github.com/JuliaMath/Combinatorics.jl/pull/107
[#111]: https://github.com/JuliaMath/Combinatorics.jl/pull/111
[#112]: https://github.com/JuliaMath/Combinatorics.jl/pull/112
[#115]: https://github.com/JuliaMath/Combinatorics.jl/pull/115
[#122]: https://github.com/JuliaMath/Combinatorics.jl/pull/122
[#131]: https://github.com/JuliaMath/Combinatorics.jl/pull/131
[#136]: https://github.com/JuliaMath/Combinatorics.jl/pull/136
[#141]: https://github.com/JuliaMath/Combinatorics.jl/pull/141
[#144]: https://github.com/JuliaMath/Combinatorics.jl/pull/144
[#145]: https://github.com/JuliaMath/Combinatorics.jl/pull/145
[#146]: https://github.com/JuliaMath/Combinatorics.jl/pull/146
[#148]: https://github.com/JuliaMath/Combinatorics.jl/pull/148
[#149]: https://github.com/JuliaMath/Combinatorics.jl/pull/149
[#153]: https://github.com/JuliaMath/Combinatorics.jl/pull/153
[#154]: https://github.com/JuliaMath/Combinatorics.jl/pull/154
[#159]: https://github.com/JuliaMath/Combinatorics.jl/pull/159
[#160]: https://github.com/JuliaMath/Combinatorics.jl/pull/160
[#161]: https://github.com/JuliaMath/Combinatorics.jl/pull/161
[#172]: https://github.com/JuliaMath/Combinatorics.jl/pull/172
[#173]: https://github.com/JuliaMath/Combinatorics.jl/pull/173
[#174]: https://github.com/JuliaMath/Combinatorics.jl/pull/174
[#178]: https://github.com/JuliaMath/Combinatorics.jl/pull/178
[#180]: https://github.com/JuliaMath/Combinatorics.jl/pull/180


## [1.0.2] - 2020-05-14

### Added

### Removed

- Remove stale dependency on `Polynomials.jl` [#94]

### Changed

### Fixed

[1.0.2]: https://github.com/JuliaMath/Combinatorics.jl/compare/v1.0.1...v1.0.2
[#94]: https://github.com/JuliaMath/Combinatorics.jl/pull/94


## [1.0.1] - 2020-04-22

### Added

- ci: Install TagBot as a GitHub Action [#90]

### Removed

### Changed

- compat: Bump `Polynomials` compat to include v0.7, v0.8 [#91]

### Fixed

[1.0.1]: https://github.com/JuliaMath/Combinatorics.jl/compare/v1.0.0...v1.0.1
[#90]: https://github.com/JuliaMath/Combinatorics.jl/pull/90
[#91]: https://github.com/JuliaMath/Combinatorics.jl/pull/91


## [1.0.0] - 2019-11-29

### Added

- Added `lobbnum` and `Narayana` numbers [#76]
- Add partial derangements `partialderangement` [#78]
- Add a Project file, remove REQUIRE, declare version 1.0 [#88]

### Removed

### Changed

- Improve `nthperm!` argument checking [#14]
- performance: Corrected and optimized `bellnum` [#74]
- performance: Give access to non-allocating `combinations` iterator [#73]
- performance: `nthperm()`: Replace one `%=` by a `-= remainder - divisor` computed earlier [#55]
- performance: Make `partitions` type-stable [#35]
- performance: Make `partitions` type-stable (deconflicted) [#75]
- doc: readme: Remove reference to Base.combinations [#77]

### Fixed

- Fix deprecations for using `lexcmp` [#70]

[1.0.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.7.0...v1.0.0
[#14]: https://github.com/JuliaMath/Combinatorics.jl/issues/14
[#35]: https://github.com/JuliaMath/Combinatorics.jl/issues/35
[#55]: https://github.com/JuliaMath/Combinatorics.jl/issues/55
[#70]: https://github.com/JuliaMath/Combinatorics.jl/issues/70
[#73]: https://github.com/JuliaMath/Combinatorics.jl/issues/73
[#74]: https://github.com/JuliaMath/Combinatorics.jl/issues/74
[#75]: https://github.com/JuliaMath/Combinatorics.jl/issues/75
[#76]: https://github.com/JuliaMath/Combinatorics.jl/issues/76
[#77]: https://github.com/JuliaMath/Combinatorics.jl/issues/77
[#78]: https://github.com/JuliaMath/Combinatorics.jl/issues/78
[#88]: https://github.com/JuliaMath/Combinatorics.jl/issues/88


## [0.7.0] - 2018-08-10

[0.7.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.6.0...v0.7.0

## [0.6.0] - 2018-03-31

[0.6.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.5.0...v0.6.0

## [0.5.0] - 2017-11-23

[0.5.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.4.0...v0.5.0

## [0.4.0] - 2017-03-17

[0.4.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.3.0...v0.4.0

## [0.3.0] - 2015-11-07

[0.3.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.2.0...v0.3.0

## [0.2.0] - 2015-11-06

[0.2.0]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.1.1...v0.2.0

## [0.1.1] - 2014-10-31

[0.1.1]: https://github.com/JuliaMath/Combinatorics.jl/compare/v0.0.1...v0.1.1

## [0.0.1] - 2014-03-17

[0.0.1]: https://github.com/JuliaMath/Combinatorics.jl/releases/tag/v0.0.1
