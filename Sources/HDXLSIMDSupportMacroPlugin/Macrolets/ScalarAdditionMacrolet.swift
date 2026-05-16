//
//  ScalarAdditionMacrolet.swift
//

import SwiftSyntax

/// Adds a scalar to every entry: `adding(scalar:)` and `formAddition(ofScalar:)`.
///
/// - Native: builds a fresh column-tuple where each column is shifted by the
///   scalar (SIMD vectors support `vec + scalar`).
/// - Storage/Wrapper: forwards.
struct ScalarAdditionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let shiftedColumnsTuple = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) &+ scalar" }
          .joined(separator: ",")
        + ")"
      // SIMD doesn't have &+ for floating point — use plain `+`. Adjusting:
      let plus = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) + scalar" }
          .joined(separator: ",")
        + ")"
      _ = shiftedColumnsTuple
      let formStmts = (0..<descriptor.columnCount)
        .map { "columns.\($0) += scalar" }
        .joined(separator: "\n")
      return [
        """
        @inlinable
        public func adding(scalar: Scalar) -> Self {
          Self(columns: \(raw: plus))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(ofScalar scalar: Scalar) {
          \(raw: formStmts)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func adding(scalar: Scalar) -> Self {
          Self(storage: storage.adding(scalar: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(ofScalar scalar: Scalar) {
          storage.formAddition(ofScalar: scalar)
        }
        """
      ]
    }
  }
}
