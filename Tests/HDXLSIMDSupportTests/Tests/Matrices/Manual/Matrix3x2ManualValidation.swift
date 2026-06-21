//
//  Matrix3x2ManualValidation.swift
//
//  `Matrix3x2` is 3 columns × 2 rows (a 2×3 matrix in math notation);
//  `init(scalars:)` takes 2 visual rows of 3 entries.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix3x2<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2, 3], [4, 5, 6]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1, 0], [1, 0, 3]] }
  override var tertiaryProbeRows: [[Int]] { [[0, 1, 2], [3, 1, 0]] }

  /// Positional `init(_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD2<T>(scalar(1), scalar(4))
    let c1 = SIMD2<T>(scalar(2), scalar(5))
    let c2 = SIMD2<T>(scalar(3), scalar(6))
    assertAlmostEqual(Matrix3x2<T>(c0, c1, c2), primaryProbe, "init(_:_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 2x3 shape, values swapped.
  func testTransposeConcrete() {
    XCTAssertEqual(Matrix2x3<T>.rowCount, 3, "[invariant] transpose of 3x2 has 3 rows")
    XCTAssertEqual(Matrix2x3<T>.columnCount, 2, "[invariant] transpose of 3x2 has 2 columns")
    assertMatricesAlmostEqual(
      primaryProbe.transposed(),
      matrix(Matrix2x3<T>.self, [[1, 4], [2, 5], [3, 6]]),
      "transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]",
      tolerance: absoluteTolerance
    )
  }

  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  /// `(3x2)·(2x3) → (2x2)`.
  func testRightMultiplyBy2x3() {
    let rhsRows = [[1, 2], [3, 4], [5, 6]]  // Matrix2x3 is 3 rows × 2 cols
    let rhs = matrix(Matrix2x3<T>.self, rhsRows)
    let expected = matrix(Matrix2x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x2)·(2x3) → 2x2", tolerance: absoluteTolerance)
  }

  /// `(3x2)·(3x3) → Self`, with identity law and form-variant.
  func testRightMultiplyBy3x3() {
    let rhsRows = [[2, 0, 1], [1, 3, 0], [0, 1, 2]]
    let rhs = matrix(Matrix3x3<T>.self, rhsRows)
    let expected = matrix(Matrix3x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x2)·(3x3) → 3x2", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix3x3<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 3x3) matches")
  }

  /// `(3x2)·(4x3) → (4x2)`.
  func testRightMultiplyBy4x3() {
    let rhsRows = [[1, 0, 1, 0], [0, 1, 0, 1], [1, 1, 0, 0]]  // Matrix4x3 is 3 rows × 4 cols
    let rhs = matrix(Matrix4x3<T>.self, rhsRows)
    let expected = matrix(Matrix4x2<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x2)·(4x3) → 4x2", tolerance: absoluteTolerance)
  }

  /// `(2x2)·(3x2) → Self`, with identity law and form-variant.
  func testLeftMultiplyBy2x2() {
    let lhsRows = [[2, 1], [0, 3]]
    let lhs = matrix(Matrix2x2<T>.self, lhsRows)
    let expected = matrix(Matrix3x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x2)·(3x2) → 3x2", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix2x2<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 2x2) matches")
  }

  /// `(2x3)·(3x2) → (3x3)`.
  func testLeftMultiplyBy2x3() {
    let lhsRows = [[1, 2], [3, 4], [5, 6]]  // Matrix2x3 is 3 rows × 2 cols
    let lhs = matrix(Matrix2x3<T>.self, lhsRows)
    let expected = matrix(Matrix3x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x3)·(3x2) → 3x3", tolerance: absoluteTolerance)
  }

  /// `(2x4)·(3x2) → (3x4)`.
  func testLeftMultiplyBy2x4() {
    let lhsRows = [[1, 2], [3, 4], [5, 6], [7, 8]]  // Matrix2x4 is 4 rows × 2 cols
    let lhs = matrix(Matrix2x4<T>.self, lhsRows)
    let expected = matrix(Matrix3x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(2x4)·(3x2) → 3x4", tolerance: absoluteTolerance)
  }
}

final class Matrix3x2_Float_Manual: Matrix3x2ManualValidation<Float> {}
final class Matrix3x2_Double_Manual: Matrix3x2ManualValidation<Double> {}
final class Matrix3x2_Half_Manual: Matrix3x2ManualValidation<Float16> {}
