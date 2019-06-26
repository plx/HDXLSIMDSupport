//
//  Matrix4x2OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix4x2OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix4x2Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix4x2OperatorSupportProtocol : Matrix4x2Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix4x2OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

public extension Matrix4x2OperatorSupportProtocol {

  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x2 {
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
    lhs: CompatibleMatrix2x2,
    rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
