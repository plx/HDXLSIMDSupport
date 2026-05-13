//
//  simd_half3x2+Matrix3x2Protocol.swift
//

import Foundation
import simd

extension simd_half3x2 : MatrixDefaultSupportProtocol, Matrix3x2Protocol {

  public typealias Scalar = Float16

  public typealias RowVector = SIMD3<Scalar>
  public typealias ColumnVector = SIMD2<Scalar>
  public typealias DiagonalVector = SIMD2<Scalar>

  public typealias Columns = T3<ColumnVector>
  public typealias Rows = T2<RowVector>

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  @inlinable
  public init(repeating scalar: Scalar) {
    self.init(diagonal: DiagonalVector(repeating: scalar))
  }

  @inlinable
  public init(diagonal: DiagonalVector) {
    self.init(
      columns: (
        ColumnVector(diagonal.x, 0),
        ColumnVector(0, diagonal.y),
        ColumnVector(0, 0)
      )
    )
  }

  @inlinable
  public init(
    _ c0: ColumnVector,
    _ c1: ColumnVector,
    _ c2: ColumnVector
  ) {
    self.init(columns: (c0, c1, c2))
  }

  @inlinable
  public init(columnVectors: [ColumnVector]) {
    precondition(columnVectors.count == Self.columnCount)
    self.init(
      columns: (
        columnVectors[0],
        columnVectors[1],
        columnVectors[2]
      )
    )
  }

  @inlinable
  public init(rowVectors: [RowVector]) {
    precondition(rowVectors.count == Self.rowCount)
    self.init(rows: (rowVectors[0], rowVectors[1]))
  }

