//
//  Matrix3x4_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4_Float_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 3, representation: .float)
}
