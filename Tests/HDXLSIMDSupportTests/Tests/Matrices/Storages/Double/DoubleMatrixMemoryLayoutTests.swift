//
//  DoubleMatrixMemoryLayoutTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class DoubleMatrixMemoryLayoutTests: XCTestCase {

  func testDoubleMatrix2x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double2x2.self,
      Double.Matrix2x2Storage.self,
      Matrix2x2<Double>.self
    )
  }

  func testDoubleMatrix2x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double2x3.self,
      Double.Matrix2x3Storage.self,
      Matrix2x3<Double>.self
    )
  }

  func testDoubleMatrix2x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double2x4.self,
      Double.Matrix2x4Storage.self,
      Matrix2x4<Double>.self
    )
  }

  func testDoubleMatrix3x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double3x2.self,
      Double.Matrix3x2Storage.self,
      Matrix3x2<Double>.self
    )
  }

  func testDoubleMatrix3x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double3x3.self,
      Double.Matrix3x3Storage.self,
      Matrix3x3<Double>.self
    )
  }

  func testDoubleMatrix3x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double3x4.self,
      Double.Matrix3x4Storage.self,
      Matrix3x4<Double>.self
    )
  }

  func testDoubleMatrix4x2NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double4x2.self,
      Double.Matrix4x2Storage.self,
      Matrix4x2<Double>.self
    )
  }

  func testDoubleMatrix4x3NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double4x3.self,
      Double.Matrix4x3Storage.self,
      Matrix4x3<Double>.self
    )
  }

  func testDoubleMatrix4x4NoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_double4x4.self,
      Double.Matrix4x4Storage.self,
      Matrix4x4<Double>.self
    )
  }
  
}
