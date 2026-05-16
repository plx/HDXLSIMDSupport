//
//  Matrix2x2DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x2DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, representation: .double)
}
