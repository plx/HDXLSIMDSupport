//
//  Matrix2x2OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix2x2OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix2x2Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix2x2OperatorSupportProtocol : Matrix2x2Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix2x2OperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension Matrix2x2OperatorSupportProtocol {
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: Self) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *=(
    lhs: inout Self,
    rhs: Self) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =*(
    lhs: Self,
    rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
  @inlinable
  static func /(
    lhs: Self,
    rhs: Self) -> Self {
    return lhs.divided(onRightBy: rhs)
  }
  
  @inlinable
  static func /=(
    lhs: inout Self,
    rhs: Self) {
    lhs.formDivision(onRightBy: rhs)
  }
  
  @inlinable
  static func =/(
    lhs: Self,
    rhs: inout Self) {
    rhs.formDivision(onLeftBy: lhs)
  }

}
