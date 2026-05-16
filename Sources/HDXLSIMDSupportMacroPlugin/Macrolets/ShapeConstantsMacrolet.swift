//
//  ShapeConstantsMacrolet.swift
//

import SwiftSyntax

/// Emits the constant shape properties of a matrix:
///
///   - `rowCount`, `columnCount`
///   - `rowLength`, `columnLength`
///   - `scalarCount`
///   - `rowIndexRange`, `columnIndexRange`, `linearizedScalarIndexRange`
///
/// All values are derivable from the descriptor at expansion time, so we emit
/// integer literals directly instead of computed expressions.
struct ShapeConstantsMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let rowCount = descriptor.rowCount
    let columnCount = descriptor.columnCount
    let scalarCount = rowCount * columnCount
    return [
      """
      @inlinable
      public static var rowCount: Int { \(raw: rowCount) }
      """,
      """
      @inlinable
      public static var columnCount: Int { \(raw: columnCount) }
      """,
      """
      @inlinable
      public static var rowLength: Int { \(raw: columnCount) }
      """,
      """
      @inlinable
      public static var columnLength: Int { \(raw: rowCount) }
      """,
      """
      @inlinable
      public static var scalarCount: Int { \(raw: scalarCount) }
      """,
      """
      @inlinable
      public static var rowIndexRange: Range<Int> { 0..<\(raw: rowCount) }
      """,
      """
      @inlinable
      public static var columnIndexRange: Range<Int> { 0..<\(raw: columnCount) }
      """,
      """
      @inlinable
      public static var linearizedScalarIndexRange: Range<Int> { 0..<\(raw: scalarCount) }
      """
    ]
  }
}
