//
//  SIMDMatrixStorageProtocol+SquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix2x2StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x2StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix2xNStorageProtocol,
  SIMDMatrixNx2StorageProtocol
  where
  NativeSIMDRepresentation: NativeSIMDMatrix2x2Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix3x3StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x3StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix3xNStorageProtocol,
  SIMDMatrixNx3StorageProtocol
  where
  NativeSIMDRepresentation: NativeSIMDMatrix3x3Protocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrix4x4StorageProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x4StorageProtocol :
  SIMDSquareMatrixStorageProtocol,
  SIMDMatrix4xNStorageProtocol,
  SIMDMatrixNx4StorageProtocol
  where
  NativeSIMDRepresentation: NativeSIMDMatrix4x4Protocol {
  
}


