import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix4x3Protocol - Operator
// -------------------------------------------------------------------------- //

extension Matrix4x3Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x4
  ) -> CompatibleMatrix2x3 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x4
  ) -> CompatibleMatrix3x3 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x4
  ) -> Self {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: CompatibleMatrix4x4
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  public static func =* (
    lhs: CompatibleMatrix3x3,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
}
