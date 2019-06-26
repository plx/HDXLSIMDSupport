//
//  Passthrough+Matrix3x2Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix3x2Protocol {
  
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
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3 {
  
  @inlinable
  func transposed() -> CompatibleMatrix2x3 {
    return CompatibleMatrix2x3(
      passthroughValue: self.passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - _ * (2x3) => 2x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x2 {
    return CompatibleMatrix2x2(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - _ * (3x3) => 3x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x3) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix3x3) {
    self.passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - _ * (4x3) => 4x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x2 {
    return CompatibleMatrix4x2(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - (2x2) * _ => 3x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix2x2:Passthrough,
CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x2) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix2x2) {
    self.passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - (2x3) * _ => 3x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix3x3 {
    return CompatibleMatrix3x3(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}


// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix3x2Protocol - (2x4) * _ => 3x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix3x2Protocol,
  PassthroughValue:Matrix3x2Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix3x4 {
    return CompatibleMatrix3x4(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}
