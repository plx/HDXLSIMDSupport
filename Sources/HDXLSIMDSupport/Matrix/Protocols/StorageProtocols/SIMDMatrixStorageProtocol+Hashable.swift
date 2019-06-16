//
//  HDXSIMDMatrixStorageProtocol+Hashable.swift
//

import Foundation

public extension SIMDMatrixStorageProtocol where Scalar:Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    for scalarIndex in 0..<Self.scalarCount {
      self[scalarIndex: scalarIndex].hash(into: &hasher)
    }
  }
  
}
