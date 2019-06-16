//
//  SIMDSquareMatrixProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixProtocol
// -------------------------------------------------------------------------- //

/// `SIMDSquareMatrixProtocol` adds the square-matrix-specific operations and supplies default
/// implementations that forward through to the implementations on `Storage`.
public protocol SIMDSquareMatrixProtocol :
  SIMDTransposableMatrixProtocol,
  SquareMatrixMathProtocol
  where
  Transpose == Self,
  Storage: SIMDSquareMatrixStorageProtocol {
  
  /// The determinant of `self`.
  var determinant: Scalar { get }
  
  /// The inverse of `self`.
  ///
  /// - note: Currently an abstraction leak: result for non-invertible matrices is unspecified (and will be whatever the wrapped type does...).
  ///
  var inverse: Self { get }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixProtocol - Defaults
// -------------------------------------------------------------------------- //

public extension SIMDSquareMatrixProtocol {

  @inlinable
  func multiplied(onRightBy other: Self) -> Self {
    return Self(
      storage: self.storage.multiplied(
        onRightBy: other.storage
      )
    )
  }

  @inlinable
  func multiplied(onLeftBy other: Self) -> Self {
    return Self(
      storage: self.storage.multiplied(
        onLeftBy: other.storage
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy other: Self) {
    self.storage.formMultiplication(
      onRightBy: other.storage
    )
  }

  @inlinable
  mutating func formMultiplication(onLeftBy other: Self) {
    self.storage.formMultiplication(
      onLeftBy: other.storage
    )
  }

  @inlinable
  var determinant: Scalar {
    get {
      return self.storage.determinant
    }
  }
  
  @inlinable
  var inverse: Self {
    get {
      return Self(
        storage: self.storage.inverse
      )
    }
  }
  
}
