//
//  Matrix3x2_Half_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2_Half_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 3, representation: .half)
}
