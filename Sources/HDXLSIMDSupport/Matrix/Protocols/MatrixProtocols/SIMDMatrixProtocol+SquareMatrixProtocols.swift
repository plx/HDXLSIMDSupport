//
//  SIMDMatrixProtocol+SquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

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


