//
//  Matrix4x2HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 4, representation: .half)
}
