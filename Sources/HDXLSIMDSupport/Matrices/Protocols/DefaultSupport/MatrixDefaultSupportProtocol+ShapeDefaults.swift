//
//  MatrixDefaultSupportProtocol+ShapeDefaults.swift
//

import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Shape Defaults
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol {
  
  @inlinable
  static var scalarCount: Int {
    get {
      return rowCount * columnCount
    }
  }

  @inlinable
  static var rowIndexRange: Range<Int> {
    get {
      return 0..<Self.rowCount
    }
  }

  @inlinable
  static var columnIndexRange: Range<Int> {
    get {
      return 0..<Self.columnCount
    }
  }
  
  @inlinable
  static var linearizedScalarIndexRange: Range<Int> {
    get {
      return 0..<Self.scalarCount
    }
  }
  
  @inlinable
  static func rowVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [RowVector] {
    precondition(linearizedScalars.count == Self.scalarCount)
    return Self.rowIndexRange.map() {
      let lowerBound = ($0 * Self.rowLength)
      let upperBound = lowerBound + Self.rowLength
      return RowVector(
        linearizedScalars[lowerBound..<upperBound]
      )
    }
  }

  @inlinable
  static func columnVectors(forLinearizedScalars linearizedScalars: [Scalar]) -> [ColumnVector] {
    precondition(linearizedScalars.count == Self.scalarCount)
    return Self.columnIndexRange.map() {
      let lowerBound = ($0 * Self.columnLength)
      let upperBound = lowerBound + Self.columnLength
      return ColumnVector(
        linearizedScalars[lowerBound..<upperBound]
      )
    }
  }
  
  @inlinable
  var linearizedScalars: [Scalar] {
    get {
      return Self.linearizedScalarIndexRange.map() {
        return self[linearizedScalarIndex: $0]
      }
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: 2-Row Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Rows == T2<RowVector> {
  
  @inlinable
  static var rowCount: Int {
    get {
      return 2
    }
  }
  
  @inlinable
  static var columnLength: Int {
    get {
      return 2
    }
  }
  
  @inlinable
  init(rows: Rows) {
    self.init(
      rowVectors: [
        rows.0,
        rows.1
      ]
    )
  }
  
  @inlinable
  var rowVectors: [RowVector] {
    get {
      return [
        rows.0,
        rows.1
      ]
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 3-Row Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Rows == T3<RowVector> {
  
  @inlinable
  static var rowCount: Int {
    get {
      return 3
    }
  }
  
  @inlinable
  static var columnLength: Int {
    get {
      return 3
    }
  }
  
  @inlinable
  init(rows: Rows) {
    self.init(
      rowVectors: [
        rows.0,
        rows.1,
        rows.2
      ]
    )
  }

  @inlinable
  var rowVectors: [RowVector] {
    get {
      return [
        rows.0,
        rows.1,
        rows.2
      ]
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: 4-Row Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Rows == T4<RowVector> {
  
  @inlinable
  static var rowCount: Int {
    get {
      return 4
    }
  }
  
  @inlinable
  static var columnLength: Int {
    get {
      return 4
    }
  }
  
  @inlinable
  init(rows: Rows) {
    self.init(
      rowVectors: [
        rows.0,
        rows.1,
        rows.2,
        rows.3
      ]
    )
  }

  @inlinable
  var rowVectors: [RowVector] {
    get {
      return [
        rows.0,
        rows.1,
        rows.2,
        rows.3
      ]
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: 2-Column Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Columns == T2<ColumnVector> {
  
  @inlinable
  static var columnCount: Int {
    get {
      return 2
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return 2
    }
  }
  
  @inlinable
  subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        return columns.0
      case 1:
        return columns.1
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        columns.0 = newValue
      case 1:
        columns.1 = newValue
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
  }

  @inlinable
  var columnVectors: [ColumnVector] {
    get {
      return [
        columns.0,
        columns.1
      ]
    }
  }
  
  @inlinable
  func adding(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar
      )
    )
  }
  
  @inlinable
  func subtracting(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar
      )
    )
  }
  
  @inlinable
  mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
  }
  
  @inlinable
  mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
  }

}

// -------------------------------------------------------------------------- //
// MARK: 3-Column Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Columns == T3<ColumnVector> {
  
  @inlinable
  static var columnCount: Int {
    get {
      return 3
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return 3
    }
  }
 
  @inlinable
  subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        return columns.0
      case 1:
        return columns.1
      case 2:
        return columns.2
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        columns.0 = newValue
      case 1:
        columns.1 = newValue
      case 2:
        columns.2 = newValue
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
  }

  @inlinable
  var columnVectors: [ColumnVector] {
    get {
      return [
        columns.0,
        columns.1,
        columns.2
      ]
    }
  }

  @inlinable
  func adding(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar,
        columns.2 + scalar
      )
    )
  }
  
  @inlinable
  func subtracting(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar,
        columns.2 - scalar
      )
    )
  }
  
  @inlinable
  mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
    columns.2 += scalar
  }
  
  @inlinable
  mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
    columns.2 -= scalar
  }

}

// -------------------------------------------------------------------------- //
// MARK: 4-Column Support
// -------------------------------------------------------------------------- //

public extension MatrixDefaultSupportProtocol
  where
  Columns == T4<ColumnVector> {
  
  @inlinable
  static var columnCount: Int {
    get {
      return 4
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return 4
    }
  }
  
  @inlinable
  subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        return columns.0
      case 1:
        return columns.1
      case 2:
        return columns.2
      case 3:
        return columns.3
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
    set {
      precondition(Self.columnIndexRange.contains(columnIndex))
      switch columnIndex {
      case 0:
        columns.0 = newValue
      case 1:
        columns.1 = newValue
      case 2:
        columns.2 = newValue
      case 3:
        columns.3 = newValue
      default:
        fatalError("Used invalid `columnIndex` \(columnIndex) to subscript \(String(reflecting: self))!")
      }
    }
  }
 
  @inlinable
  var columnVectors: [ColumnVector] {
    get {
      return [
        columns.0,
        columns.1,
        columns.2,
        columns.3
      ]
    }
  }

  @inlinable
  func adding(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar,
        columns.2 + scalar,
        columns.3 + scalar
      )
    )
  }

  @inlinable
  func subtracting(scalar: Scalar) -> Self {
    return Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar,
        columns.2 - scalar,
        columns.3 - scalar
      )
    )
  }

  @inlinable
  mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
    columns.2 += scalar
    columns.3 += scalar
  }

  @inlinable
  mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
    columns.2 -= scalar
    columns.3 -= scalar
  }

}

