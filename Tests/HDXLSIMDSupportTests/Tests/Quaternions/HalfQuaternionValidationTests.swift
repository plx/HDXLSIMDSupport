import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

// `simd_quath` lacks the Swift overlay's bridged operators and `.real` /
// `.imag` / `.conjugate` / `.inverse` accessors that `simd_quatf` and
// `simd_quatd` ship with; we route the "native" side of each comparison
// through the free C functions instead. We also pick a more lenient
// tolerance than the default — `Float16` only has ~3 decimal digits of
// precision and the default `.validationTestTolerance` of `1e-6` rounds to
// subnormal when stored in `Float16`.

extension Float16 {
  /// Override of `BinaryFloatingPoint.validationTestTolerance` suited to
  /// `Float16`'s ~3-decimal-digit precision.
  static var validationTestTolerance: Float16 { 0.05 }
}

class HalfQuaternionValidationTests: QuaternionValidationTestCase {

  lazy var probeScalars: some Collection<Float16> = [
    Float16(-5.0), Float16(-4.5), Float16(-4.0), Float16(-3.5),
    Float16(-3.0), Float16(-2.5), Float16(-2.0), Float16(-1.5),
    Float16(-1.0), Float16(-0.5), Float16(0.0),
    Float16(0.5), Float16(1.0), Float16(1.5), Float16(2.0),
    Float16(2.5), Float16(3.0), Float16(3.5), Float16(4.0),
    Float16(4.5), Float16(5.0)
  ]

  lazy var nonZeroProbeScalars: some Collection<Float16> =
    probeScalars.filter(\.isNonZero)

  let scalar: Float16.Type = Float16.self
  let aggregate: Quaternion<Float16>.Type = Quaternion<Float16>.self

  func testProbeScalarSanity() {
    XCTAssertFalse(probeScalars.isEmpty)
    XCTAssertTrue(probeScalars.allSatisfy(\.isFinite))
    XCTAssertTrue(probeScalars.contains(where: { $0.isStrictlyPositive }))
    XCTAssertTrue(probeScalars.contains(where: { $0.isStrictlyNegative }))
    XCTAssertTrue(probeScalars.contains(where: { $0.isZero }))
  }

  func testNonZeroProbeScalarSanity() {
    XCTAssertFalse(nonZeroProbeScalars.isEmpty)
    XCTAssertTrue(nonZeroProbeScalars.allSatisfy(\.isFiniteNonZero))
    XCTAssertTrue(nonZeroProbeScalars.contains(where: { $0.isStrictlyPositive }))
    XCTAssertTrue(nonZeroProbeScalars.contains(where: { $0.isStrictlyNegative }))
    XCTAssertFalse(nonZeroProbeScalars.contains(where: { $0.isZero }))
  }

  func testOutOfPlaceScalarLHSMultiplication() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceScalarAggregateToAggregateOperation(
        "*",
        on: (scalar, aggregate),
        lhses: probeScalars,
        rhses: probeTuples,
        operations: { $0 * $1 }, { simd_mul($0, $1) }
      )
    }
  }

  func testOutOfPlaceScalarRHSMultiplication() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateScalarToAggregateOperation(
        "*",
        on: (aggregate, scalar),
        lhses: probeTuples,
        rhses: probeScalars,
        operations: { $0 * $1 }, { simd_mul($1, $0) }
      )
    }
  }

  func testOutOfPlaceScalarRHSDivision() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateScalarToAggregateOperation(
        "/",
        on: (aggregate, scalar),
        lhses: probeTuples,
        rhses: nonZeroProbeScalars,
        operations: { $0 / $1 }, { simd_quath(vector: $0.vector / $1) }
      )
    }
  }

  func testOutOfPlaceQuaternionAddition() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation(
        "+",
        on: (aggregate, aggregate),
        lhses: probeTuples,
        rhses: probeTuples,
        operations: { $0 + $1 },
        { simd_quath(vector: $0.vector + $1.vector) }
      )
    }
  }

  func testOutOfPlaceQuaternionSubtraction() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation(
        "-",
        on: (aggregate, aggregate),
        lhses: probeTuples,
        rhses: probeTuples,
        operations: { $0 - $1 },
        { simd_quath(vector: $0.vector - $1.vector) }
      )
    }
  }

  func testOutOfPlaceQuaternionMultiplication() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation(
        "*",
        on: (aggregate, aggregate),
        lhses: probeTuples,
        rhses: probeTuples,
        operations: { $0 * $1 }, { simd_mul($0, $1) }
      )
    }
  }

  func testOutOfPlaceQuaternionDivision() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateAggregateToAggregateOperation(
        "/",
        on: (aggregate, aggregate),
        lhses: probeTuples,
        rhses: nonZeroProbeTuples,
        operations: { $0 / $1 }, { simd_mul($0, simd_inverse($1)) }
      )
    }
  }

  func testOutOfPlaceQuaternionConjugation() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        "conjugate",
        on: (aggregate),
        probes: probeTuples,
        operations: { $0.conjugated() }, { simd_conjugate($0) }
      )
    }
  }

  func testOutOfPlaceQuaternionNegation() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        ".negated()",
        on: (aggregate),
        probes: probeTuples,
        operations: { $0.negated() }, { simd_quath(vector: -$0.vector) }
      )
    }
  }

  func testOutOfPlaceQuaternionInversion() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        ".inverted()",
        on: (aggregate),
        probes: nonZeroProbeTuples,
        operations: { $0.inverted() }, { simd_inverse($0) }
      )
    }
  }

}
