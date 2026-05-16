//
//  Matrix3x3DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x3DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 3, representation: .double)
}
