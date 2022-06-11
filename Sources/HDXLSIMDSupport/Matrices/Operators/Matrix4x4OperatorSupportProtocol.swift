//
//  Matrix4x4OperatorSupportProtocol.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix4x4Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix4x4OperatorSupportProtocol : Matrix4x4Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4OperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension Matrix4x4OperatorSupportProtocol {
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x4
  ) -> CompatibleMatrix2x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x4
  ) -> CompatibleMatrix3x4 {
    return lhs.multiplied(onRightBy: rhs)
  }

  @inlinable
  static func * (
    lhs: Self,
    rhs: Self
  ) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *= (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =* (
    lhs: Self,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
  @inlinable
  static func / (
    lhs: Self,
    rhs: Self
  ) -> Self {
    return lhs.divided(onRightBy: rhs)
  }
  
  @inlinable
  static func /= (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formDivision(onRightBy: rhs)
  }
  
  @inlinable
  static func =/ (
    lhs: Self,
    rhs: inout Self
  ) {
    rhs.formDivision(onLeftBy: lhs)
  }

}
