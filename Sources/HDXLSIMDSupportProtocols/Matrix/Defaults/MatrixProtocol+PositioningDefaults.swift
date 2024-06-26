import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Positioning Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol {
  
  /// `true` iff `position` corresponds to a subscriptable position within matrices of this type.
  @inlinable
  public static func contains(position: MatrixPosition) -> Bool {
    // /////////////////////////////////////////////////////////////////////////
    assert(position.isValid)
    // /////////////////////////////////////////////////////////////////////////
    guard
      rowIndexRange.contains(position.rowIndex),
      columnIndexRange.contains(position.columnIndex)
    else {
      return false
    }
    return true
  }
  
  /// Library-internal tool to let us build our per-type, canonical matrix-position list.
  @usableFromInline
  package static func prepareMatrixPositionList() -> [MatrixPosition] {
    linearizedScalarIndexRange.map() {
      matrixPosition(
        forLinearizedScalarIndex: $0
      )
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Positioning Defaults
// -------------------------------------------------------------------------- //

extension MatrixProtocol {
  
  @inlinable
  public static func linearizedScalarIndex(
    forColumnIndex columnIndex: Int,
    rowIndex: Int
  ) -> Int {
    // /////////////////////////////////////////////////////////////////////////
    assert(columnIndexRange.contains(columnIndex))
    assert(rowIndexRange.contains(rowIndex))
    // /////////////////////////////////////////////////////////////////////////
    return (rowIndex * rowLength) + columnIndex
  }
  
  @inlinable
  public static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int,Int) {
    // /////////////////////////////////////////////////////////////////////////
    assert(linearizedScalarIndexRange.contains(linearizedScalarIndex))
    // /////////////////////////////////////////////////////////////////////////
    let result = linearizedScalarIndex.quotientAndRemainder(dividingBy: rowLength)
    // /////////////////////////////////////////////////////////////////////////
    assert(rowIndexRange.contains(result.quotient))
    assert(columnIndexRange.contains(result.remainder))
    // /////////////////////////////////////////////////////////////////////////
    return (
      result.remainder,
      result.quotient
    )
  }

  @inlinable
  public static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    // /////////////////////////////////////////////////////////////////////////
    assert(matrixPosition.isValid)
    assert(contains(position: matrixPosition))
    // /////////////////////////////////////////////////////////////////////////
    return linearizedScalarIndex(
      forColumnIndex: matrixPosition.columnIndex,
      rowIndex: matrixPosition.rowIndex
    )
  }

  @inlinable
  public static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition {
    // /////////////////////////////////////////////////////////////////////////
    assert(linearizedScalarIndexRange.contains(linearizedScalarIndex))
    // /////////////////////////////////////////////////////////////////////////
    let (columnIndex, rowIndex) = columnRowIndex(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
    return MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }

}
