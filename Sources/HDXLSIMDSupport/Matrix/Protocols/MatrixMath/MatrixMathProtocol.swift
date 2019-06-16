//
//  MatrixMathProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Definition
// -------------------------------------------------------------------------- //

/// Basic protocol that defines the core matrix-math methods as abstractly as possible and thus lets us define
/// the *operators* that call through to the named methods exactly once.
///
/// Expected to be refined by both (a) `SIMDMatrixProtocol` and (b) `SIMDMatrixStorageProtocol`.
///
/// - note: For *FIXED-SIZE MATRICES ONLY*.
/// - note: Would need *many* tweaks/refinements to support both dynamic matrices and fixed-size matrices.
///
public protocol MatrixMathProtocol {
  
  /// The type of the contained scalar.
  associatedtype Scalar
  
  /// Type of the individual row vectors.
  associatedtype RowVector
  
  /// Type of the individual column vectors.
  associatedtype ColumnVector
  
  // ------------------------------------------------------------------------ //
  // MARK: Matrix - Shape
  // ------------------------------------------------------------------------ //
  
  /// Numer of rows for values of this type.
  static var rowCount: Int { get }
  
  /// Numer of columns for values of this type.
  static var columnCount: Int { get }
  
  /// Number of entries within a row for values of this type.
  static var rowLength: Int { get }
  
  /// Number of entries within a column for values of this type.
  static var columnLength: Int { get }
  
  /// Total count of scalars in values of this type.
  static var scalarCount: Int { get }

  // ------------------------------------------------------------------------ //
  // MARK: Math - Negation
  // ------------------------------------------------------------------------ //
  
  /// Returns `-self`.
  func negated() -> Self
  
  /// In-place mutates `self` into `-self`.
  mutating func formNegation()
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Addition
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-sum of `self` and `other`.
  func adding(_ other: Self) -> Self
  
  /// In-place componentwise adds `other` into self.
  mutating func formAddition(of other: Self)
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - FMA Operation
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-sum of `self` and `factor * other`.
  func adding(
    _ other: Self,
    multipliedBy factor: Scalar) -> Self
  
  /// In-place adds `factor * other` into self.
  mutating func formAddition(
    of other: Self,
    multipliedBy factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Subtraction
  // ------------------------------------------------------------------------ //
  
  /// Returns the componentwise-subtraction of `other` from `self`.
  func subtracting(_ other: Self) -> Self
  
  /// In-place componentwise-subtracts `other` from `self`.
  mutating func formSubtraction(of other: Self)
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of multiplying `self` by `factor`.
  func multiplied(by factor: Scalar) -> Self
  
  /// In-place multiplies `self` by factor.
  mutating func formMultiplication(by factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Scalar Division
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of dividing `self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  func divided(by factor: Scalar) -> Self
  
  /// In-place divides `self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  mutating func formDivision(by factor: Scalar)
  
  // ------------------------------------------------------------------------ //
  // MARK: Math - Vector Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `rowVector * self`
  func multiplied(onLeftBy rowVector: RowVector) -> ColumnVector
  
  /// Returns `self * columnVector`
  func multiplied(onRightBy columnVector: ColumnVector) -> RowVector
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Shape
// -------------------------------------------------------------------------- //

public extension MatrixMathProtocol {
  
  @inlinable
  static var scalarCount: Int {
    get {
      return Self.rowCount * Self.columnCount
    }
  }
  
  @inlinable
  static var rowCount: Int {
    get {
      return Self.columnLength
    }
  }
  
  @inlinable
  static var columnCount: Int {
    get {
      return Self.rowLength
    }
  }
  
  @inlinable
  static var scalarIndexRange: Range<Int> {
    get {
      return 0..<Self.scalarCount
    }
  }
  
  @inlinable
  static var columnIndexRange: Range<Int> {
    get {
      return 0..<Self.columnCount
    }
  }
  
  @inlinable
  static var rowIndexRange: Range<Int> {
    get {
      return 0..<Self.rowCount
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Shape - Rows
// -------------------------------------------------------------------------- //

public extension MatrixMathProtocol where RowVector:SIMD {
  
  @inlinable
  static var rowLength: Int {
    get {
      return RowVector.scalarCount
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Shape - Columns
// -------------------------------------------------------------------------- //

public extension MatrixMathProtocol where ColumnVector:SIMD {
  
  @inlinable
  static var columnLength: Int {
    get {
      return ColumnVector.scalarCount
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Division
// -------------------------------------------------------------------------- //

public extension MatrixMathProtocol where Scalar:BinaryFloatingPoint {
  
  @inlinable
  func divided(by factor: Scalar) -> Self {
    precondition(factor.isNonZero)
    return self.multiplied(by: (1.0/factor))
  }
  
  @inlinable
  mutating func formDivision(by factor: Scalar) {
    precondition(factor.isNonZero)
    self.formMultiplication(by: (1.0/factor))
  }

}

// -------------------------------------------------------------------------- //
// MARK: MatrixMathProtocol - Operators
// -------------------------------------------------------------------------- //

public extension MatrixMathProtocol {
  
  @inlinable
  static prefix func - (x: Self) -> Self {
    return x.negated()
  }
  
  @inlinable
  static func + (lhs: Self, rhs: Self) -> Self {
    return lhs.adding(rhs)
  }
  
  @inlinable
  static func + (lhs: Self, rhs: (Scalar,Self)) -> Self {
    return lhs.adding(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func - (lhs: Self, rhs: Self) -> Self {
    return lhs.subtracting(rhs)
  }
  
  @inlinable
  static func * (lhs: Self, rhs: Scalar) -> Self {
    return lhs.multiplied(by: rhs)
  }
  
  @inlinable
  static func * (lhs: Scalar, rhs: Self) -> Self {
    return rhs.multiplied(by: lhs)
  }
  
  @inlinable
  static func += (lhs: inout Self, rhs: Self) {
    lhs.formAddition(of: rhs)
  }
  
  @inlinable
  static func += (lhs: inout Self, rhs: (Scalar,Self)) {
    lhs.formAddition(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  static func -= (lhs: inout Self, rhs: Self) {
    lhs.formSubtraction(of: rhs)
  }
  
  @inlinable
  static func *= (lhs: inout Self, rhs: Scalar) {
    lhs.formMultiplication(by: rhs)
  }
  
  @inlinable
  static func * (lhs: RowVector, rhs: Self) -> ColumnVector {
    return rhs.multiplied(onLeftBy: lhs)
  }
  
  @inlinable
  static func * (lhs: Self, rhs: ColumnVector) -> RowVector {
    return lhs.multiplied(onRightBy: rhs)
  }
  
}
