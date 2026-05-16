//
//  Matrix2x3DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x3DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 2, representation: .double)
}
