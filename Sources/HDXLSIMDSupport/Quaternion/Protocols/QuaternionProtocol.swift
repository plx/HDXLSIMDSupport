//
//  QuaternionProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: QuaternionProtocol - Definition
// -------------------------------------------------------------------------- //

/// Protocol with common math operations by all quaternions (and wrappers thereof).
public protocol QuaternionProtocol {

  // ------------------------------------------------------------------------ //
  // MARK: Compatible Types
  // ------------------------------------------------------------------------ //

  /// The scalar with-which we represent our coefficients.
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint
  
  /// The type of the compatible 3x3 matrix.
  associatedtype CompatibleMatrix3x3 /* : Matrix3x3Protocol where Scalar == ... */
  
  /// The type of the compatible 4x4 matrix.
  associatedtype CompatibleMatrix4x4 /* : Matrix3x3Protocol where Scalar == ... */
  
  /// Name for the length-three vector (e.g. imaginary part).
  typealias Vector3 = SIMD3<Scalar>
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  /// The zero quaternion
  init()
  
  /// Init with i,j,k, and real coefficients.
  init(i: Scalar, j: Scalar, k: Scalar, real: Scalar)
  
  /// Init with x,y,z and real coefficients.
  init(x: Scalar, y: Scalar, z: Scalar, real: Scalar)
  
  /// Construct a quaternion from real and imaginary parts.
  init(
    realComponent: Scalar,
    imaginaryComponent: Vector3)
  
  /// A quaternion whose action is a rotation by `angle` radians about `axis`.
  ///
  /// - Parameters:
  ///   - angle: The angle to rotate by measured in radians.
  ///   - axis: The axis to rotate around.
  init(
    angleInRadians angle: Scalar,
    rotationAxis axis: Vector3)
  
  /// A quaternion whose action rotates the vector `origin` onto the vector `destination`.
  init(
    rotating origin: Vector3,
    onto destination: Vector3)
  
  /// Initialize a quaternion from a 3x3 rotation matrix.
  init(rotationMatrix matrix: CompatibleMatrix3x3)
  
  /// Initialize a quaternion from a 4x4 rotation matrix.
  init(rotationMatrix matrix: CompatibleMatrix4x4)

  // ------------------------------------------------------------------------ //
  // MARK: Other Constructors
  // ------------------------------------------------------------------------ //
  
  /// Returns a spherical linearly interpolated value, using `strategy` to choose the arc in question.
  static func slerp(
    _ q0: Self,
    _ q1: Self,
    _ t: Scalar,
    strategy: QuaternionSlerpStrategy) -> Self
  
  /// Returns a spherical linearly interpolated value along the shortest arc between two quaternions.
  static func slerpShortest(
    _ q0: Self,
    _ q1: Self,
    _ t: Scalar) -> Self

  /// Returns a spherical linearly interpolated value along the longest arc between two quaternions.
  static func slerpLongest(
    _ q0: Self,
    _ q1: Self,
    _ t: Scalar) -> Self

  /// Returns the spherical cubic Bezier interpolation between quaternions.
  ///
  /// - seealso: https://developer.apple.com/documentation/simd/2867364-simd_bezier
  ///
  static func bezier(
    q0: Self,
    q1: Self,
    q2: Self,
    q3: Self,
    t: Scalar) -> Self

  /// Returns an interpolated value between two quaternions along a spherical cubic spline.
  ///
  /// - seealso: https://developer.apple.com/documentation/simd/2867378-simd_spline
  ///
  static func spline(
    q0: Self,
    q1: Self,
    q2: Self,
    q3: Self,
    t: Scalar) -> Self

  // ------------------------------------------------------------------------ //
  // MARK: Basic Properties
  // ------------------------------------------------------------------------ //

  /// The real (scalar) part of `self`.
  var realComponent: Scalar { get set }
  
  /// The imaginary (vector) part of `self`.
  var imaginaryComponent: Vector3 { get set }
  
  /// The angle (in radians) by which `self`'s action rotates.
  var angleInRadians: Scalar { get }
  
  /// The normalized axis about which `self`'s action rotates.
  var rotationAxis: Vector3 { get }
  
  /// The length of the quaternion interpreted as a 4d vector.
  var length: Scalar { get }

  // ------------------------------------------------------------------------ //
  // MARK: Applying to Vectors
  // ------------------------------------------------------------------------ //

  /// Applies the rotation represented by a unit quaternion to the vector and
  /// returns the result.
  func apply(to vector: Vector3) -> Vector3
  
  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //
  
  /// Returns a unit quaternion obtained via `self/self.length`.
  ///
  /// - precondition: `self != .zero`
  ///
  func normalized() -> Self
  
  /// In-place mutates `self` into a unit quaternion obtained via `self/self.length`.
  ///
  /// - precondition: `self != .zero`
  ///
  mutating func formNormalization()
  
  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //
  
  /// Returns the inverse of `self`.
  ///
  /// - precondition: `self != .zero`
  ///
  func inverted() -> Self
  
  /// In-place mutates `self` into its inverse.
  ///
  ///
  /// - precondition: `self != .zero`
  ///
  mutating func formInverse()
  
  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //
  
  /// Returns the conjugate of `self`.
  func conjugated() -> Self
  
  /// In-place mutates `self` into its conjugate.
  mutating func formConjugate()
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  /// Returns the negation of `self`.
  func negated() -> Self
  
  /// In-place mutates `self` into its negation.
  mutating func formNegation()
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //
  
  /// Returns the sum of `self` and `other`.
  func adding(_ other: Self) -> Self
  
  /// In-place adds `other` into  `self`.
  mutating func formAddition(of other: Self)
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  /// Returns the sum of `self` and `factor * other`.
  func adding(
    _ other: Self,
    multipliedBy factor: Scalar) -> Self
  
  /// In-place adds `factor * other` into  `self`.
  mutating func formAddition(
    of other: Self,
    multipliedBy factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of subtracting `other` from `self`.
  func subtracting(_ other: Self) -> Self
  
  /// In-place subtracts `other` from `self`.
  mutating func formSubtraction(of other: Self)

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` minus `factor * other`.
  func subtracting(
    _ other: Self,
    multipliedBy factor: Scalar) -> Self
  
  /// In-place subtracts `factor * other` from  `self`.
  mutating func formSubtraction(
    of other: Self,
    multipliedBy factor: Scalar)

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` multiplied-by `factor`.
  func multiplied(by factor: Scalar) -> Self
  
  /// In-place multiplies `self` by `factor`.
  mutating func formMultiplication(by factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` divided-by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  func divided(by factor: Scalar) -> Self
  
  /// In-place divides`self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  mutating func formDivision(by factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `self * other`.
  func multiplied(onRightBy other: Self) -> Self
  
  /// Returns `other * self`.
  func multiplied(onLeftBy other: Self) -> Self
  
  /// In-place sets `self = self * other`.
  mutating func formMultiplication(onRightBy other: Self)
  
  /// In-place sets `self = other * self`.
  mutating func formMultiplication(onLeftBy other: Self)
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  /// Returns `self * (1/other)`.
  func divided(onRightBy other: Self) -> Self
  
  /// Returns `(1/other) * self`.
  func divided(onLeftBy other: Self) -> Self
  
  /// In-place sets `self = self * (1/other)`.
  mutating func formDivision(onRightBy other: Self)
  
  /// In-place sets `self = (1/other) * self`.
  mutating func formDivision(onLeftBy other: Self)

  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Dot Product
  // ------------------------------------------------------------------------ //
  
  /// Returns the quaternion dot product with `other`.
  func dotted(with other: Self) -> Scalar

}
