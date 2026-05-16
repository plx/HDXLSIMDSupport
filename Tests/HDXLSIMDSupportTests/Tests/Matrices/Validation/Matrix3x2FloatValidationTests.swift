//
//  Matrix3x2FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 3, representation: .float)
}
