//
//  NativeSIMDQuaternionConformances.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_quatf : NativeSIMDQuaternionProtocol {
  
  public typealias NativeSIMDScalar = Float
  
  public typealias NativeSIMDRotationMatrix3x3 = simd_float3x3
  public typealias NativeSIMDRotationMatrix4x4 = simd_float4x4
  
  @inlinable
  public init(rotationMatrix matrix: NativeSIMDRotationMatrix3x3) {
    self.init(matrix)
  }
  
  @inlinable
  public init(rotationMatrix matrix: NativeSIMDRotationMatrix4x4) {
    self.init(matrix)
  }

}

extension simd_quatd : NativeSIMDQuaternionProtocol {
  
  public typealias NativeSIMDScalar = Double
  
  public typealias NativeSIMDRotationMatrix3x3 = simd_double3x3
  public typealias NativeSIMDRotationMatrix4x4 = simd_double4x4

  @inlinable
  public init(rotationMatrix matrix: NativeSIMDRotationMatrix3x3) {
    self.init(matrix)
  }
  
  @inlinable
  public init(rotationMatrix matrix: NativeSIMDRotationMatrix4x4) {
    self.init(matrix)
  }

}
