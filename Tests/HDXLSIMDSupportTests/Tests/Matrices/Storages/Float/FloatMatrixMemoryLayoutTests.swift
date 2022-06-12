//
//  FloatMatrixMemoryLayoutTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class FloatMatrixMemoryLayoutTests: XCTestCase {

  func testFloatMatrix2x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float2x2.self,
      Float.Matrix2x2Storage.self,
      Matrix2x2<Float>.self
    )
  }

  func testFloatMatrix2x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float2x3.self,
      Float.Matrix2x3Storage.self,
      Matrix2x3<Float>.self
    )
  }

  func testFloatMatrix2x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float2x4.self,
      Float.Matrix2x4Storage.self,
      Matrix2x4<Float>.self
    )
  }

  func testFloatMatrix3x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float3x2.self,
      Float.Matrix3x2Storage.self,
      Matrix3x2<Float>.self
    )
  }

  func testFloatMatrix3x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float3x3.self,
      Float.Matrix3x3Storage.self,
      Matrix3x3<Float>.self
    )
  }

  func testFloatMatrix3x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float3x4.self,
      Float.Matrix3x4Storage.self,
      Matrix3x4<Float>.self
    )
  }

  func testFloatMatrix4x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float4x2.self,
      Float.Matrix4x2Storage.self,
      Matrix4x2<Float>.self
    )
  }

  func testFloatMatrix4x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float4x3.self,
      Float.Matrix4x3Storage.self,
      Matrix4x3<Float>.self
    )
  }

  func testFloatMatrix4x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_float4x4.self,
      Float.Matrix4x4Storage.self,
      Matrix4x4<Float>.self
    )
  }
  
}
