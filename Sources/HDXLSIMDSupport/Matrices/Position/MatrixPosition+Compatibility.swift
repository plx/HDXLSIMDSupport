//
//  MatrixPosition+Compatibility.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension MatrixPosition {
  
  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 2x2 matrix.
  @inlinable
  var isCompatibleWith2x2Matrices: Bool {
    get {
      guard
        (0..<2).contains(self.rowIndex),
        (0..<2).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 2x3 matrix.
  @inlinable
  var isCompatibleWith2x3Matrices: Bool {
    get {
      guard
        (0..<3).contains(self.rowIndex),
        (0..<2).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 2x4 matrix.
  @inlinable
  var isCompatibleWith2x4Matrices: Bool {
    get {
      guard
        (0..<4).contains(self.rowIndex),
        (0..<2).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 3x2 matrix.
  @inlinable
  var isCompatibleWith3x2Matrices: Bool {
    get {
      guard
        (0..<2).contains(self.rowIndex),
        (0..<3).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 3x3 matrix.
  @inlinable
  var isCompatibleWith3x3Matrices: Bool {
    get {
      guard
        (0..<3).contains(self.rowIndex),
        (0..<3).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 3x4 matrix.
  @inlinable
  var isCompatibleWith3x4Matrices: Bool {
    get {
      guard
        (0..<4).contains(self.rowIndex),
        (0..<3).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 4x2 matrix.
  @inlinable
  var isCompatibleWith4x2Matrices: Bool {
    get {
      guard
        (0..<2).contains(self.rowIndex),
        (0..<4).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 4x3 matrix.
  @inlinable
  var isCompatibleWith4x3Matrices: Bool {
    get {
      guard
        (0..<3).contains(self.rowIndex),
        (0..<4).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }

  /// `true` iff the indicated position *exists* in a 4x4 matrix.
  @inlinable
  var isCompatibleWith4x4Matrices: Bool {
    get {
      guard
        (0..<4).contains(self.rowIndex),
        (0..<4).contains(self.columnIndex) else {
          return false
      }
      return true
    }
  }
  
}
