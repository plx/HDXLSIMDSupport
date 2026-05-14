//
//  HalfMatrixShapeSanityTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class HalfMatrixShapeSanityTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Shape Support
  // ------------------------------------------------------------------------ //

  internal func validateShape<Matrix:MatrixProtocol>(
    forMatrix matrix: Matrix.Type,
    columnCount: Int,
    rowCount: Int) {

    XCTAssertEqual(rowCount, matrix.rowCount)
    XCTAssertEqual(columnCount, matrix.columnCount)
    XCTAssertEqual(rowCount, matrix.columnLength)
    XCTAssertEqual(columnCount, matrix.rowLength)
    XCTAssertEqual(rowCount * columnCount, matrix.scalarCount)
  }

  func testHalfMatrix2x2Shape() {
    self.validateShape(forMatrix: simd_half2x2.self, columnCount: 2, rowCount: 2)
    self.validateShape(forMatrix: HalfMatrix2x2Storage.self, columnCount: 2, rowCount: 2)
    self.validateShape(forMatrix: Matrix2x2<Float16>.self, columnCount: 2, rowCount: 2)
  }

  func testHalfMatrix2x3Shape() {
    self.validateShape(forMatrix: simd_half2x3.self, columnCount: 2, rowCount: 3)
    self.validateShape(forMatrix: HalfMatrix2x3Storage.self, columnCount: 2, rowCount: 3)
    self.validateShape(forMatrix: Matrix2x3<Float16>.self, columnCount: 2, rowCount: 3)
  }

  func testHalfMatrix2x4Shape() {
    self.validateShape(forMatrix: simd_half2x4.self, columnCount: 2, rowCount: 4)
    self.validateShape(forMatrix: HalfMatrix2x4Storage.self, columnCount: 2, rowCount: 4)
    self.validateShape(forMatrix: Matrix2x4<Float16>.self, columnCount: 2, rowCount: 4)
  }

  func testHalfMatrix3x2Shape() {
    self.validateShape(forMatrix: simd_half3x2.self, columnCount: 3, rowCount: 2)
    self.validateShape(forMatrix: HalfMatrix3x2Storage.self, columnCount: 3, rowCount: 2)
    self.validateShape(forMatrix: Matrix3x2<Float16>.self, columnCount: 3, rowCount: 2)
  }

  func testHalfMatrix3x3Shape() {
    self.validateShape(forMatrix: simd_half3x3.self, columnCount: 3, rowCount: 3)
    self.validateShape(forMatrix: HalfMatrix3x3Storage.self, columnCount: 3, rowCount: 3)
    self.validateShape(forMatrix: Matrix3x3<Float16>.self, columnCount: 3, rowCount: 3)
  }

  func testHalfMatrix3x4Shape() {
    self.validateShape(forMatrix: simd_half3x4.self, columnCount: 3, rowCount: 4)
    self.validateShape(forMatrix: HalfMatrix3x4Storage.self, columnCount: 3, rowCount: 4)
    self.validateShape(forMatrix: Matrix3x4<Float16>.self, columnCount: 3, rowCount: 4)
  }

  func testHalfMatrix4x2Shape() {
    self.validateShape(forMatrix: simd_half4x2.self, columnCount: 4, rowCount: 2)
    self.validateShape(forMatrix: HalfMatrix4x2Storage.self, columnCount: 4, rowCount: 2)
    self.validateShape(forMatrix: Matrix4x2<Float16>.self, columnCount: 4, rowCount: 2)
  }

  func testHalfMatrix4x3Shape() {
    self.validateShape(forMatrix: simd_half4x3.self, columnCount: 4, rowCount: 3)
    self.validateShape(forMatrix: HalfMatrix4x3Storage.self, columnCount: 4, rowCount: 3)
    self.validateShape(forMatrix: Matrix4x3<Float16>.self, columnCount: 4, rowCount: 3)
  }

  func testHalfMatrix4x4Shape() {
    self.validateShape(forMatrix: simd_half4x4.self, columnCount: 4, rowCount: 4)
    self.validateShape(forMatrix: HalfMatrix4x4Storage.self, columnCount: 4, rowCount: 4)
    self.validateShape(forMatrix: Matrix4x4<Float16>.self, columnCount: 4, rowCount: 4)
  }

}
