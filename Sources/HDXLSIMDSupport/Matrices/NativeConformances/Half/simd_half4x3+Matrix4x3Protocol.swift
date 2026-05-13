//
//  simd_half4x3+Matrix4x3Protocol.swift
//

import Foundation
import simd

// `simd_half4x3` is a 4-column, 3-row matrix whose columns are
// `SIMD3<Float16>`. The Swift overlay (as of macOS 26) miscomputes the return
// values of C-level `simd_*` operations that produce any `simd_halfNx3`, so
// every matrix-returning operation that lands on a half3-row shape is
// implemented in pure Swift below. Operations whose result is a scalar,
// bool, vector, or a non-half3-row matrix (e.g. `transpose -> simd_half3x4`)
// still route through the C functions, which work correctly.

extension simd_half4x3 : MatrixDefaultSupportProtocol, Matrix4x3Protocol {

  public typealias Scalar = Float16

  public typealias RowVector = SIMD4<Scalar>
  public typealias ColumnVector = SIMD3<Scalar>
  public typealias DiagonalVector = SIMD3<Scalar>

  public typealias Columns = T4<ColumnVector>
  public typealias Rows = T3<RowVector>

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
        ColumnVector(diagonal.x, 0, 0),
        ColumnVector(0, diagonal.y, 0),
        ColumnVector(0, 0, diagonal.z),
        ColumnVector(0, 0, 0)
      )
    )
  }

  @inlinable
  public init(
    _ c0: ColumnVector,
    _ c1: ColumnVector,
    _ c2: ColumnVector,
    _ c3: ColumnVector
  ) {
    self.init(columns: (c0, c1, c2, c3))
  }

  @inlinable
  public init(columnVectors: [ColumnVector]) {
    precondition(columnVectors.count == Self.columnCount)
    self.init(
      columns: (
        columnVectors[0],
        columnVectors[1],
        columnVectors[2],
        columnVectors[3]
      )
    )
  }

  @inlinable
  public init(rowVectors: [RowVector]) {
    precondition(rowVectors.count == Self.rowCount)
    self.init(rows: (rowVectors[0], rowVectors[1], rowVectors[2]))
  }

  @inlinable
  public init(linearizedScalars: [Scalar]) {
    precondition(linearizedScalars.count == Self.scalarCount)
    self.init(
      columnVectors: simd_half4x3.columnVectors(
        forLinearizedScalars: linearizedScalars
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //

  @inlinable
  public static func linearCombination(
    of first: simd_half4x3,
    weight firstWeight: Scalar,
    with other: simd_half4x3,
    weight otherWeight: Scalar
  ) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        first.columns.0 * firstWeight + other.columns.0 * otherWeight,
        first.columns.1 * firstWeight + other.columns.1 * otherWeight,
        first.columns.2 * firstWeight + other.columns.2 * otherWeight,
        first.columns.3 * firstWeight + other.columns.3 * otherWeight
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //

  @inlinable
  public subscript(rowIndex rowIndex: Int) -> RowVector {
    get {
      precondition(simd_half4x3.rowIndexRange.contains(rowIndex))
      return RowVector(
        columns.0[rowIndex],
        columns.1[rowIndex],
        columns.2[rowIndex],
        columns.3[rowIndex]
      )
    }
    set {
      precondition(simd_half4x3.rowIndexRange.contains(rowIndex))
      columns.0[rowIndex] = newValue[0]
      columns.1[rowIndex] = newValue[1]
      columns.2[rowIndex] = newValue[2]
      columns.3[rowIndex] = newValue[3]
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //

  public static let matrixPositions: [MatrixPosition] = simd_half4x3.prepareMatrixPositionList()

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //

  @inlinable
  public var rows: Rows {
    get {
      return (
        RowVector(columns.0[0], columns.1[0], columns.2[0], columns.3[0]),
        RowVector(columns.0[1], columns.1[1], columns.2[1], columns.3[1]),
        RowVector(columns.0[2], columns.1[2], columns.2[2], columns.3[2])
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half4x3,
    absoluteTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements(self, other, tolerance)
  }

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half4x3,
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
        +
        simd_length_squared(columns.3)
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //

  @inlinable
  public func negated() -> simd_half4x3 {
    return simd_half4x3(columns: (-columns.0, -columns.1, -columns.2, -columns.3))
  }

  @inlinable
  public mutating func formNegation() {
    columns = (-columns.0, -columns.1, -columns.2, -columns.3)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(_ other: simd_half4x3) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        columns.0 + other.columns.0,
        columns.1 + other.columns.1,
        columns.2 + other.columns.2,
        columns.3 + other.columns.3
      )
    )
  }

  @inlinable
  public mutating func formAddition(of other: simd_half4x3) {
    columns = (
      columns.0 + other.columns.0,
      columns.1 + other.columns.1,
      columns.2 + other.columns.2,
      columns.3 + other.columns.3
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(
    _ other: simd_half4x3,
    multipliedBy scalar: Scalar
  ) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        columns.0 + other.columns.0 * scalar,
        columns.1 + other.columns.1 * scalar,
        columns.2 + other.columns.2 * scalar,
        columns.3 + other.columns.3 * scalar
      )
    )
  }

  @inlinable
  public mutating func formAddition(
    of other: simd_half4x3,
    multipliedBy scalar: Scalar
  ) {
    columns = (
      columns.0 + other.columns.0 * scalar,
      columns.1 + other.columns.1 * scalar,
      columns.2 + other.columns.2 * scalar,
      columns.3 + other.columns.3 * scalar
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(_ other: simd_half4x3) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        columns.0 - other.columns.0,
        columns.1 - other.columns.1,
        columns.2 - other.columns.2,
        columns.3 - other.columns.3
      )
    )
  }

  @inlinable
  public mutating func formSubtraction(of other: simd_half4x3) {
    columns = (
      columns.0 - other.columns.0,
      columns.1 - other.columns.1,
      columns.2 - other.columns.2,
      columns.3 - other.columns.3
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(
    _ other: simd_half4x3,
    multipliedBy scalar: Scalar
  ) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        columns.0 - other.columns.0 * scalar,
        columns.1 - other.columns.1 * scalar,
        columns.2 - other.columns.2 * scalar,
        columns.3 - other.columns.3 * scalar
      )
    )
  }

  @inlinable
  public mutating func formSubtraction(
    of other: simd_half4x3,
    multipliedBy scalar: Scalar
  ) {
    columns = (
      columns.0 - other.columns.0 * scalar,
      columns.1 - other.columns.1 * scalar,
      columns.2 - other.columns.2 * scalar,
      columns.3 - other.columns.3 * scalar
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(by scalar: Scalar) -> simd_half4x3 {
    return simd_half4x3(
      columns: (
        columns.0 * scalar,
        columns.1 * scalar,
        columns.2 * scalar,
        columns.3 * scalar
      )
    )
  }

  @inlinable
  public mutating func formMultiplication(by scalar: Scalar) {
    columns = (
      columns.0 * scalar,
      columns.1 * scalar,
      columns.2 * scalar,
      columns.3 * scalar
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(by scalar: Scalar) -> simd_half4x3 {
    let inv = (1 as Scalar) / scalar
    return simd_half4x3(
      columns: (
        columns.0 * inv,
        columns.1 * inv,
        columns.2 * inv,
        columns.3 * inv
      )
    )
  }

  @inlinable
  public mutating func formDivision(by scalar: Scalar) {
    let inv = (1 as Scalar) / scalar
    columns = (
      columns.0 * inv,
      columns.1 * inv,
      columns.2 * inv,
      columns.3 * inv
    )
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

  public typealias CompatibleMatrix4x4 = simd_half4x4
  public typealias CompatibleMatrix3x3 = simd_half3x3
  public typealias CompatibleMatrix2x3 = simd_half2x3
  public typealias CompatibleMatrix3x2 = simd_half3x2
  public typealias CompatibleMatrix2x4 = simd_half2x4
  public typealias CompatibleMatrix4x2 = simd_half4x2
  public typealias CompatibleMatrix3x4 = simd_half3x4

  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //

  // Result is `simd_half3x4` (SIMD4 columns), so the C function works.
  @inlinable
  public func transposed() -> simd_half3x4 {
    return simd_transpose(self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Right-Hand Multiplication
  // ------------------------------------------------------------------------ //

  // self (4x3) * rhs (2x4) -> 2x3 (broken): column-wise.
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    let s3 = columns.3
    let r0 = rhs.columns.0
    let r1 = rhs.columns.1
    let rc0_a: SIMD3<Scalar> = s0 * r0[0] + s1 * r0[1]
    let rc0_b: SIMD3<Scalar> = s2 * r0[2] + s3 * r0[3]
    let rc1_a: SIMD3<Scalar> = s0 * r1[0] + s1 * r1[1]
    let rc1_b: SIMD3<Scalar> = s2 * r1[2] + s3 * r1[3]
    return CompatibleMatrix2x3(columns: (rc0_a + rc0_b, rc1_a + rc1_b))
  }

  // self (4x3) * rhs (3x4) -> 3x3 (broken): column-wise.
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    let s3 = columns.3
    let r0 = rhs.columns.0
    let r1 = rhs.columns.1
    let r2 = rhs.columns.2
    let rc0_a: SIMD3<Scalar> = s0 * r0[0] + s1 * r0[1]
    let rc0_b: SIMD3<Scalar> = s2 * r0[2] + s3 * r0[3]
    let rc1_a: SIMD3<Scalar> = s0 * r1[0] + s1 * r1[1]
    let rc1_b: SIMD3<Scalar> = s2 * r1[2] + s3 * r1[3]
    let rc2_a: SIMD3<Scalar> = s0 * r2[0] + s1 * r2[1]
    let rc2_b: SIMD3<Scalar> = s2 * r2[2] + s3 * r2[3]
    return CompatibleMatrix3x3(
      columns: (rc0_a + rc0_b, rc1_a + rc1_b, rc2_a + rc2_b)
    )
  }

  // self (4x3) * rhs (4x4) -> Self (half4x3, broken): column-wise.
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x4) -> simd_half4x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    let s3 = columns.3
    let r0 = rhs.columns.0
    let r1 = rhs.columns.1
    let r2 = rhs.columns.2
    let r3 = rhs.columns.3
    let rc0_a: SIMD3<Scalar> = s0 * r0[0] + s1 * r0[1]
    let rc0_b: SIMD3<Scalar> = s2 * r0[2] + s3 * r0[3]
    let rc1_a: SIMD3<Scalar> = s0 * r1[0] + s1 * r1[1]
    let rc1_b: SIMD3<Scalar> = s2 * r1[2] + s3 * r1[3]
    let rc2_a: SIMD3<Scalar> = s0 * r2[0] + s1 * r2[1]
    let rc2_b: SIMD3<Scalar> = s2 * r2[2] + s3 * r2[3]
    let rc3_a: SIMD3<Scalar> = s0 * r3[0] + s1 * r3[1]
    let rc3_b: SIMD3<Scalar> = s2 * r3[2] + s3 * r3[3]
    return simd_half4x3(
      columns: (
        rc0_a + rc0_b,
        rc1_a + rc1_b,
        rc2_a + rc2_b,
        rc3_a + rc3_b
      )
    )
  }

  @inlinable
  public mutating func formMultiplication(onRightBy rhs: CompatibleMatrix4x4) {
    self = multiplied(onRightBy: rhs)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Left-Hand Multiplication
  // ------------------------------------------------------------------------ //

  // lhs (3x2) * self (4x3) -> 4x2 (SIMD2 cols, OK).
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix3x2) -> CompatibleMatrix4x2 {
    return simd_mul(lhs, self)
  }

  // lhs (3x3) * self (4x3) -> Self (half4x3, broken): column-wise.
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix3x3) -> simd_half4x3 {
    let l0 = lhs.columns.0
    let l1 = lhs.columns.1
    let l2 = lhs.columns.2
    return simd_half4x3(
      columns: (
        l0 * columns.0[0] + l1 * columns.0[1] + l2 * columns.0[2],
        l0 * columns.1[0] + l1 * columns.1[1] + l2 * columns.1[2],
        l0 * columns.2[0] + l1 * columns.2[1] + l2 * columns.2[2],
        l0 * columns.3[0] + l1 * columns.3[1] + l2 * columns.3[2]
      )
    )
  }

  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: CompatibleMatrix3x3) {
    self = multiplied(onLeftBy: lhs)
  }

  // lhs (3x4) * self (4x3) -> 4x4 (SIMD4 cols, OK).
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix3x4) -> CompatibleMatrix4x4 {
    return simd_mul(lhs, self)
  }

}
