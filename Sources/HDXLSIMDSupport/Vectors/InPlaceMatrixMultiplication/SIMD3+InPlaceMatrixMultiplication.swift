//
//  SIMD3+InPlaceMatrixMultiplication.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// note: the out-of-place operators already exist and are defined on the
// correponding matrix types; this is specifically patching the gap wherein we
// *can* do `vector *= someSquareMatrix`, etc., but can't *write* it without adding ths.
//
// The in-place operations are what motivated this, but then for "call-site symmetry"
// I added named, out-of-place methods here, too; trying to keep my in-place/out-of-place
// operations looking as similar in-code as I can.
public extension SIMD3 where Scalar:ExtendedSIMDScalar {
  
  @inlinable
  func multiplied(onLeftBy matrix: Matrix3x3<Scalar>) -> SIMD3<Scalar> {
    return matrix * self
  }
  
  @inlinable
  func multiplied(onRightBy matrix: Matrix3x3<Scalar>) -> SIMD3<Scalar> {
    return self * matrix
  }

  @inlinable
  mutating func formMultiplication(onLeftBy matrix: Matrix3x3<Scalar>) {
    self = matrix * self
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy matrix: Matrix3x3<Scalar>) {
    self = self * matrix
  }
  
  @inlinable
  static func *= (
    lhs: inout Self,
    rhs: Matrix3x3<Scalar>) {
    lhs.formMultiplication(
      onLeftBy: rhs
    )
  }

  @inlinable
  static func =* (
    lhs: Matrix3x3<Scalar>,
    rhs: inout Self) {
    rhs.formMultiplication(
      onRightBy: lhs
    )
  }

}
