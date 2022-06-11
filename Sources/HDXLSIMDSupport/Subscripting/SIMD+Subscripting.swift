//
//  SIMD+Subscripting.swift
//

import Foundation
import simd

public extension SIMD {
  
  /// Convenience to get a range of the subscriptable indices.
  @inlinable
  static var subscriptableIndexRange: Range<Int> {
    get {
      return 0..<Self.scalarCount
    }
  }

  /// Convenience for asserts/preconditions: is `index` a valid index?
  @inlinable
  static func canSubscript(at index: Int) -> Bool {
    return subscriptableIndexRange.contains(index)
  }
  
}
