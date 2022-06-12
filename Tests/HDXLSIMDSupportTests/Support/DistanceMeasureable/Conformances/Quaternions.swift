import Foundation
import simd
@testable import HDXLSIMDSupport

extension QuaternionProtocol where
Self: L1DistanceMeasureable,
Scalar == L1Distance
{
  func l1Distance(to other: Self) -> L1Distance {
    return (
      abs(realComponent - other.realComponent)
      +
      imaginaryComponent.l1Distance(to: other.imaginaryComponent)
    )
  }
}

extension QuaternionProtocol where
Self: LInfinityDistanceMeasureable,
Scalar == LInfinityDistance
{
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return max(
      abs(realComponent - other.realComponent),
      imaginaryComponent.l1Distance(to: other.imaginaryComponent)
    )
  }
}

extension Quaternion: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Scalar
  typealias LInfinityDistance = Scalar
}

extension simd_quatf: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float
  
  func l1Distance(to other: Self) -> Float {
    return abs(real - other.real) + imag.l1Distance(to: other.imag)
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    return max(
      abs(real - other.real),
      imag.lInfinityDistance(to: other.imag)
    )
  }
}

extension simd_quatd: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double
  
  func l1Distance(to other: Self) -> Double {
    return abs(real - other.real) + imag.l1Distance(to: other.imag)
  }
  
  func lInfinityDistance(to other: Self) -> Double {
    return max(
      abs(real - other.real),
      imag.lInfinityDistance(to: other.imag)
    )
  }
}
