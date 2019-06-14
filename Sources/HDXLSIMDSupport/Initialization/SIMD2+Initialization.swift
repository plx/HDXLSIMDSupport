//
//  SIMD2+Initialization.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

public extension SIMD2 where Scalar:BinaryInteger {
  
  /// Initialize to zero except for`x`.
  @inlinable
  init(x: Scalar) {
    self.init(
      value: x,
      at: 0
    )
  }

  /// Initialize to zero except for`y`.
  @inlinable
  init(y: Scalar) {
    self.init(
      value: y,
      at: 1
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

public extension SIMD2 where Scalar:BinaryFloatingPoint {
  
  /// Initialize to zero except for`x`.
  @inlinable
  init(x: Scalar) {
    self.init(
      value: x,
      at: 0
    )
  }
  
  /// Initialize to zero except for`y`.
  @inlinable
  init(y: Scalar) {
    self.init(
      value: y,
      at: 1
    )
  }
  
}
