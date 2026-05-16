//
//  HashableMacrolet.swift
//

import SwiftSyntax

/// `hash(into:)` — hashes one column-vector at a time (column-vector SIMD types
/// are themselves Hashable). Native simd matrix types don't conform to
/// Hashable, so this is only emitted at storage / wrapper layers.
///
/// We also emit `==` for storage/wrapper, because Equatable requires it and
/// the synthesized `==` from the compiler wouldn't see our `storage` property
/// after the macro adds it.
struct HashableMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage, .wrapper:
      let hashStatements = (0..<descriptor.columnCount)
        .map { "columns.\($0).hash(into: &hasher)" }
        .joined(separator: "\n")
      let equalityExpression = (0..<descriptor.columnCount)
        .map { "lhs.columns.\($0) == rhs.columns.\($0)" }
        .joined(separator: " && ")
      return [
        """
        @inlinable
        public func hash(into hasher: inout Hasher) {
          \(raw: hashStatements)
        }
        """,
        """
        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
          \(raw: equalityExpression)
        }
        """
      ]
    }
  }
}
