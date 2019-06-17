//
//  Float+NativeSIMDMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension Float : NativeSIMDMatrixCapable {
  
  public typealias NativeSIMDMatrix2x2 = simd_float2x2
  public typealias NativeSIMDMatrix2x3 = simd_float2x3
  public typealias NativeSIMDMatrix2x4 = simd_float2x4

  public typealias NativeSIMDMatrix3x2 = simd_float3x2
  public typealias NativeSIMDMatrix3x3 = simd_float3x3
  public typealias NativeSIMDMatrix3x4 = simd_float3x4

  public typealias NativeSIMDMatrix4x2 = simd_float4x2
  public typealias NativeSIMDMatrix4x3 = simd_float4x3
  public typealias NativeSIMDMatrix4x4 = simd_float4x4

}

extension Float : NativeSIMDQuaternionCapable {
  
  public typealias NativeSIMDQuaternion = simd_quatf
  
}
