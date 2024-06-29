import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - Basics
// ------------------------------------------------------------------------ //

extension Passthrough where Self: Matrix4x3Protocol, PassthroughValue:Matrix4x3Protocol {

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  @inlinable
  public init(
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
// MARK: Passthrough + Matrix4x3Protocol - Transpose
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  public func transposed() -> CompatibleMatrix3x4 {
    CompatibleMatrix3x4(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (2x4) => 2x3
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix2x3:Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3,
  CompatibleMatrix2x4:Passthrough,
  CompatibleMatrix2x4.PassthroughValue == PassthroughValue.CompatibleMatrix2x4
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x4) -> CompatibleMatrix2x3 {
    CompatibleMatrix2x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (3x4) => 3x3
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x3 {
    CompatibleMatrix3x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - _ * (4x4) => 4X3
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x4) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy rhs: CompatibleMatrix4x4) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x2) * _ => 4x2
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x2:Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2,
  CompatibleMatrix4x2:Passthrough,
  CompatibleMatrix4x2.PassthroughValue == PassthroughValue.CompatibleMatrix4x2
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix4x2 {
    CompatibleMatrix4x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x3) * _ => 4x3
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x3:Passthrough,
  CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix3x3) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy rhs: CompatibleMatrix3x3) {
    passthroughValue.formMultiplication(
      onLeftBy: rhs.passthroughValue
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough + Matrix4x3Protocol - (3x4) * _ => 4x4
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix4x3Protocol,
  PassthroughValue:Matrix4x3Protocol,
  CompatibleMatrix3x4:Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4,
  CompatibleMatrix4x4:Passthrough,
  CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix4x4 {
    CompatibleMatrix4x4(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

