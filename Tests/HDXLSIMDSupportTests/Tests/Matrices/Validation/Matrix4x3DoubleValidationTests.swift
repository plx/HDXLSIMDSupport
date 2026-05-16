//
//  Matrix4x3DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x3DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 4, representation: .double)
}
