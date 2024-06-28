import Foundation
import simd

extension simd_float2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float
  

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }
  
}

extension simd_float3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  
  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }

}

extension simd_float4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
      +
      these[3].l1Distance(to: those[3])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2]),
      these[3].lInfinityDistance(to: those[3])
    )
  }
  
}

extension simd_float2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  
  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }
  
}

extension simd_float3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  
  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }
  
}

extension simd_float4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
      +
      these[3].l1Distance(to: those[3])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2]),
      these[3].lInfinityDistance(to: those[3])
    )
  }
  
}

extension simd_float2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }
  
}

extension simd_float3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }
  
}

extension simd_float4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
      +
      these[2].l1Distance(to: those[2])
      +
      these[3].l1Distance(to: those[3])
    )
  }
  
  func lInfinityDistance(to other: Self) -> Float {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2]),
      these[3].lInfinityDistance(to: those[3])
    )
  }

}
