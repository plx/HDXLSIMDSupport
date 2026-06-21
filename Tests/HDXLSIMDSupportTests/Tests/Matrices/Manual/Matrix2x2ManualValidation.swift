//
//  Matrix2x2ManualValidation.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Matrix2x2ManualValidation
// -------------------------------------------------------------------------- //

/// 2x2-specific manual invariants (concrete constructor placement + concrete
/// determinant / inverse / transpose / product anchors). Inherits the full
/// common + square invariant suites.
class Matrix2x2ManualValidation<T: ExtendedSIMDScalar>: SquareMatrixManualValidation<Matrix2x2<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2], [3, 4]] }
  override var secondaryProbeRows: [[Int]] { [[5, 6], [7, 8]] }
  override var tertiaryProbeRows: [[Int]] { [[2, 0], [1, 3]] }

  /// A hand-picked invertible matrix with determinant `1`.
  private lazy var invertibleConcrete: Matrix2x2<T> = makeProbe([[2, 1], [1, 1]])

  /// Positional `init(_:_:)` builds the same matrix as `init(columns:)` and
  /// `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD2<T>(scalar(1), scalar(3))  // column 0 of [[1,2],[3,4]]
    let c1 = SIMD2<T>(scalar(2), scalar(4))  // column 1 of [[1,2],[3,4]]
    let built = Matrix2x2<T>(c0, c1)
    assertAlmostEqual(built, primaryProbe, "init(_:_:) builds the same matrix as init(scalars:)")
    assertAlmostEqual(built, Matrix2x2<T>(columns: (c0, c1)), "init(_:_:) == init(columns:)")
  }

  /// Determinant of `[[1,2],[3,4]]` is `-2` (concrete anchor).
  func testDeterminantConcrete() {
    assertScalarsAlmostEqual(primaryProbe.determinant, scalar(-2), "det([[1,2],[3,4]]) == -2")
  }

  /// Transpose of `[[1,2],[3,4]]` is `[[1,3],[2,4]]` (concrete anchor).
  func testTransposeConcrete() {
    assertAlmostEqual(
      primaryProbe.transposed(),
      makeProbe([[1, 3], [2, 4]]),
      "transpose([[1,2],[3,4]]) == [[1,3],[2,4]]"
    )
  }

  /// Product `[[1,2],[3,4]]·[[5,6],[7,8]] == [[19,22],[43,50]]` (concrete anchor).
  func testMultiplicationConcrete() {
    assertAlmostEqual(
      primaryProbe.multiplied(onRightBy: secondaryProbe),
      makeProbe([[19, 22], [43, 50]]),
      "[[1,2],[3,4]]·[[5,6],[7,8]] == [[19,22],[43,50]]"
    )
  }

  /// Inverse of `[[2,1],[1,1]]` (det `1`) is `[[1,-1],[-1,2]]` (concrete anchor).
  func testInverseConcrete() {
    assertAlmostEqual(
      invertibleConcrete.inverted(),
      makeProbe([[1, -1], [-1, 2]]),
      "[[2,1],[1,1]]⁻¹ == [[1,-1],[-1,2]]"
    )
  }
}

// -------------------------------------------------------------------------- //
// MARK: Concrete Leaves
// -------------------------------------------------------------------------- //

final class Matrix2x2_Float_Manual: Matrix2x2ManualValidation<Float> {}
final class Matrix2x2_Double_Manual: Matrix2x2ManualValidation<Double> {}
final class Matrix2x2_Half_Manual: Matrix2x2ManualValidation<Float16> {}
