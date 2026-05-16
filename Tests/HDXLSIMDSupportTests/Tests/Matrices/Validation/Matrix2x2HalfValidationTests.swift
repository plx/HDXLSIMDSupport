//
//  Matrix2x2HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x2HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, representation: .half)
}
