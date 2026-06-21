//
//  ManualValidationSupport.swift
//
//  Shared support for the hand-written "manual" algebraic-invariant suites.
//  These suites verify mathematical properties (commutativity, associativity,
//  inverse round-trips, transpose placement, the Hamilton table, rotation
//  action, …) on concrete, hand-picked numerical examples — independently of
//  the macro-generated `…_Equivalence` suites that check wrapper ≡ native simd.
//

import Foundation
import XCTest
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Float16 Tolerance
// -------------------------------------------------------------------------- //
//
// Relocated here (it formerly lived in `HalfQuaternionValidationTests.swift`)
// so both the manual and equivalence suites can lean on a neutral home for the
// per-representation tolerance ladder. The base `1e-6` default is defined in
// `AggregateToNativeOutOfPlaceOperationValidations.swift`; `Float16` only has
// ~3 decimal digits of precision, so it needs a much looser bound.

extension Float16 {
  /// Override of `BinaryFloatingPoint.validationTestTolerance` suited to
  /// `Float16`'s ~3-decimal-digit precision.
  static var validationTestTolerance: Float16 { 0.05 }
}
