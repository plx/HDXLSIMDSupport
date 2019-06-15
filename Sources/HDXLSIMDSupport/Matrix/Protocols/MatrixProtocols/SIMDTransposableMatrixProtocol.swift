//
//  SIMDTransposableMatrixProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDTransposableMatrixProtocol - Definition
// -------------------------------------------------------------------------- //

/// Protocol for storage-backed transposable SIMD matrices; exists to offer default implementations to conformers.
public protocol SIMDTransposableMatrixProtocol : SIMDMatrixProtocol
  where
  Storage: SIMDTransposableMatrixStorageProtocol {
  
  typealias TransposeStorage = Storage.TransposeStorage
  associatedtype Transpose: SIMDTransposableMatrixProtocol
    where
    Transpose.Storage == TransposeStorage,
    Transpose.TransposeStorage == Storage
    
  var transpose: Transpose { get }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDTransposableMatrixProtocol - Default Implementations
// -------------------------------------------------------------------------- //

public extension SIMDTransposableMatrixProtocol {
  
  @inlinable
  var transpose: Transpose {
    get {
      return Transpose(
        storage: self.storage.transpose
      )
    }
  }
  
}
