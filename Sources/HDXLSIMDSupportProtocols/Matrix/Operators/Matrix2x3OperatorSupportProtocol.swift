import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix2x3Protocol - Operator
// -------------------------------------------------------------------------- //

extension Matrix2x3Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x2
  ) -> Self {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x2
  ) -> CompatibleMatrix3x3 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x2
  ) -> CompatibleMatrix4x3 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: CompatibleMatrix2x2
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
