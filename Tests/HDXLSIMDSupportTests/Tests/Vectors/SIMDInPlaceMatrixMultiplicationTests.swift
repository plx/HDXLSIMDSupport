//
//  SIMDInPlaceMatrixMultiplicationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class SIMDInPlaceMatrixMultiplicationTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Explicit Examples
  // ------------------------------------------------------------------------ //

  func testExplicitSIMD2MatrixMultiplicationConveniences() {
    // SIMD2 gets named left/right multiplication plus `*=` and reversed `=*`.
    // The examples verify that left multiplication means `matrix * vector`
    // while right multiplication means `vector * matrix`.
    let matrix = Matrix2x2<Double>(scalars: [[2, 0], [0, 3]])
    let vector = SIMD2<Double>(5, 7)

    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix)
  }

  func testExplicitSIMD3MatrixMultiplicationConveniences() {
    // The SIMD3 overloads are separate source declarations, so an explicit
    // example guards their matrix shape and operand-order wiring.
    let matrix = Matrix3x3<Double>(scalars: [[2, 0, 0], [0, 3, 0], [0, 0, 4]])
    let vector = SIMD3<Double>(5, 7, 11)

    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix)
  }

  func testExplicitSIMD4MatrixMultiplicationConveniences() {
    // The SIMD4 overloads are used for homogeneous coordinates; the example
    // verifies both mutating operators against the out-of-place contracts.
    let matrix = Matrix4x4<Double>(
      scalars: [
        [2, 0, 0, 0],
        [0, 3, 0, 0],
        [0, 0, 4, 0],
        [0, 0, 0, 5]
      ]
    )
    let vector = SIMD4<Double>(5, 7, 11, 13)

    XCTAssertEqual(vector.multiplied(onLeftBy: matrix), matrix * vector)
    XCTAssertEqual(vector.multiplied(onRightBy: matrix), vector * matrix)

    var leftForm = vector
    leftForm.formMultiplication(onLeftBy: matrix)
    XCTAssertEqual(leftForm, matrix * vector)

    var rightForm = vector
    rightForm.formMultiplication(onRightBy: matrix)
    XCTAssertEqual(rightForm, vector * matrix)

    var leftOperator = vector
    leftOperator *= matrix
    XCTAssertEqual(leftOperator, matrix * vector)

    var rightOperator = vector
    matrix =* rightOperator
    XCTAssertEqual(rightOperator, vector * matrix)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Property-Style Coverage
  // ------------------------------------------------------------------------ //

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
