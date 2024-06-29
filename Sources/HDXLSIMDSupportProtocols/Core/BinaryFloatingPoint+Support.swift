import Foundation

extension BinaryFloatingPoint {

  @inlinable
  public var isZero: Bool {
    0 == self
  }

  @inlinable
  public var isNonZero: Bool {
    0 != self
  }
  
  @inlinable
  public var isNonPositive: Bool {
    self <= 0
  }

  @inlinable
  public var isNonNegative: Bool {
    self >= 0
  }

  @inlinable
  public var isStrictlyPositive: Bool {
    self > 0
  }
  
  @inlinable
  public var isStrictlyNegative: Bool {
    self < 0
  }

  @inlinable
  public var isFiniteNonZero: Bool {
    isFinite && isNonZero
  }

  @inlinable
  public var isFiniteNonPositive: Bool {
    isFinite && isNonPositive
  }
  
  @inlinable
  public var isFiniteNonNegative: Bool {
    isFinite && isNonNegative
  }

  @inlinable
  public var isFiniteStrictlyPositive: Bool {
    isFinite && isStrictlyPositive
  }
  
  @inlinable
  public var isFiniteStrictlyNegative: Bool {
    isFinite && isStrictlyNegative
  }

}
