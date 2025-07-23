import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - Basics
// ------------------------------------------------------------------------ //

extension Passthrough where Self: Matrix2x4Protocol, PassthroughValue:Matrix2x4Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public init(
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
// MARK: Passthrough + Matrix2x4Protocol - Transpose
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  public func transposed() -> CompatibleMatrix4x2 {
    CompatibleMatrix4x2(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (2x2) => 2x4
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x2) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy rhs: CompatibleMatrix2x2) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (3x2) => 3x4
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x4 {
    CompatibleMatrix3x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - _ * (4x2) => 4x4
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix4x4 {
    CompatibleMatrix4x4(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x2) * _ => 2x2
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x2:Passthrough,
  CompatibleMatrix2x2.PassthroughValue == PassthroughValue.CompatibleMatrix2x2,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix4x2) -> CompatibleMatrix2x2 {
    CompatibleMatrix2x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x3) * _ => 2x3
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3,
  CompatibleMatrix4x3:Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix2x3 {
    CompatibleMatrix2x3(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}


// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix2x4Protocol - (4x4) * _ => 2x4
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix2x4Protocol,
  PassthroughValue:Matrix2x4Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix4x4) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix4x4) {
    passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

