//
//  Passthrough+NumericAggregate.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension Passthrough where PassthroughValue:NumericAggregate {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (PassthroughValue.NumericEntryRepresentation) -> Bool) -> Bool {
    return self.passthroughValue.allNumericEntriesSatisfy(predicate)
  }

}
