//
//  Double3x3Storage.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Double3x3Storage - Definition
// -------------------------------------------------------------------------- //

public struct Double3x3Storage {
  
  public typealias Storage = simd_double3x3
  
  public var storage: Storage
  
  @usableFromInline
  internal init(storage: Storage) {
    self.storage = storage
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Double3x3Storage - SIMDMatrix3x3StorageProtocol
// -------------------------------------------------------------------------- //

extension Double3x3Storage : SIMDMatrix3x3StorageProtocol {
  
  public typealias NumericEntryRepresentation = Double
  
  public typealias Scalar = Double
  
  public typealias ShorterAxisVector = SIMD3<Scalar>
  public typealias LongerAxisVector = SIMD3<Scalar>
  
  public typealias RowVector = SIMD3<Scalar>
  public typealias ColumnVector = SIMD3<Scalar>
  
  public typealias Rows = (RowVector,RowVector,RowVector)
  public typealias Columns = (ColumnVector,ColumnVector,ColumnVector)
  
  public typealias TransposeStorage = Double3x3Storage
  
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
      columns.1,
      columns.2
    )
  }
  
  @inlinable
  public init(columns: [ColumnVector]) {
    precondition(columns.count == Double3x3Storage.columnCount)
    self.storage = Storage(
      columns[0],
      columns[1],
      columns[2]
    )
  }
  
  @inlinable
  public init(rows: Rows) {
    self.storage = Storage(
      rows: [
        rows.0,
        rows.1,
        rows.2
      ]
    )
  }
  
  @inlinable
  public init(rows: [RowVector]) {
    precondition(rows.count == Double3x3Storage.rowCount)
    self.storage = Storage(
      rows: [
        rows[0],
        rows[1],
        rows[2]
      ]
    )
  }
  
  @inlinable
  public init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector) {
    self.storage = Storage(
      columnOne,
      columnTwo,
      columnThree
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
      fatalError("Invalid array-literal construction: \(String(reflecting: elements)) supplied-to `Double3x3Storage`!")
    }
    self.init(scalars: elements)
  }
  
  @inlinable
  public var description: String {
    get {
      return "Double3x3Storage(storage: \(String(describing: self.storage)))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Double3x3Storage(storage: \(String(reflecting: self.storage)))"
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
      precondition(Double3x3Storage.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0
      case 1:
        return self.storage.columns.1
      case 2:
        return self.storage.columns.2
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Double3x3Storage.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0 = newValue
      case 1:
        self.storage.columns.1 = newValue
      case 2:
        self.storage.columns.2 = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }
  
  @inlinable
  public subscript(columnIndex columnIndex: Int, rowIndex rowIndex: Int) -> Scalar {
    get {
      precondition(Double3x3Storage.columnIndexRange.contains(columnIndex))
      precondition(Double3x3Storage.rowIndexRange.contains(rowIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0[rowIndex]
      case 1:
        return self.storage.columns.1[rowIndex]
      case 2:
        return self.storage.columns.2[rowIndex]
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Double3x3Storage.columnIndexRange.contains(columnIndex))
      precondition(Double3x3Storage.rowIndexRange.contains(rowIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0[rowIndex] = newValue
      case 1:
        self.storage.columns.1[rowIndex] = newValue
      case 2:
        self.storage.columns.2[rowIndex] = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }
  
  @inlinable
  public func negated() -> Double3x3Storage {
    return Double3x3Storage(
      storage: -self.storage
    )
  }
  
  @inlinable
  public mutating func formNegation() {
    self.storage = -self.storage
  }
  
  @inlinable
  public func adding(_ other: Double3x3Storage) -> Double3x3Storage {
    return Double3x3Storage(
      storage: self.storage + other.storage
    )
  }
  
  @inlinable
  public mutating func formAddition(of other: Double3x3Storage) {
    self.storage += other.storage
  }
  
  @inlinable
  public func adding(
    _ other: Double3x3Storage,
    multipliedBy factor: Scalar) -> Double3x3Storage {
    return Double3x3Storage(
      storage: self.storage + (other.storage * factor)
    )
  }
  
  @inlinable
  public mutating func formAddition(
    of other: Double3x3Storage,
    multipliedBy factor: Scalar) {
    self.storage += (other.storage * factor)
  }
  
  @inlinable
  public func subtracting(_ other: Double3x3Storage) -> Double3x3Storage {
    return Double3x3Storage(
      storage: other.storage - self.storage
    )
  }
  
  @inlinable
  public mutating func formSubtraction(of other: Double3x3Storage) {
    self.storage -= other.storage
  }
  
  @inlinable
  public func multiplied(by factor: Scalar) -> Double3x3Storage {
    return Double3x3Storage(
      storage: self.storage * factor
    )
  }
  
  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self.storage *= factor
  }
  
  @inlinable
  public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
    return rowVector * self.storage
  }
  
  @inlinable
  public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
    return self.storage * columnVector
  }
  
  @inlinable
  public func multiplied(onRightBy other: Double3x3Storage) -> Double3x3Storage {
    return Double3x3Storage(
      storage: self.storage * other.storage
    )
  }
  
  @inlinable
  public func multiplied(onLeftBy other: Double3x3Storage) -> Double3x3Storage {
    return Double3x3Storage(
      storage: other.storage * self.storage
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy other: Double3x3Storage) {
    self.storage = self.storage * other.storage
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy other: Double3x3Storage) {
    self.storage = other.storage * self.storage
  }
  
  @inlinable
  public var determinant: Scalar {
    get {
      return self.storage.determinant
    }
  }
  
  @inlinable
  public var inverse: Double3x3Storage {
    get {
      return Double3x3Storage(
        storage: self.storage.inverse
      )
    }
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
