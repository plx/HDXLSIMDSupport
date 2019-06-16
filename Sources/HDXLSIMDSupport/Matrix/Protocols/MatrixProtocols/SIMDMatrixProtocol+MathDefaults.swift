//
//  SIMDMatrixProtocol+MathDefaults.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension SIMDMatrixProtocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Negation
  // ------------------------------------------------------------------------ //
  
  /// Returns `-self`.
  @inlinable
  func negated() -> Self {
    return Self(
      storage: self.storage.negated()
    )
  }
  
  /// In-place mutates `self` into `-self`.
  @inlinable
  mutating func formNegation() {
    self.storage.formNegation()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Addition
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-sum of `self` and `other`.
  @inlinable
  func adding(_ other: Self) -> Self {
    return Self(
      storage: self.storage.adding(other.storage)
    )
  }
  
  /// In-place componentwise adds `other` into self.
  @inlinable
  mutating func formAddition(of other: Self) {
    self.storage.formAddition(of: other.storage)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - FMA Operation
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-sum of `self` and `factor * other`.
  @inlinable
  func adding(
    _ other: Self,
    multipliedBy factor: Scalar) -> Self {
    return Self(
      storage: self.storage.adding(
        other.storage,
        multipliedBy: factor
      )
    )
  }
  
  /// In-place adds `factor * other` into self.
  @inlinable
  mutating func formAddition(
    of other: Self,
    multipliedBy factor: Scalar) {
    self.storage.formAddition(
      of: other.storage,
      multipliedBy: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Subtraction
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-subtraction of `other` from `self`.
  @inlinable
  func subtracting(_ other: Self) -> Self {
    return Self(
      storage: self.storage.subtracting(other.storage)
    )
  }
  
  /// In-place componentwise-subtracts `other` from `self`.
  @inlinable
  mutating func formSubtraction(of other: Self) {
    self.storage.formSubtraction(of: other.storage)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of multiplying `self` by `factor`.
  @inlinable
  func multiplied(by factor: Scalar) -> Self {
    return Self(
      storage: self.storage.multiplied(
        by: factor
      )
    )
  }
  
  /// In-place multiplies `self` by factor.
  @inlinable
  mutating func formMultiplication(by factor: Scalar) {
    self.storage.formMultiplication(
      by: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Scalar Division
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of dividing `self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  @inlinable
  func divided(by factor: Scalar) -> Self {
    return Self(
      storage: self.storage.divided(
        by: factor
      )
    )
  }
  
  /// In-place divides `self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  @inlinable
  mutating func formDivision(by factor: Scalar) {
    self.storage.formDivision(by: factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `rowVector * self`
  @inlinable
  func multiplied(onLeftBy rowVector: RowVector) -> ColumnVector {
    return self.storage.multiplied(
      onLeftBy: rowVector
    )
  }
  
  /// Returns `self * columnVector`
  @inlinable
  func multiplied(onRightBy columnVector: ColumnVector) -> RowVector {
    return self.storage.multiplied(
      onRightBy: columnVector
    )

  }

}
