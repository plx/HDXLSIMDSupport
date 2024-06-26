import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

extension SIMD2 where Scalar:BinaryInteger {
  
  /// Initialize to zero except for`x`.
  @inlinable
  public init(x: Scalar) {
    self.init(
      value: x,
      at: 0
    )
  }

  /// Initialize to zero except for`y`.
  @inlinable
  public init(y: Scalar) {
    self.init(
      value: y,
      at: 1
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

extension SIMD2 where Scalar:BinaryFloatingPoint {
  
  /// Initialize to zero except for`x`.
  @inlinable
  public init(x: Scalar) {
    self.init(
      value: x,
      at: 0
    )
  }
  
  /// Initialize to zero except for`y`.
  @inlinable
  public init(y: Scalar) {
    self.init(
      value: y,
      at: 1
    )
  }
  
}
