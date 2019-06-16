//
//  Double+SIMDMatrixCapabilities.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension Double: SIMDMatrix2x2CapableProtocol {
  
  public typealias SIMDMatrix2x2Storage = Double2x2Storage
  
}

extension Double: SIMDMatrix3x3CapableProtocol {
  
  public typealias SIMDMatrix3x3Storage = Double3x3Storage
  
}

extension Double: SIMDMatrix4x4CapableProtocol {
  
  public typealias SIMDMatrix4x4Storage = Double4x4Storage
  
}

