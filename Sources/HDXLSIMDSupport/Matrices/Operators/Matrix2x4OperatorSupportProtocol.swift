//
//  Matrix2x4OperatorSupportProtocol.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix2x4OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix2x4Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix2x4OperatorSupportProtocol : Matrix2x4Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix2x4OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

public extension Matrix2x4OperatorSupportProtocol {
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x2
  ) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x2
  ) -> CompatibleMatrix3x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x2
  ) -> CompatibleMatrix4x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *= (
    lhs: inout Self,
    rhs: CompatibleMatrix2x2
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =* (
    lhs: CompatibleMatrix4x4,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
