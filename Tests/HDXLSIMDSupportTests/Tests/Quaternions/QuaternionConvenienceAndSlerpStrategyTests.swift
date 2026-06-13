//
//  QuaternionConvenienceAndSlerpStrategyTests.swift
//

import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

class QuaternionConvenienceAndSlerpStrategyTests: XCTestCase {

  typealias Q = Quaternion<Double>

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitQuaternionConvenienceConstants() {
    // These constants are compact spelling for the multiplicative identity and
    // the three imaginary basis quaternions. The examples pin the component
    // layout so future refactors cannot swap the real and imaginary parts.
    XCTAssertEqual(Q.identity, Q.one)
    XCTAssertEqual(Q.one, Q(i: 0, j: 0, k: 0, real: 1))
    XCTAssertEqual(Q.i, Q(i: 1, j: 0, k: 0, real: 0))
    XCTAssertEqual(Q.j, Q(i: 0, j: 1, k: 0, real: 0))
    XCTAssertEqual(Q.k, Q(i: 0, j: 0, k: 1, real: 0))
    XCTAssertEqual(Q.x, Q.i)
    XCTAssertEqual(Q.y, Q.j)
    XCTAssertEqual(Q.z, Q.k)
  }

  func testExplicitQuaternionConversionHelpers() {
    // The conversion helpers are the lossy/exact entry points from standard
    // numeric sources. This covers both integer and floating-point overloads,
    // including the nil branch when a value cannot be represented exactly.
    XCTAssertEqual(
      Q.truncating(i: Int16(-1), j: Int16(2), k: Int16(-3), real: Int16(4)),
      Q(i: -1, j: 2, k: -3, real: 4)
    )
    XCTAssertEqual(
      Q.exactly(i: UInt16(1), j: UInt16(2), k: UInt16(3), real: UInt16(4)),
      Q(i: 1, j: 2, k: 3, real: 4)
    )
    XCTAssertNil(
      Quaternion<Float16>.exactly(
        i: Int.max,
        j: 0,
        k: 0,
        real: 0
      )
    )

    XCTAssertEqual(
      Q.truncating(i: Float(1.25), j: Float(-2.5), k: Float(3.75), real: Float(-4.5)),
      Q(i: 1.25, j: -2.5, k: 3.75, real: -4.5)
    )
    XCTAssertEqual(
      Q.exactly(i: Float(1.5), j: Float(-2.25), k: Float(3.75), real: Float(-4.5)),
      Q(i: 1.5, j: -2.25, k: 3.75, real: -4.5)
    )
    XCTAssertNil(
      Quaternion<Float16>.exactly(
        i: Double.greatestFiniteMagnitude,
        j: 0.0,
        k: 0.0,
        real: 0.0
      )
    )
  }

