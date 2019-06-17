//
//  NativeSIMDConformances.swift
//

import Foundation
import simd

extension simd_double2x2 : NativeSIMDMatrix2x2Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double2x3 : NativeSIMDMatrix2x3Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double2x4 : NativeSIMDMatrix2x4Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double3x2 : NativeSIMDMatrix3x2Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double3x3 : NativeSIMDMatrix3x3Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double3x4 : NativeSIMDMatrix3x4Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double4x2 : NativeSIMDMatrix4x2Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double4x3 : NativeSIMDMatrix4x3Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_double4x4 : NativeSIMDMatrix4x4Protocol {
  
  public typealias NativeSIMDScalar = Double
  
}

extension simd_float2x2 : NativeSIMDMatrix2x2Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float2x3 : NativeSIMDMatrix2x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float2x4 : NativeSIMDMatrix2x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float3x2 : NativeSIMDMatrix3x2Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float3x3 : NativeSIMDMatrix3x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float3x4 : NativeSIMDMatrix3x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float4x2 : NativeSIMDMatrix4x2Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float4x3 : NativeSIMDMatrix4x3Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}

extension simd_float4x4 : NativeSIMDMatrix4x4Protocol {
  
  public typealias NativeSIMDScalar = Float
  
}
