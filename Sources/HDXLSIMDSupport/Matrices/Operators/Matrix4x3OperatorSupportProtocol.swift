//
//  Matrix4x3OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix4x3OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix4x3Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix4x3OperatorSupportProtocol : Matrix4x3Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix4x3OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

public extension Matrix4x3OperatorSupportProtocol {
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x3 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x3 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix4x4) -> Self {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *=(
    lhs: inout Self,
    rhs: CompatibleMatrix4x4) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  static func =*(
    lhs: CompatibleMatrix3x3,
    rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
}
