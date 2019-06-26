//
//  Passthrough+MatrixProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough - MatrixProtocol Support
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue: MatrixProtocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Shape Parameters
  // ------------------------------------------------------------------------ //
  
  @inlinable
  static var rowCount: Int {
    get {
      return PassthroughValue.rowCount
    }
  }
  
  @inlinable
  static var rowLength: Int {
    get {
      return PassthroughValue.rowLength
    }
  }
  
  @inlinable
  static var columnCount: Int {
    get {
      return PassthroughValue.columnCount
    }
  }
  
  @inlinable
  static var columnLength: Int {
    get {
      return PassthroughValue.columnLength
    }
  }
  
  @inlinable
  static var scalarCount: Int {
    get {
      return PassthroughValue.scalarCount
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  init() {
    self.init(
      passthroughValue: PassthroughValue()
    )
  }
  
  @inlinable
  init(repeating scalar: PassthroughValue.Scalar) {
    self.init(
      passthroughValue: PassthroughValue(
        repeating: scalar
      )
    )
  }
  
  @inlinable
  init(diagonal: PassthroughValue.DiagonalVector) {
    self.init(
      passthroughValue: PassthroughValue(
        diagonal: diagonal
      )
    )
  }
  
  @inlinable
  init(columns: PassthroughValue.Columns) {
    self.init(
      passthroughValue: PassthroughValue(
        columns: columns
      )
    )
  }
  
  @inlinable
  init(columnVectors: [PassthroughValue.ColumnVector]) {
    self.init(
      passthroughValue: PassthroughValue(
        columnVectors: columnVectors
      )
    )
  }
  
  @inlinable
  init(rows: PassthroughValue.Rows) {
    self.init(
      passthroughValue: PassthroughValue(
        rows: rows
      )
    )
  }
  
  @inlinable
  init(rowVectors: [PassthroughValue.RowVector]) {
    self.init(
      passthroughValue: PassthroughValue(
        rowVectors: rowVectors
      )
    )
  }
  
  @inlinable
  init(linearizedScalars: [PassthroughValue.Scalar]) {
    self.init(
      passthroughValue: PassthroughValue(
        linearizedScalars: linearizedScalars
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //
  
  @inlinable
  static func linearCombination(
    of first: Self,
    weight firstWeight: PassthroughValue.Scalar,
    with other: Self,
    weight otherWeight: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: PassthroughValue.linearCombination(
        of: first.passthroughValue,
        weight: firstWeight,
        with: other.passthroughValue,
        weight: otherWeight
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Columns
  // ------------------------------------------------------------------------ //
  
  @inlinable
  subscript(columnIndex columnIndex: Int) -> PassthroughValue.ColumnVector {
    get {
      return self.passthroughValue[columnIndex: columnIndex]
    }
    set {
      self.passthroughValue[columnIndex: columnIndex] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //
  

  @inlinable
  subscript(rowIndex rowIndex: Int) -> PassthroughValue.RowVector {
    get {
      return self.passthroughValue[rowIndex: rowIndex]
    }
    set {
      self.passthroughValue[rowIndex: rowIndex] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Scalars
  // ------------------------------------------------------------------------ //
  
  @inlinable
  subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> PassthroughValue.Scalar {
    get {
      return self.passthroughValue[linearizedScalarIndex: linearizedScalarIndex]
    }
    set {
      self.passthroughValue[linearizedScalarIndex: linearizedScalarIndex] = newValue
    }
  }
  
  @inlinable
  subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int) -> PassthroughValue.Scalar {
    get {
      return self.passthroughValue[columnIndex: columnIndex, rowIndex: rowIndex]
    }
    set {
      self.passthroughValue[columnIndex: columnIndex, rowIndex: rowIndex] = newValue
    }
    
  }
  
  @inlinable
  subscript(position position: MatrixPosition) -> PassthroughValue.Scalar {
    get {
      return self.passthroughValue[position: position]
    }
    set {
      self.passthroughValue[position: position] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  static func linearScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    return PassthroughValue.linearizedScalarIndex(
      forMatrixPosition: matrixPosition
    )
  }
  
  @inlinable
  static func linearizedScalarIndex(forColumnIndex columnIndex: Int, rowIndex: Int) -> Int {
    return PassthroughValue.linearizedScalarIndex(
      forColumnIndex: columnIndex,
      rowIndex: rowIndex
    )
  }
  
  @inlinable
  static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int, Int) {
    return PassthroughValue.columnRowIndex(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
  }
  
  @inlinable
  static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    return PassthroughValue.linearizedScalarIndex(
      forMatrixPosition: matrixPosition
    )
  }

  @inlinable
  static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition {
    return PassthroughValue.matrixPosition(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
  }
  
  @inlinable
  static var matrixPositions: [MatrixPosition] {
    get {
      return PassthroughValue.matrixPositions
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Linearized Scalars <=> Arrays
  // ------------------------------------------------------------------------ //
  
  @inlinable
  static func columnVectors(forLinearizedScalars linearizedScalars: [PassthroughValue.Scalar]) -> [PassthroughValue.ColumnVector] {
    return PassthroughValue.columnVectors(
      forLinearizedScalars: linearizedScalars
    )
  }
  
  @inlinable
  static func rowVectors(forLinearizedScalars linearizedScalars: [PassthroughValue.Scalar]) -> [PassthroughValue.RowVector] {
    return PassthroughValue.rowVectors(
      forLinearizedScalars: linearizedScalars
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //
  
  @inlinable
  var columns: PassthroughValue.Columns {
    get {
      return self.passthroughValue.columns
    }
    set {
      self.passthroughValue.columns = newValue
    }
  }

  @inlinable
  var rows: PassthroughValue.Rows {
    get {
      return self.passthroughValue.rows
    }
  }

  @inlinable
  var columnVectors: [PassthroughValue.ColumnVector] {
    get {
      return self.passthroughValue.columnVectors
    }
  }
  
  @inlinable
  var rowVectors: [PassthroughValue.RowVector] {
    get {
      return self.passthroughValue.rowVectors
    }
  }
  
  @inlinable
  var linearizedScalars: [PassthroughValue.Scalar] {
    get {
      return self.passthroughValue.linearizedScalars
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func negated() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.negated()
    )
  }
  
  @inlinable
  mutating func formNegation() {
    self.passthroughValue.formNegation()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func adding(_ other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.adding(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formAddition(of other: Self) {
    self.passthroughValue.formAddition(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func adding(scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.adding(
        scalar: scalar
      )
    )
  }
  
  @inlinable
  mutating func formAddition(ofScalar scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formAddition(
      ofScalar: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func adding(
    _ other: Self,
    multipliedBy scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.adding(
        other.passthroughValue,
        multipliedBy: scalar
      )
    )
  }
  
  @inlinable
  mutating func formAddition(
    of other: Self,
    multipliedBy scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formAddition(
      of: other.passthroughValue,
      multipliedBy: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func subtracting(_ other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.subtracting(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formSubtraction(of other: Self) {
    self.passthroughValue.formSubtraction(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func subtracting(scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.subtracting(
        scalar: scalar
      )
    )
  }
  
  @inlinable
  mutating func formSubtraction(ofScalar scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formSubtraction(
      ofScalar: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func subtracting(
    _ other: Self,
    multipliedBy scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.subtracting(
        other.passthroughValue,
        multipliedBy: scalar
      )
    )
  }
  
  @inlinable
  mutating func formSubtraction(
    of other: Self,
    multipliedBy scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formSubtraction(
      of: other.passthroughValue,
      multipliedBy: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Multiplication - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func multiplied(by scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        by: scalar
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(by scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formMultiplication(
      by: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Division - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func divided(by scalar: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        by: scalar
      )
    )
  }
  
  @inlinable
  mutating func formDivision(by scalar: PassthroughValue.Scalar) {
    self.passthroughValue.formDivision(
      by: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Matrix-Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func multiplied(onLeftBy columnVector: PassthroughValue.ColumnVector) -> PassthroughValue.RowVector {
    return self.passthroughValue.multiplied(
      onLeftBy: columnVector
    )
  }
  
  @inlinable
  func multiplied(onRightBy rowVector: PassthroughValue.RowVector) -> PassthroughValue.ColumnVector {
    return self.passthroughValue.multiplied(
      onRightBy: rowVector
    )
  }
  
  
}

