//
//  Matrix4x4_Double_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x4_Double_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 4, representation: .double)
}
