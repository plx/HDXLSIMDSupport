import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Shape Defaults
// -------------------------------------------------------------------------- //

extension MatrixProtocol {
  
  @inlinable
  public static var scalarCount: Int {
    rowCount * columnCount
  }

  @inlinable
  public static var rowIndexRange: Range<Int> {
    0..<rowCount
  }

  @inlinable
  public static var columnIndexRange: Range<Int> {
    0..<columnCount
  }
  
  @inlinable
  public static var linearizedScalarIndexRange: Range<Int> {
    0..<scalarCount
  }
  
  @inlinable
  public static func rowVectors(
    forLinearizedScalars linearizedScalars: [Scalar]
  ) -> [RowVector] {
    precondition(linearizedScalars.count == scalarCount)
    return rowIndexRange.map {
      let lowerBound = ($0 * rowLength)
      let upperBound = lowerBound + rowLength
      return RowVector(
        linearizedScalars[lowerBound..<upperBound]
      )
    }
  }

  @inlinable
  public static func columnVectors(
    forLinearizedScalars linearizedScalars: [Scalar]
  ) -> [ColumnVector] {
    precondition(linearizedScalars.count == scalarCount)
    return columnIndexRange.map {
      let lowerBound = ($0 * columnLength)
      let upperBound = lowerBound + columnLength
      return ColumnVector(
        linearizedScalars[lowerBound..<upperBound]
      )
    }
  }
  
  @inlinable
  public var linearizedScalars: [Scalar] {
    Self.linearizedScalarIndexRange.map {
      return self[linearizedScalarIndex: $0]
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: 2-Row Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Rows == T2<RowVector> {
  
  @inlinable
  public static var rowCount: Int { 2 }

  @inlinable
  public static var columnLength: Int { 2 }
  
  @inlinable
  public init(rows: Rows) {
    self.init(
      rowVectors: [
        rows.0,
        rows.1
      ]
    )
  }
  
  @inlinable
  public var rowVectors: [RowVector] {
    [
      rows.0,
      rows.1
    ]
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: 3-Row Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Rows == T3<RowVector> {
  
  @inlinable
  public static var rowCount: Int { 3 }
  
  @inlinable
  public static var columnLength: Int { 3 }
  
  @inlinable
  public init(rows: Rows) {
    self.init(
      rowVectors: [
        rows.0,
        rows.1,
        rows.2
      ]
    )
  }

  @inlinable
  public var rowVectors: [RowVector] {
    [
      rows.0,
      rows.1,
      rows.2
    ]
  }

}

// -------------------------------------------------------------------------- //
// MARK: 4-Row Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Rows == T4<RowVector> {
  
  @inlinable
  public static var rowCount: Int { 4 }
  
  @inlinable
  public static var columnLength: Int { 4 }
  
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
  public var rowVectors: [RowVector] {
    [
      rows.0,
      rows.1,
      rows.2,
      rows.3
    ]
  }

}

// -------------------------------------------------------------------------- //
// MARK: 2-Column Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Columns == T2<ColumnVector> {
  
  @inlinable
  public static var columnCount: Int { 2 }
  
  @inlinable
  public static var rowLength: Int { 2 }
  
  @inlinable
  public subscript(columnIndex columnIndex: Int) -> ColumnVector {
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
  public var columnVectors: [ColumnVector] {
    [
      columns.0,
      columns.1
    ]
  }
  
  @inlinable
  public func adding(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar
      )
    )
  }
  
  @inlinable
  public func subtracting(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar
      )
    )
  }
  
  @inlinable
  public mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
  }
  
  @inlinable
  public mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
  }

}

// -------------------------------------------------------------------------- //
// MARK: 3-Column Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Columns == T3<ColumnVector> {
  
  @inlinable
  public static var columnCount: Int { 3 }
  
  @inlinable
  public static var rowLength: Int { 3 }
 
  @inlinable
  public subscript(columnIndex columnIndex: Int) -> ColumnVector {
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
  public var columnVectors: [ColumnVector] {
    [
      columns.0,
      columns.1,
      columns.2
    ]
  }

  @inlinable
  public func adding(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar,
        columns.2 + scalar
      )
    )
  }
  
  @inlinable
  public func subtracting(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar,
        columns.2 - scalar
      )
    )
  }
  
  @inlinable
  public mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
    columns.2 += scalar
  }
  
  @inlinable
  public mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
    columns.2 -= scalar
  }

}

// -------------------------------------------------------------------------- //
// MARK: 4-Column Support
// -------------------------------------------------------------------------- //

extension MatrixProtocol where Columns == T4<ColumnVector> {
  
  @inlinable
  public static var columnCount: Int { 4 }
  
  @inlinable
  public static var rowLength: Int { 4 }
  
  @inlinable
  public subscript(columnIndex columnIndex: Int) -> ColumnVector {
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
  public var columnVectors: [ColumnVector] {
    [
      columns.0,
      columns.1,
      columns.2,
      columns.3
    ]
  }

  @inlinable
  public func adding(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 + scalar,
        columns.1 + scalar,
        columns.2 + scalar,
        columns.3 + scalar
      )
    )
  }

  @inlinable
  public func subtracting(scalar: Scalar) -> Self {
    Self(
      columns: (
        columns.0 - scalar,
        columns.1 - scalar,
        columns.2 - scalar,
        columns.3 - scalar
      )
    )
  }

  @inlinable
  public mutating func formAddition(ofScalar scalar: Scalar) {
    columns.0 += scalar
    columns.1 += scalar
    columns.2 += scalar
    columns.3 += scalar
  }

  @inlinable
  public mutating func formSubtraction(ofScalar scalar: Scalar) {
    columns.0 -= scalar
    columns.1 -= scalar
    columns.2 -= scalar
    columns.3 -= scalar
  }

}
