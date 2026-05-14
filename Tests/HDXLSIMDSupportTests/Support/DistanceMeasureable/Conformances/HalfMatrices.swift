import Foundation
import simd

// SIMD-friendly hand-written L1 / L∞ distance implementations for the native
// half-precision matrix types. See `DoubleMatrices.swift` for the rationale.

// MARK: 2-column shapes

extension simd_half2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_half2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_half2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

// MARK: 3-column shapes

extension simd_half3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_half3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_half3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

// MARK: 4-column shapes

extension simd_half4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max(),
      (lhs.3 - rhs.3).absoluteValue().max()
    )
  }
}

extension simd_half4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max(),
      (lhs.3 - rhs.3).absoluteValue().max()
    )
  }
}

extension simd_half4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float16
  typealias LInfinityDistance = Float16

  func l1Distance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float16 {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max(),
      (lhs.3 - rhs.3).absoluteValue().max()
    )
  }
}
