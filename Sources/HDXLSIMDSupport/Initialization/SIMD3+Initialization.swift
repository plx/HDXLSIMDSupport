import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD3 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

extension SIMD3 where Scalar:BinaryInteger {
  
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
  
  /// Initialize to zero except for`z`.
  @inlinable
  public init(z: Scalar) {
    self.init(
      value: z,
      at: 2
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD3 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

extension SIMD3 where Scalar:BinaryFloatingPoint {
  
  /// Initialize to zero except for`x`.
  @inlinable
  public init(x: Scalar) {
    self.init(
      value: x,
      at: 0
    )
  }

  /// Initialize to zero except for`x`.
  @inlinable
  public init(y: Scalar) {
    self.init(
      value: y,
      at: 1
    )
  }

  /// Initialize to zero except for`z`.
  @inlinable
  public init(z: Scalar) {
    self.init(
      value: z,
      at: 2
    )
  }

}
