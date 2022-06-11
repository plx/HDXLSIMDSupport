//
//  Passthrough+Hashable.swift
//

import Foundation
import simd

public extension Passthrough where PassthroughValue: Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    passthroughValue.hash(into: &hasher)
  }
  
}
