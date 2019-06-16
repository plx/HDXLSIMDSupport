//
//  SIMDMatrixStorageProtocol+SquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixStorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDSquareMatrixStorageProtocol : SIMDTransposableMatrixStorageProtocol
  where
  TransposeStorage == Self {
  
  var determinant: Scalar { get }
  var inverse: Self { get }
  
  static func * (lhs: Self, rhs: Self) -> Self
  static func *= (lhs: inout Self, rhs: Self)
  static func =* (lhs: Self, rhs: inout Self)
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix2x2StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x2StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix2xNStorageProtocol,
  SIMDMatrixNx2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix3x3StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x3StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix3xNStorageProtocol,
  SIMDMatrixNx3StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix4x4StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x4StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix4xNStorageProtocol,
  SIMDMatrixNx4StorageProtocol {
  
}


