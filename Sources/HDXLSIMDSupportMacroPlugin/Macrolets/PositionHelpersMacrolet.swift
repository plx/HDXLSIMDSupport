//
//  PositionHelpersMacrolet.swift
//

import SwiftSyntax

/// Emits the position / linearized-scalar-index helpers. These are all derived
/// from the descriptor's shape, with deterministic linearization order:
///
///   linearizedIndex(columnIndex c, rowIndex r) = c * columnLength + r
///
/// (i.e. column-major). This is the convention used by `simd_floatNxM`, where
/// `columns.c[r]` and `linearizedScalars[c * columnLength + r]` align.
struct PositionHelpersMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let columnLength = descriptor.rowCount  // length of one column = number of rows
    let columnCount = descriptor.columnCount
    let rowCount = descriptor.rowCount

    return [
      """
      @inlinable
      public static func linearizedScalarIndex(
        forColumnIndex columnIndex: Int,
        rowIndex: Int
      ) -> Int {
        return (columnIndex * \(raw: columnLength)) + rowIndex
      }
      """,
      """
      @inlinable
      public static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int, Int) {
        return (
          linearizedScalarIndex / \(raw: columnLength),
          linearizedScalarIndex % \(raw: columnLength)
        )
      }
      """,
      """
      @inlinable
      public static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
        return linearizedScalarIndex(
          forColumnIndex: matrixPosition.columnIndex,
          rowIndex: matrixPosition.rowIndex
        )
      }
      """,
      """
      @inlinable
      public static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition {
        let (column, row) = columnRowIndex(forLinearizedScalarIndex: linearizedScalarIndex)
        return MatrixPosition(rowIndex: row, columnIndex: column)
      }
      """,
      // Computed (not stored) because static stored properties aren't allowed
      // in generic types (the wrapper `Matrix2x2<Scalar>` is generic). The
      // array is small (≤16 entries) so the per-call cost is negligible.
      """
      @inlinable
      public static var matrixPositions: [MatrixPosition] {
        var result: [MatrixPosition] = []
        result.reserveCapacity(\(raw: columnCount * rowCount))
        for columnIndex in 0..<\(raw: columnCount) {
          for rowIndex in 0..<\(raw: rowCount) {
            result.append(MatrixPosition(rowIndex: rowIndex, columnIndex: columnIndex))
          }
        }
        return result
      }
      """,
      """
      @inlinable
      public static func columnVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [ColumnVector] {
        precondition(linearizedScalars.count == scalarCount)
        return (0..<\(raw: columnCount)).map { columnIndex in
          let lowerBound = columnIndex * \(raw: columnLength)
          let upperBound = lowerBound + \(raw: columnLength)
          return ColumnVector(linearizedScalars[lowerBound..<upperBound])
        }
      }
      """,
      """
      @inlinable
      public static func rowVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [RowVector] {
        precondition(linearizedScalars.count == scalarCount)
        return (0..<\(raw: rowCount)).map { rowIndex in
          var values: [Scalar] = []
          values.reserveCapacity(\(raw: columnCount))
          for columnIndex in 0..<\(raw: columnCount) {
            values.append(linearizedScalars[columnIndex * \(raw: columnLength) + rowIndex])
          }
          return RowVector(values)
        }
      }
      """
    ]
  }
}
