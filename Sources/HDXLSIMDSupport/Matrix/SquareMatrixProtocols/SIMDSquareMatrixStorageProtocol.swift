//
//  SIMDSquareMatrixStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

public protocol SIMDSquareMatrixStorageProtocol : SIMDTransposableMatrixStorageProtocol
  where TransposeStorage == Self {
  
  var determinant: Scalar { get }
  var inverse: Self { get }
  
  static func * (lhs: Self, rhs: Self) -> Self
  static func *= (lhs: inout Self, rhs: Self)
  static func =* (lhs: Self, rhs: inout Self)
  
}



