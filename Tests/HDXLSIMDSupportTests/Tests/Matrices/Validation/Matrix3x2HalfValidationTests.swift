//
//  Matrix3x2HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 3, representation: .half)
}
