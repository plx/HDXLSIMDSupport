//
//  QuaternionOperatorSupportProtocol.swift
//

import Foundation
import simd

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

// -------------------------------------------------------------------------- //
// MARK: QuaternionOperatorSupportProtocol - Operators - In-Place `AdditiveArithmetic`
// -------------------------------------------------------------------------- //

// technical fix: both `AdditiveArithmetic` and `QuaternionOperatorSupportProtocol`
// define default implementations of `+=` and `-=`. This results in ambiguity
// if we then have`$MatrixType:AdditiveArithmetic & QuaternionOperatorSupportProtocol`,
// b/c Swift sees two default implementations (w/out a way to pick a winner).
//
// One fix is to delete these operators and use the existing defaults--could be
// the right decision, actually.
//
// Fix I picked is to move the defaults into an extension that applies only to
// the case of `QuaternionOperatorSupportProtocol where Self:AdditiveArithmetic`,
// and then *overrides* `AdditiveArithmetic`'s default implementations with our
// own implementation. This fixes the disambiguity issue; whether it's worth
// having these remains to be seen (probably not, but don't want to jump the
// gun on removing them...).
//
public extension QuaternionOperatorSupportProtocol where Self:AdditiveArithmetic {
  
  @inlinable
  static func += (
    lhs: inout Self,
    rhs: Self
  ) {
    return lhs.formAddition(of: rhs)
  }

  @inlinable
  static func -= (
    lhs: inout Self,
    rhs: Self
  ) {
    return lhs.formSubtraction(of: rhs)
  }

}

