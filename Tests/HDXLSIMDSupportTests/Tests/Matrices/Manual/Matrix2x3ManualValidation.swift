//
//  Matrix2x3ManualValidation.swift
//
//  `Matrix2x3` is 2 columns × 3 rows (a 3×2 matrix in "rows×cols" math
//  notation). Its `init(scalars:)` takes 3 visual rows of 2 entries.
//

import XCTest
import simd
@testable import HDXLSIMDSupport

// -------------------------------------------------------------------------- //
// MARK: Matrix2x3ManualValidation
// -------------------------------------------------------------------------- //

class Matrix2x3ManualValidation<T: ExtendedSIMDScalar>: NonSquareMatrixManualValidation<Matrix2x3<T>> {

  override var primaryProbeRows: [[Int]] { [[1, 2], [3, 4], [5, 6]] }
  override var secondaryProbeRows: [[Int]] { [[2, 1], [0, 3], [4, 1]] }
  override var tertiaryProbeRows: [[Int]] { [[1, 0], [2, 1], [0, 3]] }

  /// Positional `init(_:_:)` builds the same matrix as `init(scalars:)`.
  func testPositionalInitializer() {
    // Columns of [[1,2],[3,4],[5,6]] are (1,3,5) and (2,4,6).
    let c0 = SIMD3<T>(scalar(1), scalar(3), scalar(5))
    let c1 = SIMD3<T>(scalar(2), scalar(4), scalar(6))
    assertAlmostEqual(Matrix2x3<T>(c0, c1), primaryProbe, "init(_:_:) == init(scalars:)")
  }

  /// Transpose produces the compatible 3x2 shape, with values swapped:
  /// `[[1,2],[3,4],[5,6]]ᵀ == [[1,3,5],[2,4,6]]` (concrete).
  func testTransposeConcrete() {
    let transposed = primaryProbe.transposed()  // Matrix3x2<T>
    XCTAssertEqual(Matrix3x2<T>.rowCount, 2, "[invariant] transpose of 2x3 has 2 rows")
    XCTAssertEqual(Matrix3x2<T>.columnCount, 3, "[invariant] transpose of 2x3 has 3 columns")
    assertMatricesAlmostEqual(
      transposed,
      matrix(Matrix3x2<T>.self, [[1, 3, 5], [2, 4, 6]]),
      "transpose([[1,2],[3,4],[5,6]]) == [[1,3,5],[2,4,6]]",
      tolerance: absoluteTolerance
    )
  }

  /// Double transpose (through the partner type) returns the original.
  func testDoubleTransposeRoundTrip() {
    assertAlmostEqual(primaryProbe.transposed().transposed(), primaryProbe, "aᵀᵀ == a")
  }

  // ------------------------------------------------------------------------ //
  // MARK: Cross-Shape Multiplication (vs. the textbook product oracle)
  // ------------------------------------------------------------------------ //

  /// `self · (2x2) → Self`.
  func testRightMultiplyBy2x2() {
    let rhsRows = [[1, 2], [3, 4]]
    let rhs = matrix(Matrix2x2<T>.self, rhsRows)
    let expected = matrix(Matrix2x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x3)·(2x2) → 2x3", tolerance: absoluteTolerance)
    // identity law:
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: Matrix2x2<T>.identity), primaryProbe, "a·I == a", tolerance: absoluteTolerance)
    // form-variant:
    var inPlace = primaryProbe; inPlace.formMultiplication(onRightBy: rhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onRightBy: rhs), "formMultiplication(onRightBy: 2x2) matches")
  }

  /// `self · (3x2) → (3x3)`.
  func testRightMultiplyBy3x2() {
    let rhsRows = [[1, 2, 0], [0, 1, 2]]  // Matrix3x2 is 2 rows × 3 cols
    let rhs = matrix(Matrix3x2<T>.self, rhsRows)
    let expected = matrix(Matrix3x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x3)·(3x2) → 3x3", tolerance: absoluteTolerance)
  }

  /// `self · (4x2) → (4x3)`.
  func testRightMultiplyBy4x2() {
    let rhsRows = [[1, 0, 1, 0], [0, 1, 0, 1]]  // Matrix4x2 is 2 rows × 4 cols
    let rhs = matrix(Matrix4x2<T>.self, rhsRows)
    let expected = matrix(Matrix4x3<T>.self, standardMatrixProduct(primaryProbeRows, rhsRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onRightBy: rhs), expected, "(2x3)·(4x2) → 4x3", tolerance: absoluteTolerance)
  }

  /// `(3x2) · self → (2x2)`.
  func testLeftMultiplyBy3x2() {
    let lhsRows = [[1, 2, 3], [4, 5, 6]]  // Matrix3x2 is 2 rows × 3 cols
    let lhs = matrix(Matrix3x2<T>.self, lhsRows)
    let expected = matrix(Matrix2x2<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x2)·(2x3) → 2x2", tolerance: absoluteTolerance)
  }

  /// `(3x3) · self → Self`.
  func testLeftMultiplyBy3x3() {
    let lhsRows = [[2, 0, 1], [1, 3, 0], [0, 1, 2]]
    let lhs = matrix(Matrix3x3<T>.self, lhsRows)
    let expected = matrix(Matrix2x3<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x3)·(2x3) → 2x3", tolerance: absoluteTolerance)
    // identity law:
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: Matrix3x3<T>.identity), primaryProbe, "I·a == a", tolerance: absoluteTolerance)
    // form-variant:
    var inPlace = primaryProbe; inPlace.formMultiplication(onLeftBy: lhs)
    assertAlmostEqual(inPlace, primaryProbe.multiplied(onLeftBy: lhs), "formMultiplication(onLeftBy: 3x3) matches")
  }

  /// `(3x4) · self → (2x4)`.
  func testLeftMultiplyBy3x4() {
    let lhsRows = [[1, 0, 2], [0, 1, 0], [2, 0, 1], [0, 2, 0]]  // Matrix3x4 is 4 rows × 3 cols
    let lhs = matrix(Matrix3x4<T>.self, lhsRows)
    let expected = matrix(Matrix2x4<T>.self, standardMatrixProduct(lhsRows, primaryProbeRows))
    assertMatricesAlmostEqual(primaryProbe.multiplied(onLeftBy: lhs), expected, "(3x4)·(2x3) → 2x4", tolerance: absoluteTolerance)
  }
}

// -------------------------------------------------------------------------- //
// MARK: Concrete Leaves
// -------------------------------------------------------------------------- //

final class Matrix2x3_Float_Manual: Matrix2x3ManualValidation<Float> {}
final class Matrix2x3_Double_Manual: Matrix2x3ManualValidation<Double> {}
final class Matrix2x3_Half_Manual: Matrix2x3ManualValidation<Float16> {}
