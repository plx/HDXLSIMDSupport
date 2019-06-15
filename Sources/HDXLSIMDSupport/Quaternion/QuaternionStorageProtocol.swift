//
//  QuaternionStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public enum QuaternionSlerpType {
  
  case shortest
  case longest
  
}

public protocol QuaternionStorageProtocol : Equatable {
  
  associatedtype QuaternionScalar: BinaryFloatingPoint & SIMDScalar
  
  typealias Vector3 = SIMD3<QuaternionScalar>
  typealias Vector4 = SIMD4<QuaternionScalar>
  
  /// The zero quaternion
  init()
  
  static func slerpedQuaternion(
    type: QuaternionSlerpType,
    from q0: Self,
    to q1: Self,
    at t: QuaternionScalar) -> Self
  
  var vector: Vector4 { get }

  /// The real (scalar) part of `self`.
  var real: QuaternionScalar { get set }
  
  /// The imaginary (vector) part of `self`.
  var imag: Vector3 { get set }
  
  /// The angle (in radians) by which `self`'s action rotates.
  var angleInRadians: QuaternionScalar { get }
  
  /// The normalized axis about which `self`'s action rotates.
  var rotationAxis: Vector3 { get }
  
  /// The conjugate of `self`.
  var conjugate: Self { get }
  
  /// The inverse of `self`.
  var inverse: Self { get }
  
  /// The unit quaternion obtained by normalizing `self`.
  var normalized: Self { get }
  
  /// The length of the quaternion interpreted as a 4d vector.
  var length: QuaternionScalar { get }
  
  /// Applies the rotation represented by a unit quaternion to the vector and
  /// returns the result.
  func apply(to vector: Vector3) -> Vector3
  
  /// The sum of `lhs` and `rhs`.
  static func + (lhs: Self, rhs: Self) -> Self
  
  /// Add `rhs` to `lhs`.
  static func += (lhs: inout Self, rhs: Self)
  
  /// The difference of `lhs` and `rhs`.
  static func - (lhs: Self, rhs: Self) -> Self
  
  /// Subtract `rhs` from `lhs`.
  static func -= (lhs: inout Self, rhs: Self)
  
  /// The negation of `rhs`.
  prefix static func - (rhs: Self) -> Self
  
  /// The product of `lhs` and `rhs`.
  static func * (lhs: Self, rhs: Self) -> Self
  
  /// The product of `lhs` and `rhs`.
  static func * (lhs: QuaternionScalar, rhs: Self) -> Self
  
  /// The product of `lhs` and `rhs`.
  static func * (lhs: Self, rhs: QuaternionScalar) -> Self
  
  /// Multiply `lhs` by `rhs`.
  static func *= (lhs: inout Self, rhs: Self)
  
  /// Multiply `lhs` by `rhs`.
  static func *= (lhs: inout Self, rhs: QuaternionScalar)
  
  /// The quotient of `lhs` and `rhs`.
  static func / (lhs: Self, rhs: Self) -> Self
  
  /// The quotient of `lhs` and `rhs`.
  static func / (lhs: Self, rhs: QuaternionScalar) -> Self
  
  /// Divide `lhs` by `rhs`.
  static func /= (lhs: inout Self, rhs: Self)
  
  /// Divide `lhs` by `rhs`.
  static func /= (lhs: inout Self, rhs: QuaternionScalar)

}

