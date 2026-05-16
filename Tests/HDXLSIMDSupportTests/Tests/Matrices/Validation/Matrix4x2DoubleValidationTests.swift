//
//  Matrix4x2DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 4, representation: .double)
}
