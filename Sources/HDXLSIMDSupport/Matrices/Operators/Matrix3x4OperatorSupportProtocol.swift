//
//  Matrix3x4OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix3x4OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix3x4Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix3x4OperatorSupportProtocol : Matrix3x4Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix3x4OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

public extension Matrix3x4OperatorSupportProtocol {
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x3) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *=(
    lhs: inout Self,
    rhs: CompatibleMatrix3x3) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =*(
    lhs: CompatibleMatrix4x4,
    rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
