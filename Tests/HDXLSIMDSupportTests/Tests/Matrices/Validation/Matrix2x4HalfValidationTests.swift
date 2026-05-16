//
//  Matrix2x4HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x4HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 2, representation: .half)
}
