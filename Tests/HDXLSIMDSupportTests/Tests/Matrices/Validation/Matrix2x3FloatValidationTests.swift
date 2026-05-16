//
//  Matrix2x3FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x3FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 2, representation: .float)
}
