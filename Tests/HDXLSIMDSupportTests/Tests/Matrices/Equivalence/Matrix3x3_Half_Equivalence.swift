//
//  Matrix3x3_Half_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x3_Half_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 3, representation: .half)
}
