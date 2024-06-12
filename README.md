# `HDXLSIMDSupport`: Overview

This package provides access to `SIMD`-style, generic quaternions and matrices: in the same way you can write `SIMD3<Float>`, you can now write `Quaternion<Double>`, `Matrix4x4<Float>`, and so on.

The package provides matrices and quaternions by wrapping Apple's corresponding, non-generic, still-"un-Swiftified" simd types:

- `Quaternion<Double>` is *essentially* a wrapper around `simd_quatd`
- `Matrix4x4<Float>` is *essentially* a wrapper around `simd_float4x4`

...and so on and so forth.

## Roadmap (Updated for 2024)

### Planned Changes

These items are likely to happen soon:

- [x] modernize Swift style / syntax:
  - [x] drop explicit `get { }` for read-only computed properties
  - [x] drop explicit `return ` wherever possible
  - [x] delete filename+author header comments from all files
  - [x] replace `$visibility extension $typename` with `extension $typename` (and add explicit visibility specificiers to properties, methods, etc.)
- [ ] cleanup documentation comments / get DocC working on this package
- [x] update to Swift 6 / bump minimum supported versions
- [x] pervasive `Sendable` integration (goal: safe for use w/ *strict* Swift concurrency)
- [ ] migrate to Swift Testing (and enhance test suite)
- [ ] rely more on synthesized conformances (where applicable)
- [ ] adopt `CustomMirror` (goal: only present underlying simd type to debugger)
- [ ] adopt `CustomDebugString` (where applicable/zero-cost)
- [ ] conform to any other protocols the other, "official" SIMD types conform to (TBD)

### Nice-But-Blocked

- [ ] implement types for `Float16`:
  - `half` variants are only partially-exposed (types exist, exposed api is incomplete as-of beta 1)

### Nice-But-Unlikely

There's a lot of larger changes that'd be nice to explore, but aren't current planned:

- [ ] reduce code-duplication via finer-grained layering of protocols and default implementations
- [ ] explore use for macros to streamline code (e.g. a macro to synthesize the fowarding boilerplate for our passthrough-types)
- [ ] replace protocol protocol-and-type-trickery with code-generation (or with macros)

These are "nice" b/c they're options I'd explore more-heavily in a complete do-over, but "unlikely" b/c the existing code already works.   

### Background (Updated for 2024)

This library grew out of an unreleased interpolation-support library that, in turn, was used to support custom UI animations.

The specific pain-point this address was that all of that library's interpolation code could be written generically *except for simd-accelerated matrices and quaternions*--those only existed in concrete, non-generic form.

Back then, it seemed inevitable that Apple would add SIMD-enhanced matrices within a year or two, and so this library was meant as a stop-gap:

- implement the missing functionality
- provide an API following the patterns used for Swift's vector SIMD types
- throw it away once the "official version" gets released

...and that remains motivation and the plan for this library. 

### Implementation Notes

TODO: update for 2024.

Tl;dr: 

- relies on combination of:
  - manually-written boilerplate
  - "layered" protocols
  - default methods on protocols
- protocol layers are deliberately suboptimal to work around some no-longer-relevant compiler issues
  - could benefit from leaning harder on protocol-level techniques
  - could also benefit from migrating to code-generation and/or Swift macros

