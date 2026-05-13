//
//  simd_half3x3+Matrix3x3Protocol.swift
//

import Foundation
import simd

// `simd_half3x3` is a 3-column, 3-row matrix whose columns are
// `SIMD3<Float16>`. The Swift overlay (as of macOS 26) miscomputes the return
// values of C-level `simd_*` operations that produce any `simd_halfNx3`, so
// every matrix-returning operation that lands on a half3-row shape is
// implemented in pure Swift below. Operations whose result is a scalar,
// bool, vector, or a non-half3-row matrix still route through the C
// functions, which work correctly.

extension simd_half3x3 : MatrixDefaultSupportProtocol, Matrix3x3Protocol {

  public typealias Scalar = Float16

  public typealias ColumnVector = SIMD3<Scalar>
  public typealias RowVector = SIMD3<Scalar>
  public typealias DiagonalVector = SIMD3<Scalar>

  public typealias Columns = T3<ColumnVector>
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
        ColumnVector(0, 0, diagonal.z)
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
    self.init(columns: (columnVectors[0], columnVectors[1], columnVectors[2]))
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
      columnVectors: simd_half3x3.columnVectors(
        forLinearizedScalars: linearizedScalars
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Linear Combinations
  // ------------------------------------------------------------------------ //

  @inlinable
  public static func linearCombination(
    of first: simd_half3x3,
    weight firstWeight: Scalar,
    with other: simd_half3x3,
    weight otherWeight: Scalar
  ) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        first.columns.0 * firstWeight + other.columns.0 * otherWeight,
        first.columns.1 * firstWeight + other.columns.1 * otherWeight,
        first.columns.2 * firstWeight + other.columns.2 * otherWeight
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //

  @inlinable
  public subscript(rowIndex rowIndex: Int) -> RowVector {
    get {
      precondition(simd_half3x3.rowIndexRange.contains(rowIndex))
      return RowVector(
        columns.0[rowIndex],
        columns.1[rowIndex],
        columns.2[rowIndex]
      )
    }
    set {
      precondition(simd_half3x3.rowIndexRange.contains(rowIndex))
      columns.0[rowIndex] = newValue[0]
      columns.1[rowIndex] = newValue[1]
      columns.2[rowIndex] = newValue[2]
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //

  public static let matrixPositions: [MatrixPosition] = simd_half3x3.prepareMatrixPositionList()

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //

  @inlinable
  public var rows: Rows {
    get {
      return (
        RowVector(columns.0[0], columns.1[0], columns.2[0]),
        RowVector(columns.0[1], columns.1[1], columns.2[1]),
        RowVector(columns.0[2], columns.1[2], columns.2[2])
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half3x3,
    absoluteTolerance tolerance: Scalar
  ) -> Bool {
    return simd_almost_equal_elements(self, other, tolerance)
  }

  @inlinable
  public func hasAlmostEqualElements(
    to other: simd_half3x3,
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
  public func negated() -> simd_half3x3 {
    return simd_half3x3(columns: (-columns.0, -columns.1, -columns.2))
  }

  @inlinable
  public mutating func formNegation() {
    columns = (-columns.0, -columns.1, -columns.2)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(_ other: simd_half3x3) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        columns.0 + other.columns.0,
        columns.1 + other.columns.1,
        columns.2 + other.columns.2
      )
    )
  }

  @inlinable
  public mutating func formAddition(of other: simd_half3x3) {
    columns = (
      columns.0 + other.columns.0,
      columns.1 + other.columns.1,
      columns.2 + other.columns.2
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(
    _ other: simd_half3x3,
    multipliedBy scalar: Scalar
  ) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        columns.0 + other.columns.0 * scalar,
        columns.1 + other.columns.1 * scalar,
        columns.2 + other.columns.2 * scalar
      )
    )
  }

  @inlinable
  public mutating func formAddition(
    of other: simd_half3x3,
    multipliedBy scalar: Scalar
  ) {
    columns = (
      columns.0 + other.columns.0 * scalar,
      columns.1 + other.columns.1 * scalar,
      columns.2 + other.columns.2 * scalar
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(_ other: simd_half3x3) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        columns.0 - other.columns.0,
        columns.1 - other.columns.1,
        columns.2 - other.columns.2
      )
    )
  }

  @inlinable
  public mutating func formSubtraction(of other: simd_half3x3) {
    columns = (
      columns.0 - other.columns.0,
      columns.1 - other.columns.1,
      columns.2 - other.columns.2
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(
    _ other: simd_half3x3,
    multipliedBy scalar: Scalar
  ) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        columns.0 - other.columns.0 * scalar,
        columns.1 - other.columns.1 * scalar,
        columns.2 - other.columns.2 * scalar
      )
    )
  }

  @inlinable
  public mutating func formSubtraction(
    of other: simd_half3x3,
    multipliedBy scalar: Scalar
  ) {
    columns = (
      columns.0 - other.columns.0 * scalar,
      columns.1 - other.columns.1 * scalar,
      columns.2 - other.columns.2 * scalar
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(by scalar: Scalar) -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        columns.0 * scalar,
        columns.1 * scalar,
        columns.2 * scalar
      )
    )
  }