  @inlinable
  public init(linearizedScalars: [Scalar]) {
    precondition(linearizedScalars.count == Self.scalarCount)
    self.init(
      columnVectors: simd_half3x2.columnVectors(
        forLinearizedScalars: linearizedScalars
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //

  @inlinable
  public static func linearCombination(
    of first: simd_half3x2,
    weight firstWeight: Scalar,
    with other: simd_half3x2,
    weight otherWeight: Scalar
  ) -> simd_half3x2 {
    return simd_linear_combination(
      firstWeight,
      first,
      otherWeight,
      other
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //

  @inlinable
  public subscript(rowIndex rowIndex: Int) -> RowVector {
    get {
      precondition(simd_half3x2.rowIndexRange.contains(rowIndex))
      return RowVector(
        columns.0[rowIndex],
        columns.1[rowIndex],
        columns.2[rowIndex]
      )
    }
    set {
      precondition(simd_half3x2.rowIndexRange.contains(rowIndex))
      columns.0[rowIndex] = newValue[0]
      columns.1[rowIndex] = newValue[1]
      columns.2[rowIndex] = newValue[2]
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //

  public static let matrixPositions: [MatrixPosition] = simd_half3x2.prepareMatrixPositionList()

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //

  @inlinable
  public var rows: Rows {
    get {
      return (
        RowVector(columns.0[0], columns.1[0], columns.2[0]),
        RowVector(columns.0[1], columns.1[1], columns.2[1])
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half3x2,
    absoluteTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements(self, other, tolerance)
  }

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half3x2,
    relativeTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements_relative(self, other, tolerance)
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
        +
        simd_length_squared(columns.2)
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //

  @inlinable
  public func negated() -> simd_half3x2 {
    return simd_mul((-1) as Scalar, self)
  }

  @inlinable
  public mutating func formNegation() {
    self = simd_mul((-1) as Scalar, self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(_ other: simd_half3x2) -> simd_half3x2 {
    return simd_add(self, other)
  }

  @inlinable
  public mutating func formAddition(of other: simd_half3x2) {
    self = simd_add(self, other)
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(
    _ other: simd_half3x2,
    multipliedBy scalar: Scalar
  ) -> simd_half3x2 {
    return simd_add(self, simd_mul(scalar, other))
  }

  @inlinable
  public mutating func formAddition(
    of other: simd_half3x2,
    multipliedBy scalar: Scalar
  ) {
    self = simd_add(self, simd_mul(scalar, other))
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(_ other: simd_half3x2) -> simd_half3x2 {
    return simd_sub(self, other)
  }

  @inlinable
  public mutating func formSubtraction(of other: simd_half3x2) {
    self = simd_sub(self, other)
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(
    _ other: simd_half3x2,
    multipliedBy scalar: Scalar
  ) -> simd_half3x2 {
    return simd_sub(self, simd_mul(scalar, other))
  }

  @inlinable
  public mutating func formSubtraction(
    of other: simd_half3x2,
    multipliedBy scalar: Scalar
  ) {
    self = simd_sub(self, simd_mul(scalar, other))
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(by scalar: Scalar) -> simd_half3x2 {
    return simd_mul(scalar, self)
  }

  @inlinable
  public mutating func formMultiplication(by scalar: Scalar) {
    self = simd_mul(scalar, self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(by scalar: Scalar) -> simd_half3x2 {
    return simd_mul((1 as Scalar) / scalar, self)
  }

  @inlinable
  public mutating func formDivision(by scalar: Scalar) {
    self = simd_mul((1 as Scalar) / scalar, self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Vector Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
    return simd_mul(columnVector, self)
  }

  @inlinable
  public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
    return simd_mul(self, rowVector)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Compatible Matrix Types
  // ------------------------------------------------------------------------ //

  public typealias CompatibleMatrix2x2 = simd_half2x2
  public typealias CompatibleMatrix3x3 = simd_half3x3
  public typealias CompatibleMatrix2x3 = simd_half2x3
  public typealias CompatibleMatrix2x4 = simd_half2x4
  public typealias CompatibleMatrix4x2 = simd_half4x2
  public typealias CompatibleMatrix3x4 = simd_half3x4
  public typealias CompatibleMatrix4x3 = simd_half4x3

  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //

  // `simd_transpose(simd_half3x2) -> simd_half2x3`: result is a half3-row
  // shape; build it column-by-column.
  @inlinable
  public func transposed() -> simd_half2x3 {
    return simd_half2x3(
      columns: (
        SIMD3<Scalar>(columns.0[0], columns.1[0], columns.2[0]),
        SIMD3<Scalar>(columns.0[1], columns.1[1], columns.2[1])
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Right-Hand Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x2 {
    return simd_mul(self, rhs)
  }

  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x3) -> simd_half3x2 {
    // `simd_mul(simd_half3x2, simd_half3x3) -> simd_half3x2`: output is
    // half3x2 (SIMD2 columns), not a half3-row shape, so the C function is
    // usable directly.
    return simd_mul(self, rhs)
  }

  @inlinable
  public mutating func formMultiplication(onRightBy rhs: CompatibleMatrix3x3) {
    self = simd_mul(self, rhs)
  }

  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x2 {
    return simd_mul(self, rhs)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Left-Hand Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x2) -> simd_half3x2 {
    return simd_mul(lhs, self)
  }

  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: CompatibleMatrix2x2) {
    self = simd_mul(lhs, self)
  }

  // `simd_mul(simd_half2x3, simd_half3x2) -> simd_half3x3`: the result is a
  // half3-row shape, which the Swift overlay miscomputes. Build the product
  // column-by-column from the individual SIMD3<Float16> columns.
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x3) -> CompatibleMatrix3x3 {
    let l0 = lhs.columns.0
    let l1 = lhs.columns.1
    return CompatibleMatrix3x3(
      columns: (
        l0 * columns.0[0] + l1 * columns.0[1],
        l0 * columns.1[0] + l1 * columns.1[1],
        l0 * columns.2[0] + l1 * columns.2[1]
      )
    )
  }

  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix2x4) -> CompatibleMatrix3x4 {
    return simd_mul(lhs, self)
  }

}
