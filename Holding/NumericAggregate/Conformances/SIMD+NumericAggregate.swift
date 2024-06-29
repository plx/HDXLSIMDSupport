import Foundation
import simd
import HDXLSIMDSupportProtocols

// -------------------------------------------------------------------------- //
// MARK: SIMD2 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD2 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD3 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD3 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD4 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD4 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD8 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD16 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD16 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD32 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD32 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD64 - NumericAggregate
// -------------------------------------------------------------------------- //

extension SIMD64 : @retroactive NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool {
    for index in Self.subscriptableIndexRange {
      guard try predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
}
