//
//  QuaternionDistanceSanityTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class QuaternionDistanceSanityTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Component Construction Helper
  // ------------------------------------------------------------------------ //

  /// Construct a quaternion whose only nonzero component is at `componentIndex`,
  /// where 0=real, 1=i, 2=j, 3=k.
  private func singleComponentQuaternion<Q>(
    _ quaternionType: Q.Type,
    at componentIndex: Int,
    value: Q.Scalar
  ) -> Q where Q: QuaternionProtocol {
    precondition((0...3).contains(componentIndex))
    return Q(
      i: componentIndex == 1 ? value : 0,
      j: componentIndex == 2 ? value : 0,
      k: componentIndex == 3 ? value : 0,
      real: componentIndex == 0 ? value : 0
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Individual Validators
  // ------------------------------------------------------------------------ //
  //
  // Each helper takes `l1` / `lInf` closures so the aggregate can exercise the
  // same sanity battery against both the canonical methods and the generic
  // reference (`_l1Distance` / `_lInfinityDistance`).

  /// Sanity check: zero/self-distance is zero.
  internal func validateSelfDistanceIsZero<Q>(
    forQuaternion quaternion: Q.Type,
    using label: String,
    l1: (Q, Q) -> Q.Scalar,
    lInf: (Q, Q) -> Q.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let zero = Q()
    XCTAssertEqual(
      l1(zero, zero),
      0,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `l1(zero, zero) == 0`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(zero, zero),
      0,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `lInf(zero, zero) == 0`.",
      file: file,
      line: line
    )

    let populated = Q(i: 1, j: 2, k: 3, real: 4)
    XCTAssertEqual(
      l1(populated, populated),
      0,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `l1(populated, populated) == 0`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(populated, populated),
      0,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `lInf(populated, populated) == 0`.",
      file: file,
      line: line
    )
  }

  /// For each `(componentIndex, value)`, the quaternion with that single nonzero
  /// component must be exactly `|value|` away from the zero quaternion in L1
  /// and L∞.
  internal func validateSingleComponentDistanceFromZero<Q>(
    forQuaternion quaternion: Q.Type,
    using label: String,
    l1: (Q, Q) -> Q.Scalar,
    lInf: (Q, Q) -> Q.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let zero = Q()
    let values: [Q.Scalar] = [1, -1, 2, -2]
    for componentIndex in 0...3 {
      for value in values {
        let single = self.singleComponentQuaternion(
          quaternion,
          at: componentIndex,
          value: value
        )
        let expected = abs(value)

        XCTAssertEqual(
          l1(single, zero),
          expected,
          "[\(label)] `\(String(reflecting: quaternion))` component \(componentIndex) value \(value): expected `l1(single, zero) == \(expected)`.",
          file: file,
          line: line
        )
        XCTAssertEqual(
          lInf(single, zero),
          expected,
          "[\(label)] `\(String(reflecting: quaternion))` component \(componentIndex) value \(value): expected `lInf(single, zero) == \(expected)`.",
          file: file,
          line: line
        )
        XCTAssertEqual(
          l1(zero, single),
          expected,
          "[\(label)] `\(String(reflecting: quaternion))` component \(componentIndex) value \(value): expected `l1(zero, single) == \(expected)` (symmetric).",
          file: file,
          line: line
        )
        XCTAssertEqual(
          lInf(zero, single),
          expected,
          "[\(label)] `\(String(reflecting: quaternion))` component \(componentIndex) value \(value): expected `lInf(zero, single) == \(expected)` (symmetric).",
          file: file,
          line: line
        )
      }
    }
  }

  /// Cartesian sweep of single-component quaternions against each other.
  ///
  /// - same component: L1 = L∞ = `|v₁ - v₂|`
  /// - distinct components: L1 = `|v₁| + |v₂|`, L∞ = `max(|v₁|, |v₂|)`
  internal func validateSingleComponentPairDistances<Q>(
    forQuaternion quaternion: Q.Type,
    using label: String,
    l1: (Q, Q) -> Q.Scalar,
    lInf: (Q, Q) -> Q.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let values: [Q.Scalar] = [1, -1]
    for c1 in 0...3 {
      for value1 in values {
        let q1 = self.singleComponentQuaternion(quaternion, at: c1, value: value1)
        for c2 in 0...3 {
          for value2 in values {
            let q2 = self.singleComponentQuaternion(quaternion, at: c2, value: value2)

            let expectedL1: Q.Scalar
            let expectedLInf: Q.Scalar
            if c1 == c2 {
              let diff = abs(value1 - value2)
              expectedL1 = diff
              expectedLInf = diff
            } else {
              let a1 = abs(value1)
              let a2 = abs(value2)
              expectedL1 = a1 + a2
              expectedLInf = max(a1, a2)
            }

            XCTAssertEqual(
              l1(q1, q2),
              expectedL1,
              "[\(label)] `\(String(reflecting: quaternion))`: q1@\(c1)=\(value1), q2@\(c2)=\(value2): expected `l1 == \(expectedL1)`.",
              file: file,
              line: line
            )
            XCTAssertEqual(
              lInf(q1, q2),
              expectedLInf,
              "[\(label)] `\(String(reflecting: quaternion))`: q1@\(c1)=\(value1), q2@\(c2)=\(value2): expected `lInf == \(expectedLInf)`.",
              file: file,
              line: line
            )
          }
        }
      }
    }
  }

  /// All four components = 1: L1 distance to zero should be 4; L∞ should be 1.
  internal func validateFullyPopulatedDistanceFromZero<Q>(
    forQuaternion quaternion: Q.Type,
    using label: String,
    l1: (Q, Q) -> Q.Scalar,
    lInf: (Q, Q) -> Q.Scalar,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let zero = Q()
    let ones = Q(i: 1, j: 1, k: 1, real: 1)

    XCTAssertEqual(
      l1(ones, zero),
      4,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `l1(ones, zero) == 4`.",
      file: file,
      line: line
    )
    XCTAssertEqual(
      lInf(ones, zero),
      1,
      "[\(label)] `\(String(reflecting: quaternion))`: expected `lInf(ones, zero) == 1`.",
      file: file,
      line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Cross-Check
  // ------------------------------------------------------------------------ //

  /// For each `(a, b)` in a deterministic sweep, assert that the canonical
  /// methods and the generic reference agree within epsilon.
  internal func validateGenericMatchesCanonical<Q>(
    forQuaternion quaternion: Q.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let epsilon = Q.Scalar.validationTestTolerance

    func compare(
      _ a: Q,
      _ b: Q,
      scenario: @autoclosure () -> String
    ) {
      let canonicalL1 = a.l1Distance(to: b)
      let genericL1 = a._l1Distance(to: b)
      XCTAssertEqual(
        canonicalL1,
        genericL1,
        accuracy: epsilon,
        "`\(String(reflecting: quaternion))` (l1 cross-check, \(scenario())): canonical \(canonicalL1) vs generic \(genericL1).",
        file: file,
        line: line
      )

      let canonicalLInf = a.lInfinityDistance(to: b)
      let genericLInf = a._lInfinityDistance(to: b)
      XCTAssertEqual(
        canonicalLInf,
        genericLInf,
        accuracy: epsilon,
        "`\(String(reflecting: quaternion))` (lInf cross-check, \(scenario())): canonical \(canonicalLInf) vs generic \(genericLInf).",
        file: file,
        line: line
      )
    }

    let zero = Q()
    compare(zero, zero, scenario: "zero-zero")

    let values: [Q.Scalar] = [1, -1, 2, -2]
    for componentIndex in 0...3 {
      for value in values {
        let single = self.singleComponentQuaternion(
          quaternion,
          at: componentIndex,
          value: value
        )
        compare(single, zero, scenario: "single@\(componentIndex)=\(value), zero")
        compare(zero, single, scenario: "zero, single@\(componentIndex)=\(value)")
      }
    }

    let ones = Q(i: 1, j: 1, k: 1, real: 1)
    compare(ones, zero, scenario: "ones, zero")
    compare(zero, ones, scenario: "zero, ones")

    let ramped = Q(i: 1, j: 2, k: 3, real: 4)
    compare(ramped, zero, scenario: "ramped, zero")
    compare(ramped, ones, scenario: "ramped, ones")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Aggregate Validator
  // ------------------------------------------------------------------------ //

  internal func validateQuaternionDistanceFunctions<Q>(
    forQuaternion quaternion: Q.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Q: QuaternionProtocol,
    Q: L1DistanceMeasureable,
    Q: LInfinityDistanceMeasureable,
    Q.L1Distance == Q.Scalar,
    Q.LInfinityDistance == Q.Scalar
  {
    let canonicalL1: (Q, Q) -> Q.Scalar = { $0.l1Distance(to: $1) }
    let canonicalLInf: (Q, Q) -> Q.Scalar = { $0.lInfinityDistance(to: $1) }
    let genericL1: (Q, Q) -> Q.Scalar = { $0._l1Distance(to: $1) }
    let genericLInf: (Q, Q) -> Q.Scalar = { $0._lInfinityDistance(to: $1) }

    for (label, l1, lInf) in [
      ("canonical", canonicalL1, canonicalLInf),
      ("generic", genericL1, genericLInf)
    ] {
      self.validateSelfDistanceIsZero(
        forQuaternion: quaternion,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateFullyPopulatedDistanceFromZero(
        forQuaternion: quaternion,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateSingleComponentDistanceFromZero(
        forQuaternion: quaternion,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
      self.validateSingleComponentPairDistances(
        forQuaternion: quaternion,
        using: label,
        l1: l1,
        lInf: lInf,
        file: file,
        line: line
      )
    }

    self.validateGenericMatchesCanonical(
      forQuaternion: quaternion,
      file: file,
      line: line
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Test Method
  // ------------------------------------------------------------------------ //

  func testQuaternion() {
    self.validateQuaternionDistanceFunctions(forQuaternion: simd_quatd.self)
    self.validateQuaternionDistanceFunctions(forQuaternion: simd_quatf.self)
    self.validateQuaternionDistanceFunctions(forQuaternion: simd_quath.self)
    self.validateQuaternionDistanceFunctions(forQuaternion: Quaternion<Double>.self)
    self.validateQuaternionDistanceFunctions(forQuaternion: Quaternion<Float>.self)
    self.validateQuaternionDistanceFunctions(forQuaternion: Quaternion<Float16>.self)
  }

}
