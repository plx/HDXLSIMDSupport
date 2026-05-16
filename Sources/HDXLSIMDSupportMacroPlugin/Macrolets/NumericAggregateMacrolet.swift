//
//  NumericAggregateMacrolet.swift
//

import SwiftSyntax

/// `NumericAggregate` conformance — the `allNumericEntriesSatisfy(_:)` method
/// is the single protocol requirement, and the typealias for
/// `NumericEntryRepresentation` is already emitted by `TypealiasMacrolet`.
///
/// At the native layer we iterate over each column-vector (each SIMD vector
/// itself conforms to NumericAggregate via the existing extension). At the
/// passthroughValue / wrapper layers we forward.
struct NumericAggregateMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let typealiasDecl: DeclSyntax = "public typealias NumericEntryRepresentation = \(raw: context.scalarTypeName)"
    switch context.layer {
    case .native:
      let checks = (0..<descriptor.columnCount)
        .map { "columns.\($0).allNumericEntriesSatisfy(predicate)" }
        .joined(separator: " && ")
      return [
        typealiasDecl,
        """
        @inlinable
        public func allNumericEntriesSatisfy(
          _ predicate: (NumericEntryRepresentation) -> Bool
        ) -> Bool {
          \(raw: checks)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        typealiasDecl,
        """
        @inlinable
        public func allNumericEntriesSatisfy(
          _ predicate: (NumericEntryRepresentation) -> Bool
        ) -> Bool {
          passthroughValue.allNumericEntriesSatisfy(predicate)
        }
        """
      ]
    }
  }
}
