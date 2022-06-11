//
//  NumericAggregate+FloatingPointAttributes.swift
//

import Foundation

// -------------------------------------------------------------------------- //
// MARK: NumericAggregate - Floating Point Attributes
// -------------------------------------------------------------------------- //

public extension NumericAggregate where NumericEntryRepresentation:BinaryFloatingPoint {
  
  /// Check if all values are finite.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFinite: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFinite
      }
    }
  }
  
  /// Check if all values are zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isZero: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isZero
      }
    }
  }
  
  /// Check if all values are non-zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isNonZero: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isNonZero
      }
    }
  }
  
  /// Check if all values are finite and non-zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFiniteNonZero: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFiniteNonZero
      }
    }
  }
  
  /// Check if all values are non-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isNonNegative: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isNonNegative
      }
    }
  }
  
  /// Check if all values are non-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isNonPositive: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isNonPositive
      }
    }
  }
  
  /// Check if all values are strictly-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isStrictlyPositive: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isStrictlyPositive
      }
    }
  }
  
  /// Check if all values are strictly-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isStrictlyNegative: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isStrictlyNegative
      }
    }
  }
  
  /// Check if all values are finite and non-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFiniteNonNegative: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFiniteNonNegative
      }
    }
  }
  
  /// Check if all values are finite and strictly-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFiniteStrictlyPositive: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFiniteStrictlyPositive
      }
    }
  }
  
  /// Check if all values are finite and non-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFiniteNonPositive: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFiniteNonPositive
      }
    }
  }
  
  /// Check if all values are finite and strictly-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  var isFiniteStrictlyNegative: Bool {
    get {
      return allNumericEntriesSatisfy() {
        $0.isFiniteStrictlyNegative
      }
    }
  }

}
