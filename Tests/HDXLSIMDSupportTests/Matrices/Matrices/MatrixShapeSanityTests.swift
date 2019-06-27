//
//  MatrixShapeSanityTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class MatrixShapeSanityTests: XCTestCase {

  // ------------------------------------------------------------------------ //
  // MARK: Shape Support
  // ------------------------------------------------------------------------ //
  
  internal func validateShape<Matrix:MatrixProtocol>(
    forMatrix matrix: Matrix.Type,
    columnCount: Int,
    rowCount: Int) {
    
    XCTAssertEqual(
      rowCount,
      matrix.rowCount,
      "`\(String(reflecting: matrix))` had row-count mismatch: need \(rowCount), got \(matrix.rowCount)!"
    )
    XCTAssertEqual(
      columnCount,
      matrix.columnCount,
      "`\(String(reflecting: matrix))` had column-count mismatch: need \(columnCount), got \(matrix.columnCount)!"
    )
    XCTAssertEqual(
      rowCount,
      matrix.columnLength,
      "`\(String(reflecting: matrix))` had rowCount-columnLength mismatch: expect `rowCount == matrix.columnLength`, but got `rowCount: \(rowCount), matrix.columnLength: \(matrix.columnLength)`!"
    )
    XCTAssertEqual(
      columnCount,
      matrix.rowLength,
      "`\(String(reflecting: matrix))` had columnCoun-rowLength mismatch: expect `columnCount == matrix.rowLength`, but got `columnCoun: \(columnCount), matrix.rowLength: \(matrix.rowLength)`!"
    )
    XCTAssertEqual(
      rowCount * columnCount,
      matrix.scalarCount,
      "`\(String(reflecting: matrix))` had scalar-count mismatch: expect `rowCount * columnCount == matrix.scalarCount`, but got `rowCount * columnCount: \(rowCount * columnCount), matrix.scalarCount: \(matrix.scalarCount)`!"
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Shapes
  // ------------------------------------------------------------------------ //
  
  func testMatrix2x2Shape() {
    // A matrix of two columns and two rows...
    self.validateShape(
      forMatrix: simd_double2x2.self,
      columnCount: 2,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: simd_float2x2.self,
      columnCount: 2,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: DoubleMatrix2x2Storage.self,
      columnCount: 2,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: FloatMatrix2x2Storage.self,
      columnCount: 2,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix2x2<Double>.self,
      columnCount: 2,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix2x2<Float>.self,
      columnCount: 2,
      rowCount: 2
    )
  }

  func testMatrix2x3Shape() {
    // A matrix of two columns and three rows...
    self.validateShape(
      forMatrix: simd_double2x3.self,
      columnCount: 2,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: simd_float2x3.self,
      columnCount: 2,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: DoubleMatrix2x3Storage.self,
      columnCount: 2,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: FloatMatrix2x3Storage.self,
      columnCount: 2,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix2x3<Double>.self,
      columnCount: 2,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix2x3<Float>.self,
      columnCount: 2,
      rowCount: 3
    )
  }

  func testMatrix2x4Shape() {
    // A matrix of two columns and four rows...
    self.validateShape(
      forMatrix: simd_double2x4.self,
      columnCount: 2,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: simd_float2x4.self,
      columnCount: 2,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: DoubleMatrix2x4Storage.self,
      columnCount: 2,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: FloatMatrix2x4Storage.self,
      columnCount: 2,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix2x4<Double>.self,
      columnCount: 2,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix2x4<Float>.self,
      columnCount: 2,
      rowCount: 4
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Shapes
  // ------------------------------------------------------------------------ //
  
  func testMatrix3x2Shape() {
    // A matrix of three columns and two rows...
    self.validateShape(
      forMatrix: simd_double3x2.self,
      columnCount: 3,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: simd_float3x2.self,
      columnCount: 3,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: DoubleMatrix3x2Storage.self,
      columnCount: 3,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: FloatMatrix3x2Storage.self,
      columnCount: 3,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix3x2<Double>.self,
      columnCount: 3,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix3x2<Float>.self,
      columnCount: 3,
      rowCount: 2
    )
  }
  
  func testMatrix3x3Shape() {
    // A matrix of three columns and three rows...
    self.validateShape(
      forMatrix: simd_double3x3.self,
      columnCount: 3,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: simd_float3x3.self,
      columnCount: 3,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: DoubleMatrix3x3Storage.self,
      columnCount: 3,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: FloatMatrix3x3Storage.self,
      columnCount: 3,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix3x3<Double>.self,
      columnCount: 3,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix3x3<Float>.self,
      columnCount: 3,
      rowCount: 3
    )
  }
  
  func testMatrix3x4Shape() {
    // A matrix of two columns and four rows...
    self.validateShape(
      forMatrix: simd_double3x4.self,
      columnCount: 3,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: simd_float3x4.self,
      columnCount: 3,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: DoubleMatrix3x4Storage.self,
      columnCount: 3,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: FloatMatrix3x4Storage.self,
      columnCount: 3,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix3x4<Double>.self,
      columnCount: 3,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix3x4<Float>.self,
      columnCount: 3,
      rowCount: 4
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Shapes
  // ------------------------------------------------------------------------ //
  
  func testMatrix4x2Shape() {
    // A matrix of three columns and two rows...
    self.validateShape(
      forMatrix: simd_double4x2.self,
      columnCount: 4,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: simd_float4x2.self,
      columnCount: 4,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: DoubleMatrix4x2Storage.self,
      columnCount: 4,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: FloatMatrix4x2Storage.self,
      columnCount: 4,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix4x2<Double>.self,
      columnCount: 4,
      rowCount: 2
    )
    self.validateShape(
      forMatrix: Matrix4x2<Float>.self,
      columnCount: 4,
      rowCount: 2
    )
  }
  
  func testMatrix4x3Shape() {
    // A matrix of three columns and three rows...
    self.validateShape(
      forMatrix: simd_double4x3.self,
      columnCount: 4,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: simd_float4x3.self,
      columnCount: 4,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: DoubleMatrix4x3Storage.self,
      columnCount: 4,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: FloatMatrix4x3Storage.self,
      columnCount: 4,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix4x3<Double>.self,
      columnCount: 4,
      rowCount: 3
    )
    self.validateShape(
      forMatrix: Matrix4x3<Float>.self,
      columnCount: 4,
      rowCount: 3
    )
  }
  
  func testMatrix4x4Shape() {
    // A matrix of two columns and four rows...
    self.validateShape(
      forMatrix: simd_double4x4.self,
      columnCount: 4,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: simd_float4x4.self,
      columnCount: 4,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: DoubleMatrix4x4Storage.self,
      columnCount: 4,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: FloatMatrix4x4Storage.self,
      columnCount: 4,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix4x4<Double>.self,
      columnCount: 4,
      rowCount: 4
    )
    self.validateShape(
      forMatrix: Matrix4x4<Float>.self,
      columnCount: 4,
      rowCount: 4
    )
  }

}

