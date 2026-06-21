//
//  Matrix2x4ManualValidation.swift
//
//  `Matrix2x4` is 2 columns × 4 rows (a 4×2 matrix in math notation);
//  `init(scalars:)` takes 4 visual rows of 2 entries.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x4ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix2x4<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2], [3, 4], [5, 6], [7, 8]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1], [0, 3], [1, 2], [3, 0]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0], [2, 1], [0, 2], [1, 3]] }

  /// Positional `init(_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD4<T>(scalar(1), scalar(3), scalar(5), scalar(7))
    let c1 = SIMD4<T>(scalar(2), scalar(4), scalar(6), scalar(8))
    assertAlmostEqual(Matrix2x4<T>(c0, c1), primaryProbe, "init(_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 4x2 shape, values swapped.
  func testTransposeConcrete() {
    XCTAssertEqual(Matrix4x2<T>.rowCount, 2, "[invariant] transpose of 2x4 has 2 rows")
    XCTAssertEqual(Matrix4x2<T>.columnCount, 4, "[invariant] transpose of 2x4 has 4 columns")
    assertMatricesAlmostEqual(
      primaryProbe.transposed(),
      matrix(Matrix4x2<T>.self, [[1, 3, 5, 7], [2, 4, 6, 8]]),
      "transpose([[1,2],[3,4],[5,6],[7,8]]) == [[1,3,5,7],[2,4,6,8]]",
      tolerance: absoluteTolerance
    )
  }

  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  /// `(2x4)·(2x2) → Self`, with identity law and form-variant.
  func testRightMultiplyBy2x2() {
    let rhsRows = [[2, 1], [0, 3]]
    let rhs = matrix(Matrix2x2<T>.self, rhsRows)
    let expected = matrix(Matrix2x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x4)·(2x2) → 2x4", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix2x2<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 2x2) matches")
  }

  /// `(2x4)·(3x2) → (3x4)`.
  func testRightMultiplyBy3x2() {
    let rhsRows = [[1, 2, 0], [0, 1, 2]]  // Matrix3x2 is 2 rows × 3 cols
    let rhs = matrix(Matrix3x2<T>.self, rhsRows)
    let expected = matrix(Matrix3x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x4)·(3x2) → 3x4", tolerance: absoluteTolerance)
  }

  /// `(2x4)·(4x2) → (4x4)`.
  func testRightMultiplyBy4x2() {
    let rhsRows = [[1, 0, 2, 0], [0, 1, 0, 2]]  // Matrix4x2 is 2 rows × 4 cols
    let rhs = matrix(Matrix4x2<T>.self, rhsRows)
    let expected = matrix(Matrix4x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x4)·(4x2) → 4x4", tolerance: absoluteTolerance)
  }

  /// `(4x2)·(2x4) → (2x2)`.
  func testLeftMultiplyBy4x2() {
    let lhsRows = [[1, 2, 3, 4], [5, 6, 7, 8]]  // Matrix4x2 is 2 rows × 4 cols
    let lhs = matrix(Matrix4x2<T>.self, lhsRows)
    let expected = matrix(Matrix2x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x2)·(2x4) → 2x2", tolerance: absoluteTolerance)
  }

  /// `(4x3)·(2x4) → (2x3)`.
  func testLeftMultiplyBy4x3() {
    let lhsRows = [[1, 0, 1, 0], [0, 1, 0, 1], [1, 1, 1, 1]]  // Matrix4x3 is 3 rows × 4 cols
    let lhs = matrix(Matrix4x3<T>.self, lhsRows)
    let expected = matrix(Matrix2x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x3)·(2x4) → 2x3", tolerance: absoluteTolerance)
  }

  /// `(4x4)·(2x4) → Self`, with identity law and form-variant.
  func testLeftMultiplyBy4x4() {
    let lhsRows = [[2, 0, 1, 0], [0, 2, 0, 1], [1, 0, 2, 0], [0, 1, 0, 2]]
    let lhs = matrix(Matrix4x4<T>.self, lhsRows)
    let expected = matrix(Matrix2x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x4)·(2x4) → 2x4", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix4x4<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 4x4) matches")
  }
}

final class Matrix2x4_Float_Manual: Matrix2x4ManualValidation<Float> {}
final class Matrix2x4_Double_Manual: Matrix2x4ManualValidation<Double> {}
final class Matrix2x4_Half_Manual: Matrix2x4ManualValidation<Float16> {}
