//
//  MatrixOperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: MatrixOperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// `MatrixOperatorSupportProtocol` vacuously refines `MatrixProtocol` just to have a
/// distinct extension point against-which we can define our operators for `MatrixProtocol`.
///
/// We *only* need this b/c we (a) want the native SIMD types to conform to `MatrixProtocol` but
/// (b) don't want the existing operators on the native SIMD types to get shadowed by our definitions.
public protocol MatrixOperatorSupportProtocol : MatrixProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixOperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension MatrixOperatorSupportProtocol {
  
  @inlinable
  static prefix func -(x: Self) -> Self {
    return x.negated()
  }
  
  @inlinable
  static func +(
    lhs: Self,
    rhs: Self) -> Self {
    return lhs.adding(rhs)
  }
  
  @inlinable
  static func +=(
    lhs: inout Self,
    rhs: Self) {
    return lhs.formAddition(of: rhs)
  }

  @inlinable
  static func +(
    lhs: Self,
    rhs: (Scalar,Self)) -> Self {
    return lhs.adding(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func +=(
    lhs: inout Self,
    rhs: (Scalar,Self)) {
    return lhs.formAddition(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }

  @inlinable
  static func -(
    lhs: Self,
    rhs: Self) -> Self {
    return lhs.subtracting(rhs)
  }
  
  @inlinable
  static func -=(
    lhs: inout Self,
    rhs: Self) {
    return lhs.formSubtraction(of: rhs)
  }

  @inlinable
  static func -(
    lhs: Self,
    rhs: (Scalar,Self)) -> Self {
    return lhs.subtracting(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func -=(
    lhs: inout Self,
    rhs: (Scalar,Self)) {
    return lhs.formSubtraction(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: Scalar) -> Self {
    return lhs.multiplied(by: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Scalar,
    rhs: Self) -> Self {
    return rhs.multiplied(by: lhs)
  }
  
  @inlinable
  static func *=(
    lhs: inout Self,
    rhs: Scalar) {
    lhs.formMultiplication(by: rhs)
  }
  
  @inlinable
  static func /(
    lhs: Self,
    rhs: Scalar) -> Self {
    return lhs.divided(by: rhs)
  }
  
  @inlinable
  static func /=(
    lhs: inout Self,
    rhs: Scalar) {
    return lhs.formDivision(by: rhs)
  }
  
  @inlinable
  static func *(
    lhs: ColumnVector,
    rhs: Self) -> RowVector {
    return rhs.multiplied(onLeftBy: lhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: RowVector) -> ColumnVector {
    return lhs.multiplied(onRightBy: rhs)
  }
  
}
