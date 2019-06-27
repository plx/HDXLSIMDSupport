//
//  MatrixDefaultSupportProtocol+PositioningDefaults.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Positioning Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol {
  
  /// `true` iff `position` corresponds to a subscriptable position within matrices of this type.
  @inlinable
  static func contains(position: MatrixPosition) -> Bool {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(position.isValid)
    // /////////////////////////////////////////////////////////////////////////
    guard
      Self.rowIndexRange.contains(position.rowIndex),
      Self.columnIndexRange.contains(position.columnIndex) else {
        return false
    }
    return true
  }
  
  /// Library-internal tool to let us build our per-type, canonical matrix-position list.
  @usableFromInline
  internal static func prepareMatrixPositionList() -> [MatrixPosition] {
    return self.linearizedScalarIndexRange.map() {
      Self.matrixPosition(
        forLinearizedScalarIndex: $0
      )
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Positioning Defaults
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol {
  
  @inlinable
  static func linearizedScalarIndex(
    forColumnIndex columnIndex: Int,
    rowIndex: Int) -> Int {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(Self.columnIndexRange.contains(columnIndex))
    pedantic_assert(Self.rowIndexRange.contains(rowIndex))
    // /////////////////////////////////////////////////////////////////////////
    return (rowIndex * Self.rowLength) + columnIndex
  }
  
  @inlinable
  static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int,Int) {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(Self.linearizedScalarIndexRange.contains(linearizedScalarIndex))
    // /////////////////////////////////////////////////////////////////////////
    let result = linearizedScalarIndex.quotientAndRemainder(dividingBy: Self.rowLength)
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(Self.rowIndexRange.contains(result.quotient))
    pedantic_assert(Self.columnIndexRange.contains(result.remainder))
    // /////////////////////////////////////////////////////////////////////////
    return (
      result.remainder,
      result.quotient
    )
  }

  @inlinable
  static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(matrixPosition.isValid)
    pedantic_assert(Self.contains(position: matrixPosition))
    // /////////////////////////////////////////////////////////////////////////
    return self.linearizedScalarIndex(
      forColumnIndex: matrixPosition.columnIndex,
      rowIndex: matrixPosition.rowIndex
    )
  }

  @inlinable
  static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(Self.linearizedScalarIndexRange.contains(linearizedScalarIndex))
    // /////////////////////////////////////////////////////////////////////////
    let (columnIndex, rowIndex) = self.columnRowIndex(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
    return MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }

}
