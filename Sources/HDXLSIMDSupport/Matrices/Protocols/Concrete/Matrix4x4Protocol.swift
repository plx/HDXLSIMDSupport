//
//  Matrix4x4Protocol.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4Protocol - Definition
// -------------------------------------------------------------------------- //

/// 4x4-specific matrix protocol.
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
public protocol Matrix4x4Protocol : MatrixProtocol
  where
  RowVector == SIMD4<Scalar>,
  ColumnVector == SIMD4<Scalar>,
  DiagonalVector == SIMD4<Scalar>,
  Rows == T4<RowVector>,
  Columns == T4<ColumnVector>
{

  // ------------------------------------------------------------------------ //
  // MARK: Compatible Types
  // ------------------------------------------------------------------------ //

  /// Type of the directly-compatible quaternion.
  associatedtype CompatibleQuaternion /* : QuaternionProtocol where ...  */

  /// Type of the directly-compatible 2x4 matrix.
  associatedtype CompatibleMatrix2x4 /* : Matrix2x4Protocol where ...  */
  
  /// Type of the directly-compatible 4x2 matrix.
  associatedtype CompatibleMatrix4x2 /* : Matrix4x2Protocol where...  */
  
  /// Type of the directly-compatible 3x4 matrix.
  associatedtype CompatibleMatrix3x4 /* : Matrix3x4Protocol where ...  */
  
  /// Type of the directly-compatible 4x3 matrix.
  associatedtype CompatibleMatrix4x3 /* : Matrix4x3Protocol where...  */

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  /// Initializes a 4x4 matrix from a compatible quaternion.
  init(quaternion: CompatibleQuaternion)
  
  /// Initialize a matrix from an "unpacked `Columns`" value.
  ///
  /// - parameter c0: The first column-vector.
  /// - parameter c1: The second column-vector.
  /// - parameter c2: The third column-vector.
  /// - parameter c3: The fourth column-vector.
  ///
  /// - note: In an earlier design this was on a `Matrix4xNProtocol` and not "inlined" into each concrete matrix protocol, but that earlier design took hours to compile and 50+ gigs of RAM to edit.
  ///
  init(
    _ c0: ColumnVector,
    _ c1: ColumnVector,
    _ c2: ColumnVector,
    _ c3: ColumnVector
  )

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //

  /// Obtain the matrices determinant.
  var determinant: Scalar { get }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //

  /// Returns the inversion of `self`.
  ///
  /// - warning: Behavior on non-invertible matrices is whatever the underlying type is; yes, this is *another* abstraction leak!
  ///
  func inverted() -> Self
  
  /// Inverts `self` in-place.
  ///
  /// - warning: Behavior on non-invertible matrices is whatever the underlying type is; yes, this is *another* abstraction leak!
  ///
  mutating func formInverse()

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //

  /// Returns `self`right-multiplied by `rhs` (e.g. `self * rhs`).
  func multiplied(onRightBy rhs: Self) -> Self
  
  /// Returns `self` left-multiplied by `lhs` (e.g. `lhs * self`).
  func multiplied(onLeftBy lhs: Self) -> Self

  /// In place right-multiplies `self` by `rhs` (e.g. `self = self * rhs`).
  mutating func formMultiplication(onRightBy rhs: Self)
  
  /// In place left-multiplies `self` by `lhs` (e.g. `self = lhs * self`).
  mutating func formMultiplication(onLeftBy lhs: Self)

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //

  /// Returns `self` right-divided by `rhs` (e.g. `self / rhs`).
  func divided(onRightBy rhs: Self) -> Self
  
  /// Returns `self` left-divided by `lhs` (e.g.: `lhs.inverted() * self`
  func divided(onLeftBy lhs: Self) -> Self

  /// In-place right-divides `self` by `rhs` (e.g. `self = self / rhs`).
  mutating func formDivision(onRightBy rhs: Self)
  
  /// In-place left-divides `self` by `lhs` (e.g. `self = lhs.inverted() * self`).
  mutating func formDivision(onLeftBy lhs: Self)
  
  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  /// Returns the transpose of `self`.
  ///
  /// - note: I used to have an associated type for the tranpose but that blew up compile times; for now i just inline a *concrete* transpose operation into each concrete matrix protocl.
  func transposed() -> Self
  
  /// In-place replaces `self` with its transpose.
  mutating func formTranspose()

  // ------------------------------------------------------------------------ //
  // MARK: Right Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the `2x4`-sized result of `self * rhs`.
  func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x4

  /// Returns the `3x4`-sized result of `self * rhs`.
  func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4
  
  // ------------------------------------------------------------------------ //
  // MARK: Left Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the `4x3`-sized result of `lhs * self`.
  func multiplied(onLeftBy lhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3

  /// Returns the `4x2`-sized result of `lhs * self`.
  func multiplied(onLeftBy lhs: CompatibleMatrix4x2) -> CompatibleMatrix4x2
  
}
