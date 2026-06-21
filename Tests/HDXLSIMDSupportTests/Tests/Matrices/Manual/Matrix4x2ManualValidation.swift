//
//  Matrix4x2ManualValidation.swift
//
//  `Matrix4x2` is 4 columns × 2 rows (a 2×4 matrix in math notation);
//  `init(scalars:)` takes 2 visual rows of 4 entries.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix4x2<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2, 3, 4], [5, 6, 7, 8]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1, 0, 3], [1, 0, 2, 1]] }
  override var tertiaryProbeRows: [[Int]] { [[0, 1, 2, 1], [3, 0, 1, 2]] }

  /// Positional `init(_:_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD2<T>(scalar(1), scalar(5))
    let c1 = SIMD2<T>(scalar(2), scalar(6))
    let c2 = SIMD2<T>(scalar(3), scalar(7))
    let c3 = SIMD2<T>(scalar(4), scalar(8))
    assertAlmostEqual(Matrix4x2<T>(c0, c1, c2, c3), primaryProbe, "init(_:_:_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 2x4 shape, values swapped.
  func testTransposeConcrete() {
    XCTAssertEqual(Matrix2x4<T>.rowCount, 4, "[invariant] transpose of 4x2 has 4 rows")
    XCTAssertEqual(Matrix2x4<T>.columnCount, 2, "[invariant] transpose of 4x2 has 2 columns")
    assertMatricesAlmostEqual(
      primaryProbe.transposed(),
      matrix(Matrix2x4<T>.self, [[1, 5], [2, 6], [3, 7], [4, 8]]),
      "transpose([[1,2,3,4],[5,6,7,8]]) == [[1,5],[2,6],[3,7],[4,8]]",
      tolerance: absoluteTolerance
    )
  }

  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  /// `(4x2)·(2x4) → (2x2)`.
  func testRightMultiplyBy2x4() {
    let rhsRows = [[1, 2], [3, 4], [5, 6], [7, 8]]  // Matrix2x4 is 4 rows × 2 cols
    let rhs = matrix(Matrix2x4<T>.self, rhsRows)
    let expected = matrix(Matrix2x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x2)·(2x4) → 2x2", tolerance: absoluteTolerance)
  }

  /// `(4x2)·(3x4) → (3x2)`.
  func testRightMultiplyBy3x4() {
    let rhsRows = [[1, 2, 0], [0, 1, 2], [2, 0, 1], [1, 1, 0]]  // Matrix3x4 is 4 rows × 3 cols
    let rhs = matrix(Matrix3x4<T>.self, rhsRows)
    let expected = matrix(Matrix3x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x2)·(3x4) → 3x2", tolerance: absoluteTolerance)
  }

  /// `(4x2)·(4x4) → Self`, with identity law and form-variant.
  func testRightMultiplyBy4x4() {
    let rhsRows = [[2, 0, 1, 0], [0, 2, 0, 1], [1, 0, 2, 0], [0, 1, 0, 2]]
    let rhs = matrix(Matrix4x4<T>.self, rhsRows)
    let expected = matrix(Matrix4x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x2)·(4x4) → 4x2", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix4x4<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 4x4) matches")
  }

  /// `(2x2)·(4x2) → Self`, with identity law and form-variant.
  func testLeftMultiplyBy2x2() {
    let lhsRows = [[2, 1], [0, 3]]
    let lhs = matrix(Matrix2x2<T>.self, lhsRows)
    let expected = matrix(Matrix4x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x2)·(4x2) → 4x2", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix2x2<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 2x2) matches")
  }

  /// `(2x4)·(4x2) → (4x4)`.
  func testLeftMultiplyBy2x4() {
    let lhsRows = [[1, 2], [3, 4], [5, 6], [7, 8]]  // Matrix2x4 is 4 rows × 2 cols
    let lhs = matrix(Matrix2x4<T>.self, lhsRows)
    let expected = matrix(Matrix4x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x4)·(4x2) → 4x4", tolerance: absoluteTolerance)
  }

  /// `(2x3)·(4x2) → (4x3)`.
  func testLeftMultiplyBy2x3() {
    let lhsRows = [[1, 2], [3, 4], [5, 6]]  // Matrix2x3 is 3 rows × 2 cols
    let lhs = matrix(Matrix2x3<T>.self, lhsRows)
    let expected = matrix(Matrix4x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x3)·(4x2) → 4x3", tolerance: absoluteTolerance)
  }
}

final class Matrix4x2_Float_Manual: Matrix4x2ManualValidation<Float> {}
final class Matrix4x2_Double_Manual: Matrix4x2ManualValidation<Double> {}
final class Matrix4x2_Half_Manual: Matrix4x2ManualValidation<Float16> {}
