import Foundation
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Generic Reference Implementations
// -------------------------------------------------------------------------- //
//
// `_l1Distance` / `_lInfinityDistance` iterate over `Self.matrixPositions`
// using the scalar position subscript. They are correct for every shape, but
// touch one scalar at a time and so defeat SIMD vectorization. Concrete types
// are expected to override the canonical `l1Distance` / `lInfinityDistance`
// methods with SIMD-friendly variants; the underscored helpers stay reachable
// so tests can cross-check the two implementations against each other.

extension MatrixProtocol where
  Self: L1DistanceMeasureable,
  Scalar == L1Distance
{
  func _l1Distance(to other: Self) -> L1Distance {
    var distance: L1Distance = 0
    for position in Self.matrixPositions {
      distance += abs(
        self[position: position] - other[position: position]
      )
    }
    return distance
  }
}

extension MatrixProtocol where
  Self: LInfinityDistanceMeasureable,
  Scalar == LInfinityDistance
{
  func _lInfinityDistance(to other: Self) -> LInfinityDistance {
    return Self.matrixPositions.lazy.map { position in
      abs(
        self[position: position] - other[position: position]
      )
    }.max() ?? 0
  }
}

// -------------------------------------------------------------------------- //
// MARK: Default Delegations
// -------------------------------------------------------------------------- //
//
// Types that do not provide their own `l1Distance` / `lInfinityDistance`
// inherit these, which forward to the generic reference.

extension MatrixProtocol where
  Self: L1DistanceMeasureable,
  Scalar == L1Distance
{
  func l1Distance(to other: Self) -> L1Distance {
    return _l1Distance(to: other)
  }
}

extension MatrixProtocol where
  Self: LInfinityDistanceMeasureable,
  Scalar == LInfinityDistance
{
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return _lInfinityDistance(to: other)
  }
}

// -------------------------------------------------------------------------- //
// MARK: Wrapper Conformances
// -------------------------------------------------------------------------- //
//
// `Matrix*x*<Scalar>` types adopt the generic reference by default. The
// per-shape SIMD-friendly implementations live on the underlying native
// `simd_*` types in `Double/Float/HalfMatrices.swift`.

extension Matrix2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
