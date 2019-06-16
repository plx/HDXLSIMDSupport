//
//  SquareMatrixMathoProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SquareMatrixMathProtocol - Definition
// -------------------------------------------------------------------------- //

/// Basic protocol that defines the core matrix-math methods for square matrices as abstractly as possible,
/// and thus lets us define the *operators* that call through to the named methods exactly once.
///
/// Expected to be refined by both (a) `SIMDSquareMatrixProtocol` and (b) `SIMDSquareMatrixStorageProtocol`.
///
public protocol SquareMatrixMathProtocol :
  MatrixMathProtocol
  where
  // omit this constraint *if* it results in redundant-constraint warnings elsewhere
  RowVector == ColumnVector {

  /// Returns the result of `self * other`.
  func multiplied(onRightBy other: Self) -> Self
  
  /// Returns the result of `other * self`.
  func multiplied(onLeftBy other: Self) -> Self
  
  /// In place sets `self = self * other`.
  mutating func formMultiplication(onRightBy other: Self)
  
  /// In place sets `self = other * self`.
  mutating func formMultiplication(onLeftBy other: Self)

}

// -------------------------------------------------------------------------- //
// MARK: SquareMatrixMathProtocol - Operators
// -------------------------------------------------------------------------- //

public extension SquareMatrixMathProtocol {
  
  @inlinable
  static func * (lhs: Self, rhs: Self) -> Self {
    return lhs.multiplied(
      onRightBy: rhs
    )
  }
  
  @inlinable
  static func *= (lhs: inout Self, rhs: Self) {
    lhs.formMultiplication(
      onRightBy: rhs
    )
  }
  
  @inlinable
  static func =* (lhs: Self, rhs: inout Self) {
    rhs.formMultiplication(
      onLeftBy: lhs
    )
  }

  
}
