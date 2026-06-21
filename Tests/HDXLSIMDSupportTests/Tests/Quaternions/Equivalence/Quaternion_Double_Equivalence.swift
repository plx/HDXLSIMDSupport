//
//  Quaternion_Double_Equivalence.swift
//

import XCTest
import simd
@testable import HDXLSIMDSupport

class Quaternion_Double_Equivalence: GeneratedValidationTestCase {
  #generateQuaternionConformanceTests(representation: .double)
}
