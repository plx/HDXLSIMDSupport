import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4Protocol - Operators
// -------------------------------------------------------------------------- //

extension Matrix4x4Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x4
  ) -> CompatibleMatrix2x4 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x4
  ) -> CompatibleMatrix3x4 {
    lhs.multiplied(onRightBy: rhs)
  }

  @inlinable
  public static func * (
    lhs: Self,
    rhs: Self
  ) -> Self {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  public static func =* (
    lhs: Self,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
  @inlinable
  public static func / (
    lhs: Self,
    rhs: Self
  ) -> Self {
    return lhs.divided(onRightBy: rhs)
  }
  
  @inlinable
  public static func /= (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formDivision(onRightBy: rhs)
  }
  
  @inlinable
  public static func =/ (
    lhs: Self,
    rhs: inout Self
  ) {
    rhs.formDivision(onLeftBy: lhs)
  }

}
