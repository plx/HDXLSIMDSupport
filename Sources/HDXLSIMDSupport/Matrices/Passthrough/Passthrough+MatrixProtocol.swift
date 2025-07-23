import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough - MatrixProtocol Support
// ------------------------------------------------------------------------ //

extension Passthrough where Self: MatrixProtocol, PassthroughValue: MatrixProtocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Shape Parameters
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static var rowCount: Int {
    PassthroughValue.rowCount
  }
  
  @inlinable
  public static var rowLength: Int {
    PassthroughValue.rowLength
  }
  
  @inlinable
  public static var columnCount: Int {
    PassthroughValue.columnCount
  }
  
  @inlinable
  public static var columnLength: Int {
    PassthroughValue.columnLength
  }
  
  @inlinable
  public static var scalarCount: Int {
    PassthroughValue.scalarCount
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Shape Ranges
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static var rowIndexRange: Range<Int> {
    PassthroughValue.rowIndexRange
  }

  @inlinable
  public static var columnIndexRange: Range<Int> {
    PassthroughValue.columnIndexRange
  }

  @inlinable
  public static var linearizedScalarIndexRange: Range<Int> {
    PassthroughValue.linearizedScalarIndexRange
  }

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public init() {
    self.init(
      passthroughValue: PassthroughValue()
    )
  }
  
  @inlinable
  public init(repeating scalar: PassthroughValue.Scalar) {
    self.init(
      passthroughValue: PassthroughValue(
        repeating: scalar
      )
    )
  }
  
  @inlinable
  public init(diagonal: PassthroughValue.DiagonalVector) {
    self.init(
      passthroughValue: PassthroughValue(
        diagonal: diagonal
      )
    )
  }
  
  @inlinable
  public init(columns: PassthroughValue.Columns) {
    self.init(
      passthroughValue: PassthroughValue(
        columns: columns
      )
    )
  }
  
  @inlinable
  public init(columnVectors: [PassthroughValue.ColumnVector]) {
    self.init(
      passthroughValue: PassthroughValue(
        columnVectors: columnVectors
      )
    )
  }
  
  @inlinable
  public init(rows: PassthroughValue.Rows) {
    self.init(
      passthroughValue: PassthroughValue(
        rows: rows
      )
    )
  }
  
  @inlinable
  public init(rowVectors: [PassthroughValue.RowVector]) {
    self.init(
      passthroughValue: PassthroughValue(
        rowVectors: rowVectors
      )
    )
  }
  
  @inlinable
  public init(linearizedScalars: [PassthroughValue.Scalar]) {
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
  public static func linearCombination(
    of first: Self,
    weight firstWeight: PassthroughValue.Scalar,
    with other: Self,
    weight otherWeight: PassthroughValue.Scalar
  ) -> Self {
    Self(
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
  public subscript(columnIndex columnIndex: Int) -> PassthroughValue.ColumnVector {
    get {
      passthroughValue[columnIndex: columnIndex]
    }
    set {
      passthroughValue[columnIndex: columnIndex] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Rows
  // ------------------------------------------------------------------------ //
  

  @inlinable
  public subscript(rowIndex rowIndex: Int) -> PassthroughValue.RowVector {
    get {
      passthroughValue[rowIndex: rowIndex]
    }
    set {
      passthroughValue[rowIndex: rowIndex] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subscripting - Scalars
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> PassthroughValue.Scalar {
    get {
      passthroughValue[linearizedScalarIndex: linearizedScalarIndex]
    }
    set {
      passthroughValue[linearizedScalarIndex: linearizedScalarIndex] = newValue
    }
  }
  
  @inlinable
  public subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int
  ) -> PassthroughValue.Scalar {
    get {
      passthroughValue[columnIndex: columnIndex, rowIndex: rowIndex]
    }
    set {
      passthroughValue[columnIndex: columnIndex, rowIndex: rowIndex] = newValue
    }
    
  }
  
  @inlinable
  public subscript(position position: MatrixPosition) -> PassthroughValue.Scalar {
    get {
      passthroughValue[position: position]
    }
    set {
      passthroughValue[position: position] = newValue
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Position & Linearization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static func linearScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    PassthroughValue.linearizedScalarIndex(
      forMatrixPosition: matrixPosition
    )
  }
  
  @inlinable
  public static func linearizedScalarIndex(forColumnIndex columnIndex: Int, rowIndex: Int) -> Int {
    PassthroughValue.linearizedScalarIndex(
      forColumnIndex: columnIndex,
      rowIndex: rowIndex
    )
  }
  
  @inlinable
  public static func columnRowIndex(forLinearizedScalarIndex linearizedScalarIndex: Int) -> (Int, Int) {
    PassthroughValue.columnRowIndex(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
  }
  
  @inlinable
  public static func linearizedScalarIndex(forMatrixPosition matrixPosition: MatrixPosition) -> Int {
    PassthroughValue.linearizedScalarIndex(
      forMatrixPosition: matrixPosition
    )
  }

  @inlinable
  public static func matrixPosition(forLinearizedScalarIndex linearizedScalarIndex: Int) -> MatrixPosition {
    return PassthroughValue.matrixPosition(
      forLinearizedScalarIndex: linearizedScalarIndex
    )
  }
  
  @inlinable
  public static var matrixPositions: [MatrixPosition] {
    PassthroughValue.matrixPositions
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Linearized Scalars <=> Arrays
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public static func columnVectors(forLinearizedScalars linearizedScalars: [PassthroughValue.Scalar]) -> [PassthroughValue.ColumnVector] {
    PassthroughValue.columnVectors(
      forLinearizedScalars: linearizedScalars
    )
  }
  
  @inlinable
  public static func rowVectors(forLinearizedScalars linearizedScalars: [PassthroughValue.Scalar]) -> [PassthroughValue.RowVector] {
    PassthroughValue.rowVectors(
      forLinearizedScalars: linearizedScalars
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Bulk Properties
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public var columns: PassthroughValue.Columns {
    get {
      passthroughValue.columns
    }
    set {
      passthroughValue.columns = newValue
    }
  }

  @inlinable
  public var rows: PassthroughValue.Rows {
    passthroughValue.rows
  }

  @inlinable
  public var columnVectors: [PassthroughValue.ColumnVector] {
    passthroughValue.columnVectors
  }
  
  @inlinable
  public var rowVectors: [PassthroughValue.RowVector] {
    passthroughValue.rowVectors
  }
  
  @inlinable
  public var linearizedScalars: [PassthroughValue.Scalar] {
    passthroughValue.linearizedScalars
  }

  // ------------------------------------------------------------------------ //
  // MARK: Almost Equal Elements
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func hasAlmostEqualElements(
    to other: Self,
    absoluteTolerance tolerance: PassthroughValue.Scalar
  ) -> Bool {
    passthroughValue.hasAlmostEqualElements(
      to: other.passthroughValue,
      absoluteTolerance: tolerance
    )
  }

  @inlinable
  public func hasAlmostEqualElements(
    to other: Self,
    relativeTolerance tolerance: PassthroughValue.Scalar
  ) -> Bool {
    passthroughValue.hasAlmostEqualElements(
      to: other.passthroughValue,
      relativeTolerance: tolerance
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Norms
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public var componentwiseMagnitudeSquared: PassthroughValue.Scalar {
    passthroughValue.componentwiseMagnitudeSquared
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func negated() -> Self {
    Self(
      passthroughValue: passthroughValue.negated()
    )
  }
  
  @inlinable
  public mutating func formNegation() {
    passthroughValue.formNegation()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Matrix
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(_ other: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.adding(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formAddition(of other: Self) {
    passthroughValue.formAddition(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(scalar: PassthroughValue.Scalar) -> Self {
    Self(
      passthroughValue: passthroughValue.adding(
        scalar: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formAddition(ofScalar scalar: PassthroughValue.Scalar) {
    passthroughValue.formAddition(
      ofScalar: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(
    _ other: Self,
    multipliedBy scalar: PassthroughValue.Scalar
  ) -> Self {
    Self(
      passthroughValue: passthroughValue.adding(
        other.passthroughValue,
        multipliedBy: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formAddition(
    of other: Self,
    multipliedBy scalar: PassthroughValue.Scalar
  ) {
    passthroughValue.formAddition(
      of: other.passthroughValue,
      multipliedBy: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Matrix
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(_ other: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.subtracting(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formSubtraction(of other: Self) {
    passthroughValue.formSubtraction(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(scalar: PassthroughValue.Scalar) -> Self {
    Self(
      passthroughValue: passthroughValue.subtracting(
        scalar: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formSubtraction(ofScalar scalar: PassthroughValue.Scalar) {
    passthroughValue.formSubtraction(
      ofScalar: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(
    _ other: Self,
    multipliedBy scalar: PassthroughValue.Scalar
  ) -> Self {
    Self(
      passthroughValue: passthroughValue.subtracting(
        other.passthroughValue,
        multipliedBy: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formSubtraction(
    of other: Self,
    multipliedBy scalar: PassthroughValue.Scalar
  ) {
    passthroughValue.formSubtraction(
      of: other.passthroughValue,
      multipliedBy: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Multiplication - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(by scalar: PassthroughValue.Scalar) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        by: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(by scalar: PassthroughValue.Scalar) {
    passthroughValue.formMultiplication(
      by: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Division - Scalar
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(by scalar: PassthroughValue.Scalar) -> Self {
    Self(
      passthroughValue: passthroughValue.divided(
        by: scalar
      )
    )
  }
  
  @inlinable
  public mutating func formDivision(by scalar: PassthroughValue.Scalar) {
    passthroughValue.formDivision(
      by: scalar
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Matrix-Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onLeftBy columnVector: PassthroughValue.ColumnVector) -> PassthroughValue.RowVector {
    return passthroughValue.multiplied(
      onLeftBy: columnVector
    )
  }
  
  @inlinable
  public func multiplied(onRightBy rowVector: PassthroughValue.RowVector) -> PassthroughValue.ColumnVector {
    return passthroughValue.multiplied(
      onRightBy: rowVector
    )
  }
    
}
