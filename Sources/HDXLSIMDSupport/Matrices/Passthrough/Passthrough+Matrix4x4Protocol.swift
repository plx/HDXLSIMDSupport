//
//  Passthrough+Matrix4x4Protocol.swift
//  

import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue: Matrix4x4Protocol {

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector,
    _ c2: PassthroughValue.ColumnVector,
    _ c3: PassthroughValue.ColumnVector
  ) {
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1,
        c2,
        c3
      )
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //

  @inlinable
  var determinant: PassthroughValue.Scalar {
    get {
      return passthroughValue.determinant
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //

  @inlinable
  func inverted() -> Self {
    return Self(
      passthroughValue: passthroughValue.inverted()
    )
  }

  @inlinable
  mutating func formInverse() {
    passthroughValue.formInverse()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  func multiplied(onRightBy rhs: Self) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  func multiplied(onLeftBy lhs: Self) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: Self) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy lhs: Self) {
    passthroughValue.formMultiplication(
      onLeftBy: lhs.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func divided(onRightBy rhs: Self) -> Self {
    return Self(
      passthroughValue: passthroughValue.divided(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  func divided(onLeftBy lhs: Self) -> Self {
    return Self(
      passthroughValue: passthroughValue.divided(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formDivision(onRightBy rhs: Self) {
    passthroughValue.formDivision(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  mutating func formDivision(onLeftBy lhs: Self) {
    passthroughValue.formDivision(
      onLeftBy: lhs.passthroughValue
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func transposed() -> Self {
    return Self(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
  @inlinable
  mutating func formTranspose() {
    passthroughValue.formTranspose()
  }

}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support - 2x4 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x4Protocol,
  PassthroughValue: Matrix4x4Protocol,
  CompatibleMatrix2x4: Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4
{

  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x4 {
    return CompatibleMatrix2x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }

}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support - 3x4 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x4Protocol,
  PassthroughValue: Matrix4x4Protocol,
  CompatibleMatrix3x4: Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4 {
    return CompatibleMatrix3x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support - 4x2 Left-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x4Protocol,
  PassthroughValue: Matrix4x4Protocol,
  CompatibleMatrix4x2: Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x2 {
    return CompatibleMatrix4x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support - 4x3 Right-Multiplication
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x4Protocol,
  PassthroughValue: Matrix4x4Protocol,
  CompatibleMatrix4x3: Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3 {
    return CompatibleMatrix4x3(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix4x4Protocol Support - Quaternion
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x4Protocol,
  PassthroughValue: Matrix4x4Protocol,
  CompatibleQuaternion: Passthrough,
  CompatibleQuaternion.PassthroughValue == PassthroughValue.CompatibleQuaternion
{
  
  @inlinable
  init(quaternion: CompatibleQuaternion) {
    self.init(
      passthroughValue: PassthroughValue(
        quaternion: quaternion.passthroughValue
      )
    )
  }
  
}
