//
//  Passthrough+Matrix3x4Protocol.swift
//

import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix3x4Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector,
    _ c2: PassthroughValue.ColumnVector
  ) {
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1,
        c2
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  func transposed() -> CompatibleMatrix4x3 {
    return CompatibleMatrix4x3(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - _ * (2x3) => 2x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x4 {
    return CompatibleMatrix2x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - _ * (3x3) => 3x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x3) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix3x3) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - _ * (4x3) => 4x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x4 {
    return CompatibleMatrix4x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - (4x2) * _ => 3x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix3x2 {
    return CompatibleMatrix3x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - (4x3) * _ => 3x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix3x3 {
    return CompatibleMatrix3x3(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x4Protocol - (4x4) * _ => 3x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x4Protocol,
  PassthroughValue:Matrix3x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x4) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix4x4) {
    passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

