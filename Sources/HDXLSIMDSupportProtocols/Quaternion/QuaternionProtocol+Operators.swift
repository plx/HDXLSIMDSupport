import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: QuaternionProtocol - Operators
// -------------------------------------------------------------------------- //

extension QuaternionProtocol {
  
  @inlinable
  public static prefix func -(x: Self) -> Self {
    x.negated()
  }
  
  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    lhs.adding(rhs)
  }
    
  @inlinable
  public static func + (lhs: Self, rhs: (Scalar,Self)) -> Self {
    lhs.adding(
      rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  public static func += (lhs: inout Self, rhs: (Scalar,Self)) {
    lhs.formAddition(
      of: rhs.1,
      multipliedBy: rhs.0
    )
  }
  
  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    lhs.subtracting(rhs)
  }
  
  @inlinable
  public static func * (lhs: Self, rhs: Scalar) -> Self {
    lhs.multiplied(by: rhs)
  }
  
  @inlinable
  public static func * (lhs: Scalar, rhs: Self) -> Self {
    return rhs.multiplied(by: lhs)
  }
  
  @inlinable
  public static func *= (lhs: inout Self, rhs: Scalar) {
    lhs.formMultiplication(by: rhs)
  }
  
  @inlinable
  public static func / (lhs: Self, rhs: Scalar) -> Self {
    lhs.divided(by: rhs)
  }
  
  @inlinable
  public static func /= (lhs: inout Self, rhs: Scalar) {
    lhs.formDivision(by: rhs)
  }
  
  @inlinable
  public static func * (lhs: Self, rhs: Self) -> Self {
    lhs.multiplied(onRightBy: rhs)
  }
  
  @inlinable
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs.formMultiplication(onRightBy: rhs)
  }
  
  @inlinable
  public static func =* (lhs: Self, rhs: inout Self) {
    rhs.formMultiplication(onLeftBy: lhs)
  }
  
  @inlinable
  public static func / (lhs: Self, rhs: Self) -> Self {
    lhs.divided(onRightBy: rhs)
  }
  
  @inlinable
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs.formDivision(onRightBy: rhs)
  }
  
  @inlinable
  public static func =/ (lhs: Self, rhs: inout Self) {
    rhs.formDivision(onLeftBy: lhs)
  }
  
  @inlinable
  public static func • (lhs: Self, rhs: Self) -> Scalar {
    lhs.dotted(with: rhs)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionOperatorSupportProtocol - Operators - In-Place `AdditiveArithmetic`
// -------------------------------------------------------------------------- //

// technical fix: both `AdditiveArithmetic` and `QuaternionOperatorSupportProtocol`
// define default implementations of `+=` and `-=`. This results in ambiguity
// if we then have`$MatrixType:AdditiveArithmetic & QuaternionOperatorSupportProtocol`,
// b/c Swift sees two default implementations (w/out a way to pick a winner).
//
// One fix is to delete these operators and use the existing defaults--could be
// the right decision, actually.
//
// Fix I picked is to move the defaults into an extension that applies only to
// the case of `QuaternionOperatorSupportProtocol where Self:AdditiveArithmetic`,
// and then *overrides* `AdditiveArithmetic`'s default implementations with our
// own implementation. This fixes the disambiguity issue; whether it's worth
// having these remains to be seen (probably not, but don't want to jump the
// gun on removing them...).
//
extension QuaternionProtocol where Self:AdditiveArithmetic {
  
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

