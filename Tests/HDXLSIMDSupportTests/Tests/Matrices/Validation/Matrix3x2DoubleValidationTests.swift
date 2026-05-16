//
//  Matrix3x2DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 3, representation: .double)
}
