//
//  Matrix2x3_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix2x3_Float_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 2, representation: .float)
}
