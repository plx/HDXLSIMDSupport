import Foundation
import simd

//extension SIMD where
//  Self: L1DistanceMeasureable,
//  Self: LInfinityDistanceMeasureable,
//  Scalar == L1Distance,
//  Scalar == LInfinityDistance,
//  MaskStorage == MaskStorage.MaskStorage
//{
//  func l1Distance(to other: Self) -> L1Distance {
//    return (self - other).absoluteValue().sum()
//  }
//  
//  func lInfinityDistance(to other: Self) -> LInfinityDistance {
//    return (self - other).absoluteValue().max()
//  }
//}

extension SIMD2: L1DistanceMeasureable, LInfinityDistanceMeasureable where Scalar: BinaryFloatingPoint {
  typealias L1Distance = Scalar
  typealias LInfinityDistance = Scalar
  
  func l1Distance(to other: Self) -> L1Distance {
    return (self - other).absoluteValue().sum()
  }
  
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return (self - other).absoluteValue().max()
  }
}

extension SIMD3: L1DistanceMeasureable, LInfinityDistanceMeasureable where Scalar: BinaryFloatingPoint {
  typealias L1Distance = Scalar
  typealias LInfinityDistance = Scalar
  
  func l1Distance(to other: Self) -> L1Distance {
    return (self - other).absoluteValue().sum()
  }
  
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return (self - other).absoluteValue().max()
  }
}

extension SIMD4: L1DistanceMeasureable, LInfinityDistanceMeasureable where Scalar: BinaryFloatingPoint {
  typealias L1Distance = Scalar
  typealias LInfinityDistance = Scalar
  
  func l1Distance(to other: Self) -> L1Distance {
    return (self - other).absoluteValue().sum()
  }
  
  func lInfinityDistance(to other: Self) -> LInfinityDistance {
    return (self - other).absoluteValue().max()
  }
}
