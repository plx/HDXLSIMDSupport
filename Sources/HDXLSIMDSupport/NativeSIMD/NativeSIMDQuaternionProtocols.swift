//
//  NativeSIMDQuaternionProtocols.swift
//

import Foundation
import simd

public protocol NativeSIMDQuaternionProtocol : NativeSIMDProtocol {
  
  associatedtype NativeSIMDRotationMatrix3x3: NativeSIMDMatrix3x3Protocol
    where NativeSIMDRotationMatrix3x3.NativeSIMDScalar == NativeSIMDScalar
  
  associatedtype NativeSIMDRotationMatrix4x4: NativeSIMDMatrix4x4Protocol
    where NativeSIMDRotationMatrix4x4.NativeSIMDScalar == NativeSIMDScalar
  
  init(rotationMatrix matrix: NativeSIMDRotationMatrix3x3)
  init(rotationMatrix matrix: NativeSIMDRotationMatrix4x4)
  
}
