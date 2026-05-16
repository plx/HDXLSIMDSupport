//
//  Matrix2x2FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x2FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, representation: .float)
}
