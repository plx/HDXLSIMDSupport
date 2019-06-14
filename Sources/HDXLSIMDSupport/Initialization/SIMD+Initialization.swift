//
//  SIMD+Initialization.swift
//

import Foundation
import simd

public extension SIMD where Scalar:BinaryInteger {
  
  /// Initialize to zero, except with `value` at `index`.
  @inlinable
  init(
    value: Scalar,
    at index: Int) {
    precondition(Self.canSubscript(at: index))
    self.init(repeating: 0)
    self[index] = value
  }
  
}

public extension SIMD where Scalar:BinaryFloatingPoint {

  /// Initialize to zero, except with `value` at `index`.
  @inlinable
  init(
    value: Scalar,
    at index: Int) {
    precondition(Self.canSubscript(at: index))
    self.init(repeating: 0)
    self[index] = value
  }

}
