import Foundation
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Generic Reference Implementations
// -------------------------------------------------------------------------- //
//
// `_l1Distance` / `_lInfinityDistance` access the four quaternion components
// individually. They're correct for any conforming type but don't take
// advantage of SIMD reductions on the underlying 4-vector. Concrete types are
// expected to override the canonical methods with SIMD-friendly variants; the
// underscored helpers stay reachable so tests can cross-check the two.

extension QuaternionProtocol where
  Self: L1DistanceMeasureable,
  Scalar == L1Distance
{
  func _l1Distance(to other: Self) -> L1Distance {
    return (
      abs(realComponent - other.realComponent)
      + abs(imaginaryComponent.x - other.imaginaryComponent.x)
      + abs(imaginaryComponent.y - other.imaginaryComponent.y)
      + abs(imaginaryComponent.z - other.imaginaryComponent.z)
    )
  }
}

extension QuaternionProtocol where
  Self: LInfinityDistanceMeasureable,
  Scalar == LInfinityDistance
{
  func _lInfinityDistance(to other: Self) -> LInfinityDistance {
    let r = abs(realComponent - other.realComponent)
    let x = abs(imaginaryComponent.x - other.imaginaryComponent.x)
    let y = abs(imaginaryComponent.y - other.imaginaryComponent.y)
    let z = abs(imaginaryComponent.z - other.imaginaryComponent.z)
    return max(r, x, y, z)
  }
}

// -------------------------------------------------------------------------- //
// MARK: Default Delegations
// -------------------------------------------------------------------------- //

extension QuaternionProtocol where
  Self: L1DistanceMeasureable,
  Scalar == L1Distance
{
  func l1Distance(to other: Self) -> L1Distance {
    return _l1Distance(to: other)
  }
}

extension QuaternionProtocol where
  Self: LInfinityDistanceMeasureable,
  Scalar == LInfinityDistance
{
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return _lInfinityDistance(to: other)
  }
}

// -------------------------------------------------------------------------- //
// MARK: Wrapper Conformance
// -------------------------------------------------------------------------- //
//
// `Quaternion<Scalar>` uses the generic reference by default. The
// SIMD-friendly per-representation implementations live on the underlying
// `simd_quat*` types below.

extension Quaternion: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Scalar
  typealias LInfinityDistance = Scalar
}

// -------------------------------------------------------------------------- //
// MARK: simd_quat* SIMD-Friendly Hand-Written
// -------------------------------------------------------------------------- //
//
// Each native quaternion stores its components in a `vector: SIMD4`, with the
// real part in the `w` lane. A single SIMD subtraction + componentwise
// absolute value, followed by a SIMD horizontal reduction, computes either
// distance in one pass.

extension simd_quatf: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    return (vector - other.vector).absoluteValue().sum()
  }

  func lInfinityDistance(to other: Self) -> Float {
    return (vector - other.vector).absoluteValue().max()
  }
}

extension simd_quatd: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    return (vector - other.vector).absoluteValue().sum()
  }

  func lInfinityDistance(to other: Self) -> Double {
    return (vector - other.vector).absoluteValue().max()
  }
}

extension simd_quath: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    return (vector - other.vector).absoluteValue().sum()
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    return (vector - other.vector).absoluteValue().max()
  }
}
