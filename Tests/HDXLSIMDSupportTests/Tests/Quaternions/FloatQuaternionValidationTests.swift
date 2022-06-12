import Foundation
import XCTest
import simd
@testable import HDXLSIMDSupport

class FloatQuaternionValidationTests: QuaternionValidationTestCase {
  
  lazy var probeScalars: some Collection<Float> = (
    Array(stride(from: -5.0, through: 5.0, by: 0.1)) + [0.0]
  ).sorted()
  
  lazy var nonZeroProbeScalars: some Collection<Float> = probeScalars.filter(\.isNonZero)
  
  let scalar: Float.Type = Float.self
  let aggregate: Quaternion<Float>.Type = Quaternion<Float>.self

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
        operations: *, *
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
        operations: *, *
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
        operations: / , /
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
        operations: + , +
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
        operations: - , -
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
        operations: * , *
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
        operations: / , /
      )
    }
  }
  
  func testOutOfPlaceQuaternionConjugation() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        "\\.conjugate",
        on: (aggregate),
        probes: probeTuples,
        operations: { $0.conjugated() }, { $0.conjugate }
      )
    }
  }

  func testOutOfPlaceQuaternionNegation() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        ".negated()",
        on: (aggregate),
        probes: probeTuples,
        operations: { $0.negated() }, { -$0 }
      )
    }
  }

  func testOutOfPlaceQuaternionInversion() async throws {
    try await withFailureReaction(.haltImmediately) {
      try await HDXLValidateOutOfPlaceAggregateToAggregateOperation(
        ".inverted()",
        on: (aggregate),
        probes: nonZeroProbeTuples,
        operations: { $0.inverted() }, { $0.inverse }
      )
    }
  }

}
