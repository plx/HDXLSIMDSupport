import Foundation
import simd

extension SIMD where Scalar:BinaryInteger {
  
  /// Initialize to zero, except with `value` at `index`.
  @inlinable
  public init(
    value: Scalar,
    at index: Int
  ) {
    precondition(Self.canSubscript(at: index))
    self.init(repeating: 0)
    self[index] = value
  }
  
}

extension SIMD where Scalar:BinaryFloatingPoint {

  /// Initialize to zero, except with `value` at `index`.
  @inlinable
  public init(
    value: Scalar,
    at index: Int
  ) {
    precondition(Self.canSubscript(at: index))
    self.init(repeating: 0)
    self[index] = value
  }

}
