//
//  SIMDMatrix4x3StorageProtocol.swift
//

import Foundation

// -------------------------------------------------------------------------- //
// MARK: SIMDNonSquareMatrixStorageProtocol - Definition
// -------------------------------------------------------------------------- //

public protocol SIMDNonSquareMatrixStorageProtocol : SIMDTransposableMatrixStorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: NonSquare - (2,4) & (4,2)
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x2StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix4xNStorageProtocol, SIMDMatrixNx2StorageProtocol
  where
  TransposeStorage: SIMDMatrix2x4StorageProtocol {
    
}

public protocol SIMDMatrix2x4StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix2xNStorageProtocol, SIMDMatrixNx4StorageProtocol
  where
  TransposeStorage: SIMDMatrix4x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: NonSquare - (2,3) & (3,2)
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x2StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix3xNStorageProtocol, SIMDMatrixNx2StorageProtocol
  where
  TransposeStorage: SIMDMatrix2x3StorageProtocol {
  
}

public protocol SIMDMatrix2x3StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix2xNStorageProtocol, SIMDMatrixNx3StorageProtocol
  where
  TransposeStorage: SIMDMatrix3x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: NonSquare - (4,3) & (3,4)
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x4StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix3xNStorageProtocol, SIMDMatrixNx4StorageProtocol
  where
  TransposeStorage: SIMDMatrix4x3StorageProtocol {
  
}

public protocol SIMDMatrix4x3StorageProtocol : SIMDNonSquareMatrixStorageProtocol, SIMDMatrix4xNStorageProtocol, SIMDMatrixNx3StorageProtocol
  where
  TransposeStorage: SIMDMatrix3x4StorageProtocol {

}
