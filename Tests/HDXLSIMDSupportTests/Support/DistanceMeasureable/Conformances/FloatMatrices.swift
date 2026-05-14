import Foundation
import simd

// SIMD-friendly hand-written L1 / L∞ distance implementations for the native
// single-precision matrix types. See `DoubleMatrices.swift` for the rationale.

// MARK: 2-column shapes

extension simd_float2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_float2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_float2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

// MARK: 3-column shapes

extension simd_float3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_float3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_float3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
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

extension simd_float4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
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

extension simd_float4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
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

extension simd_float4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Float
  typealias LInfinityDistance = Float

  func l1Distance(to other: Self) -> Float {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Float {
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
