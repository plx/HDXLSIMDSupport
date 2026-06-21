//
//  Matrix3x4_Half_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Matrix3x4_Half_Equivalence: GeneratedValidationTestCase {
  #generateMatrixConformanceTests(rowCount: 4, columnCount: 3, representation: .half)
}
