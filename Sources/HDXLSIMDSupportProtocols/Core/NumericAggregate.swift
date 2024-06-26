import Foundation
import simd

/// Semi-artificial protocol for SIMD-liked fixed-size "numeric aggregates".
///
/// Exists to provide (a) an easily-conformable target for concrete SIMD types, and then (b) a useful base type
/// against-which to write protocol extensions for e.g. `isFinite` and friends. This lets us avoid having
/// as much repetitive boilerplate (e.g. copy-and-paste `isFinite` implementations for each `doubleXxX`),
/// and makes minimal demands upon the conforming type.
///
/// Note that given the artificiality, here, I've deliberately chosen clunky, awkward names for the associatedtype
/// and the single protocol method.
///
/// I should probably rename the protocol before flipping to the 0.1.x series, but for now this works.
///
public protocol NumericAggregate<NumericEntryRepresentation> {
  
  /// The type of the individual numeric entries w/in the aggregate.
  associatedtype NumericEntryRepresentation
  
  /// Should return `true` iff all entries in the aggregate satisfy `predicate`.
  ///
  /// - note: Unlikely to be efficient, and really only meant for use in code that gets called in assertions and/or otherwise off "the critical path".
  ///
  func allNumericEntriesSatisfy(
    _ predicate: (NumericEntryRepresentation) throws -> Bool
  ) rethrows -> Bool
  
}
