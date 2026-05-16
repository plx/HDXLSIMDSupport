//
//  Matrix2x4DoubleValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x4DoubleValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 2, representation: .double)
}
