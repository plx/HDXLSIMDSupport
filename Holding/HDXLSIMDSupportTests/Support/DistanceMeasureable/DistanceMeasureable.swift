import Foundation

protocol L1DistanceMeasureable<L1Distance> {
  associatedtype L1Distance: BinaryFloatingPoint
  
  func l1Distance(to other: Self) -> L1Distance
  
}

extension L1DistanceMeasureable {
  @inlinable
  func isWithinL1Distance(
    _ epsilon: L1Distance,
    of other: Self
  ) -> Bool {
    return abs(l1Distance(to: other)) < epsilon
  }
}

protocol LInfinityDistanceMeasureable<LInfinityDistance> {
  associatedtype LInfinityDistance: BinaryFloatingPoint
  
  func lInfinityDistance(to other: Self) -> LInfinityDistance
  
}

extension LInfinityDistanceMeasureable {
  @inlinable
  func isWithinLInfinityDistance(
    _ epsilon: LInfinityDistance,
    of other: Self
  ) -> Bool {
    return abs(lInfinityDistance(to: other)) < epsilon
  }
}
