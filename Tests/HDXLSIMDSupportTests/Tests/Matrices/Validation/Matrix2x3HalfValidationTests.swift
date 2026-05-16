//
//  Matrix2x3HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x3HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 2, representation: .half)
}
