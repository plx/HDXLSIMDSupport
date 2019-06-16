//
//  SIMDMatrixProtocol+SquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDSquareMatrixProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDSquareMatrixProtocol : SIMDTransposableMatrixProtocol
  where
  Transpose == Self,
  Storage: SIMDSquareMatrixStorageProtocol {
  
  var determinant: Scalar { get }
  var inverse: Self { get }
  
  static func * (lhs: Self, rhs: Self) -> Self
  static func *= (lhs: inout Self, rhs: Self)
  static func =* (lhs: Self, rhs: inout Self)
  
}

public extension SIMDSquareMatrixProtocol {
  
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
  
  @inlinable
  static func * (lhs: Self, rhs: Self) -> Self {
    return Self(
      storage: lhs.storage * rhs.storage
    )
  }

  @inlinable
  static func *= (lhs: inout Self, rhs: Self) {
    lhs.storage *= rhs.storage
  }

  @inlinable
  static func =* (lhs: Self, rhs: inout Self) {
    lhs.storage =* rhs.storage
  }

}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix2x2Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x2Protocol :
  SIMDSquareMatrixProtocol,
  SIMDMatrix2xNProtocol,
  SIMDMatrixNx2Protocol
  where
  Storage:SIMDMatrix2x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix3x3Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x3Protocol :
  SIMDSquareMatrixProtocol,
  SIMDMatrix3xNProtocol,
  SIMDMatrixNx3Protocol
  where
  Storage:SIMDMatrix3x3StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix4x4Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x4Protocol :
  SIMDSquareMatrixProtocol,
  SIMDMatrix4xNProtocol,
  SIMDMatrixNx4Protocol
  where
  Storage:SIMDMatrix4x4StorageProtocol {
  
}


