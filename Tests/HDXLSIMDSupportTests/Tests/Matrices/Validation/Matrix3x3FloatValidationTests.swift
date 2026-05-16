//
//  Matrix3x3FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x3FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 3, representation: .float)
}
