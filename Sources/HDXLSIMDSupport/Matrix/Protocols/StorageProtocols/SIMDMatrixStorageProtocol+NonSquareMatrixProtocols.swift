//
//  SIMDMatrixStorageProtocol+NonSquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDNonSquareMatrixStorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDNonSquareMatrixStorageProtocol : SIMDTransposableMatrixStorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (4,2) SIMDMatrix4x2StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x2StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix4xNStorageProtocol,
  SIMDMatrixNx2StorageProtocol
  where
  TransposeStorage: SIMDMatrix2x4StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (2,4) SIMDMatrix4x2StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x4StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix2xNStorageProtocol,
  SIMDMatrixNx4StorageProtocol
  where
  TransposeStorage: SIMDMatrix4x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (3,2) SIMDMatrix3x2StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x2StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix3xNStorageProtocol,
  SIMDMatrixNx2StorageProtocol
  where
  TransposeStorage: SIMDMatrix2x3StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (2,3) SIMDMatrix2x3StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x3StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix2xNStorageProtocol,
  SIMDMatrixNx3StorageProtocol
  where
  TransposeStorage: SIMDMatrix3x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (3,4) SIMDMatrix3x4StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x4StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix3xNStorageProtocol,
  SIMDMatrixNx4StorageProtocol
  where
  TransposeStorage: SIMDMatrix4x3StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (4,3) SIMDMatrix4x3StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x3StorageProtocol :
  SIMDNonSquareMatrixStorageProtocol,
  SIMDMatrix4xNStorageProtocol,
  SIMDMatrixNx3StorageProtocol
  where
  TransposeStorage: SIMDMatrix3x4StorageProtocol {
  
}
