//
//  SIMDInPlaceMatrixMultiplicationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class SIMDInPlaceMatrixMultiplicationTests: XCTestCase {

  func testSIMD2MatrixMultiplicationConveniencesAcrossGeneratedValues() {
    for seed in -3...3 {
      let matrix = Matrix2x2<Double>(
        scalars: [
          [Double(seed + 2), 0],
          [0, Double(seed + 4)]
        ]
      )
      let vector = SIMD2<Double>(Double(seed + 5), Double(seed + 7))
      assertSIMD2Conveniences(vector: vector, matrix: matrix)
    }
  }

  func testSIMD3MatrixMultiplicationConveniencesAcrossGeneratedValues() {
    for seed in -3...3 {
      let matrix = Matrix3x3<Double>(
        scalars: [
          [Double(seed + 2), 0, 0],
          [0, Double(seed + 4), 0],
          [0, 0, Double(seed + 6)]
        ]
      )
      let vector = SIMD3<Double>(
        Double(seed + 5),
        Double(seed + 7),
        Double(seed + 11)
      )
      assertSIMD3Conveniences(vector: vector, matrix: matrix)
    }
  }

  func testSIMD4MatrixMultiplicationConveniencesAcrossGeneratedValues() {
    for seed in -3...3 {
      let matrix = Matrix4x4<Double>(
        scalars: [
          [Double(seed + 2), 0, 0, 0],
          [0, Double(seed + 4), 0, 0],
          [0, 0, Double(seed + 6), 0],
          [0, 0, 0, Double(seed + 8)]
        ]
      )
      let vector = SIMD4<Double>(
        Double(seed + 5),
        Double(seed + 7),
        Double(seed + 11),
        Double(seed + 13)
      )
      assertSIMD4Conveniences(vector: vector, matrix: matrix)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Helpers
  // ------------------------------------------------------------------------ //

  private func assertSIMD2Conveniences(
    vector: SIMD2<Double>,
    matrix: Matrix2x2<Double>,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector, file: file, line: line)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix, file: file, line: line)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector, file: file, line: line)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix, file: file, line: line)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector, file: file, line: line)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix, file: file, line: line)
  }

  private func assertSIMD3Conveniences(
    vector: SIMD3<Double>,
    matrix: Matrix3x3<Double>,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector, file: file, line: line)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix, file: file, line: line)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector, file: file, line: line)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix, file: file, line: line)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector, file: file, line: line)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix, file: file, line: line)
  }

  private func assertSIMD4Conveniences(
    vector: SIMD4<Double>,
    matrix: Matrix4x4<Double>,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector, file: file, line: line)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix, file: file, line: line)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector, file: file, line: line)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix, file: file, line: line)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector, file: file, line: line)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix, file: file, line: line)
  }

}
