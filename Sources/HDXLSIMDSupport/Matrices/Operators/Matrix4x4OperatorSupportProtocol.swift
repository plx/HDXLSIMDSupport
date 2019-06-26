//
//  Matrix4x4OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

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
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x4 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4 {
    return lhs.multiplied(onRightBy: rhs)
  }

}
