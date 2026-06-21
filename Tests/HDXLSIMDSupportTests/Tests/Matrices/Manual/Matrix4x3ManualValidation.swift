//
//  Matrix4x3ManualValidation.swift
//
//  `Matrix4x3` is 4 columns × 3 rows (a 3×4 matrix in math notation);
//  `init(scalars:)` takes 3 visual rows of 4 entries. Its result shape (3 rows)
//  makes it one of the `Float16` half-3-row cases the equivalence layer skips,
//  so these hand-checked invariants are the primary safety net there.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x3ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix4x3<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1, 0, 3], [1, 0, 2, 1], [0, 3, 1, 0]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0, 1, 0], [0, 2, 0, 1], [1, 0, 2, 0]] }

  /// Positional `init(_:_:_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    let c0 = SIMD3<T>(scalar(1), scalar(5), scalar(9))
    let c1 = SIMD3<T>(scalar(2), scalar(6), scalar(10))
    let c2 = SIMD3<T>(scalar(3), scalar(7), scalar(11))
    let c3 = SIMD3<T>(scalar(4), scalar(8), scalar(12))
    assertAlmostEqual(Matrix4x3<T>(c0, c1, c2, c3), primaryProbe, "init(_:_:_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 3x4 shape, values swapped.
  func testTransposeConcrete() {
    XCTAssertEqual(Matrix3x4<T>.rowCount, 4, "[invariant] transpose of 4x3 has 4 rows")
    XCTAssertEqual(Matrix3x4<T>.columnCount, 3, "[invariant] transpose of 4x3 has 3 columns")
    assertMatricesAlmostEqual(
      primaryProbe.transposed(),
      matrix(Matrix3x4<T>.self, [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]),
      "transpose concrete",
      tolerance: absoluteTolerance
    )
  }

  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  /// `(4x3)·(2x4) → (2x3)`.
  func testRightMultiplyBy2x4() {
    let rhsRows = [[1, 2], [3, 4], [5, 6], [7, 8]]  // Matrix2x4 is 4 rows × 2 cols
    let rhs = matrix(Matrix2x4<T>.self, rhsRows)
    let expected = matrix(Matrix2x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x3)·(2x4) → 2x3", tolerance: absoluteTolerance)
  }

  /// `(4x3)·(3x4) → (3x3)`.
  func testRightMultiplyBy3x4() {
    let rhsRows = [[1, 2, 0], [0, 1, 2], [2, 0, 1], [1, 1, 0]]  // Matrix3x4 is 4 rows × 3 cols
    let rhs = matrix(Matrix3x4<T>.self, rhsRows)
    let expected = matrix(Matrix3x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x3)·(3x4) → 3x3", tolerance: absoluteTolerance)
  }

  /// `(4x3)·(4x4) → Self`, with identity law and form-variant.
  func testRightMultiplyBy4x4() {
    let rhsRows = [[2, 0, 1, 0], [0, 2, 0, 1], [1, 0, 2, 0], [0, 1, 0, 2]]
    let rhs = matrix(Matrix4x4<T>.self, rhsRows)
    let expected = matrix(Matrix4x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(4x3)·(4x4) → 4x3", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix4x4<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 4x4) matches")
  }

  /// `(3x2)·(4x3) → (4x2)`.
  func testLeftMultiplyBy3x2() {
    let lhsRows = [[1, 2, 3], [4, 5, 6]]  // Matrix3x2 is 2 rows × 3 cols
    let lhs = matrix(Matrix3x2<T>.self, lhsRows)
    let expected = matrix(Matrix4x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x2)·(4x3) → 4x2", tolerance: absoluteTolerance)
  }

  /// `(3x3)·(4x3) → Self`, with identity law and form-variant.
  func testLeftMultiplyBy3x3() {
    let lhsRows = [[2, 0, 1], [1, 3, 0], [0, 1, 2]]
    let lhs = matrix(Matrix3x3<T>.self, lhsRows)
    let expected = matrix(Matrix4x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x3)·(4x3) → 4x3", tolerance: absoluteTolerance)
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix3x3<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 3x3) matches")
  }

  /// `(3x4)·(4x3) → (4x4)`.
  func testLeftMultiplyBy3x4() {
    let lhsRows = [[1, 0, 1], [0, 1, 0], [1, 0, 1], [0, 1, 1]]  // Matrix3x4 is 4 rows × 3 cols
    let lhs = matrix(Matrix3x4<T>.self, lhsRows)
    let expected = matrix(Matrix4x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x4)·(4x3) → 4x4", tolerance: absoluteTolerance)
  }
}

final class Matrix4x3_Float_Manual: Matrix4x3ManualValidation<Float> {}
final class Matrix4x3_Double_Manual: Matrix4x3ManualValidation<Double> {}
final class Matrix4x3_Half_Manual: Matrix4x3ManualValidation<Float16> {}
