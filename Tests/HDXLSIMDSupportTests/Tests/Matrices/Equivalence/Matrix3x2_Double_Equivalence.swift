//
//  Matrix3x2_Double_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x2_Double_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 3, representation: .double)
}
