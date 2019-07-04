//
//  Passthrough+Equatable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension Passthrough where PassthroughValue: Equatable {
  
  @inlinable
  static func ==(
    lhs: Self,
    rhs: Self) -> Bool {
    return lhs.passthroughValue == rhs.passthroughValue
  }

}
