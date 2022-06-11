//
// Matrix3x2OperatorSupportProtocol.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix3x2OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix3x2Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix3x2OperatorSupportProtocol : Matrix3x2Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix3x2OperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension Matrix3x2OperatorSupportProtocol {
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x3
  ) -> CompatibleMatrix2x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x3
  ) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x3
  ) -> CompatibleMatrix4x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *= (
    lhs: inout Self,
    rhs: CompatibleMatrix3x3
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =* (
    lhs: CompatibleMatrix2x2,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
