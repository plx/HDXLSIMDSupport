import Foundation
@testable import HDXLSIMDSupport

extension MatrixProtocol where
  Self: L1DistanceMeasureable,
  Scalar == L1Distance
{
  func l1Distance(to other: Self) -> L1Distance {
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
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return Self.matrixPositions.lazy.map { position in
      abs(
        self[position: position] - other[position: position]
      )
    }.max() ?? 0
  }
  
}

extension Matrix2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
extension Matrix4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable { }
