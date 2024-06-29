import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: - Subscripting Defaults
// -------------------------------------------------------------------------- //

extension MatrixProtocol {
  
  @inlinable
  public subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> Scalar {
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
  public subscript(position position: MatrixPosition) -> Scalar {
    get {
      // ///////////////////////////////////////////////////////////////////////
      assert(position.isValid)
      assert(Self.contains(position: position))
      // ///////////////////////////////////////////////////////////////////////
      return self[
        columnIndex: position.columnIndex,
        rowIndex: position.rowIndex
      ]
    }
    set {
      // ///////////////////////////////////////////////////////////////////////
      assert(position.isValid)
      assert(Self.contains(position: position))
      // ///////////////////////////////////////////////////////////////////////
      self[
        columnIndex: position.columnIndex,
        rowIndex: position.rowIndex
      ] = newValue
    }
  }
  
  @inlinable
  public subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int
  ) -> Scalar {
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
