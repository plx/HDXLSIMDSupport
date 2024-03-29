//
//  Matrix3x4Protocol.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix3x4Protocol - Definition
// -------------------------------------------------------------------------- //

/// 3x4-specific matrix protocol.
///
/// As stated repeatedly, my earlier attempts included a Matrix4xNProtocol, MatrixNx4Protocol, etc., from
/// which this protocol inherited; this bought less repetition and a "cleaner, more-elegant feel" but also produced
/// nightmarish compile times and even-more nightmarish memory consumption by `SourceKitService`.
///
/// I've opted, instead, to flatten the hierarchy *and* repeat myself in places where it's unavoidable.
///
/// Also, this protocol *must* be adoptable by (a) the native SIMD types, (b) the storage types, and finally
/// (c) the `Matrix4x4<Scalar>` type, thus we can't define the operators on it directly; we must, instead,
/// define a `Matrix4x4OperatorSupportProtocol` against-which we can define those operators.
public protocol Matrix3x4Protocol : MatrixProtocol
  where
  RowVector == SIMD3<Scalar>,
  ColumnVector == SIMD4<Scalar>,
  DiagonalVector == SIMD3<Scalar>,
  Rows == T4<RowVector>,
  Columns == T3<ColumnVector>
{
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  /// Initialize a matrix from an "unpacked `Columns`" value.
  ///
  /// - parameter c0: The first column-vector.
  /// - parameter c1: The second column-vector.
  /// - parameter c2: The third column-vector.
  ///
  /// - note: In an earlier design this was on a `Matrix3xNProtocol` and not "inlined" into each concrete matrix protocol, but that earlier design took hours to compile and 50+ gigs of RAM to edit.
  ///
  init(
    _ c0: ColumnVector,
    _ c1: ColumnVector,
    _ c2: ColumnVector
  )
  
  // ------------------------------------------------------------------------ //
  // MARK: Compatible Matrix Types
  // ------------------------------------------------------------------------ //
  
  /// Type of the compatible 4x4 matrix.
  associatedtype CompatibleMatrix4x4
  
  /// Type of the compatible 3x3 matrix.
  associatedtype CompatibleMatrix3x3
  
  /// Type of the compatible 2x3 matrix.
  associatedtype CompatibleMatrix2x3
  
  /// Type of the compatible 3x2 matrix.
  associatedtype CompatibleMatrix3x2
  
  /// Type of the compatible 2x4 matrix.
  associatedtype CompatibleMatrix2x4
  
  /// Type of the compatible 4x2 matrix.
  associatedtype CompatibleMatrix4x2
  
  /// Type of the compatible 4x3 matrix.
  associatedtype CompatibleMatrix4x3

  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  func transposed() -> CompatibleMatrix4x3
  
  // ------------------------------------------------------------------------ //
  // MARK: Right-Hand Multiplication
  // ------------------------------------------------------------------------ //

  /// Returns the `2x4`-sized result of `self * rhs`.
  func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x4

  /// Returns the `3x4`-sized result of `self * rhs`.
  func multiplied(onRightBy rhs: CompatibleMatrix3x3) -> Self

  /// In-place sets `self = self * rhs`.
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix3x3)
  
  /// Returns the `4x3`-sized result of `self * rhs`.
  func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x4
  
  // ------------------------------------------------------------------------ //
  // MARK: Left-Hand Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the `3x2`-sized result of `lhs * self`.
  func multiplied(onLeftBy lhs: CompatibleMatrix4x2) -> CompatibleMatrix3x2
  
  /// Returns the `3x3`-sized result of `lhs * self`.
  func multiplied(onLeftBy lhs: CompatibleMatrix4x3) -> CompatibleMatrix3x3
  
  /// Returns the `3x4`-sized result of `lhs * self`.
  func multiplied(onLeftBy lhs: CompatibleMatrix4x4) -> Self
  
  /// In-place sets `self = lhs * self`.
  mutating func formMultiplication(onLeftBy lhs: CompatibleMatrix4x4)

}
