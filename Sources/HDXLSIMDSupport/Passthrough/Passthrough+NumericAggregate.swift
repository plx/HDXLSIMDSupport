import Foundation
import simd

extension Passthrough where Self: NumericAggregate, PassthroughValue:NumericAggregate {
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (PassthroughValue.NumericEntryRepresentation) -> Bool) -> Bool {
    passthroughValue.allNumericEntriesSatisfy(predicate)
  }

}
