//
//  Matrix4x2_Double_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2_Double_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 4, representation: .double)
}
