//
//  Passthrough+Matrix2x3Protocol.swift
//

import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix2x3Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector
  ) {
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2
{
  
  @inlinable
  func transposed() -> CompatibleMatrix3x2 {
    return CompatibleMatrix3x2(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - _ * (2x2) => 2x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x2) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix2x2) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - _ * (3x2) => 3x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x3 {
    return CompatibleMatrix3x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - _ * (4x2) => 4x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x3 {
    return CompatibleMatrix4x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - (3x2) * _ => 2x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix2x2 {
    return CompatibleMatrix2x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - (3x3) * _ => 2x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x3) -> Self {
    return Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix3x3) {
    passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}


// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x3Protocol - (3x4) * _ => 2x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x3Protocol,
  PassthroughValue:Matrix2x3Protocol,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix2x4 {
    return CompatibleMatrix2x4(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}
