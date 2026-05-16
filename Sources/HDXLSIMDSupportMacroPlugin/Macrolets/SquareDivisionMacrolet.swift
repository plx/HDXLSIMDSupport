//
//  SquareDivisionMacrolet.swift
//

import SwiftSyntax

/// Square self-division operations from `MatrixNxNProtocol`.
///
/// For half representation we go through the protocol-level
/// `multiplied(onRightBy:)` / `inverted()` helpers rather than `*` and
/// `.inverse`, because (a) `*` doesn't exist on `simd_halfNxM`, and
/// (b) `simd_inverse(simd_half3x3)` is miscomputed.
struct SquareDivisionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        return [
          """
          @inlinable
          public func divided(onRightBy rhs: Self) -> Self {
            multiplied(onRightBy: rhs.inverted())
          }
          """,
          """
          @inlinable
          public func divided(onLeftBy lhs: Self) -> Self {
            multiplied(onLeftBy: lhs.inverted())
          }
          """,
          """
          @inlinable
          public mutating func formDivision(onRightBy rhs: Self) {
            self = divided(onRightBy: rhs)
          }
          """,
          """
          @inlinable
          public mutating func formDivision(onLeftBy lhs: Self) {
            self = divided(onLeftBy: lhs)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func divided(onRightBy rhs: Self) -> Self { self * rhs.inverse }
        """,
        """
        @inlinable
        public func divided(onLeftBy lhs: Self) -> Self { lhs.inverse * self }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy rhs: Self) {
          self = self * rhs.inverse
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy lhs: Self) {
          self = lhs.inverse * self
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func divided(onRightBy rhs: Self) -> Self {
          Self(storage: storage.divided(onRightBy: rhs.storage))
        }
        """,
        """
        @inlinable
        public func divided(onLeftBy lhs: Self) -> Self {
          Self(storage: storage.divided(onLeftBy: lhs.storage))
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onRightBy rhs: Self) {
          storage.formDivision(onRightBy: rhs.storage)
        }
        """,
        """
        @inlinable
        public mutating func formDivision(onLeftBy lhs: Self) {
          storage.formDivision(onLeftBy: lhs.storage)
        }
        """
      ]
    }
  }
}
