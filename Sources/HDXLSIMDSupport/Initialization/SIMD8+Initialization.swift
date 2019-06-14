//
//  SIMD8+Initialization.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

public extension SIMD8 where Scalar:BinaryInteger {
  
  /// Initialize to zero except for`a`.
  @inlinable
  init(a: Scalar) {
    self.init(
      value: a,
      at: 0
    )
  }
  
  /// Initialize to zero except for`b`.
  @inlinable
  init(b: Scalar) {
    self.init(
      value: b,
      at: 1
    )
  }
  
  /// Initialize to zero except for`c`.
  @inlinable
  init(c: Scalar) {
    self.init(
      value: c,
      at: 2
    )
  }
  
  /// Initialize to zero except for`d`.
  @inlinable
  init(d: Scalar) {
    self.init(
      value: d,
      at: 3
    )
  }
  
  /// Initialize to zero except for`e`.
  @inlinable
  init(e: Scalar) {
    self.init(
      value: e,
      at: 4
    )
  }
  
  /// Initialize to zero except for`f`.
  @inlinable
  init(f: Scalar) {
    self.init(
      value: f,
      at: 5
    )
  }
  
  /// Initialize to zero except for`g`.
  @inlinable
  init(g: Scalar) {
    self.init(
      value: g,
      at: 6
    )
  }
  
  /// Initialize to zero except for`h`.
  @inlinable
  init(h: Scalar) {
    self.init(
      value: h,
      at: 7
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

public extension SIMD8 where Scalar:BinaryFloatingPoint {
  
  /// Initialize to zero except for`a`.
  @inlinable
  init(a: Scalar) {
    self.init(
      value: a,
      at: 0
    )
  }
  
  /// Initialize to zero except for`b`.
  @inlinable
  init(b: Scalar) {
    self.init(
      value: b,
      at: 1
    )
  }
  
  /// Initialize to zero except for`c`.
  @inlinable
  init(c: Scalar) {
    self.init(
      value: c,
      at: 2
    )
  }
  
  /// Initialize to zero except for`d`.
  @inlinable
  init(d: Scalar) {
    self.init(
      value: d,
      at: 3
    )
  }
  
  /// Initialize to zero except for`e`.
  @inlinable
  init(e: Scalar) {
    self.init(
      value: e,
      at: 4
    )
  }
  
  /// Initialize to zero except for`f`.
  @inlinable
  init(f: Scalar) {
    self.init(
      value: f,
      at: 5
    )
  }
  
  /// Initialize to zero except for`g`.
  @inlinable
  init(g: Scalar) {
    self.init(
      value: g,
      at: 6
    )
  }
  
  /// Initialize to zero except for`h`.
  @inlinable
  init(h: Scalar) {
    self.init(
      value: h,
      at: 7
    )
  }
    
}
