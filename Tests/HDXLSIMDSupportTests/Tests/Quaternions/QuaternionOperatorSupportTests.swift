//
//  QuaternionOperatorSupportTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class QuaternionOperatorSupportTests: XCTestCase {

  typealias Q = Quaternion<Double>

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitQuaternionOperatorsForwardToNamedOperations() {
    // Quaternion multiplication and division are non-commutative, so the
    // operator layer must preserve exact operand order. This example touches
    // every QuaternionOperatorSupportProtocol overload and compares it against
    // the named operation with the same contract.
    let lhs = Q(i: 1, j: 2, k: 3, real: 4)
    let rhs = Q(i: -2, j: 0.5, k: 1.5, real: 3)

    assertQuaternion(-lhs, lhs.negated())
    assertQuaternion(lhs + rhs, lhs.adding(rhs))
    assertQuaternion(lhs + (2, rhs), lhs.adding(rhs, multipliedBy: 2))

    var addAssign = lhs
    addAssign += rhs
    assertQuaternion(addAssign, lhs.adding(rhs))

    var scaledAddAssign = lhs
    scaledAddAssign += (2, rhs)
    assertQuaternion(scaledAddAssign, lhs.adding(rhs, multipliedBy: 2))

    assertQuaternion(lhs - rhs, lhs.subtracting(rhs))

    var subtractAssign = lhs
    subtractAssign -= rhs
    assertQuaternion(subtractAssign, lhs.subtracting(rhs))

    assertQuaternion(lhs * 3, lhs.multiplied(by: 3))
    assertQuaternion(3 * lhs, lhs.multiplied(by: 3))

    var scalarMultiplyAssign = lhs
    scalarMultiplyAssign *= 3
    assertQuaternion(scalarMultiplyAssign, lhs.multiplied(by: 3))

    assertQuaternion(lhs / 2, lhs.divided(by: 2))

    var scalarDivideAssign = lhs
    scalarDivideAssign /= 2
    assertQuaternion(scalarDivideAssign, lhs.divided(by: 2))

    assertQuaternion(lhs * rhs, lhs.multiplied(onRightBy: rhs))

    var rightMultiplyAssign = lhs
    rightMultiplyAssign *= rhs
    assertQuaternion(rightMultiplyAssign, lhs.multiplied(onRightBy: rhs))

    var leftMultiplyAssign = rhs
    lhs =* leftMultiplyAssign
    assertQuaternion(leftMultiplyAssign, rhs.multiplied(onLeftBy: lhs))

    assertQuaternion(lhs / rhs, lhs.divided(onRightBy: rhs))

    var rightDivideAssign = lhs
    rightDivideAssign /= rhs
    assertQuaternion(rightDivideAssign, lhs.divided(onRightBy: rhs))

    var leftDivideAssign = lhs
    rhs =/ leftDivideAssign
    assertQuaternion(leftDivideAssign, lhs.divided(onLeftBy: rhs))

    XCTAssertEqual(lhs • rhs, lhs.dotted(with: rhs), accuracy: 1.0e-10)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testQuaternionOperatorsAcrossGeneratedValuesAndScalars() {
    for seed in -3...3 {
      let lhs = generatedQuaternion(seed: seed)
      let rhs = generatedQuaternion(seed: seed + 7)
      let scalar = Double(seed == 0 ? 2 : seed)
      let divisor = scalar == 0 ? 2 : scalar

      assertQuaternion(-lhs, lhs.negated())
      assertQuaternion(lhs + rhs, lhs.adding(rhs))
      assertQuaternion(lhs + (scalar, rhs), lhs.adding(rhs, multipliedBy: scalar))

      var addAssign = lhs
      addAssign += rhs
      assertQuaternion(addAssign, lhs.adding(rhs))

      var scaledAddAssign = lhs
      scaledAddAssign += (scalar, rhs)
      assertQuaternion(scaledAddAssign, lhs.adding(rhs, multipliedBy: scalar))

      assertQuaternion(lhs - rhs, lhs.subtracting(rhs))

      var subtractAssign = lhs
      subtractAssign -= rhs
      assertQuaternion(subtractAssign, lhs.subtracting(rhs))

      assertQuaternion(lhs * scalar, lhs.multiplied(by: scalar))
      assertQuaternion(scalar * lhs, lhs.multiplied(by: scalar))

      var scalarMultiplyAssign = lhs
      scalarMultiplyAssign *= scalar
      assertQuaternion(scalarMultiplyAssign, lhs.multiplied(by: scalar))

      assertQuaternion(lhs / divisor, lhs.divided(by: divisor))

      var scalarDivideAssign = lhs
      scalarDivideAssign /= divisor
      assertQuaternion(scalarDivideAssign, lhs.divided(by: divisor))

      assertQuaternion(lhs * rhs, lhs.multiplied(onRightBy: rhs))

      var rightMultiplyAssign = lhs
      rightMultiplyAssign *= rhs
      assertQuaternion(rightMultiplyAssign, lhs.multiplied(onRightBy: rhs))

      var leftMultiplyAssign = rhs
      lhs =* leftMultiplyAssign
      assertQuaternion(leftMultiplyAssign, rhs.multiplied(onLeftBy: lhs))

      assertQuaternion(lhs / rhs, lhs.divided(onRightBy: rhs))

      var rightDivideAssign = lhs
      rightDivideAssign /= rhs
      assertQuaternion(rightDivideAssign, lhs.divided(onRightBy: rhs))

      var leftDivideAssign = lhs
      rhs =/ leftDivideAssign
      assertQuaternion(leftDivideAssign, lhs.divided(onLeftBy: rhs))

      XCTAssertEqual(lhs • rhs, lhs.dotted(with: rhs), accuracy: 1.0e-10)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func generatedQuaternion(seed: Int) -> Q {
    let base = Double(seed)
    return Q(
      i: base + 0.25,
      j: base + 1.5,
      k: base - 2.25,
      real: base + 4.0
    )
  }

  private func assertQuaternion(
    _ lhs: Q,
    _ rhs: Q,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertLessThanOrEqual(
      lhs.lInfinityDistance(to: rhs),
      1.0e-10,
      file: file,
      line: line
    )
  }

}
