//
//  simd_quath+Equatable.swift
//

import Foundation
import simd

// `simd_quatf` and `simd_quatd` are `Equatable` via the Swift overlay; the
// half-precision variant is not yet bridged that way as of macOS 26. The
// macro-generated `==` on `HalfQuaternionStorage` forwards to the native
// `simd_quath` value, which needs a usable `==` to exist; we add the explicit
// conformance here so `HalfQuaternionStorage` has the same shape as
// `FloatQuaternionStorage` / `DoubleQuaternionStorage`. If/when the Swift
// overlay bridges this itself, this can be removed.

extension simd_quath : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_quath, rhs: simd_quath) -> Bool {
    return lhs.vector == rhs.vector
  }
}
