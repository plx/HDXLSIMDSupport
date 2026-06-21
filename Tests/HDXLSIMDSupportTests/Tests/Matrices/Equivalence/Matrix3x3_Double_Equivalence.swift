//
//  Matrix3x3_Double_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x3_Double_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 3, representation: .double)
}
