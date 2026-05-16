//
//  LinearCombinationMacrolet.swift
//

import SwiftSyntax

/// `linearCombination(of:weight:with:weight:)`. Half-3-row results use a
/// pure-Swift column-wise fallback rather than `simd_linear_combination`.
struct LinearCombinationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount)
            .map { "first.columns.\($0) * firstWeight + other.columns.\($0) * otherWeight" }
            .joined(separator: ",")
          + ")"
        return [
          """
          @inlinable
          public static func linearCombination(
            of first: Self,
            weight firstWeight: Scalar,
            with other: Self,
            weight otherWeight: Scalar
          ) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public static func linearCombination(
          of first: Self,
          weight firstWeight: Scalar,
          with other: Self,
          weight otherWeight: Scalar
        ) -> Self {
          simd_linear_combination(firstWeight, first, otherWeight, other)
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public static func linearCombination(
          of first: Self,
          weight firstWeight: Scalar,
          with other: Self,
          weight otherWeight: Scalar
        ) -> Self {
          Self(
            passthroughValue: \(raw: wrapped).linearCombination(
              of: first.passthroughValue,
              weight: firstWeight,
              with: other.passthroughValue,
              weight: otherWeight
            )
          )
        }
        """
      ]
    }
  }
}
