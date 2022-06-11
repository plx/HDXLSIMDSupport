//
//  simd_float4x3+NumericAggregate.swift
//

import Foundation
import simd

extension simd_float4x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      columns.0.allNumericEntriesSatisfy(predicate),
      columns.1.allNumericEntriesSatisfy(predicate),
      columns.2.allNumericEntriesSatisfy(predicate),
      columns.3.allNumericEntriesSatisfy(predicate)
    else {
        return false
    }
    return true
  }

}
