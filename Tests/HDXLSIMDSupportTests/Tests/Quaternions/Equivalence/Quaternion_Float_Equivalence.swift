//
//  Quaternion_Float_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Quaternion_Float_Equivalence: GeneratedValidationTestCase {
  #generateQuaternionConformanceTests(representation: .float)
}
