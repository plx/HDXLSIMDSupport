//
//  SIMD+NumericAggregate.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD8 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD16 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD16 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD32 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD32 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD64 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD64 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}
