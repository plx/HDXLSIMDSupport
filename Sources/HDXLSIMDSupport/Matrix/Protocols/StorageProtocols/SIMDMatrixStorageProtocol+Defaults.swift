//
//  SIMDMatrixStorageProtocol+Defaults.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixStorageProtocol - Defaults
// -------------------------------------------------------------------------- //

public extension SIMDMatrixStorageProtocol {
  
  @inlinable
  var linearizedScalarValues: [Scalar] {
    get {
      var result: [Scalar] = []
      result.reserveCapacity(Self.scalarCount)
      for scalarIndex in 0..<Self.scalarCount {
        result.append(self[scalarIndex: scalarIndex])
      }
      return result
    }
  }
  
  @inlinable
  subscript(scalarIndex scalarIndex: Int) -> Scalar {
    get {
      return self[
        columnIndex: (scalarIndex / Self.columnCount),
        rowIndex: (scalarIndex % Self.columnCount)
      ]
    }
    set {
      self[
        columnIndex: (scalarIndex / Self.columnCount),
        rowIndex: (scalarIndex % Self.columnCount)
        ] = newValue
    }
  }
  
  
  /// Define matrix-scalar `/` once, using `*` by `1.0/rhs`.
  @inlinable
  static func / (lhs: Self, rhs: Scalar) -> Self {
    precondition(rhs.isNonZero)
    return lhs * (1.0/rhs)
  }
  
  /// Define matrix-scalar `/=` once, using `*=` by `1.0/rhs`.
  @inlinable
  static func /= (lhs: inout Self, rhs: Scalar) {
    precondition(rhs.isNonZero)
    lhs *= (1.0/rhs)
  }
  
}
