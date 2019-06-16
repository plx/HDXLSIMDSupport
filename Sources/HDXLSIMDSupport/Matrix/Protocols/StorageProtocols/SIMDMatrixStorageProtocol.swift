//
//  SIMDMatrixStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// - todo: *move me* somewhere useful
infix operator =* : AssignmentPrecedence

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

/// Basic protocol for all SIMD matrix storages.
public protocol SIMDMatrixStorageProtocol : Equatable, Codable {
  
  /// The underlying scalar, it doesn't *have* to be *either* `SIMDScalar` *or* `BinaryFloatingPoint` and maybe shouldn't be.
  ///
  /// - todo: *minimize* to, what, nothing?
  ///
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint
  
  /// Type with the vector used by the *shorter* axis.
  ///
  /// - todo: *Consider* eliminating in favor of just a single `DiagonalVector` if the longer/shorter isn't used.
  ///
  associatedtype ShorterAxisVector: SIMD
    where ShorterAxisVector.Scalar == Scalar

  /// Type with the vector used by the *longer* axis.
  ///
  /// - todo: *Consider* eliminating in favor of just a single `DiagonalVector` if the longer/shorter isn't used.
  ///
  associatedtype LongerAxisVector: SIMD
    where LongerAxisVector.Scalar == Scalar

  /// Type of the individual row vectors.
  associatedtype RowVector: SIMD
    where RowVector.Scalar == Scalar
  
  /// Type of the individual column vectors.
  associatedtype ColumnVector: SIMD
    where ColumnVector.Scalar == Scalar
  
  /// Type of the row-vector tuple.
  associatedtype Rows
  
  /// Type of the column-vector tuple.
  associatedtype Columns
  
  /// Name used for the (required) diagonal-vector initializer.
  typealias DiagonalVector = ShorterAxisVector
  
  /// The total number of scalars contained within values of this type.
  static var scalarCount: Int { get }
  
  /// The number of columns for values of this type.
  static var columnCount: Int { get }
  
  /// The number of rows for values of this type.
  static var rowCount: Int { get }
  
  /// The *length* of rows for values of this type.
  static var rowLength: Int { get }
  
  /// The *length* of columns for values of this type.
  static var columnLength: Int { get }
  
  /// Construct and populate with zero everywhere.
  init()
  
  /// Construct and populate with zero everywhere.
  init(repeating scalar: Scalar)
  
  /// Construct and populate with zero everywhere.
  init(diagonal: DiagonalVector)
  
  /// Construct from a tuple of column-vectors.
  init(columns: Columns)
  
  /// Construct from a tuple of row-vectors.
  init(rows: Rows)
  
  /// Directly access the underlying columns.
  ///
  /// - note: This is an abstraction leak: Apple's SIMD types are stored as column vectors, but it's *conceivable* that others could use rows; for the foreseeable future I don't care beyond noting this in passing.
  ///
  var columns: Columns {get set}
  
  /// Access underlying scalar values by their linear index.
  ///
  /// - note: Named subscript arguments to avoid ambiguity at call sites.
  ///
  subscript(scalarIndex scalarIndex: Int) -> Scalar { get set }
  
  /// Access underlying columns by index.
  ///
  /// - note: Named subscript arguments to avoid ambiguity at call sites.
  /// - note: 50% (or better!) odds I have the label wrong here and will flip it; that's largely *why* I'm keeping this explicit!
  ///
  subscript(columnIndex columnIndex: Int) -> ColumnVector { get set }

  /// Access underlying scalars by `(columnIndex, rowIndex)`.
  ///
  /// - note: Named subscript arguments to avoid ambiguity at call sites.
  /// - note: 50% (or better!) odds I have the label wrong here and will flip it; that's largely *why* I'm keeping this explicit!
  ///
  subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int) -> Scalar { get set }
  
  /// Operator to get the negation of self.
  static prefix func -(x: Self) -> Self

  /// Operator for componentwise-addition.
  static func + (lhs: Self, rhs: Self) -> Self
  
  /// Operator for componentwise-subtraction.
  static func - (lhs: Self, rhs: Self) -> Self
  
  /// Operator for componentwise-multiplication by a scalar.
  static func * (lhs: Self, rhs: Scalar) -> Self
  
  /// Operator for componentwise-multiplication by a scalar.
  static func * (lhs: Scalar, rhs: Self) -> Self
  
  /// Operator for in-place componentwise-addition.
  static func += (lhs: inout Self, rhs: Self)
  
  /// Operator for in-place componentwise-subtraction.
  static func -= (lhs: inout Self, rhs: Self)
  
  /// Operator for in-place componentwise-multiplication by a scalar.
  static func *= (lhs: inout Self, rhs: Scalar)
  
  /// Operator for vector-matrix multiplication.
  static func * (lhs: RowVector, rhs: Self) -> ColumnVector
  
  /// Operator for matrix-vector multiplication.
  static func * (lhs: Self, rhs: ColumnVector) -> RowVector
  
}



public extension SIMDMatrixStorageProtocol {
  
  @inlinable
  static var scalarCount: Int {
    get {
      return Self.rowCount * Self.columnCount
    }
  }
  
  @inlinable
  var linearizedScalarValues: [Scalar] {
    get {
      var result: [Scalar] = []
      result.reserveCapacity(Self.scalarCount)
      for scalarIndex in 0..<Self.scalarCount {
        result.append(self[scalarIndex: scalarIndex])
      }
      return result
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return RowVector.scalarCount
    }
  }

  @inlinable
  static var rowCount: Int {
    get {
      return ColumnVector.scalarCount
    }
  }

  @inlinable
  static var columnLength: Int {
    get {
      return ColumnVector.scalarCount
    }
  }

  @inlinable
  static var columnCount: Int {
    get {
      return RowVector.scalarCount
    }
  }
  
  @inlinable
  subscript(scalarIndex scalarIndex: Int) -> Scalar {
    get {
      return self[
        columnIndex: (scalarIndex / Self.columnCount),
        rowIndex: (scalarIndex % Self.columnCount)
      ]
    }
    set {
      self[
        columnIndex: (scalarIndex / Self.columnCount),
        rowIndex: (scalarIndex % Self.columnCount)
      ] = newValue
    }
  }
  
  /// Define matrix-scalar `/` once, using `*` by `1.0/rhs`.
  @inlinable
  static func / (lhs: Self, rhs: Scalar) -> Self {
    precondition(rhs.isNonZero)
    return lhs * (1.0/rhs)
  }
  
  /// Define matrix-scalar `/=` once, using `*=` by `1.0/rhs`.
  @inlinable
  static func /= (lhs: inout Self, rhs: Scalar) {
    precondition(rhs.isNonZero)
    lhs *= (1.0/rhs)
  }

}
