import Foundation
import simd
import HDXLSIMDSupportProtocols

// note: the out-of-place operators already exist and are defined on the
// correponding matrix types; this is specifically patching the gap wherein we
// *can* do `vector *= someSquareMatrix`, etc., but can't *write* it without adding ths.
//
// The in-place operations are what motivated this, but then for "call-site symmetry"
// I added named, out-of-place methods here, too; trying to keep my in-place/out-of-place
// operations looking as similar in-code as I can.
extension SIMD2 where Scalar:ExtendedSIMDScalar {
  
  @inlinable
  public func multiplied(onLeftBy matrix: Matrix2x2<Scalar>) -> SIMD2<Scalar> {
    matrix * self
  }
  
  @inlinable
  public func multiplied(onRightBy matrix: Matrix2x2<Scalar>) -> SIMD2<Scalar> {
    self * matrix
  }

  @inlinable
  public mutating func formMultiplication(onLeftBy matrix: Matrix2x2<Scalar>) {
    self = matrix * self
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy matrix: Matrix2x2<Scalar>) {
    self = self * matrix
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: Matrix2x2<Scalar>
  ) {
    lhs.formMultiplication(
      onLeftBy: rhs
    )
  }

  @inlinable
  public static func =* (
    lhs: Matrix2x2<Scalar>,
    rhs: inout Self
  ) {
    rhs.formMultiplication(
      onRightBy: lhs
    )
  }

}