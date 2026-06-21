//
//  Quaternion_Half_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Quaternion_Half_Equivalence: GeneratedValidationTestCase {
  #generateQuaternionConformanceTests(representation: .half)
}
