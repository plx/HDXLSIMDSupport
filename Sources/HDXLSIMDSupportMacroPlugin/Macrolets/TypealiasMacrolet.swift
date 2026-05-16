//
//  TypealiasMacrolet.swift
//

import SwiftSyntax

/// Emits the standard MatrixProtocol typealiases:
///
///   - `Scalar`
///   - `RowVector` (= SIMD<columnCount><Scalar>)
///   - `ColumnVector` (= SIMD<rowCount><Scalar>)
///   - `DiagonalVector` (= SIMD<min(rowCount, columnCount)><Scalar>)
///   - `Rows` (tuple of rowCount-many RowVectors)
///   - `Columns` (tuple of columnCount-many ColumnVectors)
///   - `NumericEntryRepresentation` (= Scalar)
///
/// At the native layer the `Scalar` typealias usually already exists from the
/// simd overlay, so we still emit it explicitly to ensure the conformance
/// resolves identically regardless of overlay behavior.
struct TypealiasMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let scalar = context.scalarTypeName
    let rowTupleType = tupleType(arity: descriptor.rowCount, of: "RowVector")
    let columnsTupleType = tupleType(arity: descriptor.columnCount, of: "ColumnVector")
    let columnVectorSize = descriptor.rowCount
    let rowVectorSize = descriptor.columnCount
    let diagonalSize = Swift.min(descriptor.rowCount, descriptor.columnCount)

    // Note: `NumericEntryRepresentation` is emitted by `NumericAggregateMacrolet`,
    // not here, so that the typealias and the conformance method that requires
    // it stay together.
    return [
      "public typealias Scalar = \(raw: scalar)",
      "public typealias RowVector = SIMD\(raw: rowVectorSize)<\(raw: scalar)>",
      "public typealias ColumnVector = SIMD\(raw: columnVectorSize)<\(raw: scalar)>",
      "public typealias DiagonalVector = SIMD\(raw: diagonalSize)<\(raw: scalar)>",
      "public typealias Rows = \(raw: rowTupleType)",
      "public typealias Columns = \(raw: columnsTupleType)"
    ]
  }

  private func tupleType(arity: Int, of element: String) -> String {
    "(\(Array(repeating: element, count: arity).joined(separator: ",")))"
  }
}
