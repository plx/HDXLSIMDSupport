//
//  Matrix3x3HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x3HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 3, representation: .half)
}
