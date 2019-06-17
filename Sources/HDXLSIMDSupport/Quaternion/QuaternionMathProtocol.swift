//
//  QuaternionMathProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public protocol QuaternionMathProtocol {
  
  associatedtype Scalar: SIMDScalar & BinaryFloatingPoint
  
  /// Name for the length-three vector (e.g. imaginary part).
  typealias Vector3 = SIMD3<Scalar>
  
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
  func conjugate() -> Self
  
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
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionMathProtocol - Default Math Implementations
// -------------------------------------------------------------------------- //

public extension QuaternionMathProtocol {
  
  @inlinable
  func divided(by factor: Scalar) -> Self {
    precondition(factor.isNonZero)
    return self.multiplied(
      by: 1.0/factor
    )
  }
  
  @inlinable
  mutating func formDivision(by factor: Scalar) {
    precondition(factor.isNonZero)
    self.formMultiplication(
      by: 1.0/factor
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionMathProtocol - Operators
// -------------------------------------------------------------------------- //

public extension QuaternionMathProtocol {
  
  @inlinable
  static prefix func -(x: Self) -> Self {
    return x.negated()
  }
  
  @inlinable
  static func + (lhs: Self, rhs: Self) -> Self {
    return lhs.adding(rhs)
  }
  
  @inlinable
  static func += (lhs: inout Self, rhs: Self) {
    lhs.formAddition(of: rhs)
  }
  
  @inlinable
  static func + (lhs: Self, rhs: (Scalar,Self)) -> Self {
    return lhs.adding(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func += (lhs: inout Self, rhs: (Scalar,Self)) {
    lhs.formAddition(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func - (lhs: Self, rhs: Self) -> Self {
    return lhs.subtracting(rhs)
  }
  
  @inlinable
  static func -= (lhs: inout Self, rhs: Self) {
    lhs.formSubtraction(of: rhs)
  }
  
  @inlinable
  static func * (lhs: Self, rhs: Scalar) -> Self {
    return lhs.multiplied(by: rhs)
  }
  
  @inlinable
  static func * (lhs: Scalar, rhs: Self) -> Self {
    return rhs.multiplied(by: lhs)
  }
  
  @inlinable
  static func *= (lhs: inout Self, rhs: Scalar) {
    lhs.formMultiplication(by: rhs)
  }
  
  @inlinable
  static func / (lhs: Self, rhs: Scalar) -> Self {
    return lhs.divided(by: rhs)
  }
  
  @inlinable
  static func /= (lhs: inout Self, rhs: Scalar) {
    lhs.formDivision(by: rhs)
  }
  
  @inlinable
  static func * (lhs: Self, rhs: Self) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *= (lhs: inout Self, rhs: Self) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =* (lhs: Self, rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
  @inlinable
  static func / (lhs: Self, rhs: Self) -> Self {
    return lhs.divided(onRightBy: rhs)
  }
  
  @inlinable
  static func /= (lhs: inout Self, rhs: Self) {
    lhs.formDivision(onRightBy: rhs)
  }
  
  @inlinable
  static func =/ (lhs: Self, rhs: inout Self) {
    rhs.formDivision(onLeftBy: lhs)
  }
  
}
