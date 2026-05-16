//
//  Matrix3x4DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 3, representation: .double)
}
