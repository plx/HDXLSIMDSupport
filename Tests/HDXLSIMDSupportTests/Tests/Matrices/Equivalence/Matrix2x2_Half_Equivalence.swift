//
//  Matrix2x2_Half_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x2_Half_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 2, representation: .half)
}
