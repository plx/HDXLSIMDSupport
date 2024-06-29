import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix3x4Protocol - Definition
// -------------------------------------------------------------------------- //

// -------------------------------------------------------------------------- //
// MARK: Matrix3x4Protocol - Operator
// -------------------------------------------------------------------------- //

extension Matrix3x4Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x3
  ) -> CompatibleMatrix2x4 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x3
  ) -> Self {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x3
  ) -> CompatibleMatrix4x4 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: CompatibleMatrix3x3
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  public static func =* (
    lhs: CompatibleMatrix4x4,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
