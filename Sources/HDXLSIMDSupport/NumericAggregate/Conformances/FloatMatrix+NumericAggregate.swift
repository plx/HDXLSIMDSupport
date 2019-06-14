//
//  FloatMatrix+NumericAggregate.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: float - 2x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float2x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float
  
  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: float - 2x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float2x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: float - 2x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float2x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: float - 3x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float3x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
// MARK: float - 3x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float3x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
// MARK: float - 3x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float3x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
// MARK: float - 4x2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float4x2 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
// MARK: float - 4x3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float4x3 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
// MARK: float - 4x4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension float4x4 : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Float

  /// `true` iff all components satisfy `predicate`.
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (Float) -> Bool) -> Bool {
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
