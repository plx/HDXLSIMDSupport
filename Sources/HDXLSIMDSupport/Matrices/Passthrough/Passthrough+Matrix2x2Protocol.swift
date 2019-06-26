//
//  Passthrough+Matrix2x2Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix2x2Protocol Support
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue: Matrix2x2Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector) {
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //
  
  @inlinable
  var determinant: PassthroughValue.Scalar {
    get {
      return self.passthroughValue.determinant
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func inverted() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.inverted()
    )
  }
  
  @inlinable
  mutating func formInverse() {
    self.passthroughValue.formInverse()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func multiplied(onRightBy rhs: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  func multiplied(onLeftBy lhs: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: Self) {
    self.passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy lhs: Self) {
    self.passthroughValue.formMultiplication(
      onLeftBy: lhs.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func divided(onRightBy rhs: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  func divided(onLeftBy lhs: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formDivision(onRightBy rhs: Self) {
    self.passthroughValue.formDivision(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  mutating func formDivision(onLeftBy lhs: Self) {
    self.passthroughValue.formDivision(
      onLeftBy: lhs.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func transposed() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.transposed()
    )
  }
  
  @inlinable
  mutating func formTranspose() {
    self.passthroughValue.formTranspose()
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix2x2Protocol Support - 3x2 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x2Protocol,
  PassthroughValue: Matrix2x2Protocol,
  CompatibleMatrix3x2: Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    return CompatibleMatrix3x2(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix2x2Protocol Support - 4x2 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x2Protocol,
  PassthroughValue: Matrix2x2Protocol,
  CompatibleMatrix4x2: Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x2 {
    return CompatibleMatrix4x2(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix2x2Protocol Support - 2x3 Left-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x2Protocol,
  PassthroughValue: Matrix2x2Protocol,
  CompatibleMatrix2x3: Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    return CompatibleMatrix2x3(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix2x2Protocol Support - 2x4 Left-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x2Protocol,
  PassthroughValue: Matrix2x2Protocol,
  CompatibleMatrix2x4: Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x4 {
    return CompatibleMatrix2x4(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

