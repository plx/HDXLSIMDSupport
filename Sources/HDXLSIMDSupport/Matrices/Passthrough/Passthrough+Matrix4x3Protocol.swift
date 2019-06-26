//
//  Passthrough+Matrix4x3Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix4x3Protocol {

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  @inlinable
  init(
    _ c0: PassthroughValue.ColumnVector,
    _ c1: PassthroughValue.ColumnVector,
    _ c2: PassthroughValue.ColumnVector,
    _ c3: PassthroughValue.ColumnVector) {
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
// MARK: Passthrough + Matrix4x3Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4 {
  
  @inlinable
  func transposed() -> CompatibleMatrix3x4 {
    return CompatibleMatrix3x4(
      passthroughValue: self.passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (2x4) => 2x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x3 {
    return CompatibleMatrix2x3(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (3x4) => 3x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x3 {
    return CompatibleMatrix3x3(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (4x4) => 4X3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x4) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix4x4) {
    self.passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x2) * _ => 4x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix4x2 {
    return CompatibleMatrix4x2(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x3) * _ => 4x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x3) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix3x3) {
    self.passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x4) * _ => 4x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix4x4 {
    return CompatibleMatrix4x4(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

