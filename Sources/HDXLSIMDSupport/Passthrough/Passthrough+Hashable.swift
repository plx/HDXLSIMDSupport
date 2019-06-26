//
//  Passthrough+Hashable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension Passthrough where PassthroughValue: Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    self.passthroughValue.hash(into: &hasher)
  }
  
}
