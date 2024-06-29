import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: MatrixProtocol - Operators
// -------------------------------------------------------------------------- //

extension MatrixProtocol {
  
  @inlinable
  public static prefix func -(x: Self) -> Self {
    x.negated()
  }
  
  @inlinable
  public static func + (
    lhs: Self,
    rhs: Self
  ) -> Self {
    lhs.adding(rhs)
  }
  
  @inlinable
  public static func + (
    lhs: Self,
    rhs: (Scalar,Self)
  ) -> Self {
    lhs.adding(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  public static func += (
    lhs: inout Self,
    rhs: (Scalar,Self)
  ) {
    lhs.formAddition(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }

  @inlinable
  public static func - (
    lhs: Self,
    rhs: Self
  ) -> Self {
    lhs.subtracting(rhs)
  }
  
  @inlinable
  public static func - (
    lhs: Self,
    rhs: (Scalar,Self)
  ) -> Self {
    lhs.subtracting(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  public static func -= (
    lhs: inout Self,
    rhs: (Scalar,Self)
  ) {
    lhs.formSubtraction(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: Scalar
  ) -> Self {
    lhs.multiplied(by: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: Scalar,
    rhs: Self
  ) -> Self {
    rhs.multiplied(by: lhs)
  }
  
  @inlinable
  public static func *= (
    lhs: inout Self,
    rhs: Scalar
  ) {
    lhs.formMultiplication(by: rhs)
  }
  
  @inlinable
  public static func / (
    lhs: Self,
    rhs: Scalar
  ) -> Self {
    lhs.divided(by: rhs)
  }
  
  @inlinable
  public static func /= (
    lhs: inout Self,
    rhs: Scalar
  ) {
    lhs.formDivision(by: rhs)
  }
  
  @inlinable
  public static func * (
    lhs: ColumnVector,
    rhs: Self
  ) -> RowVector {
    rhs.multiplied(onLeftBy: lhs)
  }
  
  @inlinable
  public static func * (
    lhs: Self,
    rhs: RowVector
  ) -> ColumnVector {
    lhs.multiplied(onRightBy: rhs)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: MatrixOperatorSupportProtocol - Operators - In-Place `AdditiveArithmetic`
// -------------------------------------------------------------------------- //

// technical fix: both `AdditiveArithmetic` and `MatrixOperatorSupportProtocol`
// define default implementations of `+=` and `-=`. This results in ambiguity
// if we then have`$MatrixType:AdditiveArithmetic & MatrixOperatorSupportProtocol`,
// b/c Swift sees two default implementations (w/out a way to pick a winner).
//
// One fix is to delete these operators and use the existing defaults--could be
// the right decision, actually.
//
// Fix I picked is to move the defaults into an extension that applies only to
// the case of `MatrixOperatorSupportProtocol where Self:AdditiveArithmetic`,
// and then *overrides* `AdditiveArithmetic`'s default implementations with our
// own implementation. This fixes the disambiguity issue; whether it's worth
// having these remains to be seen (probably not, but don't want to jump the
// gun on removing them...).
//
extension MatrixProtocol where Self:AdditiveArithmetic {
  
  @inlinable
  public static func += (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formAddition(of: rhs)
  }

  @inlinable
  public static func -= (
    lhs: inout Self,
    rhs: Self
  ) {
    lhs.formSubtraction(of: rhs)
  }

}