  @inlinable
  public mutating func formMultiplication(by scalar: Scalar) {
    columns = (columns.0 * scalar, columns.1 * scalar, columns.2 * scalar)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(by scalar: Scalar) -> simd_half3x3 {
    let inv = (1 as Scalar) / scalar
    return simd_half3x3(
      columns: (
        columns.0 * inv,
        columns.1 * inv,
        columns.2 * inv
      )
    )
  }

  @inlinable
  public mutating func formDivision(by scalar: Scalar) {
    let inv = (1 as Scalar) / scalar
    columns = (columns.0 * inv, columns.1 * inv, columns.2 * inv)
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

  public typealias CompatibleQuaternion = simd_quath
  public typealias CompatibleMatrix2x3 = simd_half2x3
  public typealias CompatibleMatrix3x2 = simd_half3x2
  public typealias CompatibleMatrix3x4 = simd_half3x4
  public typealias CompatibleMatrix4x3 = simd_half4x3

  // ------------------------------------------------------------------------ //
  // MARK: Initialization From Quaternion
  // ------------------------------------------------------------------------ //

  // `simd_matrix3x3(simd_quath)` is buggy in macOS 26 (columns are scrambled
  // when the result crosses the Swift overlay). The 4x4 form is correct, so
  // we obtain the rotation matrix from `simd_matrix4x4` and extract its
  // upper-left 3x3 submatrix.
  @inlinable
  public init(quaternion: CompatibleQuaternion) {
    let m4 = simd_matrix4x4(quaternion)
    self.init(
      columns: (
        SIMD3<Scalar>(m4.columns.0.x, m4.columns.0.y, m4.columns.0.z),
        SIMD3<Scalar>(m4.columns.1.x, m4.columns.1.y, m4.columns.1.z),
        SIMD3<Scalar>(m4.columns.2.x, m4.columns.2.y, m4.columns.2.z)
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //

  @inlinable
  public var determinant: Scalar {
    get {
      return simd_determinant(self)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //

  // Compute the inverse via the cross-product formula:
  // ```
  //   M^-1 = (1/det) · | (c1 × c2)^T |
  //                    | (c2 × c0)^T |
  //                    | (c0 × c1)^T |
  // ```
  // where `c0`/`c1`/`c2` are the columns of M. We can't use
  // `simd_inverse(simd_half3x3)` because the return crosses the broken
  // half3-row Swift bridge.
  @inlinable
  public func inverted() -> simd_half3x3 {
    let c0 = columns.0
    let c1 = columns.1
    let c2 = columns.2
    let det = simd_determinant(self)
    let invDet = (1 as Scalar) / det
    let r0 = simd_cross(c1, c2)
    let r1 = simd_cross(c2, c0)
    let r2 = simd_cross(c0, c1)
    return simd_half3x3(
      columns: (
        SIMD3<Scalar>(r0[0], r1[0], r2[0]) * invDet,
        SIMD3<Scalar>(r0[1], r1[1], r2[1]) * invDet,
        SIMD3<Scalar>(r0[2], r1[2], r2[2]) * invDet
      )
    )
  }

  @inlinable
  public mutating func formInverse() {
    self = inverted()
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //

  // self * rhs: build the product column-by-column from the columns of self.
  @inlinable
  public func multiplied(onRightBy rhs: simd_half3x3) -> simd_half3x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    return simd_half3x3(
      columns: (
        s0 * rhs.columns.0[0] + s1 * rhs.columns.0[1] + s2 * rhs.columns.0[2],
        s0 * rhs.columns.1[0] + s1 * rhs.columns.1[1] + s2 * rhs.columns.1[2],
        s0 * rhs.columns.2[0] + s1 * rhs.columns.2[1] + s2 * rhs.columns.2[2]
      )
    )
  }

  @inlinable
  public func multiplied(onLeftBy lhs: simd_half3x3) -> simd_half3x3 {
    return lhs.multiplied(onRightBy: self)
  }

  @inlinable
  public mutating func formMultiplication(onRightBy rhs: simd_half3x3) {
    self = multiplied(onRightBy: rhs)
  }

  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: simd_half3x3) {
    self = lhs.multiplied(onRightBy: self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(onRightBy rhs: simd_half3x3) -> simd_half3x3 {
    return multiplied(onRightBy: rhs.inverted())
  }

  @inlinable
  public func divided(onLeftBy lhs: simd_half3x3) -> simd_half3x3 {
    return lhs.inverted().multiplied(onRightBy: self)
  }

  @inlinable
  public mutating func formDivision(onRightBy rhs: simd_half3x3) {
    self = divided(onRightBy: rhs)
  }

  @inlinable
  public mutating func formDivision(onLeftBy lhs: simd_half3x3) {
    self = lhs.inverted().multiplied(onRightBy: self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //

  @inlinable
  public func transposed() -> simd_half3x3 {
    return simd_half3x3(
      columns: (
        SIMD3<Scalar>(columns.0[0], columns.1[0], columns.2[0]),
        SIMD3<Scalar>(columns.0[1], columns.1[1], columns.2[1]),
        SIMD3<Scalar>(columns.0[2], columns.1[2], columns.2[2])
      )
    )
  }

  @inlinable
  public mutating func formTranspose() {
    self = transposed()
  }

  // ------------------------------------------------------------------------ //
  // MARK: Right Multiplication
  // ------------------------------------------------------------------------ //

  // self (3x3) * rhs (2x3) -> 2x3 (broken): build column-wise.
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    return CompatibleMatrix2x3(
      columns: (
        s0 * rhs.columns.0[0] + s1 * rhs.columns.0[1] + s2 * rhs.columns.0[2],
        s0 * rhs.columns.1[0] + s1 * rhs.columns.1[1] + s2 * rhs.columns.1[2]
      )
    )
  }

  // self (3x3) * rhs (4x3) -> 4x3 (broken): build column-wise.
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3 {
    let s0 = columns.0
    let s1 = columns.1
    let s2 = columns.2
    return CompatibleMatrix4x3(
      columns: (
        s0 * rhs.columns.0[0] + s1 * rhs.columns.0[1] + s2 * rhs.columns.0[2],
        s0 * rhs.columns.1[0] + s1 * rhs.columns.1[1] + s2 * rhs.columns.1[2],
        s0 * rhs.columns.2[0] + s1 * rhs.columns.2[1] + s2 * rhs.columns.2[2],
        s0 * rhs.columns.3[0] + s1 * rhs.columns.3[1] + s2 * rhs.columns.3[2]
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Left Multiplication
  // ------------------------------------------------------------------------ //

  // lhs (3x2) * self (3x3) -> half3x2 (SIMD2 cols, OK).
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    return simd_mul(lhs, self)
  }

  // lhs (3x4) * self (3x3) -> half3x4 (SIMD4 cols, OK).
  @inlinable
  public func multiplied(onLeftBy lhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4 {
    return simd_mul(lhs, self)
  }

}
