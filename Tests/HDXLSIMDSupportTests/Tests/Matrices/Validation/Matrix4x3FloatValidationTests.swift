//
//  Matrix4x3FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x3FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 4, representation: .float)
}
