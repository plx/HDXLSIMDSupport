import Foundation
import simd

extension Passthrough where Self: Hashable, PassthroughValue: Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    passthroughValue.hash(into: &hasher)
  }
  
}
