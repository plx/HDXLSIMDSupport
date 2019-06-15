//
//  Double+SIMDMatrixCapabilities.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension Double: SIMDMatrix4x4CapableProtocol {
  public typealias SIMDMatrix4x4Storage = Double4x4Storage
}

