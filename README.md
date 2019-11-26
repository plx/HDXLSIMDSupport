# `HDXLSIMDSupport`: Overview

This package provides access to `SIMD`-style, generic quaternions and matrices: you can write `Quaternion<Double>`, `Matrix4x4<Float>`, and so on. The package provides this functionality by wrapping Apple's corresponding, non-generic simd types: `Quaternion<Double>` is ultimately a wrapper around `simd_quatd`, `Matrix4x4<Float>` is ultimately a wrapper around `simd_float4x4`, and so on.

## Warning: Compile Time

The package presently can require 30-40+ minutes to compile in both `Debug` and `Release` configurations. This is simultaneously (a) extremely-unfortunate but also (b) a remarkable improvement over the **6-8 hours* required of some earlier versions. 

If I knew *exactly* what it was about this package that caused such ridiculous compile times, I'd just...fix it. As it is, I have some guesses, but haven't explored them, yet--testing any of these guesses would, at minimum, require extensive refactoring and, at maximum, require an essentially-full rewrite.

Given that the package *works for my needs*, for now I've deliberately accepted the excessive compile times and moved on; it's something I'd like to improve, and I would be happy to discuss further with any interested parties.

## Miscellaneous Notes

- [Goal](#goal): a placeholder until there's an official equivalent
- [Performance](#performance): 5-10% slower in `Release` (room for improvement)
- [Narrow Type Erasure](#erasure): the package's core "technique"  
- [Why Three Layers?](#layers): why each type "has 3 layers"
- [`Passthrough`](#passthrough): boilerplate-minimization technique 
- [Regrets](#regrets): "maybe I shoulda gone with code generation?"
- [Non-Decomposability](#decomposability): defense of "all-or-none" design
- [Limitations](#limitations): justifying some non-intuitive protocol design
- [Testing](#testing): why so few tests?

### <a name="attitude">Goal: Temporary Placeholder</a>

I don't have grand ambitions for this module: I view it as a simple placeholder until the arrival of the inevitable standard-library equivalent. Perhaps that'll arrive next year, perhaps that'll arrive in a few years, etc., but this package exists simply to plug the gap from now until then.

I'm not *opposed* to expanding it to include more utilities, conveniences, generic (small) matrix and vector algorithms, etc., but nothing along those lines is on my agenda at this time.

### <a name="perfomance">Performance Status: 5-10% Penalty in `Release`</a>

Within this package I've constrained myself to using only the "public" annotations: I use `@frozen`, `@inlinable`, and `@usableFromInline`, but I don't use underscored annotations like `@_transparent` or `@inline(_always)`. Note that this constraint isn't necessarily *permanent*--I'm open to using them once I have more comfort with their semantics and implications--but it will remain in effect in the near term.

Despite that constraint, in `Release` builds I consistently see only a moderate penalty of 5-10% for using, say, `Matrix4x4<Double>` instead of `simd_double4x4`. Given the triviality of the package's code, I strongly suspect that all it would take to eliminate that gap would be judicious application of `@_transparent` and `@inline(_always)`; investigating this is certainly on my todo list, and any informed advice and guidance would be appreciated.

Now, some bad news: `Debug` build performance is, frankly, atrocious--expect a penalty somewhere between 500% and 1000%. I'm sure some improvement is possible, but don't have much hope; the slowdown seems intrinsic to how Swift handles generics in `Debug` builds, and thus is more of a "language and tooling" issue rather than a "this package, right here" issue.

### <a name="erasure">Narrow Type Erasure</a>

The package uses the following technique:

```swift
// Compatible scalaras *must* provide concrete "storage" types, as below.
protocol ExtendedSIMDScalar {
  
  // Concrete "quaternion storage" type, eliding full conformances & constraints
  associatedtype QuaternionStorage: QuaternionProtocol, /* ... */
    where 
    Self == QuaternionStorage.Scalar, /* ... */
    
  // ^ and continues similarly for each concrete matrix type
}

// the "primary types" wrap their corresponding storage type...
struct Quaternion<Scalar:ExtendedSIMDScalar> {
  @usableFromInline
  internal typealias Storage = Scalar.QuaternionStorage
  
  @usableFromInline
  internal var storage: Storage
}

// ...and implement their API via simple, trivial forwarding:
extension Quaternion {
  // *named* addition; user code prefer the `+` operator
  func adding(_ other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: sef.storage.adding(other.storage)
    )
  }
}
``` 

At heart, this is simply a narrow, special-purpose form of type-erasure. The advantage of this technique is that we can *write* generic code but *use* the pre-existing highly-optimized, type-specific equivalents: when you write `Quaternion<Float>` you wind up with (a wrapper around) `simd_quatf`, when you write `Quaternion<Double>` you wind up with (a wrapper around) `simd_quatd`, and so on and so forth. 

Given the usefulness of this technique it deserves a name of its own; if there is one, pleae let me know!

### <a name="layers">Why Three Layers?</a>

If you dig into it, there are three distinct "layers" to each type. `Quaternion`, for example, involves three layers:

- primary: `Quaternion<Scalar>`
- storage: `Scalar.QuaternionStorage`
- native: `simd_quatd` and `simd_quatf`

*In theory*, I could have gotten away with just two:

- primary: `Quaternion<Scalar>`
- storage: `simd_quatd` and `simd_quatf`

...achieving abstraction over `simd_quatd` and `simd_quatf` by having them each conform to a carefully-constructed protocol.

If I were working on the standard library--and thus had *control* over `simd_quatd` and `simd_quatf`, etc.--I'd have strongly considered that exact approach. Since I don't have that control, however, it seemed far safer to introduce that intermediate *storage* tier: I'm *far* more comfortable with `FloatQuaternionStorage` *providing its own conformances* to the common protocols like `Equatable` and `Hashable` (etc.) than I am *externally-adding conformances* to types outside of this module.

Note that I *do* still add protocol conformances to `simd_quatf` and `simd_quatd`, but (a) it's to protocols of my own design and (b) I made certain design choices that sidestep possible conflicts (albeit at the cost of looking somewhat unidiomatic, viewed in isolation).

### <a name="passthrough">Passthrough</a>

To minimize the repetitive boilerplate, I make heavy use of conditional extension on what I named the `Passthrough` protocol, e.g. like so:

```swift
// Protocol for "trivial forwarding wrapper" types.
protocol Passthrough {
  associatedtype PassthroughValue
  var passthroughValue: PassthroughValue { get set }
  init(passthroughValue: PassthroughValue)
}

// example conditional extension:
public extension Passthrough where PassthroughValue:AdditiveArithmetic {
  
  static var zero: Self {
    get {
      return Self(passthroughValue: PassthroughValue.zero)
    }    
  }
  
  static func +(
    lhs: Self,
    rhs: Self) -> Self {
      return Self(
      passthroughValue: lhs.passthroughValue + rhs.passthroughValue
    )
  }
}
```

Use of this `Passthrough` protocol means I need only write the trivial-forwarding boilerplate code once-per-protocol. Having done so--say for `AdditiveArithmetic` as-above--my concrete wrapper types obtain their conformance "for free". It's not a true substitute for compiler-synthesized conformances--and with a deeper type system this could presumably be implemented entirely as some higher-kinded something-or-other--but it *does* efficiently cut down on boilerplate.

### <a name="regrets">Regrets</a>

I've had a few--and at least one of them concerns `HDXLSIMDSupport`.

The nature of this project intrinsically involves a *lot* of boilerplate. For each top-level type like `Quaternion<T>`, we need at least three distinct types:
  
- `Quaternion<T>`, itself
- `Float`-flavored `QuaternionStorage` (wrapping `simd_quatf`)
- `Double`-flavored `QuaternionStorage` (wrapping `simd_quatd`)

In total we thus need **30** distinct types: 3 for `Quaternion`, and 3, each, for the 9 distinct `MatrixNxM` types. 

When I started the project, I immediately decided against using code generation--whether via "Swift-favorite" GYB or any other tool--simply to avoid a "now you have two problems" situation. I wanted SIMD matrices and SIMD quaternions, I wanted them now, and the last thing I needed was to get stuck learning some other toolchain (and debugging both the code and the templates).

In hindsight, I regret this: I managed to get my pure-Swift, protocol-centric approach to *work*, but only for a definition of *work* that's compatible-with the package's ridiculous compile time. I also have had to restructure the protocol hierarchy several times just to get to that "reasonable" compile time; earlier iterations had finer-grained protocol hierarchies I found far more aesthetically-pleasing, but they suffered from compile times measured in hours instead of minutes.

Aside from compile-time issues, the current iteration of the protocol-centric exposes a fair amount of internal implementation detail. This unwanted exposure could, perhaps, be *lessened*--somehow--but it's hard to see how it could be *eliminated* with this approach.

All that said, I hesitate slightly: there's still a need for *some* protocol per "primary type"--e.g. `Quaternion` needs *something like* `QuaternionProtocol`, etc.--and those protocols would still necessarily include associated types that cross-reference each other (e.g. a `Quaternion` needs associated types for, at least, compatible 3x3 and 4x4 matrices, and so on). Using codegen *instead of* "inheritance & default implementations" would thus allow me to have a flatter hierarchy, but at this time it's unclear if that would actually have a material impact on the compile-time issue.

### <a name="decomposability">Non-Decomposability</a>

The current design supports exactly two scalar types: `Float` and `Double`. Additional scalar types *can* be introduced--all they need to do is conform to `ExtendedSIMDScalar`. That said, there's a *slight* catch, here: for a type to conform to `ExtendedSIMDScalar` it must provide *all 10 top-level types* (`Quaternion` and the nine `MatrixNxM` variants); technically-speaking the type must also conform to `SIMDScalar`, too, but I take that for granted.

At first glance this seems unnecessary--"what if I only want a `Quaternion`?" isn't an unreasonable sentiment--but it's less unnecessary than it seems. Consider `Quaternion`, again: the `Quaternion` API as currently-provided requires `associatedtype`s for the compatible 3x3 and 4x4 matrices; those matrices, in turn, require `associatedtype`s for the matrices with which they can be multiplied. For the 4x4 matrix that means 4x3, 4x2, 3x4, and 2x4; for the 3x3 matrix that means 4x3, 2x3, 4x4, and 3x2; each of those, in turn, drag in their own `associatedtype`s corresponding to the compatible matrices 

I think you can see where this is going: each of the "primary types" winds up bringing in all of the others via the transitive property. Even if not *immediately-obvious*, then, it does indeed seem as if the "all-in-one" scalar protocol is, in fact, the natural design, here.

### <a name="limitations">Design Limitations</a>

This final "miscellaneous note" is intended to explain something that I suspect will otherwise be far from obvious. Here's how `QuaternionProtocol` declares its associated types:

```swift
public protocol QuaternionProtocol {

  /// The scalar with-which we represent our coefficients.
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint
  
  /// The type of the compatible 3x3 matrix.
  associatedtype CompatibleMatrix3x3
  
  /// The type of the compatible 4x4 matrix.
  associatedtype CompatibleMatrix4x4
  
  // ... 
}
```

Note that although I *have* elided the rest of the protocol, the above is a true-and-correct reproduction of the `associatedtype` declarations--it's not simplified, it's not simplified, that's the actual definition.

I mention this because--at first glance--the more-natural formulation would be *seemingly* be something like this:

```swift
public protocol QuaternionProtocol {

  /// The scalar with-which we represent our coefficients.
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint
  
  /// The type of the compatible 3x3 matrix.
  associatedtype CompatibleMatrix3x3 : Matrix3x3Protocol 
    where
    // we need compatible `Scalar`, right?
    Scalar == CompatibleMatrix3x3.Scalar, 
    // you'd think we need this, too, right?
    Self == CompatibleMatrix3x3.CompatibleQuaternion 
  
  /// The type of the compatible 4x4 matrix.
  associatedtype CompatibleMatrix4x4 : Matrix4x4Protocol
    where
    // we need compatible `Scalar`, right?
    Scalar == CompatibleMatrix4x4.Scalar,
    // you'd think we need this, too, right?
    Self == CompatibleMatrix4x4.CompatibleQuaternion 
  
  // ... 
}
```

For the cautious reader I will simply state that Swift can both *understand* and--at least in general--*handle* recursive protocol constraints like the `Self == Compatible3x3Matrix.CompatibleQuaternion`; there *is* an issue here, but the recursive declaration isn't it.

So, what's the issue? 

Easy: using more-semantic, more-precise declarations as above would be my preference--and, indeed, I used them in earlier iterations--but I go back to hours-long compile times each time I've given them a try. I mean, sure, perhaps the most-recent Swift compiler is the one that'll suddenly have no issue with the above--if it is, let me know!--but, for now, I simply assume such declarations go down some pathological paths in the compiler.

What I do, instead, is "stitch everything together" in the `ExtendedSIMDScalar` protocol, itself. This approach (a) requires associated-type declarations I find *hilarious* and (b) has a non-fun cross interaction with the compiler's "redundant type constraint" pass, but...it *does* work, for, again, a definition of *work* that is compatible with "30-40 minute" compile times.

Here's one such example, reproduced *verbatim*--and in its full, uh, glory:

```swift
associatedtype Matrix4x4Storage: Matrix4x4Protocol, Passthrough, NumericAggregate, Hashable, Codable
  where
  Matrix4x4Storage.Scalar == Self,
  Matrix4x4Storage.NumericEntryRepresentation == Self,
  Matrix4x4Storage.CompatibleQuaternion == Self.QuaternionStorage,
  Matrix4x4Storage.CompatibleMatrix2x4 == Self.Matrix2x4Storage,
  Matrix4x4Storage.CompatibleMatrix4x2 == Self.Matrix4x2Storage,
  Matrix4x4Storage.CompatibleMatrix3x4 == Self.Matrix3x4Storage,
  Matrix4x4Storage.CompatibleMatrix4x3 == Self.Matrix4x3Storage,
  Matrix4x4Storage.PassthroughValue: Matrix4x4Protocol,
  Matrix4x4Storage.PassthroughValue.Scalar == Self,
  Matrix4x4Storage.PassthroughValue.CompatibleQuaternion == Self.QuaternionStorage.PassthroughValue,
  Matrix4x4Storage.PassthroughValue.CompatibleMatrix2x4 == Self.Matrix2x4Storage.PassthroughValue,
  Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x2 == Self.Matrix4x2Storage.PassthroughValue,
  Matrix4x4Storage.PassthroughValue.CompatibleMatrix3x4 == Self.Matrix3x4Storage.PassthroughValue,
  Matrix4x4Storage.PassthroughValue.CompatibleMatrix4x3 == Self.Matrix4x3Storage.PassthroughValue
```

...with the other 9 `associatedtype` declarations all very similar.

### <a name="testing">Testing</a>

This package has only very few unit tests. The primary reason is simply time--producing meaningful test examples to confirm that each combination of compatible matrices multiply-out correctly *is* rather time-intensive, after all.

The other reason is that--thankfully--the actual code consists almost-entirely of trivial forwarding logic--generally implemented *once-per-`protocol`*--together with a precise set of types. 

To elaborate on this, one set of unit tests verifies that the `rowCount` and `columnCount` values are as they should be for `MxN`. I included those tests because it's the kind of thing for which I'd expect to make a few mistakes (and indeed I did, at first, but the tests caught them).

For the actual core operations, however, I saw less need: the use of fine-grained types caught a lot of simple transposition errors like "multiplying on the left instead of the right"; the pervasive use of "once per protocol" default implmentations for the forwarding boilerplate logic also tightly-constrained the range of plausible errors.

More testing would still be beneficial--particularly for simple sanity checks and whatnot--but the situation *is* much better than the slim set of unit tests would suggest.