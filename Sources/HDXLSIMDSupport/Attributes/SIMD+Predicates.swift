//
//  SIMD+Predicates.swift
//

import Foundation
import simd

public extension SIMD {
  
  /// Returns `true` iff all values in `self` satisfy `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func allSatisfy(_ predicate: (Scalar) -> Bool) -> Bool {
    for index in Self.subscriptableIndexRange {
      guard predicate(self[index]) else {
        return false
      }
    }
    return true
  }
  
  /// Returns count of values in `self` that *fail* `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func countFailing(_ predicate: (Scalar) -> Bool) -> Int {
    var count = 0
    for index in Self.subscriptableIndexRange {
      if !predicate(self[index]) {
        count += 1
      }
    }
    return count
  }

  /// Returns count of values in `self` that *pass* `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func countSatisfying(_ predicate: (Scalar) -> Bool) -> Int {
    var count = 0
    for index in Self.subscriptableIndexRange {
      if predicate(self[index]) {
        count += 1
      }
    }
    return count
  }

  /// Returns set of indices for which the associated values in `self` *fail* `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func indexesFailing(_ predicate: (Scalar) -> Bool) -> IndexSet {
    var result: IndexSet = IndexSet()
    for index in Self.subscriptableIndexRange {
      if !predicate(self[index]) {
        result.insert(index)
      }
    }
    return result
  }

  /// Returns set of indices for which the associated values in `self` *pass* `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func indexesSatisfying(_ predicate: (Scalar) -> Bool) -> IndexSet {
    var result: IndexSet = IndexSet()
    for index in Self.subscriptableIndexRange {
      if predicate(self[index]) {
        result.insert(index)
      }
    }
    return result
  }

  /// Returns sets of indices for which the associated values in `self` *pass* and *fail* `predicate`.
  ///
  /// - note: Inefficient; meant for use in `assert`.
  ///
  @inlinable
  func indexesPartitioned(by predicate: (Scalar) -> Bool) -> (IndexSet,IndexSet) {
    var passing: IndexSet = IndexSet()
    var failing: IndexSet = IndexSet()
    for index in Self.subscriptableIndexRange {
      if predicate(self[index]) {
        passing.insert(index)
      } else {
        failing.insert(index)
      }
    }
    return (passing,failing)
  }

}
