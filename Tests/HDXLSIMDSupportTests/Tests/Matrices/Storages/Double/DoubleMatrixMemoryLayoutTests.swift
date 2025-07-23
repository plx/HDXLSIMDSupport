import Testing
import simd
@testable import HDXLSIMDSupport

// MARK: 2xN Layouts

@Test("2x2 Double Memory Layout")
func testDoubleMatrix2x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double2x2.self,
    candidates: (
      Double.Matrix2x2Storage.self,
      Matrix2x2<Double>.self
    )
  )
}

@Test("2x3 Double Memory Layout")
func testDoubleMatrix2x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double2x3.self,
    candidates: (
      Double.Matrix2x3Storage.self,
      Matrix2x3<Double>.self
    )
  )
}

@Test("2x4 Double Memory Layout")
func testDoubleMatrix2x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double2x4.self,
    candidates: (
      Double.Matrix2x4Storage.self,
      Matrix2x4<Double>.self
    )
  )
}

// MARK: 3xN Layouts

@Test("3x2 Double Memory Layout")
func testDoubleMatrix3x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double3x2.self,
    candidates: (
      Double.Matrix3x2Storage.self,
      Matrix3x2<Double>.self
    )
  )
}

@Test("3x3 Double Memory Layout")
func testDoubleMatrix3x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double3x3.self,
    candidates: (
      Double.Matrix3x3Storage.self,
      Matrix3x3<Double>.self
    )
  )
}

@Test("3x4 Double Memory Layout")
func testDoubleMatrix3x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double3x4.self,
    candidates: (
      Double.Matrix3x4Storage.self,
      Matrix3x4<Double>.self
    )
  )
}

// MARK: 4xN Layouts

@Test("4x2 Double Memory Layout")
func testDoubleMatrix4x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double4x2.self,
    candidates: (
      Double.Matrix4x2Storage.self,
      Matrix4x2<Double>.self
    )
  )
}

@Test("4x3 Double Memory Layout")
func testDoubleMatrix4x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double4x3.self,
    candidates: (
      Double.Matrix4x3Storage.self,
      Matrix4x3<Double>.self
    )
  )
}

@Test("4x4 Double Memory Layout")
func testDoubleMatrix4x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_double4x4.self,
    candidates: (
      Double.Matrix4x4Storage.self,
      Matrix4x4<Double>.self
    )
  )
}
