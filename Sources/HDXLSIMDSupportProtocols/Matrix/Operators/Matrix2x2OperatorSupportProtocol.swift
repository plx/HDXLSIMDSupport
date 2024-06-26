import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix2x2Protocol - Operators
// -------------------------------------------------------------------------- //

extension Matrix2x2Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x2
  ) -> CompatibleMatrix3x2 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x2
  ) -> CompatibleMatrix4x2 {
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
    lhs.divided(onRightBy: rhs)
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
