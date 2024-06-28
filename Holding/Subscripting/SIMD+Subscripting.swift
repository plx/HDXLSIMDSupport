import Foundation
import simd

extension SIMD {
  
  /// Convenience to get a range of the subscriptable indices.
  @inlinable
  package static var subscriptableIndexRange: Range<Int> {
    0..<Self.scalarCount
  }

  /// Convenience for asserts/preconditions: is `index` a valid index?
  @inlinable
  package static func canSubscript(at index: Int) -> Bool {
    subscriptableIndexRange.contains(index)
  }
  
}
