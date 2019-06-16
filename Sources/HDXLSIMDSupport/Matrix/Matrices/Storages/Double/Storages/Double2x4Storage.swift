//
//  Double2x4Storage.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Double2x4Storage - Definition
// -------------------------------------------------------------------------- //

public struct Double2x4Storage {
  
  public typealias Storage = simd_double2x4
  
  public var storage: Storage
  
  @usableFromInline
  internal init(storage: Storage) {
    self.storage = storage
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Double2x4Storage - SIMDMatrix2x4StorageProtocol
// -------------------------------------------------------------------------- //

extension Double2x4Storage : SIMDMatrix2x4StorageProtocol {
  
  public typealias NumericEntryRepresentation = Double
  
  public typealias Scalar = Double
  
  public typealias ShorterAxisVector = SIMD2<Scalar>
  public typealias LongerAxisVector = SIMD4<Scalar>
  
  public typealias RowVector = SIMD2<Scalar>
  public typealias ColumnVector = SIMD4<Scalar>
  
  public typealias Rows = (RowVector,RowVector,RowVector,RowVector)
  public typealias Columns = (ColumnVector,ColumnVector)
  
  public typealias TransposeStorage = Double4x2Storage
  
  @inlinable
  public init() {
    self.storage = Storage()
  }
  
  @inlinable
  public init(repeating scalar: Double) {
    self.storage = Storage(scalar)
  }
  
  @inlinable
  public init(diagonal: DiagonalVector) {
    self.storage = Storage(diagonal: diagonal)
  }
  
  @inlinable
  public init(columns: Columns) {
    self.storage = Storage(
      columns.0,
      columns.1
    )
  }
  
  @inlinable
  public init(columns: [ColumnVector]) {
    precondition(columns.count == Double2x4Storage.columnCount)
    self.storage = Storage(
      columns[0],
      columns[1]
    )
  }
  
  @inlinable
  public init(rows: Rows) {
    self.storage = Storage(
      rows: [
        rows.0,
        rows.1,
        rows.2,
        rows.3
      ]
    )
  }
  
  @inlinable
  public init(rows: [RowVector]) {
    precondition(rows.count == Double2x4Storage.rowCount)
    self.storage = Storage(
      rows: [
        rows[0],
        rows[1],
        rows[2],
        rows[3]
      ]
    )
  }
  
  @inlinable
  public init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector) {
    self.storage = Storage(
      columnOne,
      columnTwo
    )
  }
  
  @inlinable
  public init<S:Sequence>(scalars: S)
    where S.Element == Scalar {
      self.init()
      var visitCount: Int = 0
      let scalarCount = type(of: self).scalarCount
      for (scalarIndex,element) in scalars.enumerated() {
        guard visitCount <= scalarCount else {
          preconditionFailure("init<S:Sequence>(scalars:) supplied an overlong sequence \(String(reflecting: scalars)); final state: \(String(reflecting: self)).")
        }
        self[scalarIndex: scalarIndex] = element
        visitCount += 1
      }
      guard visitCount == scalarCount else {
        preconditionFailure("init<S:Sequence>(scalars:) supplied an underlong (only \(visitCount) sequence \(String(reflecting: scalars)); final state: \(String(reflecting: self)).")
      }
  }
  
  @inlinable
  public init<C:Collection>(scalars: C)
    where C.Element == Scalar {
      self.init()
      precondition(scalars.count == type(of: self).scalarCount)
      for (scalarIndex,element) in scalars.enumerated() {
        self[scalarIndex: scalarIndex] = element
      }
  }
  
  @inlinable
  public init(arrayLiteral elements: Scalar...) {
    guard elements.count == type(of: self).scalarCount else {
      fatalError("Invalid array-literal construction: \(String(reflecting: elements)) supplied-to `Double2x4Storage`!")
    }
    self.init(scalars: elements)
  }
  
  @inlinable
  public var description: String {
    get {
      return "Double2x4Storage(storage: \(String(describing: self.storage)))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Double2x4Storage(storage: \(String(reflecting: self.storage)))"
    }
  }
  
  @inlinable
  public var columns: Columns {
    get {
      return self.storage.columns
    }
    set {
      self.storage.columns = newValue
    }
  }
  
  @inlinable
  public subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      precondition(Double2x4Storage.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0
      case 1:
        return self.storage.columns.1
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Double2x4Storage.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0 = newValue
      case 1:
        self.storage.columns.1 = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }
  
  @inlinable
  public subscript(columnIndex columnIndex: Int, rowIndex rowIndex: Int) -> Scalar {
    get {
      precondition(Double2x4Storage.columnIndexRange.contains(columnIndex))
      precondition(Double2x4Storage.rowIndexRange.contains(rowIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0[rowIndex]
      case 1:
        return self.storage.columns.1[rowIndex]
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Double2x4Storage.columnIndexRange.contains(columnIndex))
      precondition(Double2x4Storage.rowIndexRange.contains(rowIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0[rowIndex] = newValue
      case 1:
        self.storage.columns.1[rowIndex] = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }
  
  @inlinable
  public func negated() -> Double2x4Storage {
    return Double2x4Storage(
      storage: -self.storage
    )
  }
  
  @inlinable
  public mutating func formNegation() {
    self.storage = -self.storage
  }
  
  @inlinable
  public func adding(_ other: Double2x4Storage) -> Double2x4Storage {
    return Double2x4Storage(
      storage: self.storage + other.storage
    )
  }
  
  @inlinable
  public mutating func formAddition(of other: Double2x4Storage) {
    self.storage += other.storage
  }
  
  @inlinable
  public func adding(
    _ other: Double2x4Storage,
    multipliedBy factor: Scalar) -> Double2x4Storage {
    return Double2x4Storage(
      storage: self.storage + (other.storage * factor)
    )
  }
  
  @inlinable
  public mutating func formAddition(
    of other: Double2x4Storage,
    multipliedBy factor: Scalar) {
    self.storage += (other.storage * factor)
  }
  
  @inlinable
  public func subtracting(_ other: Double2x4Storage) -> Double2x4Storage {
    return Double2x4Storage(
      storage: other.storage - self.storage
    )
  }
  
  @inlinable
  public mutating func formSubtraction(of other: Double2x4Storage) {
    self.storage -= other.storage
  }
  
  @inlinable
  public func multiplied(by factor: Scalar) -> Double2x4Storage {
    return Double2x4Storage(
      storage: self.storage * factor
    )
  }
  
  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self.storage *= factor
  }
  
  @inlinable
  public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
    return columnVector * self.storage
  }
  
  @inlinable
  public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
    return self.storage * rowVector
  }
  
  @inlinable
  public var transpose: TransposeStorage {
    get {
      return TransposeStorage(
        storage: self.storage.transpose
      )
    }
  }
  
}
