import Testing
import simd
@testable import HDXLSIMDSupport

@Test("Float Quaternion Memory Layout")
func testFloatQuaternionMemoryLayout() {
  validateEquivalentMemoryLayouts(
    reference: simd_quatf.self,
    candidates: (
      FloatQuaternionStorage.self,
      Quaternion<Float>.self
    )
  )
}

@Test("Double Quaternion Memory Layout")
func testDoubleQuaternionMemoryLayout() {
  validateEquivalentMemoryLayouts(
    reference: simd_quatd.self,
    candidates: (
      DoubleQuaternionStorage.self,
      Quaternion<Double>.self
    )
  )
}

