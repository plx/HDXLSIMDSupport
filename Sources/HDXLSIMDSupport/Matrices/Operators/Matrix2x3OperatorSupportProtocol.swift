//
//  Matrix2x3OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix2x3OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix2x3Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix2x3OperatorSupportProtocol : Matrix2x3Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix2x3OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

public extension Matrix2x3OperatorSupportProtocol {
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x2) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x3 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x3 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *=(
    lhs: inout Self,
    rhs: CompatibleMatrix2x2) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =*(
    lhs: CompatibleMatrix3x3,
    rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
