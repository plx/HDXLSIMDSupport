import Foundation
import simd

extension SIMD where Scalar: FloatingPoint {
  @inlinable
  func absoluteValue() -> Self {
    return self.replacing(
      with: -self,
      where: self .< .zero
    )
  }
}
