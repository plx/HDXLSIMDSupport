//
//  simd_double3x3+NumericAggregate.swift
//

import Foundation
import simd

extension simd_double3x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      columns.0.allNumericEntriesSatisfy(predicate),
      columns.1.allNumericEntriesSatisfy(predicate),
      columns.2.allNumericEntriesSatisfy(predicate)
    else {
        return false
    }
    return true
  }

}
