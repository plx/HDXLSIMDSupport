//
//  DoubleMatrix+Predicates.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: double - 2x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double2x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 2x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double2x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 2x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double2x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 3x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double3x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 3x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double3x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 3x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double3x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: double - 4x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double4x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
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

// -------------------------------------------------------------------------- //
// MARK: double - 4x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double4x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
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

// -------------------------------------------------------------------------- //
// MARK: double - 4x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension double4x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Double
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Double) -> Bool) -> Bool {
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
