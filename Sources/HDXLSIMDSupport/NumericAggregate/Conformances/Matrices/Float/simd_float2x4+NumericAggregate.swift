//
//  simd_float2x4+NumericAggregate.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_float2x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }

}
