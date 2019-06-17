//
//  Double+NativeSIMDMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension Double : NativeSIMDMatrixCapable {
  
  public typealias NativeSIMDMatrix2x2 = simd_double2x2
  public typealias NativeSIMDMatrix2x3 = simd_double2x3
  public typealias NativeSIMDMatrix2x4 = simd_double2x4
  
  public typealias NativeSIMDMatrix3x2 = simd_double3x2
  public typealias NativeSIMDMatrix3x3 = simd_double3x3
  public typealias NativeSIMDMatrix3x4 = simd_double3x4
  
  public typealias NativeSIMDMatrix4x2 = simd_double4x2
  public typealias NativeSIMDMatrix4x3 = simd_double4x3
  public typealias NativeSIMDMatrix4x4 = simd_double4x4
  
}

extension Double : NativeSIMDQuaternionCapable {
  
  public typealias NativeSIMDQuaternion = simd_quatd
  
}
