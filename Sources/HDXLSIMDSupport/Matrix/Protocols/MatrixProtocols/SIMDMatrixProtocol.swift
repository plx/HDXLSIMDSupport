//
//  SIMDMatrixProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Definition
// -------------------------------------------------------------------------- //

/// Protocol for storage-backed SIMD matrices; exists to offer default implementations to conformers.
public protocol SIMDMatrixProtocol : Hashable, Codable {
  
  associatedtype Storage: SIMDMatrixStorageProtocol
  
  typealias Scalar = Storage.Scalar
  typealias RowVector = Storage.RowVector
  typealias ColumnVector = Storage.ColumnVector
  typealias ShorterAxisVector = Storage.ShorterAxisVector
  typealias LongerAxisVector = Storage.LongerAxisVector
  typealias DiagonalVector = Storage.DiagonalVector
  
  typealias Columns = Storage.Columns
  typealias Rows = Storage.Rows
  
  init(storage: Storage)
  
  var storage: Storage { get set }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - Common
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
  
  @inlinable
  static var scalarCount: Int {
    get {
      return Storage.scalarCount
    }
  }
  
  @inlinable
  static var rowCount: Int {
    get {
      return Storage.rowCount
    }
  }

  @inlinable
  static var columnCount: Int {
    get {
      return Storage.columnCount
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return Storage.rowLength
    }
  }
  
  @inlinable
  static var columnLength: Int {
    get {
      return Storage.columnLength
    }
  }
  
  @inlinable
  subscript(scalarIndex scalarIndex: Int) -> Scalar {
    get {
      return self.storage[scalarIndex: scalarIndex]
    }
    set {
      self.storage[scalarIndex: scalarIndex] = newValue
    }
  }

  @inlinable
  subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      return self.storage[columnIndex: columnIndex]
    }
    set {
      self.storage[columnIndex: columnIndex] = newValue
    }
  }

  @inlinable
  subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int) -> Scalar {
    get {
      return self.storage[columnIndex: columnIndex, rowIndex: rowIndex]
    }
    set {
      self.storage[columnIndex: columnIndex, rowIndex: rowIndex] = newValue
    }
  }
  
  @inlinable
  init() {
    self.init(
      storage: Storage()
    )
  }
  
  @inlinable
  init(repeating scalar: Scalar) {
    self.init(
      storage: Storage(
        repeating: scalar
      )
    )
  }
  
  @inlinable
  init(diagonal: DiagonalVector) {
    self.init(
      storage: Storage(
        diagonal: diagonal
      )
    )
  }
  
  @inlinable
  init(columns: Columns) {
    self.init(
      storage: Storage(
        columns: columns
      )
    )
  }
  
  @inlinable
  init(rows: Rows) {
    self.init(
      storage: Storage(
        rows: rows
      )
    )
  }
  
  @inlinable
  var columns: Columns {
    get {
      return self.storage.columns
    }
    set {
      self.storage.columns = newValue
    }
  }

  @inlinable
  static prefix func -(x: Self) -> Self {
    return Self(
      storage: -x.storage
    )
  }
  
  @inlinable
  static func + (lhs: Self, rhs: Self) -> Self {
    return Self.init(
      storage: lhs.storage + rhs.storage
    )
  }
  
  @inlinable
  static func - (lhs: Self, rhs: Self) -> Self {
    return Self.init(
      storage: lhs.storage - rhs.storage
    )
  }
  
  @inlinable
  static func * (lhs: Self, rhs: Scalar) -> Self {
    return Self.init(
      storage: lhs.storage * rhs
    )
  }
  
  @inlinable
  static func * (lhs: Scalar, rhs: Self) -> Self {
    return Self.init(
      storage: lhs * rhs.storage
    )
  }
  
  @inlinable
  static func += (lhs: inout Self, rhs: Self) {
    lhs.storage += rhs.storage
  }
  
  @inlinable
  static func -= (lhs: inout Self, rhs: Self) {
    lhs.storage -= rhs.storage
  }
  
  @inlinable
  static func *= (lhs: inout Self, rhs: Scalar) {
    lhs.storage *= rhs
  }
  
  @inlinable
  static func * (lhs: RowVector, rhs: Self) -> ColumnVector {
    return lhs * rhs.storage
  }
  
  @inlinable
  static func * (lhs: Self, rhs: ColumnVector) -> RowVector {
    return lhs.storage * rhs
  }

}
