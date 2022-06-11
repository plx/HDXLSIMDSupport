//
//  Passthrough+Equatable.swift
//

import Foundation
import simd

extension Passthrough where PassthroughValue: Equatable {
  
  @inlinable
  public static func == (
    lhs: Self,
    rhs: Self
  ) -> Bool {
    return lhs.passthroughValue == rhs.passthroughValue
  }

}
