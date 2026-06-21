//
//  Matrix4x4_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix4x4_Float_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 4, representation: .float)
}
