//
//  QuaternionConstructorMacrolet.swift
//

import SwiftSyntax

/// `init(quaternion: CompatibleQuaternion)` — only required by
/// `Matrix3x3Protocol` and `Matrix4x4Protocol`.
///
/// - Native: bridges via the simd overlay's `init(_ quaternion:)`. For
///   `simd_half3x3` specifically the overlay's `simd_matrix3x3(quath)` is
///   miscomputed, so we route via `simd_matrix4x4(quaternion)` and slice the
///   top-left 3x3 out by hand.
/// - Storage/Wrapper: forwards down the storage chain.
struct QuaternionConstructorMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare, descriptor.rowCount == 3 || descriptor.rowCount == 4 else {
      return []
    }
    switch context.layer {
    case .native:
      // ONLY simd_half3x3 needs the 4x4-and-slice workaround. simd_half4x4
      // is fine — `simd_matrix4x4(quaternion)` works and the 4x4 result
      // doesn't cross the broken half-3-row bridge.
      if descriptor.representation == .half && descriptor.rowCount == 3 {
        return [
          """
          @inlinable
          public init(quaternion: CompatibleQuaternion) {
            let m4 = simd_matrix4x4(quaternion)
            self.init(
              columns: (
                SIMD3<Scalar>(m4.columns.0.x, m4.columns.0.y, m4.columns.0.z),
                SIMD3<Scalar>(m4.columns.1.x, m4.columns.1.y, m4.columns.1.z),
                SIMD3<Scalar>(m4.columns.2.x, m4.columns.2.y, m4.columns.2.z)
              )
            )
          }
          """
        ]
      }
      if descriptor.representation == .half {
        // simd_half4x4: simd_matrix4x4 returns the right shape directly.
        return [
          """
          @inlinable
          public init(quaternion: CompatibleQuaternion) {
            self = simd_matrix4x4(quaternion)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public init(quaternion: CompatibleQuaternion) {
          self.init(quaternion)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public init(quaternion: CompatibleQuaternion) {
          self.init(storage: Storage(quaternion: quaternion.storage))
        }
        """
      ]
    }
  }
}
