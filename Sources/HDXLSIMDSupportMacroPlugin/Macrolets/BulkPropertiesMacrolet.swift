//
//  BulkPropertiesMacrolet.swift
//

import SwiftSyntax

/// Emits the bulk-access properties from MatrixProtocol:
///
///   - `var columns: Columns { get set }`
///   - `var rows: Rows { get }` (computed; rebuilds row vectors per access)
///   - `var columnVectors: [ColumnVector] { get }`
///   - `var rowVectors: [RowVector] { get }`
///   - `var linearizedScalars: [Scalar] { get }`
struct BulkPropertiesMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    result.append(contentsOf: columnsProperty(in: context))
    result.append(contentsOf: rowsProperty(in: context))
    result.append(contentsOf: columnVectorsProperty(in: context))
    result.append(contentsOf: rowVectorsProperty(in: context))
    result.append(contentsOf: linearizedScalarsProperty(in: context))
    return result
  }

  // MARK: - var columns

  private func columnsProperty(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // simd_floatNxM already exposes `columns: T<columnCount>` natively.
      return []
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public var columns: Columns {
          get { storage.columns }
          set { storage.columns = newValue }
          _modify { yield &storage.columns }
        }
        """
      ]
    }
  }

  // MARK: - var rows

  private func rowsProperty(in context: MatrixLayerContext) -> [DeclSyntax] {
    let rowsTupleElements = (0..<descriptor.rowCount)
      .map { rowIndex in
        let entries = (0..<descriptor.columnCount).map { c in "columns.\(c)[\(rowIndex)]" }.joined(separator: ",")
        return "RowVector(\(entries))"
      }
      .joined(separator: ", ")
    return [
      """
      @inlinable
      public var rows: Rows {
        get { (\(raw: rowsTupleElements)) }
      }
      """
    ]
  }

  // MARK: - var columnVectors

  private func columnVectorsProperty(in context: MatrixLayerContext) -> [DeclSyntax] {
    let arrayLiteral = "[" + (0..<descriptor.columnCount).map { "columns.\($0)" }.joined(separator: ",") + "]"
    return [
      """
      @inlinable
      public var columnVectors: [ColumnVector] {
        get { \(raw: arrayLiteral) }
      }
      """
    ]
  }

  // MARK: - var rowVectors

  private func rowVectorsProperty(in context: MatrixLayerContext) -> [DeclSyntax] {
    let arrayLiteral: String = {
      let parts = (0..<descriptor.rowCount).map { r -> String in
        let entries = (0..<descriptor.columnCount).map { c in "columns.\(c)[\(r)]" }.joined(separator: ",")
        return "RowVector(\(entries))"
      }
      return "[" + parts.joined(separator: ",") + "]"
    }()
    return [
      """
      @inlinable
      public var rowVectors: [RowVector] {
        get { \(raw: arrayLiteral) }
      }
      """
    ]
  }

  // MARK: - var linearizedScalars

  private func linearizedScalarsProperty(in context: MatrixLayerContext) -> [DeclSyntax] {
    // Column-major scalar list.
    let scalarParts = (0..<descriptor.columnCount).flatMap { c in
      (0..<descriptor.rowCount).map { r in "columns.\(c)[\(r)]" }
    }
    let arrayLiteral = "[" + scalarParts.joined(separator: ",") + "]"
    return [
      """
      @inlinable
      public var linearizedScalars: [Scalar] {
        get { \(raw: arrayLiteral) }
      }
      """
    ]
  }
}
