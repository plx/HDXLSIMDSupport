//
//  Matrix3x4FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 3, representation: .float)
}
