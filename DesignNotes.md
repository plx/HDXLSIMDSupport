# Design Notes: MatrixMxN & Quaternion

This package provides (a) a quaternion type written as `Quaternion<T>` and (b) a family of matrix types written like `Matrix4x4<T>`, `Matrix4x3<T>`, and so on.
  
I wrote these mostly to figure out the implementation of Apple's Swift API for `simd`, which now includes types writable as `SIMD2<Float>`, `SIMD3<Double>`, and so on and so forth. The implementation is non-obvious due to the underlying types being concrete types--`double2` and not `simd_vector2<Double>`, essentially--but easy to piece together.
  
To make a long story short, the basic pattern to get to `Matrix4x4<T>` can be *paraphrased* like so:

```swift
/// Concrete *storage type* for a 4x4 matrix with `Double` as scalar.
/// Will mostly *forward* inits, math ops, etc., to the underlying SIMD type.
struct Double4x4 {
  var storage: double4x4
  init(storage: double4x4)
}

protocol Matrix4x4Capable {
  associatedtype Matrix4x4Storage 
}

/// Generic *user-facing* type for a 4x4 matrix, accepting a generic `Scalar`
/// parameter. Will also need to *forward* inits, math ops, etc., to the
/// underlying storage type (which, itself, *forwards*, and so on).
struct Matrix4x4<Scalar:Matrix4x4Capable> {
  var storage: Scalar.Storage
  init(storage: Scalar.Storage)
}

extension Double : Matrix4x4Capable {
  typealias Matrix4x4Storage = Double4x4
}
```

...where I've omitted a lot of detail, constraints on associated types, and so on and so forth. On paper there's a ton of wrapping-and-apparent-indirection involved, in practice the hope would be you slap `@inlinable` and `@usableFromInline` on everything and pray that all the wrapping/indirection "boils off" at compile time.

In theory the above is sub-optimal insofar as there's not really a *type-level* way to *truly* guarantee that `Matrix4x4Storage` is actually 4x4 and not, say, 3x2 or 3x4; this seems vanishingly-unlikely to be an issue in practice, however, and falls into the risks I don't think are worth considering. In any case, I don't think the above recipe can be simplified at this time, due to (a) the limitations of Swift's type system and (b) the concrete, non-generic nature of the underlying SIMD types.

Where the design space has more flexibility is in the forwarding: via clever protocol definition and clever use of protocol extensions one could *conceivably* cut down on the amount of method-forwarding boilerplate. 

Apple's `SIMDStorage` protocol is very minimal and so I don't know how they're doing what they do. 

In my case I define a much heavier storage type--really a *family* thereof for the matrices--that includes all the mathematical requirements, inits, and so on on the *storage*; I then define a parallel set of matrix protocols that (a) expect to be backed-by an equivalent storage type and (b) include protocol extensions that handle the forwarding.

For example, what I did can be *paraphrased* like so:

```swift
protocol SIMDMatrixStorageProtocol {
  /// Define addition on the *storage*.
  static func + (lhs: Self, rhs: Self) -> Self
}

protocol SIMDMatrixProtocol {  
  associatedtype Storage: SIMDMatrixStorageProtocol  
  var storage: Storage {get set }  
  init(storage: Storage)
  // note: no math operations here!  
}

extension SIMDMatrixProtocol {
  
  /// Boilerplate forwarding addition to underlying storage.
  @inlinable
  static func + (lhs: Self, rhs: Self) -> Self {
    return Self(
      storage: Storage(
        lhs.storage + rhs.storage
      )
    )
  }
} 
```

...which I mostly use to need to clone that boilerplate on my public-facing matrix and quaternion types: they conform to the appropriate non-storage protocols, are "trivial" wrappers around the underlying `Storage`, and all their requirements are forwarded (or as close to that as achievable).

My only question, for now, is if it's necessary to include the mathematical operations within the non-storage protocols for some performance reason; I have a nasty feeling this may be the case, actually, and to be "safe" I'll probably wind up doing a third parallel hierarchy with just the appropriate math ops.

Note that as long as the final, concrete types pick up their implementations automatically--e.g. by the combination of default implementations they obtain--then it should be "easy" to adopt that third hierarchy of "Matrix Math Operations" if I decide to do so.