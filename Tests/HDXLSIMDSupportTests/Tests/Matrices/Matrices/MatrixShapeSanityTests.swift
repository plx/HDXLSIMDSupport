import Testing
import simd
@testable import HDXLSIMDSupport

func validateShape<Matrix>(
  matrixType matrix: Matrix.Type,
  columnCount: Int,
  rowCount: Int
) where Matrix: MatrixProtocol {
  #expect(rowCount == matrix.rowCount)
  #expect(columnCount == matrix.columnCount)
  #expect(rowCount == matrix.columnLength)
  #expect(columnCount == matrix.rowLength)
  #expect(columnCount * rowCount == matrix.scalarCount)
}

func validateCommonShape<each Matrix: MatrixProtocol>(
  columnCount: Int,
  rowCount: Int,
  forMatrixTypes matrixTypes: (repeat (each Matrix).Type)
) {
  #expect(columnCount > 1)
  #expect(rowCount > 1)
  for matrixType in repeat each matrixTypes {
    validateShape(
      matrixType: matrixType,
      columnCount: columnCount,
      rowCount: rowCount
    )
  }
}

// MARK: 2xN Shape Validation

@Test("2x2 Matrix Shape Validation")
func validate2x2MatrixShapes() {
  validateCommonShape(
    columnCount: 2,
    rowCount: 2,
    forMatrixTypes: (
      simd_double2x2.self,
      simd_float2x2.self,
      DoubleMatrix2x2Storage.self,
      FloatMatrix2x2Storage.self,
      Matrix2x2<Double>.self,
      Matrix2x2<Float>.self
    )
  )
}

@Test("2x3 Matrix Shape Validation")
func validate2x3MatrixShapes() {
  validateCommonShape(
    columnCount: 2,
    rowCount: 3,
    forMatrixTypes: (
      simd_double2x3.self,
      simd_float2x3.self,
      DoubleMatrix2x3Storage.self,
      FloatMatrix2x3Storage.self,
      Matrix2x3<Double>.self,
      Matrix2x3<Float>.self
    )
  )
}

@Test("2x4 Matrix Shape Validation")
func validate2x4MatrixShapes() {
  validateCommonShape(
    columnCount: 2,
    rowCount: 4,
    forMatrixTypes: (
      simd_double2x4.self,
      simd_float2x4.self,
      DoubleMatrix2x4Storage.self,
      FloatMatrix2x4Storage.self,
      Matrix2x4<Double>.self,
      Matrix2x4<Float>.self
    )
  )
}

// MARK: 3xN Shape Validation

@Test("3x2 Matrix Shape Validation")
func validate3x2MatrixShapes() {
  validateCommonShape(
    columnCount: 3,
    rowCount: 2,
    forMatrixTypes: (
      simd_double3x2.self,
      simd_float3x2.self,
      DoubleMatrix3x2Storage.self,
      FloatMatrix3x2Storage.self,
      Matrix3x2<Double>.self,
      Matrix3x2<Float>.self
    )
  )
}

@Test("3x3 Matrix Shape Validation")
func validate3x3MatrixShapes() {
  validateCommonShape(
    columnCount: 3,
    rowCount: 3,
    forMatrixTypes: (
      simd_double3x3.self,
      simd_float3x3.self,
      DoubleMatrix3x3Storage.self,
      FloatMatrix3x3Storage.self,
      Matrix3x3<Double>.self,
      Matrix3x3<Float>.self
    )
  )
}

@Test("3x4 Matrix Shape Validation")
func validate3x4MatrixShapes() {
  validateCommonShape(
    columnCount: 3,
    rowCount: 4,
    forMatrixTypes: (
      simd_double3x4.self,
      simd_float3x4.self,
      DoubleMatrix3x4Storage.self,
      FloatMatrix3x4Storage.self,
      Matrix3x4<Double>.self,
      Matrix3x4<Float>.self
    )
  )
}

// MARK: 4xN Shape Validation

@Test("4x2 Matrix Shape Validation")
func validate4x2MatrixShapes() {
  validateCommonShape(
    columnCount: 4,
    rowCount: 2,
    forMatrixTypes: (
      simd_double4x2.self,
      simd_float4x2.self,
      DoubleMatrix4x2Storage.self,
      FloatMatrix4x2Storage.self,
      Matrix4x2<Double>.self,
      Matrix4x2<Float>.self
    )
  )
}

@Test("4x3 Matrix Shape Validation")
func validate4x3MatrixShapes() {
  validateCommonShape(
    columnCount: 4,
    rowCount: 3,
    forMatrixTypes: (
      simd_double4x3.self,
      simd_float4x3.self,
      DoubleMatrix4x3Storage.self,
      FloatMatrix4x3Storage.self,
      Matrix4x3<Double>.self,
      Matrix4x3<Float>.self
    )
  )
}

@Test("4x4 Matrix Shape Validation")
func validate4x4MatrixShapes() {
  validateCommonShape(
    columnCount: 4,
    rowCount: 4,
    forMatrixTypes: (
      simd_double4x4.self,
      simd_float4x4.self,
      DoubleMatrix4x4Storage.self,
      FloatMatrix4x4Storage.self,
      Matrix4x4<Double>.self,
      Matrix4x4<Float>.self
    )
  )
}

