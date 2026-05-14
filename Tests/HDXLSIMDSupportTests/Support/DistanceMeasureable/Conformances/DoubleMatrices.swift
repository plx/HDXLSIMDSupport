import Foundation
import simd

// Each native `simd_double*x*` matrix is column-major: its `columns` tuple is
// a tuple of `SIMD<M, Double>` vectors. We compute distances by issuing one
// SIMD subtract per column, taking the componentwise absolute value, and then
// horizontally reducing (sum for L1, max for L∞) across the resulting vectors.
//
// These hand-written implementations are cross-checked against the generic
// reference (`_l1Distance` / `_lInfinityDistance`) in the sanity tests.

// MARK: 2-column shapes

extension simd_double2x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_double2x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

extension simd_double2x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max()
    )
  }
}

// MARK: 3-column shapes

extension simd_double3x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_double3x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return max(
      (lhs.0 - rhs.0).absoluteValue().max(),
      (lhs.1 - rhs.1).absoluteValue().max(),
      (lhs.2 - rhs.2).absoluteValue().max()
    )
  }
}

extension simd_double3x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
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

extension simd_double4x2: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
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

extension simd_double4x3: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
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

extension simd_double4x4: L1DistanceMeasureable, LInfinityDistanceMeasureable {
  typealias L1Distance = Double
  typealias LInfinityDistance = Double

  func l1Distance(to other: Self) -> Double {
    let lhs = self.columns
    let rhs = other.columns
    return (
      (lhs.0 - rhs.0).absoluteValue().sum()
      + (lhs.1 - rhs.1).absoluteValue().sum()
      + (lhs.2 - rhs.2).absoluteValue().sum()
      + (lhs.3 - rhs.3).absoluteValue().sum()
    )
  }

  func lInfinityDistance(to other: Self) -> Double {
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
