//
//  Matrix2x4FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x4FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 2, representation: .float)
}
