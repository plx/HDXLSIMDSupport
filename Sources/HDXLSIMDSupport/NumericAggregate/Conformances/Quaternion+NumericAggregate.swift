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

// -------------------------------------------------------------------------- //
// MARK: simd_quath - NumericAggregate
// -------------------------------------------------------------------------- //

extension simd_quath : NumericAggregate {

  public typealias NumericEntryRepresentation = Float16

  // `simd_quath` does not (yet) bridge the `.real`/`.imag` accessors that
  // `simd_quatf`/`simd_quatd` have, so we route through the free C functions.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      predicate(simd_real(self)),
      simd_imag(self).allNumericEntriesSatisfy(predicate)
    else {
        return false
    }
    return true
  }

}
