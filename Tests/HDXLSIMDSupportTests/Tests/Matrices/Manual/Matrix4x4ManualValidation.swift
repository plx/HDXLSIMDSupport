//
//  Matrix4x4ManualValidation.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4ManualValidation
// -------------------------------------------------------------------------- //

/// 4x4-specific manual invariants. The primary probe is upper-triangular so its
/// determinant is the (hand-verifiable) product of the diagonal and its
/// transpose is visibly different. (Quaternion ↔ 4x4 conversion is covered in
/// the quaternion suite.)
class Matrix4x4ManualValidation<T: ExtendedSIMDScalar>: SquareMatrixManualValidation<Matrix4x4<T>> {

  override var primaryProbeRows: [[Int]] { [[2, 1, 1, 1], [0, 3, 1, 1], [0, 0, 2, 1], [0, 0, 0, 1]] }
  override var secondaryProbeRows: [[Int]] { [[1, 0, 2, 0], [0, 1, 0, 2], [2, 0, 1, 0], [0, 2, 0, 1]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0, 0, 0], [1, 1, 0, 0], [1, 1, 1, 0], [1, 1, 1, 1]] }

  /// Positional `init(_:_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    // Columns of the upper-triangular primary probe.
    let c0 = SIMD4<T>(scalar(2), scalar(0), scalar(0), scalar(0))
    let c1 = SIMD4<T>(scalar(1), scalar(3), scalar(0), scalar(0))
    let c2 = SIMD4<T>(scalar(1), scalar(1), scalar(2), scalar(0))
    let c3 = SIMD4<T>(scalar(1), scalar(1), scalar(1), scalar(1))
    assertAlmostEqual(Matrix4x4<T>(c0, c1, c2, c3), primaryProbe, "init(_:_:_:_:) == init(scalars:)")
  }

  /// Determinant of the upper-triangular probe is the product of the diagonal:
  /// `2·3·2·1 == 12` (concrete anchor).
  func testDeterminantConcrete() {
    assertScalarsAlmostEqual(primaryProbe.determinant, scalar(12), "det(upper-triangular) == product of diagonal == 12")
  }

  /// Transpose of the upper-triangular probe is its lower-triangular mirror.
  func testTransposeConcrete() {
    assertAlmostEqual(
      primaryProbe.transposed(),
      makeProbe([[2, 0, 0, 0], [1, 3, 0, 0], [1, 1, 2, 0], [1, 1, 1, 1]]),
      "transpose concrete"
    )
  }

  /// The square product agrees with the textbook definition (independent oracle).
  func testMultiplicationMatchesDefinition() {
    let expected = matrix(Matrix4x4<T>.self, standardMatrixProduct(primaryProbeRows, secondaryProbeRows))
    assertMatricesAlmostEqual(
      primaryProbe.multiplied(onRightBy: secondaryProbe),
      expected,
      "a·b matches the textbook product",
      tolerance: absoluteTolerance
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: Concrete Leaves
// -------------------------------------------------------------------------- //

final class Matrix4x4_Float_Manual: Matrix4x4ManualValidation<Float> {}
final class Matrix4x4_Double_Manual: Matrix4x4ManualValidation<Double> {}
final class Matrix4x4_Half_Manual: Matrix4x4ManualValidation<Float16> {}
