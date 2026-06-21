//
//  Matrix3x4ManualValidation.swift
//
//  `Matrix3x4` is 3 columns × 4 rows (a 4×3 matrix in math notation);
//  `init(scalars:)` takes 4 visual rows of 3 entries.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix3x4<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1, 0], [1, 0, 3], [0, 2, 1], [3, 1, 0]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0, 1], [0, 2, 0], [1, 0, 2], [0, 1, 1]] }

  /// Positional `init(_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD4<T>(scalar(1), scalar(4), scalar(7), scalar(10))
    let c1 = SIMD4<T>(scalar(2), scalar(5), scalar(8), scalar(11))
    let c2 = SIMD4<T>(scalar(3), scalar(6), scalar(9), scalar(12))
    assertAlmostEqual(Matrix3x4<T>(c0, c1, c2), primaryProbe, "init(_:_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 4x3 shape, values swapped.
  func testTransposeConcrete() {
    XCTAssertEqual(Matrix4x3<T>.rowCount, 3, "[invariant] transpose of 3x4 has 3 rows")
    XCTAssertEqual(Matrix4x3<T>.columnCount, 4, "[invariant] transpose of 3x4 has 4 columns")
    assertMatricesAlmostEqual(
      primaryProbe.transposed(),
      matrix(Matrix4x3<T>.self, [[1, 4, 7, 10], [2, 5, 8, 11], [3, 6, 9, 12]]),
      "transpose concrete",
      tolerance: absoluteTolerance
    )
  }

  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  /// `(3x4)·(2x3) → (2x4)`.
  func testRightMultiplyBy2x3() {
    let rhsRows = [[1, 2], [3, 4], [5, 6]]  // Matrix2x3 is 3 rows × 2 cols
    let rhs = matrix(Matrix2x3<T>.self, rhsRows)
    let expected = matrix(Matrix2x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x4)·(2x3) → 2x4", tolerance: absoluteTolerance)
  }

  /// `(3x4)·(3x3) → Self`, with identity law and form-variant.
  func testRightMultiplyBy3x3() {
    let rhsRows = [[2, 0, 1], [1, 3, 0], [0, 1, 2]]
    let rhs = matrix(Matrix3x3<T>.self, rhsRows)
    let expected = matrix(Matrix3x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x4)·(3x3) → 3x4", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix3x3<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 3x3) matches")
  }

  /// `(3x4)·(4x3) → (4x4)`.
  func testRightMultiplyBy4x3() {
    let rhsRows = [[1, 0, 1, 0], [0, 1, 0, 1], [1, 1, 0, 0]]  // Matrix4x3 is 3 rows × 4 cols
    let rhs = matrix(Matrix4x3<T>.self, rhsRows)
    let expected = matrix(Matrix4x4<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(3x4)·(4x3) → 4x4", tolerance: absoluteTolerance)
  }

  /// `(4x2)·(3x4) → (3x2)`.
  func testLeftMultiplyBy4x2() {
    let lhsRows = [[1, 2, 3, 4], [5, 6, 7, 8]]  // Matrix4x2 is 2 rows × 4 cols
    let lhs = matrix(Matrix4x2<T>.self, lhsRows)
    let expected = matrix(Matrix3x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x2)·(3x4) → 3x2", tolerance: absoluteTolerance)
  }

  /// `(4x3)·(3x4) → (3x3)`.
  func testLeftMultiplyBy4x3() {
    let lhsRows = [[1, 0, 1, 0], [0, 1, 0, 1], [1, 1, 1, 1]]  // Matrix4x3 is 3 rows × 4 cols
    let lhs = matrix(Matrix4x3<T>.self, lhsRows)
    let expected = matrix(Matrix3x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x3)·(3x4) → 3x3", tolerance: absoluteTolerance)
  }

  /// `(4x4)·(3x4) → Self`, with identity law and form-variant.
  func testLeftMultiplyBy4x4() {
    let lhsRows = [[2, 0, 1, 0], [0, 2, 0, 1], [1, 0, 2, 0], [0, 1, 0, 2]]
    let lhs = matrix(Matrix4x4<T>.self, lhsRows)
    let expected = matrix(Matrix3x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(4x4)·(3x4) → 3x4", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix4x4<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 4x4) matches")
  }
}

final class Matrix3x4_Float_Manual: Matrix3x4ManualValidation<Float> {}
final class Matrix3x4_Double_Manual: Matrix3x4ManualValidation<Double> {}
final class Matrix3x4_Half_Manual: Matrix3x4ManualValidation<Float16> {}
