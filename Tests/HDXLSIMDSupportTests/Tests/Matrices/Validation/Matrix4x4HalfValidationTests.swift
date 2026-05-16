//
//  Matrix4x4HalfValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x4HalfValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 4, representation: .half)
}
