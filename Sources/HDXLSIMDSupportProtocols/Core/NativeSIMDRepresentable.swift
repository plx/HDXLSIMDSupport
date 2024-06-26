import Foundation
import simd

/// Protocol for types ultimately backed-by some system-provided "native SIMD type".
///
/// Exists as both (a) an "escape hatch"—advanced SIMD operations can operate on the underlying type
/// without the wrapper layers needing to know—and also (b) as a way to "hide" the "Storage" type in our
/// 3-level system of "Type->Storage->SIMD".
///
/// In earlier drafts this protocol did more work than it does now and I used it in ways that overlapped with the
/// `Passthrough` protocol, but in the interest of sane compilation times it's now a minimal, "just in case"
/// thing; the only reason it *didn't* get eliminated is due to my wanting to hide the "Storage" layer in the
/// `description` and `debugDescription` implementations for quaternions and matrices.
/// 
package protocol NativeSIMDRepresentable<NativeSIMDRepresentation> {
  
  /// The type of underlying native-SIMD value.
  ///
  /// - note: Kept as an unconstrained typealias for now, but if Apple adds a `SIMD`-esque protocol that also holds for quaternions and matrices should revisit that.
  associatedtype NativeSIMDRepresentation
  
  /// Directly get-or-set the underying native-SIMD representation.
  var nativeSIMDRepresentation: NativeSIMDRepresentation { get set }
  
  /// Directly construct a value from the underlying native-SIMD representation.
  init(nativeSIMDRepresentation: NativeSIMDRepresentation)
  
}
