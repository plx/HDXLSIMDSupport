//
//  MatrixOperatorSupportTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixOperatorSupportTests: XCTestCase {

  typealias M2 = Matrix2x2<Double>

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitSquareMatrixIdentityValues() {
    // The identity convenience should be a real diagonal identity matrix, not
    // merely a matrix filled with ones or a shape-specific native shortcut.
    assertMatrix(
      Matrix2x2<Double>.identity,
      Matrix2x2<Double>(scalars: [[1, 0], [0, 1]])
    )
    assertMatrix(
      Matrix3x3<Double>.identity,
      Matrix3x3<Double>(scalars: [[1, 0, 0], [0, 1, 0], [0, 0, 1]])
    )
    assertMatrix(
      Matrix4x4<Double>.identity,
      Matrix4x4<Double>(scalars: [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

  func testCommonMatrixOperatorsAcrossGeneratedMatricesAndScalars() {
    for seed in -3...3 {
      let lhs = generatedMatrix(seed: seed)
      let rhs = generatedMatrix(seed: seed + 5)
      let scalar = Double(seed == 0 ? 2 : seed)

      assertMatrix(-lhs, lhs.negated())
      assertMatrix(lhs + rhs, lhs.adding(rhs))
      assertMatrix(lhs + (scalar, rhs), lhs.adding(rhs, multipliedBy: scalar))

      var addAssign = lhs
      addAssign += rhs
      assertMatrix(addAssign, lhs.adding(rhs))

      var scaledAddAssign = lhs
      scaledAddAssign += (scalar, rhs)
      assertMatrix(scaledAddAssign, lhs.adding(rhs, multipliedBy: scalar))

      assertMatrix(lhs - rhs, lhs.subtracting(rhs))
      assertMatrix(lhs - (scalar, rhs), lhs.subtracting(rhs, multipliedBy: scalar))

      var subtractAssign = lhs
      subtractAssign -= rhs
      assertMatrix(subtractAssign, lhs.subtracting(rhs))

      var scaledSubtractAssign = lhs
      scaledSubtractAssign -= (scalar, rhs)
      assertMatrix(scaledSubtractAssign, lhs.subtracting(rhs, multipliedBy: scalar))

      assertMatrix(lhs * scalar, lhs.multiplied(by: scalar))
      assertMatrix(scalar * lhs, lhs.multiplied(by: scalar))

      var multiplyAssign = lhs
      multiplyAssign *= scalar
      assertMatrix(multiplyAssign, lhs.multiplied(by: scalar))

      assertMatrix(lhs / scalar, lhs.divided(by: scalar))

      var divideAssign = lhs
      divideAssign /= scalar
      assertMatrix(divideAssign, lhs.divided(by: scalar))

      let leftVector = SIMD2<Double>(Double(seed + 1), Double(seed + 2))
      XCTAssertEqual(leftVector * lhs, lhs.multiplied(onLeftBy: leftVector))

      let rightVector = SIMD2<Double>(Double(seed + 3), Double(seed + 4))
      XCTAssertEqual(lhs * rightVector, lhs.multiplied(onRightBy: rightVector))
    }
  }

  func testMatrix2x2SpecificOperatorsAcrossGeneratedMatrices() {
    for seed in -3...3 {
      let lhs = generatedMatrix(seed: seed)
      let rhs = diagonalMatrix(first: Double(seed + 5), second: Double(seed + 7))

      assertMatrix(lhs * rhs, lhs.multiplied(onRightBy: rhs))

      var rightMultiplyAssign = lhs
      rightMultiplyAssign *= rhs
      assertMatrix(rightMultiplyAssign, lhs.multiplied(onRightBy: rhs))

      var leftMultiplyAssign = rhs
      lhs =* leftMultiplyAssign
      assertMatrix(leftMultiplyAssign, rhs.multiplied(onLeftBy: lhs))

      assertMatrix(lhs / rhs, lhs.divided(onRightBy: rhs))

      var rightDivideAssign = lhs
      rightDivideAssign /= rhs
      assertMatrix(rightDivideAssign, lhs.divided(onRightBy: rhs))

      var leftDivideAssign = lhs
      rhs =/ leftDivideAssign
      assertMatrix(leftDivideAssign, lhs.divided(onLeftBy: rhs))

      let matrix3x2 = Matrix3x2<Double>(
        scalars: [
          [Double(seed), Double(seed + 1), Double(seed + 2)],
          [Double(seed + 3), Double(seed + 4), Double(seed + 5)]
        ]
      )
      assertMatrix(lhs * matrix3x2, lhs.multiplied(onRightBy: matrix3x2))

      let matrix4x2 = Matrix4x2<Double>(
        scalars: [
          [Double(seed), Double(seed + 1), Double(seed + 2), Double(seed + 3)],
          [Double(seed + 4), Double(seed + 5), Double(seed + 6), Double(seed + 7)]
        ]
      )
      assertMatrix(lhs * matrix4x2, lhs.multiplied(onRightBy: matrix4x2))
    }
  }

  func testSquareMatrixIdentityActsAsMultiplicativeIdentity() {
    for seed in -3...3 {
      let matrix2x2 = generatedMatrix(seed: seed)
      assertMatrix(Matrix2x2<Double>.identity * matrix2x2, matrix2x2)
      assertMatrix(matrix2x2 * Matrix2x2<Double>.identity, matrix2x2)

      let matrix3x3 = Matrix3x3<Double>(
        scalars: [
          [Double(seed + 1), 0, 0],
          [0, Double(seed + 2), 0],
          [0, 0, Double(seed + 3)]
        ]
      )
      assertMatrix(Matrix3x3<Double>.identity * matrix3x3, matrix3x3)
      assertMatrix(matrix3x3 * Matrix3x3<Double>.identity, matrix3x3)

      let matrix4x4 = Matrix4x4<Double>(
        scalars: [
          [Double(seed + 1), 0, 0, 0],
          [0, Double(seed + 2), 0, 0],
          [0, 0, Double(seed + 3), 0],
          [0, 0, 0, Double(seed + 4)]
        ]
      )
      assertMatrix(Matrix4x4<Double>.identity * matrix4x4, matrix4x4)
      assertMatrix(matrix4x4 * Matrix4x4<Double>.identity, matrix4x4)
    }
  }

  func testRemainingShapeSpecificOperatorsAcrossGeneratedMatrices() {
    for seed in -3...3 {
      exerciseRemainingShapeSpecificOperators(seed: seed)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func exerciseRemainingShapeSpecificOperators(seed: Int) {
    let matrix2x2 = diagonalMatrix(first: 2, second: 3)
    let matrix3x3 = Matrix3x3<Double>(
      scalars: [
        [2, 0, 0],
        [0, 3, 0],
        [0, 0, 5]
      ]
    )
    let matrix4x4 = Matrix4x4<Double>(
      scalars: [
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 5, 0],
        [0, 0, 0, 7]
      ]
    )

    let matrix2x3 = Matrix2x3<Double>(scalars: scalars(rows: 3, columns: 2, seed: seed + 1))
    let matrix2x4 = Matrix2x4<Double>(scalars: scalars(rows: 4, columns: 2, seed: seed + 2))
    let matrix3x2 = Matrix3x2<Double>(scalars: scalars(rows: 2, columns: 3, seed: seed + 3))
    let matrix3x4 = Matrix3x4<Double>(scalars: scalars(rows: 4, columns: 3, seed: seed + 4))
    let matrix4x2 = Matrix4x2<Double>(scalars: scalars(rows: 2, columns: 4, seed: seed + 5))
    let matrix4x3 = Matrix4x3<Double>(scalars: scalars(rows: 3, columns: 4, seed: seed + 6))

    assertMatrix(matrix2x3 * matrix2x2, matrix2x3.multiplied(onRightBy: matrix2x2))
    assertMatrix(matrix2x3 * matrix3x2, matrix2x3.multiplied(onRightBy: matrix3x2))
    assertMatrix(matrix2x3 * matrix4x2, matrix2x3.multiplied(onRightBy: matrix4x2))
    var matrix2x3RightAssign = matrix2x3
    matrix2x3RightAssign *= matrix2x2
    assertMatrix(matrix2x3RightAssign, matrix2x3.multiplied(onRightBy: matrix2x2))
    var matrix2x3LeftAssign = matrix2x3
    matrix3x3 =* matrix2x3LeftAssign
    assertMatrix(matrix2x3LeftAssign, matrix2x3.multiplied(onLeftBy: matrix3x3))

    assertMatrix(matrix2x4 * matrix2x2, matrix2x4.multiplied(onRightBy: matrix2x2))
    assertMatrix(matrix2x4 * matrix3x2, matrix2x4.multiplied(onRightBy: matrix3x2))
    assertMatrix(matrix2x4 * matrix4x2, matrix2x4.multiplied(onRightBy: matrix4x2))
    var matrix2x4RightAssign = matrix2x4
    matrix2x4RightAssign *= matrix2x2
    assertMatrix(matrix2x4RightAssign, matrix2x4.multiplied(onRightBy: matrix2x2))
    var matrix2x4LeftAssign = matrix2x4
    matrix4x4 =* matrix2x4LeftAssign
    assertMatrix(matrix2x4LeftAssign, matrix2x4.multiplied(onLeftBy: matrix4x4))

    assertMatrix(matrix3x2 * matrix2x3, matrix3x2.multiplied(onRightBy: matrix2x3))
    assertMatrix(matrix3x2 * matrix3x3, matrix3x2.multiplied(onRightBy: matrix3x3))
    assertMatrix(matrix3x2 * matrix4x3, matrix3x2.multiplied(onRightBy: matrix4x3))
    var matrix3x2RightAssign = matrix3x2
    matrix3x2RightAssign *= matrix3x3
    assertMatrix(matrix3x2RightAssign, matrix3x2.multiplied(onRightBy: matrix3x3))
    var matrix3x2LeftAssign = matrix3x2
    matrix2x2 =* matrix3x2LeftAssign
    assertMatrix(matrix3x2LeftAssign, matrix3x2.multiplied(onLeftBy: matrix2x2))

    assertMatrix(matrix3x4 * matrix2x3, matrix3x4.multiplied(onRightBy: matrix2x3))
    assertMatrix(matrix3x4 * matrix3x3, matrix3x4.multiplied(onRightBy: matrix3x3))
    assertMatrix(matrix3x4 * matrix4x3, matrix3x4.multiplied(onRightBy: matrix4x3))
    var matrix3x4RightAssign = matrix3x4
    matrix3x4RightAssign *= matrix3x3
    assertMatrix(matrix3x4RightAssign, matrix3x4.multiplied(onRightBy: matrix3x3))
    var matrix3x4LeftAssign = matrix3x4
    matrix4x4 =* matrix3x4LeftAssign
    assertMatrix(matrix3x4LeftAssign, matrix3x4.multiplied(onLeftBy: matrix4x4))

    assertMatrix(matrix4x2 * matrix2x4, matrix4x2.multiplied(onRightBy: matrix2x4))
    assertMatrix(matrix4x2 * matrix3x4, matrix4x2.multiplied(onRightBy: matrix3x4))
    assertMatrix(matrix4x2 * matrix4x4, matrix4x2.multiplied(onRightBy: matrix4x4))
    var matrix4x2RightAssign = matrix4x2
    matrix4x2RightAssign *= matrix4x4
    assertMatrix(matrix4x2RightAssign, matrix4x2.multiplied(onRightBy: matrix4x4))
    var matrix4x2LeftAssign = matrix4x2
    matrix2x2 =* matrix4x2LeftAssign
    assertMatrix(matrix4x2LeftAssign, matrix4x2.multiplied(onLeftBy: matrix2x2))

    assertMatrix(matrix4x3 * matrix2x4, matrix4x3.multiplied(onRightBy: matrix2x4))
    assertMatrix(matrix4x3 * matrix3x4, matrix4x3.multiplied(onRightBy: matrix3x4))
    assertMatrix(matrix4x3 * matrix4x4, matrix4x3.multiplied(onRightBy: matrix4x4))
    var matrix4x3RightAssign = matrix4x3
    matrix4x3RightAssign *= matrix4x4
    assertMatrix(matrix4x3RightAssign, matrix4x3.multiplied(onRightBy: matrix4x4))
    var matrix4x3LeftAssign = matrix4x3
    matrix3x3 =* matrix4x3LeftAssign
    assertMatrix(matrix4x3LeftAssign, matrix4x3.multiplied(onLeftBy: matrix3x3))

    let square3 = Matrix3x3<Double>(
      scalars: [
        [Double(seed + 1), 0, 0],
        [0, Double(seed + 3), 0],
        [0, 0, Double(seed + 5)]
      ]
    )
    let square4 = Matrix4x4<Double>(
      scalars: [
        [Double(seed + 1), 0, 0, 0],
        [0, Double(seed + 3), 0, 0],
        [0, 0, Double(seed + 5), 0],
        [0, 0, 0, Double(seed + 7)]
      ]
    )

    assertMatrix(square3 * matrix2x3, square3.multiplied(onRightBy: matrix2x3))
    assertMatrix(square3 * matrix4x3, square3.multiplied(onRightBy: matrix4x3))
    assertMatrix(square3 * matrix3x3, square3.multiplied(onRightBy: matrix3x3))
    var square3RightAssign = square3
    square3RightAssign *= matrix3x3
    assertMatrix(square3RightAssign, square3.multiplied(onRightBy: matrix3x3))
    var square3LeftAssign = matrix3x3
    square3 =* square3LeftAssign
    assertMatrix(square3LeftAssign, matrix3x3.multiplied(onLeftBy: square3))
    assertMatrix(square3 / matrix3x3, square3.divided(onRightBy: matrix3x3))
    var square3RightDivide = square3
    square3RightDivide /= matrix3x3
    assertMatrix(square3RightDivide, square3.divided(onRightBy: matrix3x3))
    var square3LeftDivide = square3
    matrix3x3 =/ square3LeftDivide
    assertMatrix(square3LeftDivide, square3.divided(onLeftBy: matrix3x3))

    assertMatrix(square4 * matrix2x4, square4.multiplied(onRightBy: matrix2x4))
    assertMatrix(square4 * matrix3x4, square4.multiplied(onRightBy: matrix3x4))
    assertMatrix(square4 * matrix4x4, square4.multiplied(onRightBy: matrix4x4))
    var square4RightAssign = square4
    square4RightAssign *= matrix4x4
    assertMatrix(square4RightAssign, square4.multiplied(onRightBy: matrix4x4))
    var square4LeftAssign = matrix4x4
    square4 =* square4LeftAssign
    assertMatrix(square4LeftAssign, matrix4x4.multiplied(onLeftBy: square4))
    assertMatrix(square4 / matrix4x4, square4.divided(onRightBy: matrix4x4))
    var square4RightDivide = square4
    square4RightDivide /= matrix4x4
    assertMatrix(square4RightDivide, square4.divided(onRightBy: matrix4x4))
    var square4LeftDivide = square4
    matrix4x4 =/ square4LeftDivide
    assertMatrix(square4LeftDivide, square4.divided(onLeftBy: matrix4x4))
  }

  private func generatedMatrix(seed: Int) -> M2 {
    let base = Double(seed)
    return M2(
      scalars: [
        [base + 1, base + 2],
        [base + 3, base + 5]
      ]
    )
  }

  private func diagonalMatrix(first: Double, second: Double) -> M2 {
    return M2(
      scalars: [
        [first, 0],
        [0, second]
      ]
    )
  }

  private func scalars(
    rows: Int,
    columns: Int,
    seed: Int
  ) -> [[Double]] {
    return (0..<rows).map { row in
      (0..<columns).map { column in
        Double(seed + (row * columns) + column)
      }
    }
  }

  private func assertMatrix<Matrix>(
    _ lhs: Matrix,
    _ rhs: Matrix,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where
    Matrix: MatrixProtocol & LInfinityDistanceMeasureable,
    Matrix.Scalar == Double,
    Matrix.LInfinityDistance == Double
  {
    XCTAssertLessThanOrEqual(
      lhs.lInfinityDistance(to: rhs),
      1.0e-10,
      file: file,
      line: line
    )
  }

}
