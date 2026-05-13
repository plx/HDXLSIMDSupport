//
//  HalfMatrixMemoryLayoutTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class HalfMatrixMemoryLayoutTests: XCTestCase {

  func testHalfMatrix2x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half2x2.self,
      Float16.Matrix2x2Storage.self,
      Matrix2x2<Float16>.self
    )
  }

  func testHalfMatrix2x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half2x3.self,
      Float16.Matrix2x3Storage.self,
      Matrix2x3<Float16>.self
    )
  }

  func testHalfMatrix2x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half2x4.self,
      Float16.Matrix2x4Storage.self,
      Matrix2x4<Float16>.self
    )
  }

  func testHalfMatrix3x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half3x2.self,
      Float16.Matrix3x2Storage.self,
      Matrix3x2<Float16>.self
    )
  }

  func testHalfMatrix3x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half3x3.self,
      Float16.Matrix3x3Storage.self,
      Matrix3x3<Float16>.self
    )
  }

  func testHalfMatrix3x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half3x4.self,
      Float16.Matrix3x4Storage.self,
      Matrix3x4<Float16>.self
    )
  }

  func testHalfMatrix4x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half4x2.self,
      Float16.Matrix4x2Storage.self,
      Matrix4x2<Float16>.self
    )
  }

  func testHalfMatrix4x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half4x3.self,
      Float16.Matrix4x3Storage.self,
      Matrix4x3<Float16>.self
    )
  }

  func testHalfMatrix4x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_half4x4.self,
      Float16.Matrix4x4Storage.self,
      Matrix4x4<Float16>.self
    )
  }

}