  func testExplicitSlerpStrategyConformances() throws {
    // Slerp strategy is intentionally raw-value backed for Objective-C and
    // Codable use. This example pins ordering, string forms, hashing, allCases,
    // successful coding, and invalid raw-value rejection.
    XCTAssertEqual(
      QuaternionSlerpStrategy.allCases,
      [.automatic, .shortest, .longest]
    )
    XCTAssertLessThan(QuaternionSlerpStrategy.automatic, .shortest)
    XCTAssertLessThan(QuaternionSlerpStrategy.shortest, .longest)
    XCTAssertEqual(QuaternionSlerpStrategy.automatic.description, ".automatic")
    XCTAssertEqual(QuaternionSlerpStrategy.shortest.description, ".shortest")
    XCTAssertEqual(QuaternionSlerpStrategy.longest.description, ".longest")
    XCTAssertEqual(
      QuaternionSlerpStrategy.automatic.debugDescription,
      "QuaternionSlerpStrategy.automatic"
    )
    XCTAssertEqual(
      QuaternionSlerpStrategy.shortest.debugDescription,
      "QuaternionSlerpStrategy.shortest"
    )
    XCTAssertEqual(
      QuaternionSlerpStrategy.longest.debugDescription,
      "QuaternionSlerpStrategy.longest"
    )
    XCTAssertEqual(
      Set(QuaternionSlerpStrategy.allCases),
      Set([.automatic, .shortest, .longest])
    )

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    XCTAssertEqual(
      try decoder.decode(QuaternionSlerpStrategy.self, from: encoder.encode(QuaternionSlerpStrategy.shortest)),
      .shortest
    )
    XCTAssertThrowsError(
      try decoder.decode(
        QuaternionSlerpStrategy.self,
        from: Data("99".utf8)
      )
    ) { error in
      guard case DecodingError.dataCorrupted = error else {
        XCTFail("Expected dataCorrupted error, got \(error)")
        return
      }
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testQuaternionConvenienceConstantsAcrossScalarTypes() {
    confirmQuaternionConstants(Quaternion<Float>.self)
    confirmQuaternionConstants(Quaternion<Double>.self)
    confirmQuaternionConstants(Quaternion<Float16>.self)
  }

  func testQuaternionConversionsAcrossGeneratedValues() {
    for seed in -8...8 {
      let i = Int16(seed)
      let j = Int16(seed + 1)
      let k = Int16(seed - 2)
      let real = Int16(seed + 3)
      XCTAssertEqual(
        Q.truncating(i: i, j: j, k: k, real: real),
        Q(i: Double(i), j: Double(j), k: Double(k), real: Double(real))
      )
      XCTAssertEqual(
        Q.exactly(i: i, j: j, k: k, real: real),
        Q(i: Double(i), j: Double(j), k: Double(k), real: Double(real))
      )

      let base = Float(seed) / 4
      XCTAssertEqual(
        Q.truncating(i: base, j: base + 0.5, k: base - 1.0, real: base + 1.5),
        Q(
          i: Double(base),
          j: Double(base + 0.5),
          k: Double(base - 1.0),
          real: Double(base + 1.5)
        )
      )
      XCTAssertEqual(
        Q.exactly(i: base, j: base + 0.5, k: base - 1.0, real: base + 1.5),
        Q(
          i: Double(base),
          j: Double(base + 0.5),
          k: Double(base - 1.0),
          real: Double(base + 1.5)
        )
      )
    }
  }

  func testSlerpStrategyConformancesAcrossAllCases() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let expectedDescriptions: [QuaternionSlerpStrategy: String] = [
      .automatic: ".automatic",
      .shortest: ".shortest",
      .longest: ".longest"
    ]
    let expectedDebugDescriptions: [QuaternionSlerpStrategy: String] = [
      .automatic: "QuaternionSlerpStrategy.automatic",
      .shortest: "QuaternionSlerpStrategy.shortest",
      .longest: "QuaternionSlerpStrategy.longest"
    ]

    for strategy in QuaternionSlerpStrategy.allCases {
      XCTAssertEqual(strategy, QuaternionSlerpStrategy(rawValue: strategy.rawValue))
      XCTAssertEqual(strategy.description, expectedDescriptions[strategy])
      XCTAssertEqual(strategy.debugDescription, expectedDebugDescriptions[strategy])
      XCTAssertEqual(
        try decoder.decode(QuaternionSlerpStrategy.self, from: encoder.encode(strategy)),
        strategy
      )
    }

    XCTAssertEqual(
      QuaternionSlerpStrategy.allCases.sorted(),
      [.automatic, .shortest, .longest]
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func confirmQuaternionConstants<T: ExtendedSIMDScalar>(
    _ type: Quaternion<T>.Type,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      Quaternion<T>.identity,
      Quaternion<T>.one,
      file: file,
      line: line
    )
    XCTAssertEqual(
      Quaternion<T>.one,
      Quaternion<T>(i: 0, j: 0, k: 0, real: 1),
      file: file,
      line: line
    )
    XCTAssertEqual(
      Quaternion<T>.x,
      Quaternion<T>.i,
      file: file,
      line: line
    )
    XCTAssertEqual(
      Quaternion<T>.y,
      Quaternion<T>.j,
      file: file,
      line: line
    )
    XCTAssertEqual(
      Quaternion<T>.z,
      Quaternion<T>.k,
      file: file,
      line: line
    )
  }

}
