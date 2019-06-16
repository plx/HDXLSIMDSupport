//
//  Double+SIMDMatrixCapabilities.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension Double: SIMDMatrix2x3CapableProtocol {
  
  public typealias SIMDMatrix2x3Storage = Double2x3Storage
  
}

extension Double: SIMDMatrix3x2CapableProtocol {
  
  public typealias SIMDMatrix3x2Storage = Double3x2Storage
  
}

extension Double: SIMDMatrix2x4CapableProtocol {
  
  public typealias SIMDMatrix2x4Storage = Double2x4Storage
  
}

extension Double: SIMDMatrix4x2CapableProtocol {
  
  public typealias SIMDMatrix4x2Storage = Double4x2Storage
  
}

extension Double: SIMDMatrix4x3CapableProtocol {
  
  public typealias SIMDMatrix4x3Storage = Double4x3Storage
  
}

extension Double: SIMDMatrix3x4CapableProtocol {
  
  public typealias SIMDMatrix3x4Storage = Double3x4Storage
  
}

extension Double: SIMDMatrix2x2CapableProtocol {
  
  public typealias SIMDMatrix2x2Storage = Double2x2Storage
  
}

extension Double: SIMDMatrix3x3CapableProtocol {
  
  public typealias SIMDMatrix3x3Storage = Double3x3Storage
  
}

extension Double: SIMDMatrix4x4CapableProtocol {
  
  public typealias SIMDMatrix4x4Storage = Double4x4Storage
  
}

