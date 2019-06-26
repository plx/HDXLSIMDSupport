//
//  QuaternionOperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

infix operator • : MultiplicationPrecedence

// -------------------------------------------------------------------------- //
// MARK: QuaternionOperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Artificial protocol to be adopted by quaternion storages and `Quaternion<Scalar>`.
///
/// We need this so we can *supply* operators for the storages and `Quaternion<Scalar>` w/out
/// running into ambiguity issues vis-a-vis the existing operators on the native types.
public protocol QuaternionOperatorSupportProtocol : QuaternionProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionOperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension QuaternionOperatorSupportProtocol {
  
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
  
  @inlinable
  static func • (lhs: Self, rhs: Self) -> Scalar {
    return lhs.dotted(with: rhs)
  }
  
}

