//
//  NativeSIMDRepresentable.swift
//

import Foundation
import simd

/// Protocol for types ultimately backed-by some system-provided "native SIMD type".
///
/// Exists as both (a) an "escape hatch"—advanced SIMD operations can operate on the underlying type
/// without the wrapper layers needing to know—and also (b) as a way to "hide" the "Storage" type in our
/// 3-level system of "Type->Storage->SIMD".
///
/// The protocol is intentionally minimal; its raison d'être is mostly so the macro-generated
/// `description` / `debugDescription` implementations for quaternions and matrices can defer to the
/// underlying native SIMD value without leaking the intermediate `Storage` layer into user-facing output.
///
public protocol NativeSIMDRepresentable<NativeSIMDRepresentation> {
  
  /// The type of underlying native-SIMD value.
  ///
  /// - note: Kept as an unconstrained typealias for now, but if Apple adds a `SIMD`-esque protocol that also holds for quaternions and matrices should revisit that.
  associatedtype NativeSIMDRepresentation
  
  /// Directly get-or-set the underying native-SIMD representation.
  var nativeSIMDRepresentation: NativeSIMDRepresentation { get set }
  
  /// Directly construct a value from the underlying native-SIMD representation.
  init(nativeSIMDRepresentation: NativeSIMDRepresentation)
  
}
