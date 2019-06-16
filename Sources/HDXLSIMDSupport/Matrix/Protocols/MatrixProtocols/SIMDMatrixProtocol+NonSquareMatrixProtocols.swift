//
//  SIMDMatrixProtocol+NonSquareMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDNonSquareMatrixProtocol
// -------------------------------------------------------------------------- //

public protocol SIMDNonSquareMatrixProtocol : SIMDTransposableMatrixProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (4,2) SIMDMatrix4x2Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x2Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix4xNProtocol,
  SIMDMatrixNx2Protocol
  where
  Transpose: SIMDMatrix2x4Protocol,
  Storage:SIMDMatrix4x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (2,4) SIMDMatrix4x2Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x4Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix2xNProtocol,
  SIMDMatrixNx4Protocol
  where
  Transpose: SIMDMatrix4x2Protocol
  // redundant due to constraints on transpose:
  /*, Storage:SIMDMatrix2x4StorageProtocol */ {
  
}

// -------------------------------------------------------------------------- //
// MARK: (3,2) SIMDMatrix3x2Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x2Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix3xNProtocol,
  SIMDMatrixNx2Protocol
  where
  Transpose: SIMDMatrix2x3Protocol,
  Storage:SIMDMatrix3x2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (2,3) SIMDMatrix2x3Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix2x3Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix2xNProtocol,
  SIMDMatrixNx3Protocol
  where
  Transpose: SIMDMatrix3x2Protocol
  // redundant due to constraints on transpose:
  /*, Storage:SIMDMatrix2x3StorageProtocol */ {
  
}

// -------------------------------------------------------------------------- //
// MARK: (3,4) SIMDMatrix3x4Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix3x4Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix3xNProtocol,
  SIMDMatrixNx4Protocol
  where
  Transpose: SIMDMatrix4x3Protocol,
  Storage:SIMDMatrix3x4StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK: (4,3) SIMDMatrix4x3Protocol
// -------------------------------------------------------------------------- //

public protocol SIMDMatrix4x3Protocol :
  SIMDNonSquareMatrixProtocol,
  SIMDMatrix4xNProtocol,
  SIMDMatrixNx3Protocol
  where
  Transpose: SIMDMatrix3x4Protocol
  // redundant due to constraints on transpose:
  /*, Storage:SIMDMatrix4x3StorageProtocol */ {
  
}
