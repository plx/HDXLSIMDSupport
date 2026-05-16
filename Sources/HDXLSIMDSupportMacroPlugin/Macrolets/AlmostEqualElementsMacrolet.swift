//
//  AlmostEqualElementsMacrolet.swift
//

import SwiftSyntax

/// `hasAlmostEqualElements(to:absoluteTolerance:)` and the relative-tolerance
/// variant. Native bodies use `simd_almost_equal_elements` and
/// `simd_almost_equal_elements_relative`; storage/wrapper forward.
struct AlmostEqualElementsMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          absoluteTolerance tolerance: Scalar
        ) -> Bool {
          simd_almost_equal_elements(self, other, tolerance)
        }
        """,
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          relativeTolerance tolerance: Scalar
        ) -> Bool {
          simd_almost_equal_elements_relative(self, other, tolerance)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          absoluteTolerance tolerance: Scalar
        ) -> Bool {
          storage.hasAlmostEqualElements(to: other.storage, absoluteTolerance: tolerance)
        }
        """,
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          relativeTolerance tolerance: Scalar
        ) -> Bool {
          storage.hasAlmostEqualElements(to: other.storage, relativeTolerance: tolerance)
        }
        """
      ]
    }
  }
}
