//
//  SIMDInitializationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class SIMDInitializationTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitSingleLaneIntegerInitializers() {
    // Each lane-label initializer should produce a sparse vector with exactly
    // the named lane populated. These examples catch label-to-index wiring
    // mistakes that compile cleanly but put the value in the wrong position.
    XCTAssertEqual(SIMD2<Int32>(x: 11), SIMD2<Int32>(11, 0))
    XCTAssertEqual(SIMD2<Int32>(y: 12), SIMD2<Int32>(0, 12))

    XCTAssertEqual(SIMD3<Int32>(x: 21), SIMD3<Int32>(21, 0, 0))
    XCTAssertEqual(SIMD3<Int32>(y: 22), SIMD3<Int32>(0, 22, 0))
    XCTAssertEqual(SIMD3<Int32>(z: 23), SIMD3<Int32>(0, 0, 23))

    XCTAssertEqual(SIMD4<Int32>(x: 31), SIMD4<Int32>(31, 0, 0, 0))
    XCTAssertEqual(SIMD4<Int32>(y: 32), SIMD4<Int32>(0, 32, 0, 0))
    XCTAssertEqual(SIMD4<Int32>(z: 33), SIMD4<Int32>(0, 0, 33, 0))
    XCTAssertEqual(SIMD4<Int32>(w: 34), SIMD4<Int32>(0, 0, 0, 34))

    XCTAssertEqual(SIMD8<Int32>(a: 41), SIMD8<Int32>(41, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(b: 42), SIMD8<Int32>(0, 42, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(c: 43), SIMD8<Int32>(0, 0, 43, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(d: 44), SIMD8<Int32>(0, 0, 0, 44, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(e: 45), SIMD8<Int32>(0, 0, 0, 0, 45, 0, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(f: 46), SIMD8<Int32>(0, 0, 0, 0, 0, 46, 0, 0))
    XCTAssertEqual(SIMD8<Int32>(g: 47), SIMD8<Int32>(0, 0, 0, 0, 0, 0, 47, 0))
    XCTAssertEqual(SIMD8<Int32>(h: 48), SIMD8<Int32>(0, 0, 0, 0, 0, 0, 0, 48))

    XCTAssertEqual(SIMD16<Int32>(a: 51), SIMD16<Int32>(51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(b: 52), SIMD16<Int32>(0, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(c: 53), SIMD16<Int32>(0, 0, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(d: 54), SIMD16<Int32>(0, 0, 0, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(e: 55), SIMD16<Int32>(0, 0, 0, 0, 55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(f: 56), SIMD16<Int32>(0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(g: 57), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 57, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(h: 58), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(i: 59), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 59, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(j: 60), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(k: 61), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 61, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(l: 62), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(m: 63), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 0, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(n: 64), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0))
    XCTAssertEqual(SIMD16<Int32>(o: 65), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 0))
    XCTAssertEqual(SIMD16<Int32>(p: 66), SIMD16<Int32>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 66))
  }

  func testExplicitSingleLaneFloatingPointInitializers() {
    // The floating-point overloads mirror the integer API; the examples make
    // sure the overload set forwards every label through the shared sparse
    // initializer instead of accidentally relying on integer-only coverage.
    XCTAssertEqual(SIMD2<Float>(x: 1.25), SIMD2<Float>(1.25, 0))
    XCTAssertEqual(SIMD2<Float>(y: -1.5), SIMD2<Float>(0, -1.5))

    XCTAssertEqual(SIMD3<Float>(x: 2.25), SIMD3<Float>(2.25, 0, 0))
    XCTAssertEqual(SIMD3<Float>(y: -2.5), SIMD3<Float>(0, -2.5, 0))
    XCTAssertEqual(SIMD3<Float>(z: 2.75), SIMD3<Float>(0, 0, 2.75))

    XCTAssertEqual(SIMD4<Float>(x: 3.25), SIMD4<Float>(3.25, 0, 0, 0))
    XCTAssertEqual(SIMD4<Float>(y: -3.5), SIMD4<Float>(0, -3.5, 0, 0))
    XCTAssertEqual(SIMD4<Float>(z: 3.75), SIMD4<Float>(0, 0, 3.75, 0))
    XCTAssertEqual(SIMD4<Float>(w: -4.0), SIMD4<Float>(0, 0, 0, -4.0))

    XCTAssertEqual(SIMD8<Float>(a: 4.25), SIMD8<Float>(4.25, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Float>(b: -4.5), SIMD8<Float>(0, -4.5, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Float>(c: 4.75), SIMD8<Float>(0, 0, 4.75, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Float>(d: -5.0), SIMD8<Float>(0, 0, 0, -5.0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD8<Float>(e: 5.25), SIMD8<Float>(0, 0, 0, 0, 5.25, 0, 0, 0))
    XCTAssertEqual(SIMD8<Float>(f: -5.5), SIMD8<Float>(0, 0, 0, 0, 0, -5.5, 0, 0))
    XCTAssertEqual(SIMD8<Float>(g: 5.75), SIMD8<Float>(0, 0, 0, 0, 0, 0, 5.75, 0))
    XCTAssertEqual(SIMD8<Float>(h: -6.0), SIMD8<Float>(0, 0, 0, 0, 0, 0, 0, -6.0))

    XCTAssertEqual(SIMD16<Float>(a: 6.25), SIMD16<Float>(6.25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(b: -6.5), SIMD16<Float>(0, -6.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(c: 6.75), SIMD16<Float>(0, 0, 6.75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(d: -7.0), SIMD16<Float>(0, 0, 0, -7.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(e: 7.25), SIMD16<Float>(0, 0, 0, 0, 7.25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(f: -7.5), SIMD16<Float>(0, 0, 0, 0, 0, -7.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(g: 7.75), SIMD16<Float>(0, 0, 0, 0, 0, 0, 7.75, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(h: -8.0), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, -8.0, 0, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(i: 8.25), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 8.25, 0, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(j: -8.5), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, -8.5, 0, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(k: 8.75), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8.75, 0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(l: -9.0), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -9.0, 0, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(m: 9.25), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.25, 0, 0, 0))
    XCTAssertEqual(SIMD16<Float>(n: -9.5), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -9.5, 0, 0))
    XCTAssertEqual(SIMD16<Float>(o: 9.75), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.75, 0))
    XCTAssertEqual(SIMD16<Float>(p: -10.0), SIMD16<Float>(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -10.0))
  }

  func testExplicitGenericValueAtIndexInitializer() {
    // The generic initializer is the primitive used by every labeled
    // initializer. A direct integer and floating-point example proves the
    // precondition-guarded path writes only the requested index.
    XCTAssertEqual(SIMD4<Int32>(value: 7, at: 2), SIMD4<Int32>(0, 0, 7, 0))
    XCTAssertEqual(SIMD4<Float>(value: 2.5, at: 1), SIMD4<Float>(0, 2.5, 0, 0))
  }

  func testExplicitSubscriptIndexHelpers() {
    // These helpers centralize index validity checks for the sparse
    // initializers, so examples cover both boundary-adjacent failures and the
    // exact valid range.
    XCTAssertEqual(SIMD4<Int32>.subscriptableIndexRange, 0..<4)
    XCTAssertFalse(SIMD4<Int32>.canSubscript(at: -1))
    XCTAssertTrue(SIMD4<Int32>.canSubscript(at: 0))
    XCTAssertTrue(SIMD4<Int32>.canSubscript(at: 3))
    XCTAssertFalse(SIMD4<Int32>.canSubscript(at: 4))
  }

  func testExplicitUnitVectors() {
    // The named unit vectors are axis constants used by quaternion and vector
    // call sites; explicit examples lock their orientation to x/y/z.
    XCTAssertEqual(SIMD3<Float>.unitXVector, SIMD3<Float>(1, 0, 0))
    XCTAssertEqual(SIMD3<Float>.unitYVector, SIMD3<Float>(0, 1, 0))
    XCTAssertEqual(SIMD3<Float>.unitZVector, SIMD3<Float>(0, 0, 1))
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testSingleLaneIntegerInitializersAcrossGeneratedValues() {
    let specs: [(Int, (Int32) -> [Int32])] = [
      (0, { Self.values(SIMD2<Int32>(x: $0)) }),
      (1, { Self.values(SIMD2<Int32>(y: $0)) }),
      (0, { Self.values(SIMD3<Int32>(x: $0)) }),
      (1, { Self.values(SIMD3<Int32>(y: $0)) }),
      (2, { Self.values(SIMD3<Int32>(z: $0)) }),
      (0, { Self.values(SIMD4<Int32>(x: $0)) }),
      (1, { Self.values(SIMD4<Int32>(y: $0)) }),
      (2, { Self.values(SIMD4<Int32>(z: $0)) }),
      (3, { Self.values(SIMD4<Int32>(w: $0)) }),
      (0, { Self.values(SIMD8<Int32>(a: $0)) }),
      (1, { Self.values(SIMD8<Int32>(b: $0)) }),
      (2, { Self.values(SIMD8<Int32>(c: $0)) }),
      (3, { Self.values(SIMD8<Int32>(d: $0)) }),
      (4, { Self.values(SIMD8<Int32>(e: $0)) }),
      (5, { Self.values(SIMD8<Int32>(f: $0)) }),
      (6, { Self.values(SIMD8<Int32>(g: $0)) }),
      (7, { Self.values(SIMD8<Int32>(h: $0)) }),
      (0, { Self.values(SIMD16<Int32>(a: $0)) }),
      (1, { Self.values(SIMD16<Int32>(b: $0)) }),
      (2, { Self.values(SIMD16<Int32>(c: $0)) }),
      (3, { Self.values(SIMD16<Int32>(d: $0)) }),
      (4, { Self.values(SIMD16<Int32>(e: $0)) }),
      (5, { Self.values(SIMD16<Int32>(f: $0)) }),
      (6, { Self.values(SIMD16<Int32>(g: $0)) }),
      (7, { Self.values(SIMD16<Int32>(h: $0)) }),
      (8, { Self.values(SIMD16<Int32>(i: $0)) }),
      (9, { Self.values(SIMD16<Int32>(j: $0)) }),
      (10, { Self.values(SIMD16<Int32>(k: $0)) }),
      (11, { Self.values(SIMD16<Int32>(l: $0)) }),
      (12, { Self.values(SIMD16<Int32>(m: $0)) }),
      (13, { Self.values(SIMD16<Int32>(n: $0)) }),
      (14, { Self.values(SIMD16<Int32>(o: $0)) }),
      (15, { Self.values(SIMD16<Int32>(p: $0)) })
    ]

    for value in Int32(-3)...Int32(3) {
      for (expectedLane, build) in specs {
        assertSparseVector(
          build(value),
          expectedValue: value,
          expectedLane: expectedLane
        )
      }
    }
  }

  func testSingleLaneFloatingPointInitializersAcrossGeneratedValues() {
    let specs: [(Int, (Float) -> [Float])] = [
      (0, { Self.values(SIMD2<Float>(x: $0)) }),
      (1, { Self.values(SIMD2<Float>(y: $0)) }),
      (0, { Self.values(SIMD3<Float>(x: $0)) }),
      (1, { Self.values(SIMD3<Float>(y: $0)) }),
      (2, { Self.values(SIMD3<Float>(z: $0)) }),
      (0, { Self.values(SIMD4<Float>(x: $0)) }),
      (1, { Self.values(SIMD4<Float>(y: $0)) }),
      (2, { Self.values(SIMD4<Float>(z: $0)) }),
      (3, { Self.values(SIMD4<Float>(w: $0)) }),
      (0, { Self.values(SIMD8<Float>(a: $0)) }),
      (1, { Self.values(SIMD8<Float>(b: $0)) }),
      (2, { Self.values(SIMD8<Float>(c: $0)) }),
      (3, { Self.values(SIMD8<Float>(d: $0)) }),
      (4, { Self.values(SIMD8<Float>(e: $0)) }),
      (5, { Self.values(SIMD8<Float>(f: $0)) }),
      (6, { Self.values(SIMD8<Float>(g: $0)) }),
      (7, { Self.values(SIMD8<Float>(h: $0)) }),
      (0, { Self.values(SIMD16<Float>(a: $0)) }),
      (1, { Self.values(SIMD16<Float>(b: $0)) }),
      (2, { Self.values(SIMD16<Float>(c: $0)) }),
      (3, { Self.values(SIMD16<Float>(d: $0)) }),
      (4, { Self.values(SIMD16<Float>(e: $0)) }),
      (5, { Self.values(SIMD16<Float>(f: $0)) }),
      (6, { Self.values(SIMD16<Float>(g: $0)) }),
      (7, { Self.values(SIMD16<Float>(h: $0)) }),
      (8, { Self.values(SIMD16<Float>(i: $0)) }),
      (9, { Self.values(SIMD16<Float>(j: $0)) }),
      (10, { Self.values(SIMD16<Float>(k: $0)) }),
      (11, { Self.values(SIMD16<Float>(l: $0)) }),
      (12, { Self.values(SIMD16<Float>(m: $0)) }),
      (13, { Self.values(SIMD16<Float>(n: $0)) }),
      (14, { Self.values(SIMD16<Float>(o: $0)) }),
      (15, { Self.values(SIMD16<Float>(p: $0)) })
    ]

    for value in stride(from: Float(-3.5), through: Float(3.5), by: 0.5) {
      for (expectedLane, build) in specs {
        assertSparseVector(
          build(value),
          expectedValue: value,
          expectedLane: expectedLane
        )
      }
    }
  }

  func testGenericValueAtIndexInitializerAcrossAllLanesAndValues() {
    for value in Int32(-3)...Int32(3) {
      for index in SIMD8<Int32>.subscriptableIndexRange {
        assertSparseVector(
          Self.values(SIMD8<Int32>(value: value, at: index)),
          expectedValue: value,
          expectedLane: index
        )
      }
    }

    for value in stride(from: Float(-3.5), through: Float(3.5), by: 0.5) {
      for index in SIMD8<Float>.subscriptableIndexRange {
        assertSparseVector(
          Self.values(SIMD8<Float>(value: value, at: index)),
          expectedValue: value,
          expectedLane: index
        )
      }
    }
  }

  func testSubscriptIndexHelpersAcrossVectorWidths() {
    let specs: [(Range<Int>, (Int) -> Bool)] = [
      (0..<2, { SIMD2<Int32>.canSubscript(at: $0) }),
      (0..<3, { SIMD3<Int32>.canSubscript(at: $0) }),
      (0..<4, { SIMD4<Int32>.canSubscript(at: $0) }),
      (0..<8, { SIMD8<Int32>.canSubscript(at: $0) }),
      (0..<16, { SIMD16<Int32>.canSubscript(at: $0) })
    ]

    for (range, canSubscript) in specs {
      XCTAssertFalse(canSubscript(range.lowerBound - 1))
      XCTAssertFalse(canSubscript(range.upperBound))
      for index in (range.lowerBound - 1)...range.upperBound {
        XCTAssertEqual(
          range.contains(index),
          canSubscript(index),
          "canSubscript(at:) should match Range.contains for index \(index) in \(range)."
        )
      }
    }

    XCTAssertEqual(SIMD2<Int32>.subscriptableIndexRange, 0..<2)
    XCTAssertEqual(SIMD3<Int32>.subscriptableIndexRange, 0..<3)
    XCTAssertEqual(SIMD4<Int32>.subscriptableIndexRange, 0..<4)
    XCTAssertEqual(SIMD8<Int32>.subscriptableIndexRange, 0..<8)
    XCTAssertEqual(SIMD16<Int32>.subscriptableIndexRange, 0..<16)
  }

  func testUnitVectorsAreOrthogonalGeneratedBasis() {
    let basis = [
      SIMD3<Float>.unitXVector,
      SIMD3<Float>.unitYVector,
      SIMD3<Float>.unitZVector
    ]

    for (axis, vector) in basis.enumerated() {
      XCTAssertEqual(vector[axis], 1)
      XCTAssertEqual(simd_dot(vector, vector), 1)
      for otherAxis in SIMD3<Float>.subscriptableIndexRange where otherAxis != axis {
        XCTAssertEqual(vector[otherAxis], 0)
      }
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func assertSparseVector<Scalar>(
    _ values: [Scalar],
    expectedValue: Scalar,
    expectedLane: Int,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where Scalar: AdditiveArithmetic & Equatable {
    for (index, value) in values.enumerated() {
      XCTAssertEqual(
        value,
        index == expectedLane ? expectedValue : .zero,
        "Lane \(index) should match the sparse initializer contract.",
        file: file,
        line: line
      )
    }
  }

  private static func values<Scalar>(_ vector: SIMD2<Scalar>) -> [Scalar] {
    return [
      vector[0],
      vector[1]
    ]
  }

  private static func values<Scalar>(_ vector: SIMD3<Scalar>) -> [Scalar] {
    return [
      vector[0],
      vector[1],
      vector[2]
    ]
  }

  private static func values<Scalar>(_ vector: SIMD4<Scalar>) -> [Scalar] {
    return [
      vector[0],
      vector[1],
      vector[2],
      vector[3]
    ]
  }

  private static func values<Scalar>(_ vector: SIMD8<Scalar>) -> [Scalar] {
    return (0..<8).map { vector[$0] }
  }

  private static func values<Scalar>(_ vector: SIMD16<Scalar>) -> [Scalar] {
    return (0..<16).map { vector[$0] }
  }

}
