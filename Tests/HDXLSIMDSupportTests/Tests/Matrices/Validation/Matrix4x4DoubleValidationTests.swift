//
//  Matrix4x4DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x4DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 4, representation: .double)
}
