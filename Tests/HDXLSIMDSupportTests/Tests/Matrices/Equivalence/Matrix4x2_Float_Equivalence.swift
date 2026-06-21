//
//  Matrix4x2_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x2_Float_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 2, columnCount: 4, representation: .float)
}
