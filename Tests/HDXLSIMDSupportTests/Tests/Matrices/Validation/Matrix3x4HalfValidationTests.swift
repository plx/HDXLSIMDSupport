//
//  Matrix3x4HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 3, representation: .half)
}
