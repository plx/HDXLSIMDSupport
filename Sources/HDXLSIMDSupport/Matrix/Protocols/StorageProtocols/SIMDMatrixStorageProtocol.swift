//
//  SIMDMatrixStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// - todo: *move me* somewhere useful
infix operator =* : AssignmentPrecedence
infix operator =/ : AssignmentPrecedence

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

/// Basic protocol for all SIMD matrix storages.
public protocol SIMDMatrixStorageProtocol :
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  ExpressibleByArrayLiteral,
  NumericAggregate,
  MatrixMathProtocol,
  NativeSIMDRepresentable
  where
  Scalar: BinaryFloatingPoint,
  /*Scalar: SIMDScalar, implied by `Scalar == NativeSIMDRepresentation.NativeSIMDScalar */
  RowVector: SIMD,
  ColumnVector: SIMD,
  Scalar == NumericEntryRepresentation,
  Scalar == RowVector.Scalar,
  Scalar == ColumnVector.Scalar,
  ArrayLiteralElement == Scalar,
  NativeSIMDRepresentation: NativeSIMDMatrixProtocol,
  Scalar == NativeSIMDRepresentation.NativeSIMDScalar {
  
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
  
  /// Type of the row-vector tuple.
  associatedtype Rows
  
  /// Type of the column-vector tuple.
  associatedtype Columns
  
  /// Name used for the (required) diagonal-vector initializer.
  typealias DiagonalVector = ShorterAxisVector
  
  /// Construct and populate with zero everywhere.
  init()
  
  /// Populates `self` with the scalars in `scalars`.
  ///
  /// - precondition: `scalars` *must* have exactly `Self.scalarCount` elements.
  init<S:Sequence>(scalars: S)
    where S.Element == Scalar

  /// Populates `self` with the scalars in `scalars`.
  ///
  /// - precondition: `scalars` *must* have exactly `Self.scalarCount` elements.
  init<C:Collection>(scalars: C)
    where C.Element == Scalar

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
  
}


