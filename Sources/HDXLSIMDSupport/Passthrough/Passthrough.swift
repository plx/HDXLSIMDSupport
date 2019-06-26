//
//  Passthrough.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// `Passthrough` is for adoption by types that (a) wrap a single underlying value and (b) largely "pass through"
/// their calls to that wrapped, underlying value. In other words, for example, `DoubleMatrix4x4Storage`
/// (a) is *just* a wrapper around a `simd_double4x4` and (b)  where `DoubleMatrix4x4Storage`
/// has identical functionality to `simd_double4x4` it implements said functionality by passing the calls
/// through to the underlying `simd_double4x4`.
///
/// `Passthrough` conformers *may also* add additional functionality above-and-beyond that offered by
/// the base type—e.g. `DoubleMatrix4x4Storage` adds `Hashable` and `Codable` conformances,,
/// neither of which is offere by `simd_double4x4`—but that doesn't change the basic statement: *where*
/// the passthrough and the passthrough value have equivalent functionality, the *expectation* is that the
/// passthrough will, indeed, implement that functionality by (trivially) passing-through to the passthrough value.
///
/// This protocol exists because we have a 3-layer structure: a `Matrix4x4<Scalar>`  is backed
/// by `Scalar.Matrix4x4Storage`, which, in turn, is backed-by `simd_${SCALAR}4x4`. For the
/// common functionality the matrix should just forward to the storage, and the storage just forward to the
/// native SIMD type—with as little *manual* forwarding as possible.
///
/// Enter `Passthrough`: we can write things like `extension Passthrough where PassthroughValue:Matrix4x4`,
/// within-which we hand-write the necessary forwarding exactly once; as long as we get `simd_double4x4`, etc.,
/// to conform to the appropriate protocols then the higher-level `Passthrough` wrappers gain forwarding calls "for free".
///
/// In a lanugage with higher-kinded types I suspect this rigamarole would be mostly-unnecessary, but this
/// is Swift, so I worked with what was available.
///
public protocol Passthrough {
  
  /// The underlying, wrapped type.
  associatedtype PassthroughValue

  /// Directly get-and-set the underlying value.
  ///
  /// To *properly* conform to `Passthrough` this should either (a) be the only stored property or perhaps
  /// there should only be a single underlying value that this transparently exposes (e.g. by exposing it wrapped in
  /// an invariant-enforcing struct of some kind, I suppose).
  ///
  /// - note: How conformers handle this vis-a-vis maintaining expected invariants is ¯\(°_o)/¯ (they generally...don't).
  ///
  var passthroughValue: PassthroughValue { get set }
  
  /// Initalize a value directly from the underlying passthrough value.
  ///
  /// - note: How conformers handle this vis-a-vis maintaining expected invariants is ¯\(°_o)/¯ (they generally...don't).
  ///
  init(passthroughValue: PassthroughValue)
  
}
