//
//  GeneratedValidationTestCase.swift
//

import XCTest

/// Base class for every macro-generated *equivalence* suite
/// (`MatrixNxM_<Rep>_Equivalence`, `Quaternion_<Rep>_Equivalence`).
///
/// These suites sweep a handful of probe inputs per operation and assert that
/// the wrapper result equals the native `simd_*` result within an L∞ tolerance
/// — i.e. they establish that our wrappers are *equivalent* to the raw simd
/// types they wrap. On the first failing probe we want the suite to halt
/// cleanly rather than emit one failure per remaining probe, so we force
/// `failureReaction = .haltImmediately` (which sets `continueAfterFailure`
/// to `false`).
///
/// The actual test methods are injected into each subclass by the
/// `#generateMatrixConformanceTests` / `#generateQuaternionConformanceTests`
/// freestanding macros; this base contributes only the failure-reaction setup.
class GeneratedValidationTestCase: ValidationTestCase {
  override func setUp() {
    super.setUp()
    failureReaction = .haltImmediately
  }
}
