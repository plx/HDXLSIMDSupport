//
//  MatrixProtocol+ScalarSubscriptingDefaults.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: MatrixDefaultSupportProtocol - Subscripting Defaults
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol {
  
  @inlinable
  subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> Scalar {
    get {
      return self[
        position: Self.matrixPosition(
          forLinearizedScalarIndex: linearizedScalarIndex
        )
      ]
    }
    set {
      self[
        position: Self.matrixPosition(
          forLinearizedScalarIndex: linearizedScalarIndex
        )
      ] = newValue
    }
  }

  @inlinable
  subscript(position position: MatrixPosition) -> Scalar {
    get {
      // ///////////////////////////////////////////////////////////////////////
      pedantic_assert(position.isValid)
      pedantic_assert(Self.contains(position: position))
      // ///////////////////////////////////////////////////////////////////////
      return self[
        columnIndex: position.columnIndex,
        rowIndex: position.rowIndex
      ]
    }
    set {
      // ///////////////////////////////////////////////////////////////////////
      pedantic_assert(position.isValid)
      pedantic_assert(Self.contains(position: position))
      // ///////////////////////////////////////////////////////////////////////
      self[
        columnIndex: position.columnIndex,
        rowIndex: position.rowIndex
      ] = newValue
    }
  }
  
  @inlinable
  subscript(columnIndex columnIndex: Int, rowIndex rowIndex: Int) -> Scalar {
    get {
      precondition(Self.columnIndexRange.contains(columnIndex))
      precondition(Self.rowIndexRange.contains(rowIndex))
      return self[columnIndex: columnIndex][rowIndex]
    }
    set {
      precondition(Self.columnIndexRange.contains(columnIndex))
      precondition(Self.rowIndexRange.contains(rowIndex))
      self[columnIndex: columnIndex][rowIndex] = newValue
    }
  }

}
