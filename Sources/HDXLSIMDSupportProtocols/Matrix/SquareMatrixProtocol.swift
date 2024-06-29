import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: MatrixProtocol - Supporting Defines
// ------------------------------------------------------------------------ //

/// Shorthand for a 2-tuple with all types identically-`T`.
public typealias T2<T> = (T,T)

/// Shorthand for a 3-tuple with all types identically-`T`.
public typealias T3<T> = (T,T,T)

/// Shorthand for a 4-tuple with all types identically-`T`.
public typealias T4<T> = (T,T,T,T)

// ------------------------------------------------------------------------ //
// MARK: MatrixProtocol - Definition
// ------------------------------------------------------------------------ //

/// Basic protocol for *adoption* by (a) the native SIMD matrices, (b) the "storage" types, and (c) the generic
/// wrappers *around* those types. The design is somewhat artificial because on the one hand (a) I want to
/// use `extension Passthrough where PassthroughValue:MatrixProtocol` to minimize the
/// repetive boilerplate I need to write, but (b) the native SIMD types implement their math operations as
/// *operators* and thus defining operators directly, here, risks shadowing/ambiguity/etc. (e.g.: annoyances).
///
/// So the final *conformances* will look like this:
///
/// - native-simd types: `MatrixProtocol`
/// - storage types: `MatrixProtocol` + `MatrixOperatorSupportProtocol`
/// - matrix types: `MatrixProtocol` + `MatrixOperatorSupportProtocol`
///
/// ...with a similar *conformance* pattern applying to the size-specific protocol refinements.
///
/// Secondly, note that numerous early designs (a) had a fine-grained protocol hierarchy but (b) something
/// about that lead to multi-hour compilation times (and SourceKitService using, no joke, 56gb of RAM—or more!—
/// just while trying to edit the thing). As a work-around I've simplified-and-flattened the protocol hierarchy, which
/// makes it a bit more boilerplate-ish—and a bit less abstract/elegant—but I want tihs to be usable...it is what it is.
///
/// As an example of what's lost, though, there used to be protocols for square vs non-square matrices, and
/// e.g. protocols for 2xn, 3xn, 4xn, nx2, nx3, nx4, etc.; the original matrix 4x4 protocol inherited from square,
/// 4xn, and nx4 (etc.). That blows up compile times and doesn't result in *that much* code saving: you repeat
/// less code, sure, but the code you save is about as much as the hassle of declaring the MxN protocols and
/// extensions thereof, so...I'll take sub-hour compile times, thanks.
///
public protocol SquareMatrixProtocol<Scalar> : MatrixProtocol
where
RowVector == ColumnVector,
Rows == Columns
{
  
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
  
//  // ------------------------------------------------------------------------ //
//  // MARK: Transposition
//  // ------------------------------------------------------------------------ //
//  
//  /// Returns the transpose of `self`.
//  ///
//  /// - note: I used to have an associated type for the tranpose but that blew up compile times; for now i just inline a *concrete* transpose operation into each concrete matrix protocl.
//  func transposed() -> Self
//  
//  /// In-place replaces `self` with its transpose.
//  mutating func formTranspose()

}
