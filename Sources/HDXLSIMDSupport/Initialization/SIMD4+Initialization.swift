//
//  SIMD4+Initialization.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD4 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

public extension SIMD4 where Scalar:BinaryInteger {
  
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
  
  /// Initialize to zero except for`z`.
  @inlinable
  init(z: Scalar) {
    self.init(
      value: z,
      at: 2
    )
  }

  /// Initialize to zero except for`w`.
  @inlinable
  init(w: Scalar) {
    self.init(
      value: w,
      at: 3
    )
  }

}

// -------------------------------------------------------------------------- //
// MARK: SIMD4 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

public extension SIMD4 where Scalar:BinaryFloatingPoint {
  
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
  
  /// Initialize to zero except for`z`.
  @inlinable
  init(z: Scalar) {
    self.init(
      value: z,
      at: 2
    )
  }

  /// Initialize to zero except for`w`.
  @inlinable
  init(w: Scalar) {
    self.init(
      value: w,
      at: 3
    )
  }

}
