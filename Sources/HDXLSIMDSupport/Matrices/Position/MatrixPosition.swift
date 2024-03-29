//
//  MatrixPosition.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Definition
// -------------------------------------------------------------------------- //

/// Struct specifically for indicating row-index, column-index pairs.
public struct MatrixPosition {
  
  /// The *row index* (e.g. the "y-axis coordinate").
  public var rowIndex: Int
  
  /// The *column index* (e.g. the "y-axis coordinate").
  public var columnIndex: Int
  
  /// "Designated initializer" for `MatrixPosition`.
  ///
  /// - parameter rowIndex: The index for a row (e.g. the "y-axis coordinate").
  /// - parameter columnIndex: The index for a column (e.g. the "x-axis coordinate").
  ///
  /// - returns: The requested `MatrixPosition`
  ///
  /// - precondition: `rowIndex >= 0`
  /// - precondition: `columnIndex >= 0`
  ///
  @inlinable
  public init(
    rowIndex: Int,
    columnIndex: Int
  ) {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(rowIndex >= 0)
    pedantic_assert(columnIndex >= 0)
    defer { pedantic_assert(isValid) }
    // /////////////////////////////////////////////////////////////////////////
    self.rowIndex = rowIndex
    self.columnIndex = columnIndex
  }

}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Diagonal
// -------------------------------------------------------------------------- //

public extension MatrixPosition {
  
  /// `true` iff the position if *on* the diagonal.
  @inlinable
  var isOnDiagonal: Bool {
    get {
      return rowIndex == columnIndex
    }
  }
  
  /// `true` iff the position if *off* the diagonal.
  @inlinable
  var isOffDiagonal: Bool {
    get {
      return rowIndex != columnIndex
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Tranposition
// -------------------------------------------------------------------------- //

public extension MatrixPosition {
  
  /// Returns a position with swapped row-and-column indices.
  @inlinable
  func transposed() -> MatrixPosition {
    return MatrixPosition(
      rowIndex: columnIndex,
      columnIndex: rowIndex
    )
  }
  
  /// In-place swaps the row and column indices.
  @inlinable
  mutating func formTranspose() {
    swap(
      &rowIndex,
      &columnIndex
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - With
// -------------------------------------------------------------------------- //

public extension MatrixPosition {
  
  /// Obtain a `MatrixPosition` replacing `self.rowIndex` with `rowIndex`.
  @inlinable
  func with(rowIndex: Int) -> MatrixPosition {
    return MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }
  
  /// Obtain a `MatrixPosition` replacing `self.columnIndex` with `columnIndex`.
  @inlinable
  func with(columnIndex: Int) -> MatrixPosition {
    return MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }
  
}


// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Validatable
// -------------------------------------------------------------------------- //

extension MatrixPosition {
  
  @inlinable
  public var isValid: Bool {
    get {
      guard
        rowIndex >= 0,
        columnIndex >= 0
      else {
          return false
      }
      return true
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Equatable
// -------------------------------------------------------------------------- //

extension MatrixPosition : Equatable {
  
  @inlinable
  public static func == (
    lhs: MatrixPosition,
    rhs: MatrixPosition
  ) -> Bool {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(lhs.isValid)
    pedantic_assert(rhs.isValid)
    // /////////////////////////////////////////////////////////////////////////
    guard
      lhs.rowIndex == rhs.rowIndex,
      lhs.columnIndex == rhs.columnIndex else {
        return false
    }
    return true
  }
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Hashable
// -------------------------------------------------------------------------- //

extension MatrixPosition : Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    rowIndex.hash(into: &hasher)
    columnIndex.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension MatrixPosition : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      return "(rowIndex: \(rowIndex), columnIndex: \(columnIndex))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension MatrixPosition : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      return "MatrixPosition(rowIndex: \(rowIndex), columnIndex: \(columnIndex))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixPosition - Codable
// -------------------------------------------------------------------------- //

extension MatrixPosition : Codable {
  
  // synthesized ok
  
}
