import Testing
import simd
@testable import HDXLSIMDSupport

// MARK: 2xN Layouts

@Test("2x2 Float Memory Layout")
func testFloatMatrix2x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float2x2.self,
    candidates: (
      Float.Matrix2x2Storage.self,
      Matrix2x2<Float>.self
    )
  )
}

@Test("2x3 Float Memory Layout")
func testFloatMatrix2x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float2x3.self,
    candidates: (
      Float.Matrix2x3Storage.self,
      Matrix2x3<Float>.self
    )
  )
}

@Test("2x4 Float Memory Layout")
func testFloatMatrix2x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float2x4.self,
    candidates: (
      Float.Matrix2x4Storage.self,
      Matrix2x4<Float>.self
    )
  )
}

// MARK: 3xN Layouts

@Test("3x2 Float Memory Layout")
func testFloatMatrix3x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float3x2.self,
    candidates: (
      Float.Matrix3x2Storage.self,
      Matrix3x2<Float>.self
    )
  )
}

@Test("3x3 Float Memory Layout")
func testFloatMatrix3x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float3x3.self,
    candidates: (
      Float.Matrix3x3Storage.self,
      Matrix3x3<Float>.self
    )
  )
}

@Test("3x4 Float Memory Layout")
func testFloatMatrix3x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float3x4.self,
    candidates: (
      Float.Matrix3x4Storage.self,
      Matrix3x4<Float>.self
    )
  )
}

// MARK: 4xN Layouts

@Test("4x2 Float Memory Layout")
func testFloatMatrix4x2NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float4x2.self,
    candidates: (
      Float.Matrix4x2Storage.self,
      Matrix4x2<Float>.self
    )
  )
}

@Test("4x3 Float Memory Layout")
func testFloatMatrix4x3NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float4x3.self,
    candidates: (
      Float.Matrix4x3Storage.self,
      Matrix4x3<Float>.self
    )
  )
}

@Test("4x4 Float Memory Layout")
func testFloatMatrix4x4NoPaddingAdded() {
  validateEquivalentMemoryLayouts(
    reference: simd_float4x4.self,
    candidates: (
      Float.Matrix4x4Storage.self,
      Matrix4x4<Float>.self
    )
  )
}
