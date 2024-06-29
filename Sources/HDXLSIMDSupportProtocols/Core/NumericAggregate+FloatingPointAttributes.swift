import Foundation

// -------------------------------------------------------------------------- //
// MARK: NumericAggregate - Floating Point Attributes
// -------------------------------------------------------------------------- //

extension NumericAggregate where NumericEntryRepresentation:BinaryFloatingPoint {
  
  /// Check if all values are finite.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFinite: Bool {
    allNumericEntriesSatisfy {
      $0.isFinite
    }
  }
  
  /// Check if all values are zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isZero: Bool {
    allNumericEntriesSatisfy {
      $0.isZero
    }
  }
  
  /// Check if all values are non-zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isNonZero: Bool {
    allNumericEntriesSatisfy {
      $0.isNonZero
    }
  }
  
  /// Check if all values are finite and non-zero.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFiniteNonZero: Bool {
    allNumericEntriesSatisfy {
      $0.isFiniteNonZero
    }
  }
  
  /// Check if all values are non-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isNonNegative: Bool {
    allNumericEntriesSatisfy {
      $0.isNonNegative
    }
  }
  
  /// Check if all values are non-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isNonPositive: Bool {
    allNumericEntriesSatisfy() {
      $0.isNonPositive
    }
  }
  
  /// Check if all values are strictly-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isStrictlyPositive: Bool {
    allNumericEntriesSatisfy {
      $0.isStrictlyPositive
    }
  }
  
  /// Check if all values are strictly-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isStrictlyNegative: Bool {
    allNumericEntriesSatisfy {
      $0.isStrictlyNegative
    }
  }
  
  /// Check if all values are finite and non-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFiniteNonNegative: Bool {
    allNumericEntriesSatisfy {
      $0.isFiniteNonNegative
    }
  }
  
  /// Check if all values are finite and strictly-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFiniteStrictlyPositive: Bool {
    allNumericEntriesSatisfy {
      $0.isFiniteStrictlyPositive
    }
  }
  
  /// Check if all values are finite and non-positive.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFiniteNonPositive: Bool {
    allNumericEntriesSatisfy {
      $0.isFiniteNonPositive
    }
  }
  
  /// Check if all values are finite and strictly-negative.
  ///
  /// - note: Inefficient, only meant for `assert` (etc.).
  ///
  @inlinable
  public var isFiniteStrictlyNegative: Bool {
    allNumericEntriesSatisfy {
      $0.isFiniteStrictlyNegative
    }
  }

}
