//
//  Matrix4x3_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x3_Float_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 3, columnCount: 4, representation: .float)
}
