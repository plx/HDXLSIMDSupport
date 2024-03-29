//
//  simd_float2x2+Matrix2x2Protocol.swift
//

import Foundation
import simd

extension simd_float2x2 : MatrixDefaultSupportProtocol, Matrix2x2Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar
  // ------------------------------------------------------------------------ //
  
  public typealias Scalar = Float
  
  // ------------------------------------------------------------------------ //
  // MARK: Vectors
  // ------------------------------------------------------------------------ //
  
  public typealias ColumnVector = SIMD2<Scalar>
  public typealias RowVector = SIMD2<Scalar>
  public typealias DiagonalVector = SIMD2<Scalar>
  
  // ------------------------------------------------------------------------ //
  // MARK: Components
  // ------------------------------------------------------------------------ //
  
  public typealias Columns = T2<ColumnVector>
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
      columnVectors: simd_float2x2.columnVectors(
        forLinearizedScalars: linearizedScalars
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static func linearCombination(
    of first: simd_float2x2,
    weight firstWeight: Scalar,
    with other: simd_float2x2,
    weight otherWeight: Scalar
  ) -> simd_float2x2 {
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
      precondition(simd_float2x2.rowIndexRange.contains(rowIndex))
      return RowVector(
        columns.0[rowIndex],
        columns.1[rowIndex]
      )
    }
    set {
      precondition(simd_float2x2.rowIndexRange.contains(rowIndex))
      columns.0[rowIndex] = newValue[0]
      columns.1[rowIndex] = newValue[1]
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
  public static let matrixPositions: [MatrixPosition] = simd_float2x2.prepareMatrixPositionList()
  
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
          columns.0[0],
          columns.1[0]
        ),
        RowVector(
          columns.0[1],
          columns.1[1]
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
    to other: simd_float2x2,
    absoluteTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements(
      self,
      other,
      tolerance
    )
  }
  
  // we supply:
  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_float2x2,
    relativeTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements_relative(
      self,
      other,
      tolerance
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Norms
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public var componentwiseMagnitudeSquared: Scalar {
    get {
      return (
        simd_length_squared(columns.0)
        +
        simd_length_squared(columns.1)
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func negated() -> simd_float2x2 {
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
  public func adding(_ other: simd_float2x2) -> simd_float2x2 {
    return self + other
  }
  
  // we supply:
  @inlinable
  public mutating func formAddition(of other: simd_float2x2) {
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
    _ other: simd_float2x2,
    multipliedBy scalar: Scalar
  ) -> simd_float2x2 {
    return self + (other * scalar)
  }
  
  // we supply:
  @inlinable
  public mutating func formAddition(
    of other: simd_float2x2,
    multipliedBy scalar: Scalar
  ) {
    self += other * scalar
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func subtracting(_ other: simd_float2x2) -> simd_float2x2 {
    return self - other
  }
  
  // we supply:
  @inlinable
  public mutating func formSubtraction(of other: simd_float2x2) {
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
    _ other: simd_float2x2,
    multipliedBy scalar: Scalar
  ) -> simd_float2x2 {
    return self - (other * scalar)
  }
  
  @inlinable
  public mutating func formSubtraction(
    of other: simd_float2x2,
    multipliedBy scalar: Scalar
  ) {
    self -= (other * scalar)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(by scalar: Scalar) -> simd_float2x2 {
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
  public func divided(by scalar: Scalar) -> simd_float2x2 {
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
  
  public typealias CompatibleQuaternion = simd_quatd
  public typealias CompatibleMatrix2x3 = simd_float2x3
  public typealias CompatibleMatrix3x2 = simd_float3x2
  public typealias CompatibleMatrix2x4 = simd_float2x4
  public typealias CompatibleMatrix4x2 = simd_float4x2
  
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
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //
  
  // should already exist
  // var determinant: Scalar { get }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func inverted() -> simd_float2x2 {
    return self.inverse
  }
  
  // we supply:
  @inlinable
  public mutating func formInverse() {
    self = self.inverse
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(onRightBy rhs: simd_float2x2) -> simd_float2x2 {
    return self * rhs
  }
  
  // we supply:
  @inlinable
  public func multiplied(onLeftBy lhs: simd_float2x2) -> simd_float2x2 {
    return lhs * self
  }
  
  // we supply:
  @inlinable
  public mutating func formMultiplication(onRightBy rhs: simd_float2x2) {
    self = self * rhs
  }
  
  // we supply:
  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: simd_float2x2) {
    self = lhs * self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func divided(onRightBy rhs: simd_float2x2) -> simd_float2x2 {
    return self * rhs.inverse
  }
  
  // we supply:
  @inlinable
  public func divided(onLeftBy lhs: simd_float2x2) -> simd_float2x2 {
    return lhs.inverse * self
  }
  
  // we supply:
  @inlinable
  public mutating func formDivision(onRightBy rhs: simd_float2x2) {
    self = self * rhs.inverse
  }
  
  // we supply:
  @inlinable
  public mutating func formDivision(onLeftBy lhs: simd_float2x2) {
    self = lhs.inverse * self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func transposed() -> simd_float2x2 {
    return self.transpose
  }
  
  // we supply:
  @inlinable
  public mutating func formTranspose() {
    self = self.transpose
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Right Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    return self * rhs
  }
  
  // we supply:
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x2 {
    return self * rhs
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Left Multiplication
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    return lhs * self
  }
  
  // we supply:
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x4) -> CompatibleMatrix2x4 {
    return lhs * self
  }
  
}
