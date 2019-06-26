//
//  QuaternionMemoryLayoutTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class QuaternionMemoryLayoutTests: XCTestCase {
  
  func testFloatQuaternionNoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_quatf.self,
      FloatQuaternionStorage.self
    )
  }

  func testDoubleQuaternionNoPaddingAdded() {
    AssertMemoryEquivalentMemoryLayouts(
      simd_quatd.self,
      DoubleQuaternionStorage.self
    )
  }

}
