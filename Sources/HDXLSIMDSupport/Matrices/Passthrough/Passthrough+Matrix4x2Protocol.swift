//
//  Passthrough+Matrix4x2Protocol.swift
//

import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix4x2Protocol {
  
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
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4
{
  
  @inlinable
  func transposed() -> CompatibleMatrix2x4 {
    return CompatibleMatrix2x4(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - _ * (2x4) => 2x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x2 {
    return CompatibleMatrix2x2(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - _ * (3x4) => 3x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x2 {
    return CompatibleMatrix3x2(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - _ * (4x4) => 4X2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x4) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix4x4) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - (2x3) * _ => 4x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix4x3 {
    return CompatibleMatrix4x3(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - (2x2) * _ => 4x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x2) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix2x2) {
    passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x2Protocol - (2x4) * _ => 4x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x2Protocol,
  PassthroughValue:Matrix4x2Protocol,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix4x4 {
    return CompatibleMatrix4x4(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

