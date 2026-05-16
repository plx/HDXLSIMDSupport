//
//  Matrix4x4FloatValidationTests.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x4FloatValidationTests: XCTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 4, representation: .float)
}
