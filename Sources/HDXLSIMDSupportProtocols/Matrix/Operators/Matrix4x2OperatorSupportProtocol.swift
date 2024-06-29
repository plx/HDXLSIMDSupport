import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: Matrix4x2OperatorSupportProtocol - Operator
// -------------------------------------------------------------------------- //

extension Matrix4x2Protocol {

  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix2x4
  ) -> CompatibleMatrix2x2 {
    return lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: CompatibleMatrix3x4
  ) -> CompatibleMatrix3x2 {
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
    lhs: CompatibleMatrix2x2,
    rhs: inout Self
  ) {
    rhs.formMultiplication(onLeftBy: lhs)
  }

}
