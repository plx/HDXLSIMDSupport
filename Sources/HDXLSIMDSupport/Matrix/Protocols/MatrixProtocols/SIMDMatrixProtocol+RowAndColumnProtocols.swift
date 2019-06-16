//
//  SIMDMatrixProtocol+RowAndColumnProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix2xNProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 2-column matrices.
public protocol SIMDMatrix2xNProtocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrix2xNStorageProtocol {
  
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector)
  
}

public extension SIMDMatrix2xNProtocol {
  
  /// Initialize a 2-column matrix directly from the underlying 3 column vectors.
  @inlinable
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector) {
    self.init(
      storage: Storage(
        columnOne,
        columnTwo
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix3xNProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 3-column matrices.
public protocol SIMDMatrix3xNProtocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrix3xNStorageProtocol {
  
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector)
  
}

public extension SIMDMatrix3xNProtocol {
  
  /// Initialize a 3-column matrix directly from the underlying 3 column vectors.
  @inlinable
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector) {
    self.init(
      storage: Storage(
        columnOne,
        columnTwo,
        columnThree
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix4xNProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 4-column matrices.
public protocol SIMDMatrix4xNProtocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrix4xNStorageProtocol {

  /// Initialize a 4-column matrix directly from the underlying 4 column vectors.
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector,
    _ columnFour: ColumnVector)
  
}

public extension SIMDMatrix4xNProtocol {
  
  @inlinable
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector,
    _ columnFour: ColumnVector) {
    self.init(
      storage: Storage(
        columnOne,
        columnTwo,
        columnThree,
        columnFour
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx2Protocol
// -------------------------------------------------------------------------- //

/// Protocol for 2-row matrices.
public protocol SIMDMatrixNx2Protocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrixNx2StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx3Protocol
// -------------------------------------------------------------------------- //

/// Protocol for 3-row matrices.
public protocol SIMDMatrixNx3Protocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrixNx3StorageProtocol {
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx4Protocol
// -------------------------------------------------------------------------- //

/// Protocol for 4-row matrices.
public protocol SIMDMatrixNx4Protocol : SIMDMatrixProtocol
  where
  Storage: SIMDMatrixNx4StorageProtocol {
  
}

