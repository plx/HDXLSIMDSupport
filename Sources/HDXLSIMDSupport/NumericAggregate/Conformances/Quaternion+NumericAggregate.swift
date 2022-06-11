//
//  Quaternion+NumericAggregate.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: simd_quatf - NumericAggregate
// -------------------------------------------------------------------------- //

extension simd_quatf : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      predicate(real),
      imag.allNumericEntriesSatisfy(predicate)
    else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: simd_quatd - NumericAggregate
// -------------------------------------------------------------------------- //

extension simd_quatd : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      predicate(real),
      imag.allNumericEntriesSatisfy(predicate)
    else {
        return false
    }
    return true
  }
  
}
