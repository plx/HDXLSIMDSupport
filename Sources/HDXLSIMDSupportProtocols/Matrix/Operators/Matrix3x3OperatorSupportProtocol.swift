import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix3x3Protocol - Operators
// -------------------------------------------------------------------------- //

extension Matrix3x3Protocol {
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x3
  ) -> CompatibleMatrix2x3 {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix4x3
  ) -> CompatibleMatrix4x3 {
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
