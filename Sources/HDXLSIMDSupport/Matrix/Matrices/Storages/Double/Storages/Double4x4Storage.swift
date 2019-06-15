//
//  Double4x4Storage.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public struct Double4x4Storage {
  
  public typealias Storage = simd_double4x4
  
  public var storage: Storage
  
  @usableFromInline
  internal init(storage: Storage) {
    self.storage = storage
  }
  
}

extension Double4x4Storage : SIMDMatrix4x4StorageProtocol {
  
  public typealias Scalar = Double

  public typealias ShorterAxisVector = SIMD4<Scalar>
  public typealias LongerAxisVector = SIMD4<Scalar>
  
  public typealias RowVector = SIMD4<Scalar>
  public typealias ColumnVector = SIMD4<Scalar>
  
  public typealias Rows = (RowVector,RowVector,RowVector,RowVector)
  public typealias Columns = (RowVector,RowVector,RowVector,RowVector)
  
  public typealias TransposeStorage = Double4x4Storage
  
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
      columns.2,
      columns.3
    )
  }

  @inlinable
  public init(columns: [ColumnVector]) {
    precondition(columns.count == Double4x4Storage.columnCount)
    self.storage = Storage(
      columns[0],
      columns[1],
      columns[2],
      columns[3]
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
    precondition(rows.count == Double4x4Storage.rowCount)
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
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector,
    _ columnFour: ColumnVector) {
    self.storage = Storage(
      columnOne,
      columnTwo,
      columnThree,
      columnFour
    )
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
      precondition((0..<4).contains(columnIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0
      case 1:
        return self.storage.columns.1
      case 2:
        return self.storage.columns.2
      case 3:
        return self.storage.columns.3
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition((0..<4).contains(columnIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0 = newValue
      case 1:
        self.storage.columns.1 = newValue
      case 2:
        self.storage.columns.2 = newValue
      case 3:
        self.storage.columns.3 = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }

  @inlinable
  public subscript(columnIndex columnIndex: Int, rowIndex rowIndex: Int) -> Scalar {
    get {
      precondition((0..<4).contains(columnIndex))
      precondition((0..<4).contains(rowIndex))
      switch columnIndex {
      case 0:
        return self.storage.columns.0[rowIndex]
      case 1:
        return self.storage.columns.1[rowIndex]
      case 2:
        return self.storage.columns.2[rowIndex]
      case 3:
        return self.storage.columns.3[rowIndex]
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
    set {
      precondition((0..<4).contains(columnIndex))
      precondition((0..<4).contains(rowIndex))
      switch columnIndex {
      case 0:
        self.storage.columns.0[rowIndex] = newValue
      case 1:
        self.storage.columns.1[rowIndex] = newValue
      case 2:
        self.storage.columns.2[rowIndex] = newValue
      case 3:
        self.storage.columns.3[rowIndex] = newValue
      default:
        fatalError("Used invalid column-index subscript \(columnIndex) on \(String(reflecting: self))!")
      }
    }
  }

  @inlinable
  public static prefix func -(x: Double4x4Storage) -> Double4x4Storage {
    return Double4x4Storage(
      storage: -x.storage
    )
  }
  
  @inlinable
  public static func + (lhs: Double4x4Storage, rhs: Double4x4Storage) -> Double4x4Storage {
    return Double4x4Storage(
      storage: lhs.storage + rhs.storage
    )
  }

  @inlinable
  public static func - (lhs: Double4x4Storage, rhs: Double4x4Storage) -> Double4x4Storage {
    return Double4x4Storage(
      storage: lhs.storage - rhs.storage
    )
  }
  
  @inlinable
  public static func * (lhs: Double4x4Storage, rhs: Scalar) -> Double4x4Storage {
    return Double4x4Storage(
      storage: lhs.storage * rhs
    )
  }
  
  @inlinable
  public static func * (lhs: Scalar, rhs: Double4x4Storage) -> Double4x4Storage {
    return Double4x4Storage(
      storage: lhs * rhs.storage
    )
  }
  
  @inlinable
  public static func += (lhs: inout Double4x4Storage, rhs: Double4x4Storage) {
    lhs.storage += rhs.storage
  }
  
  @inlinable
  public static func -= (lhs: inout Double4x4Storage, rhs: Double4x4Storage) {
    lhs.storage -= rhs.storage
  }
  
  @inlinable
  public static func *= (lhs: inout Double4x4Storage, rhs: Scalar) {
    lhs.storage *= rhs
  }
  
  @inlinable
  public static func * (lhs: RowVector, rhs: Double4x4Storage) -> ColumnVector {
    return lhs * rhs.storage
  }
  
  @inlinable
  public static func * (lhs: Double4x4Storage, rhs: ColumnVector) -> RowVector {
    return lhs.storage * rhs
  }
  
  @inlinable
  public static func *= (lhs: inout Double4x4Storage, rhs: Double4x4Storage) {
    lhs.storage *= rhs.storage
  }

  @inlinable
  public static func =* (lhs: Double4x4Storage, rhs: inout Double4x4Storage) {
    rhs.storage = lhs.storage * rhs.storage
  }

  @inlinable
  public var determinant: Scalar {
    get {
      return self.storage.determinant
    }
  }
  
  @inlinable
  public var inverse: Double4x4Storage {
    get {
      return Double4x4Storage(
        storage: self.storage.inverse
      )
    }
  }
  
  @inlinable
  public static func * (lhs: Double4x4Storage, rhs: Double4x4Storage) -> Double4x4Storage {
    return Double4x4Storage(
      storage: lhs.storage * rhs.storage
    )
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
