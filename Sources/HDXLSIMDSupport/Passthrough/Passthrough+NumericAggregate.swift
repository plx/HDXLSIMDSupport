//
//  Passthrough+NumericAggregate.swift
//

import Foundation
import simd

public extension Passthrough where PassthroughValue:NumericAggregate {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (PassthroughValue.NumericEntryRepresentation) -> Bool) -> Bool {
    return passthroughValue.allNumericEntriesSatisfy(predicate)
  }

}
