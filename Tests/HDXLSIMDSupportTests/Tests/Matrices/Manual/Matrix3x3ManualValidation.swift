//
//  Matrix3x3ManualValidation.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Matrix3x3ManualValidation
// -------------------------------------------------------------------------- //

/// 3x3-specific manual invariants. Inherits the full common + square suites;
/// adds concrete constructor placement, determinant, transpose, and product
/// anchors. (Quaternion ↔ 3x3 conversion is covered in the quaternion suite.)
class Matrix3x3ManualValidation<T: ExtendedSIMDScalar>: SquareMatrixManualValidation<Matrix3x3<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2, 3], [4, 5, 6], [7, 8, 10]] }
  override var secondaryProbeRows: [[Int]] { [[2, 0, 1], [1, 3, 0], [0, 1, 2]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0, 0], [2, 1, 0], [3, 2, 1]] }

  /// Positional `init(_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    // Columns of [[1,2,3],[4,5,6],[7,8,10]] are (1,4,7), (2,5,8), (3,6,10).
    let c0 = SIMD3<T>(scalar(1), scalar(4), scalar(7))
    let c1 = SIMD3<T>(scalar(2), scalar(5), scalar(8))
    let c2 = SIMD3<T>(scalar(3), scalar(6), scalar(10))
    assertAlmostEqual(Matrix3x3<T>(c0, c1, c2), primaryProbe, "init(_:_:_:) == init(scalars:)")
  }

  /// Determinant of `[[1,2,3],[4,5,6],[7,8,10]]` is `-3` (concrete anchor).
  func testDeterminantConcrete() {
    assertScalarsAlmostEqual(primaryProbe.determinant, scalar(-3), "det([[1,2,3],[4,5,6],[7,8,10]]) == -3")
  }

  /// Transpose of `[[1,2,3],[4,5,6],[7,8,10]]` is `[[1,4,7],[2,5,8],[3,6,10]]`.
  func testTransposeConcrete() {
    assertAlmostEqual(
      primaryProbe.transposed(),
      makeProbe([[1, 4, 7], [2, 5, 8], [3, 6, 10]]),
      "transpose concrete"
    )
  }

  /// The square product agrees with the textbook definition (independent oracle).
  func testMultiplicationMatchesDefinition() {
    let expected = matrix(Matrix3x3<T>.self, standardMatrixProduct(primaryProbeRows, secondaryProbeRows))
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

final class Matrix3x3_Float_Manual: Matrix3x3ManualValidation<Float> {}
final class Matrix3x3_Double_Manual: Matrix3x3ManualValidation<Double> {}
final class Matrix3x3_Half_Manual: Matrix3x3ManualValidation<Float16> {}
