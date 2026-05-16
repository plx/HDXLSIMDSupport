//
//  ComponentwiseMagnitudeSquaredMacrolet.swift
//

import SwiftSyntax

/// `componentwiseMagnitudeSquared` — sum of squares of all entries.
///
/// At the native layer we emit `simd_length_squared(columns.c) + ...` because
/// that's what the simd toolkit gives us. At storage/wrapper layers we forward.
struct ComponentwiseMagnitudeSquaredMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let expression = (0..<descriptor.columnCount)
        .map { "simd_length_squared(columns.\($0))" }
        .joined(separator: " + ")
      return [
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { \(raw: expression) }
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { storage.componentwiseMagnitudeSquared }
        }
        """
      ]
    }
  }
}
