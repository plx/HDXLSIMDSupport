import Foundation
import simd

extension simd_half2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }

}

extension simd_half3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }

}

extension simd_half4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
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

extension simd_half2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }

}

extension simd_half3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }

}

extension simd_half4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
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

extension simd_half2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return (
      these[0].l1Distance(to: those[0])
      +
      these[1].l1Distance(to: those[1])
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1])
    )
  }

}

extension simd_half3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
    let these = self.rowVectors
    let those = other.rowVectors
    return max(
      these[0].lInfinityDistance(to: those[0]),
      these[1].lInfinityDistance(to: those[1]),
      these[2].lInfinityDistance(to: those[2])
    )
  }

}

extension simd_half4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {

  func l1Distance(to other: Self) -> Float16 {
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

  func lInfinityDistance(to other: Self) -> Float16 {
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
