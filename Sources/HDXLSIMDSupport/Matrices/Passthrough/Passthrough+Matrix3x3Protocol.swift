//
//  Passthrough+Matrix3x3Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue: Matrix3x3Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector,
    _ c2: PassthroughValue.ColumnVector) {
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1,
        c2
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
// MARK: Passthrough - Matrix3x3Protocol Support - 2x3 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix2x3: Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    return CompatibleMatrix2x3(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 4x3 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix4x3: Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3 {
    return CompatibleMatrix4x3(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 3x2 Left-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix3x2: Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    return CompatibleMatrix3x2(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 3x4 Left-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix3x4: Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4 {
    return CompatibleMatrix3x4(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - Quaternion
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleQuaternion: Passthrough,
  CompatibleQuaternion.PassthroughValue == PassthroughValue.CompatibleQuaternion {
  
  @inlinable
  init(quaternion: CompatibleQuaternion) {
    self.init(
      passthroughValue: PassthroughValue(
        quaternion: quaternion.passthroughValue
      )
    )
  }
  
}
