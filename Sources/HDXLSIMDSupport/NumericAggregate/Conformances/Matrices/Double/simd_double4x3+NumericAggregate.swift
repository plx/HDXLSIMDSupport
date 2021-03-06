//
//  simd_double4x3+NumericAggregate.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_double4x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate),
      self.columns.3.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }

}
