//
//  Matrix4x3HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x3HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 4, representation: .half)
}
