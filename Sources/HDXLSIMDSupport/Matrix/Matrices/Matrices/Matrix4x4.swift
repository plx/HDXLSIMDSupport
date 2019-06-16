//
//  Matrix4x4.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public struct Matrix4x4<Scalar:SIMDMatrix4x4CapableProtocol> : SIMDMatrix4x4Protocol {
  
  public typealias Transpose = Matrix4x4<Scalar>
  
  
  public typealias Storage = Scalar.SIMDMatrix4x4Storage
  
  public var storage: Storage
  
  @inlinable
  public init(storage: Storage) {
    self.storage = storage
  }
  
}
