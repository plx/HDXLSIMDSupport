//
//  Matrix3x3OperatorSupportProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix3x3OperatorSupportProtocol - Definition
// -------------------------------------------------------------------------- //

/// Vacuous, artificial protocol trivially refining `Matrix3x3Protocol`.
///
/// Exists *only* to let us define operators for the types *wrapping* the native SIMD matrices
/// *without* shadowing the operators already defined on said native SIMD matrices.
public protocol Matrix3x3OperatorSupportProtocol : Matrix3x3Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: Matrix3x3OperatorSupportProtocol - Operators
// -------------------------------------------------------------------------- //

public extension Matrix3x3OperatorSupportProtocol {
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  static func *(
    lhs: Self,
    rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3 {
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
