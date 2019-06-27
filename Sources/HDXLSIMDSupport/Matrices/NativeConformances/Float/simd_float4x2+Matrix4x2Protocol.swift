//
//  simd_float4x2+Matrix4x2Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_float4x2 : MatrixDefaultSupportProtocol, Matrix4x2Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar
  // ------------------------------------------------------------------------ //
  
  public typealias Scalar = Float
  
  // ------------------------------------------------------------------------ //
  // MARK: Vectors
  // ------------------------------------------------------------------------ //
  
  public typealias RowVector = SIMD4<Scalar>
  public typealias ColumnVector = SIMD2<Scalar>
  public typealias DiagonalVector = SIMD2<Scalar>
  
  // ------------------------------------------------------------------------ //
  // MARK: Components
  // ------------------------------------------------------------------------ //
  
  public typealias Columns = T4<ColumnVector>
  public typealias Rows = T2<RowVector>
  
  // ------------------------------------------------------------------------ //
  // MARK: Shape Parameters
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  /*
   static var rowCount: Int { get }
   static var rowLength: Int { get }
   static var columnCount: Int { get }
   static var columnLength: Int { get }
   static var scalarCount: Int { get }
   */
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  // should already exist:
  // init()
  
  // we supply (for now)
  @inlinable
  public init(repeating scalar: Scalar) {
    self.init(scalar)
  }
  
  // should already exist:
  // init(diagonal: DiagonalVector)
  
  // should already exist:
  // init(columns: Columns)
  
  // we supply:
  @inlinable
  public init(columnVectors: [ColumnVector]) {
    precondition(columnVectors.count == Self.columnCount)
    self.init(columnVectors)
  }
  
  
  // defaults should supply:
  // init(rows: Rows)
  
  // we supply:
  @inlinable
  public init(rowVectors: [RowVector]) {
    precondition(rowVectors.count == Self.rowCount)
    self.init(rows: rowVectors)
  }
  
  // we supply:
  // - note: we *could* call through to the existing `init<S>` on the type,
  // but I want to keep my semantics stable
  @inlinable
  public init(linearizedScalars: [Scalar]) {
    precondition(linearizedScalars.count == Self.scalarCount)
    self.init(
      columnVectors: simd_float4x2.columnVectors(
        forLinearizedScalars: linearizedScalars
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static func linearCombination(
    of first: simd_float4x2,
    weight firstWeight: Scalar,
    with other: simd_float4x2,
    weight otherWeight: Scalar) -> simd_float4x2 {
    return simd_linear_combination(
      firstWeight,
      first,
      otherWeight,
      other
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Columns
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  // subscript(columnIndex columnIndex: Int) -> ColumnVector { get set }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public subscript(rowIndex rowIndex: Int) -> RowVector {
    get {
      precondition(simd_float4x2.rowIndexRange.contains(rowIndex))
      return RowVector(
        self.columns.0[rowIndex],
        self.columns.1[rowIndex],
        self.columns.2[rowIndex],
        self.columns.3[rowIndex]
      )
    }
    set {
      precondition(simd_float4x2.rowIndexRange.contains(rowIndex))
      self.columns.0[rowIndex] = newValue[0]
      self.columns.1[rowIndex] = newValue[1]
      self.columns.2[rowIndex] = newValue[2]
      self.columns.3[rowIndex] = newValue[3]
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Scalars
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  // subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> Scalar { get set }
  
  // defaults should supply:
  //  subscript(
  //    columnIndex columnIndex: Int,
  //    rowIndex rowIndex: Int) -> Scalar { get set }
  
  // defaults should supply:
  // subscript(position position: MatrixPosition) -> Scalar { get set }
  
  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  // static func linearizedScalarIndex(
  //  forColumnIndex columnIndex: Int,
  //  rowIndex: Int) -> Int
  
  // defaults should supply:
  // static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int,Int)
  
  // defaults should supply:
  // static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int
  
  // defaults should supply:
  // static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition
  
  // we supply:
  public static let matrixPositions: [MatrixPosition] = simd_float4x2.prepareMatrixPositionList()
  
  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //
  
  // should already exist:
  // var columns: Columns { get set }
  
  // we supply:
  @inlinable
  public var rows: Rows {
    get {
      return (
        RowVector(
          self.columns.0[0],
          self.columns.1[0],
          self.columns.2[0],
          self.columns.3[0]
        ),
        RowVector(
          self.columns.0[1],
          self.columns.1[1],
          self.columns.2[1],
          self.columns.3[1]
        )
      )
    }
  }
  
  // defaults should supply:
  // var columnVectors: [ColumnVector]
  
  // defaults should supply:
  // var rowVectors: [RowVector] { get }
  
  // defaults should supply:
  // var linearizedScalars: [Scalar] { get }
  
  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_float4x2,
    absoluteTolerance tolerance: Scalar) -> Bool {
    return simd_almost_equal_elements(
      self,
      other,
      tolerance
    )
  }
  
  // we supply:
  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_float4x2,
    relativeTolerance tolerance: Scalar) -> Bool {
    return simd_almost_equal_elements_relative(
      self,
      other,
      tolerance
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func negated() -> simd_float4x2 {
    return -self
  }
  
  // we supply:
  @inlinable
  public mutating func formNegation() {
    self = -self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func adding(_ other: simd_float4x2) -> simd_float4x2 {
    return self + other
  }
  
  // we supply:
  @inlinable
  public mutating func formAddition(of other: simd_float4x2) {
    self += other
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Scalar
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  // func adding(scalar: Scalar) -> Self
  
  // defaults should supply:
  // mutating func formAddition(ofScalar scalar: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func adding(
    _ other: simd_float4x2,
    multipliedBy scalar: Scalar) -> simd_float4x2 {
    return self + (other * scalar)
  }
  
  // we supply:
  @inlinable
  public mutating func formAddition(
    of other: simd_float4x2,
    multipliedBy scalar: Scalar) {
    self += other * scalar
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func subtracting(_ other: simd_float4x2) -> simd_float4x2 {
    return self - other
  }
  
  // we supply:
  @inlinable
  public mutating func formSubtraction(of other: simd_float4x2) {
    self -= other
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Scalar
  // ------------------------------------------------------------------------ //
  
  // defaults should supply:
  // func subtracting(scalar: Scalar) -> Self
  
  // defaults should supply:
  // mutating func formSubtraction(ofScalar scalar: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func subtracting(
    _ other: simd_float4x2,
    multipliedBy scalar: Scalar) -> simd_float4x2 {
    return self - (other * scalar)
  }
  
  @inlinable
  public mutating func formSubtraction(
    of other: simd_float4x2,
    multipliedBy scalar: Scalar) {
    self -= (other * scalar)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(by scalar: Scalar) -> simd_float4x2 {
    return self * scalar
  }
  
  // we supply:
  @inlinable
  public mutating func formMultiplication(by scalar: Scalar) {
    self *= scalar
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func divided(by scalar: Scalar) -> simd_float4x2 {
    // let built-in handle the != 0.0 precondition!
    return self * (1.0/scalar)
  }
  
  // we supply:
  @inlinable
  public mutating func formDivision(by scalar: Scalar) {
    // let built-in handle the != 0.0 precondition!
    self *= (1.0/scalar)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
    return columnVector * self
  }
  
  // we supply:
  @inlinable
  public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
    return self * rowVector
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Compatible Matrix Types
  // ------------------------------------------------------------------------ //
  
  public typealias CompatibleMatrix4x4 = simd_float4x4
  public typealias CompatibleMatrix2x2 = simd_float2x2
  public typealias CompatibleMatrix2x3 = simd_float2x3
  public typealias CompatibleMatrix3x2 = simd_float3x2
  public typealias CompatibleMatrix2x4 = simd_float2x4
  public typealias CompatibleMatrix3x4 = simd_float3x4
  public typealias CompatibleMatrix4x3 = simd_float4x3

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  // should already exist:
  // init(
  // _ c0: ColumnVector,
  // _ c1: ColumnVector,
  // _ c2: ColumnVector,
  // _ c3: ColumnVector)
  
  
  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func transposed() -> simd_float2x4 {
    return self.transpose
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Right-Hand Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x2 {
    return self * rhs
  }
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x2 {
    return self * rhs
  }
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x4) -> simd_float4x2 {
    return self * rhs
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy rhs: CompatibleMatrix4x4) {
    self = self * rhs
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Left-Hand Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x2) -> simd_float4x2 {
    return lhs * self
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: CompatibleMatrix2x2) {
    self = lhs * self
  }
  
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x4) -> CompatibleMatrix4x4 {
    return lhs * self
  }
  
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x3) -> CompatibleMatrix4x3 {
    return lhs * self
  }

}
