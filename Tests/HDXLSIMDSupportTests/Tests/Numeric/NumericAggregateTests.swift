//
//  NumericAggregateTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class NumericAggregateTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitBinaryFloatingPointPredicates() {
    // The scalar predicates are convenience names over zero/sign/finite checks.
    // These examples pin the boundary cases that tend to be confused: zero is
    // non-negative and non-positive, but neither strictly positive nor strictly
    // negative; infinities are signed but not finite.
    XCTAssertTrue(0.0.isZero)
    XCTAssertFalse(0.0.isNonZero)
    XCTAssertTrue(0.0.isNonNegative)
    XCTAssertTrue(0.0.isNonPositive)
    XCTAssertFalse(0.0.isStrictlyPositive)
    XCTAssertFalse(0.0.isStrictlyNegative)

    XCTAssertFalse(2.0.isZero)
    XCTAssertTrue(2.0.isNonZero)
    XCTAssertTrue(2.0.isStrictlyPositive)
    XCTAssertFalse(2.0.isStrictlyNegative)
    XCTAssertTrue(2.0.isFiniteNonZero)
    XCTAssertTrue(2.0.isFiniteStrictlyPositive)

    XCTAssertTrue((-2.0).isNonZero)
    XCTAssertTrue((-2.0).isStrictlyNegative)
    XCTAssertTrue((-2.0).isFiniteStrictlyNegative)
    XCTAssertFalse((-2.0).isStrictlyPositive)

    XCTAssertFalse(Double.infinity.isFiniteNonZero)
    XCTAssertFalse((-Double.infinity).isFiniteStrictlyNegative)
  }

  func testExplicitNumericAggregatePredicates() {
    // Aggregate predicates require all entries to satisfy the corresponding
    // scalar predicate. The examples use mixed-sign and all-positive vectors
    // to prove both the success path and the first failing entry path.
    let allPositive = SIMD4<Double>(1, 2, 3, 4)
    XCTAssertTrue(allPositive.allNumericEntriesSatisfy { $0 > 0 })
    XCTAssertTrue(allPositive.isFinite)
    XCTAssertTrue(allPositive.isNonZero)
    XCTAssertTrue(allPositive.isFiniteNonZero)
    XCTAssertTrue(allPositive.isNonNegative)
    XCTAssertTrue(allPositive.isStrictlyPositive)
    XCTAssertTrue(allPositive.isFiniteNonNegative)
    XCTAssertTrue(allPositive.isFiniteStrictlyPositive)
    XCTAssertFalse(allPositive.isZero)
    XCTAssertFalse(allPositive.isNonPositive)
    XCTAssertFalse(allPositive.isStrictlyNegative)

    let mixed = SIMD4<Double>(1, 0, -3, Double.infinity)
    XCTAssertFalse(mixed.allNumericEntriesSatisfy { $0 > 0 })
    XCTAssertFalse(mixed.isFinite)
    XCTAssertFalse(mixed.isNonZero)
    XCTAssertFalse(mixed.isFiniteNonZero)
    XCTAssertFalse(mixed.isNonNegative)
    XCTAssertFalse(mixed.isNonPositive)
    XCTAssertFalse(mixed.isStrictlyPositive)
    XCTAssertFalse(mixed.isStrictlyNegative)
    XCTAssertFalse(mixed.isFiniteNonNegative)
    XCTAssertFalse(mixed.isFiniteStrictlyPositive)
    XCTAssertFalse(mixed.isFiniteNonPositive)
    XCTAssertFalse(mixed.isFiniteStrictlyNegative)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testBinaryFloatingPointPredicatesMatchStandardComparisons() {
    let values: [Double] = [
      -Double.infinity,
      -3,
      -Double.leastNonzeroMagnitude,
      -0.0,
      0.0,
      Double.leastNonzeroMagnitude,
      3,
      Double.infinity,
      Double.nan
    ]

    for value in values {
      XCTAssertEqual(value.isZero, value == 0)
      XCTAssertEqual(value.isNonZero, value != 0)
      XCTAssertEqual(value.isNonPositive, value <= 0)
      XCTAssertEqual(value.isNonNegative, value >= 0)
      XCTAssertEqual(value.isStrictlyPositive, value > 0)
      XCTAssertEqual(value.isStrictlyNegative, value < 0)
      XCTAssertEqual(value.isFiniteNonZero, value.isFinite && value != 0)
      XCTAssertEqual(value.isFiniteNonPositive, value.isFinite && value <= 0)
      XCTAssertEqual(value.isFiniteNonNegative, value.isFinite && value >= 0)
      XCTAssertEqual(value.isFiniteStrictlyPositive, value.isFinite && value > 0)
      XCTAssertEqual(value.isFiniteStrictlyNegative, value.isFinite && value < 0)
    }
  }

  func testSIMDNumericAggregateConformancesAcrossWidths() {
    assertNumericAggregate(
      SIMD2<Double>(repeating: 2),
      failingAt: 1
    )
    assertNumericAggregate(
      SIMD3<Double>(repeating: 2),
      failingAt: 2
    )
    assertNumericAggregate(
      SIMD4<Double>(repeating: 2),
      failingAt: 3
    )
    assertNumericAggregate(
      SIMD8<Double>(repeating: 2),
      failingAt: 7
    )
    assertNumericAggregate(
      SIMD16<Double>(repeating: 2),
      failingAt: 15
    )
    assertNumericAggregate(
      SIMD32<Double>(repeating: 2),
      failingAt: 31
    )
    assertNumericAggregate(
      SIMD64<Double>(repeating: 2),
      failingAt: 63
    )
  }

  func testNumericAggregateFloatingPointPredicatesMatchAllEntries() {
    let cases: [[Double]] = [
      [0, 0, 0, 0],
      [1, 2, 3, 4],
      [-1, -2, -3, -4],
      [1, 0, 3, 4],
      [1, 2, Double.infinity, 4],
      [-1, -2, -Double.infinity, -4]
    ]

    for values in cases {
      let vector = SIMD4<Double>(
        values[0],
        values[1],
        values[2],
        values[3]
      )
      XCTAssertEqual(vector.isFinite, values.allSatisfy { $0.isFinite })
      XCTAssertEqual(vector.isZero, values.allSatisfy { $0.isZero })
      XCTAssertEqual(vector.isNonZero, values.allSatisfy { $0.isNonZero })
      XCTAssertEqual(vector.isFiniteNonZero, values.allSatisfy { $0.isFiniteNonZero })
      XCTAssertEqual(vector.isNonNegative, values.allSatisfy { $0.isNonNegative })
      XCTAssertEqual(vector.isNonPositive, values.allSatisfy { $0.isNonPositive })
      XCTAssertEqual(vector.isStrictlyPositive, values.allSatisfy { $0.isStrictlyPositive })
      XCTAssertEqual(vector.isStrictlyNegative, values.allSatisfy { $0.isStrictlyNegative })
      XCTAssertEqual(vector.isFiniteNonNegative, values.allSatisfy { $0.isFiniteNonNegative })
      XCTAssertEqual(vector.isFiniteStrictlyPositive, values.allSatisfy { $0.isFiniteStrictlyPositive })
      XCTAssertEqual(vector.isFiniteNonPositive, values.allSatisfy { $0.isFiniteNonPositive })
      XCTAssertEqual(vector.isFiniteStrictlyNegative, values.allSatisfy { $0.isFiniteStrictlyNegative })
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func assertNumericAggregate<Vector>(
    _ allPositive: Vector,
    failingAt failingIndex: Int,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Vector: SIMD & NumericAggregate,
    Vector.Scalar == Double,
    Vector.NumericEntryRepresentation == Double
  {
    XCTAssertTrue(
      allPositive.allNumericEntriesSatisfy { $0 > 0 },
      file: file,
      line: line
    )

    var withFailure = allPositive
    withFailure[failingIndex] = -1
    XCTAssertFalse(
      withFailure.allNumericEntriesSatisfy { $0 > 0 },
      file: file,
      line: line
    )
  }

}
