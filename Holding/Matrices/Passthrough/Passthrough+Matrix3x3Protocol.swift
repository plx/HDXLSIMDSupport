import Foundation
import simd

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support
// ------------------------------------------------------------------------ //

extension Passthrough where Self: Matrix3x3Protocol, PassthroughValue: Matrix3x3Protocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public init(
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
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Determinants
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public var determinant: PassthroughValue.Scalar {
    passthroughValue.determinant
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Inversion
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func inverted() -> Self {
    Self(
      passthroughValue: passthroughValue.inverted()
    )
  }
  
  @inlinable
  public mutating func formInverse() {
    passthroughValue.formInverse()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onRightBy rhs: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public func multiplied(onLeftBy lhs: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy rhs: Self) {
    passthroughValue.formMultiplication(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy lhs: Self) {
    passthroughValue.formMultiplication(
      onLeftBy: lhs.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Square-Matrix Math - Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(onRightBy rhs: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.divided(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public func divided(onLeftBy lhs: Self) -> Self {
    Self(
      passthroughValue: passthroughValue.divided(
        onLeftBy: lhs.passthroughValue
      )
    )
  }
  
  @inlinable
  public mutating func formDivision(onRightBy rhs: Self) {
    passthroughValue.formDivision(
      onRightBy: rhs.passthroughValue
    )
  }
  
  @inlinable
  public mutating func formDivision(onLeftBy lhs: Self) {
    passthroughValue.formDivision(
      onLeftBy: lhs.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Transposition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func transposed() -> Self {
    Self(
      passthroughValue: passthroughValue.transposed()
    )
  }
  
  @inlinable
  public mutating func formTranspose() {
    passthroughValue.formTranspose()
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 2x3 Right-Multiplication
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix2x3: Passthrough,
  CompatibleMatrix2x3.PassthroughValue == PassthroughValue.CompatibleMatrix2x3
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix2x3) -> CompatibleMatrix2x3 {
    CompatibleMatrix2x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 4x3 Right-Multiplication
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix4x3: Passthrough,
  CompatibleMatrix4x3.PassthroughValue == PassthroughValue.CompatibleMatrix4x3
{
  
  @inlinable
  public func multiplied(onRightBy rhs: CompatibleMatrix4x3) -> CompatibleMatrix4x3 {
    CompatibleMatrix4x3(
      passthroughValue: passthroughValue.multiplied(
        onRightBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 3x2 Left-Multiplication
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix3x2: Passthrough,
  CompatibleMatrix3x2.PassthroughValue == PassthroughValue.CompatibleMatrix3x2
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix3x2) -> CompatibleMatrix3x2 {
    CompatibleMatrix3x2(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - 3x4 Left-Multiplication
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleMatrix3x4: Passthrough,
  CompatibleMatrix3x4.PassthroughValue == PassthroughValue.CompatibleMatrix3x4
{
  
  @inlinable
  public func multiplied(onLeftBy rhs: CompatibleMatrix3x4) -> CompatibleMatrix3x4 {
    CompatibleMatrix3x4(
      passthroughValue: passthroughValue.multiplied(
        onLeftBy: rhs.passthroughValue
      )
    )
  }
  
}

// ------------------------------------------------------------------------ //
// MARK: Passthrough - Matrix3x3Protocol Support - Quaternion
// ------------------------------------------------------------------------ //

extension Passthrough
  where
  Self:Matrix3x3Protocol,
  PassthroughValue: Matrix3x3Protocol,
  CompatibleQuaternion: Passthrough,
  CompatibleQuaternion.PassthroughValue == PassthroughValue.CompatibleQuaternion
{
  
  @inlinable
  public init(quaternion: CompatibleQuaternion) {
    self.init(
      passthroughValue: PassthroughValue(
        quaternion: quaternion.passthroughValue
      )
    )
  }
  
}
