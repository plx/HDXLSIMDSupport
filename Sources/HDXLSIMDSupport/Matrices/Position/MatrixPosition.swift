import Foundation
import simd

// MARK: MatrixPosition

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

// MARK: - Synthesized Conformances

extension MatrixPosition: Sendable { }
extension MatrixPosition: Equatable { }
extension MatrixPosition: Hashable { }
extension MatrixPosition: Codable { }

// MARK: - CustomStringConvertible

extension MatrixPosition : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      return "(rowIndex: \(rowIndex), columnIndex: \(columnIndex))"
    }
  }
  
}

// MARK: - CustomDebugStringConvertible

extension MatrixPosition : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      return "MatrixPosition(rowIndex: \(rowIndex), columnIndex: \(columnIndex))"
    }
  }
  
}

// MARK: - Diagonal

extension MatrixPosition {
  
  /// `true` iff the position if *on* the diagonal.
  @inlinable
  public var isOnDiagonal: Bool {
    rowIndex == columnIndex
  }
  
  /// `true` iff the position if *off* the diagonal.
  @inlinable
  public var isOffDiagonal: Bool {
    rowIndex != columnIndex
  }
  
}

// MARK: - Tranposition

extension MatrixPosition {
  
  /// Returns a position with swapped row-and-column indices.
  @inlinable
  public func transposed() -> MatrixPosition {
    MatrixPosition(
      rowIndex: columnIndex,
      columnIndex: rowIndex
    )
  }
  
  /// In-place swaps the row and column indices.
  @inlinable
  public mutating func formTranspose() {
    swap(
      &rowIndex,
      &columnIndex
    )
  }
  
}

// MARK: - With-Derivation

extension MatrixPosition {
  
  /// Obtain a `MatrixPosition` replacing `self.rowIndex` with `rowIndex`.
  @inlinable
  public func with(rowIndex: Int) -> MatrixPosition {
    MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }
  
  /// Obtain a `MatrixPosition` replacing `self.columnIndex` with `columnIndex`.
  @inlinable
  public func with(columnIndex: Int) -> MatrixPosition {
    MatrixPosition(
      rowIndex: rowIndex,
      columnIndex: columnIndex
    )
  }
  
}


// MARK: - Validatable

extension MatrixPosition {
  
  @inlinable
  public var isValid: Bool {
    rowIndex >= 0 && columnIndex >= 0
  }
  
}

