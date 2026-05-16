//
//  Matrix4x2FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 4, representation: .float)
}
