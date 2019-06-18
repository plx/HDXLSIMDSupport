//
//  SIMDSquareMatrixStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixStorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDSquareMatrixStorageProtocol :
  SquareMatrixMathProtocol,
  SIMDTransposableMatrixStorageProtocol
  where
  NativeSIMDRepresentation: NativeSIMDSquareMatrixProtocol,
  TransposeStorage == Self {
  
  /// The determinant of `self`.
  var determinant: Scalar { get }
  
  /// The inverse of `self`.
  ///
  /// - note: Currently an abstraction leak: result for non-invertible matrices is unspecified (and will be whatever the wrapped type does...).
  ///
  var inverse: Self { get }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixStorageProtocol - Defaults
// -------------------------------------------------------------------------- //

public extension SIMDSquareMatrixStorageProtocol {
  
  @inlinable
  func multiplied(onLeftBy other: Self) -> Self {
    return other.multiplied(onRightBy: self)
  }
  
}

