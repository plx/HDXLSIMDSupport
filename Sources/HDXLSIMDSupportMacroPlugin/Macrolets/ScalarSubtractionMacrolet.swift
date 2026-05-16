//
//  ScalarSubtractionMacrolet.swift
//

import SwiftSyntax

/// Subtracts a scalar from every entry.
struct ScalarSubtractionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let shifted = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) - scalar" }.joined(separator: ",")
        + ")"
      let formStmts = (0..<descriptor.columnCount)
        .map { "columns.\($0) -= scalar" }
        .joined(separator: "\n")
      return [
        """
        @inlinable
        public func subtracting(scalar: Scalar) -> Self {
          Self(columns: \(raw: shifted))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(ofScalar scalar: Scalar) {
          \(raw: formStmts)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func subtracting(scalar: Scalar) -> Self {
          Self(storage: storage.subtracting(scalar: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(ofScalar scalar: Scalar) {
          storage.formSubtraction(ofScalar: scalar)
        }
        """
      ]
    }
  }
}
