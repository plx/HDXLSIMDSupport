//
//  Passthrough+Matrix2x4Protocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - Basics
// ------------------------------------------------------------------------ //

public extension Passthrough where PassthroughValue:Matrix2x4Protocol {
  
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
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - Transpose
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2 {
  
  @inlinable
  func transposed() -> CompatibleMatrix4x2 {
    return CompatibleMatrix4x2(
      passthroughValue: self.passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (2x2) => 2x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix2x2) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy rhs: CompatibleMatrix2x2) {
    self.passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (3x2) => 3x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x4 {
    return CompatibleMatrix3x4(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (4x2) => 4x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2 {
  
  @inlinable
  func multiplied(onRightBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x4 {
    return CompatibleMatrix4x4(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x2) * _ => 2x2
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix2x2 {
    return CompatibleMatrix2x2(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x3) * _ => 2x3
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix2x3 {
    return CompatibleMatrix2x3(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}


// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x4) * _ => 2x4
// ------------------------------------------------------------------------ //

public extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4 {
  
  @inlinable
  func multiplied(onLeftBy rhs: CompatibleMatrix4x4) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix4x4) {
    self.passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

