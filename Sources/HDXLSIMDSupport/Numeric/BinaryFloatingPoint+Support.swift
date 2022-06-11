import Foundation

extension BinaryFloatingPoint {

  @inlinable
  public var isZero: Bool {
    return 0 == self
  }

  @inlinable
  public var isNonZero: Bool {
    return 0 != self
  }
  
  @inlinable
  public var isNonPositive: Bool {
    return self <= 0
  }

  @inlinable
  public var isNonNegative: Bool {
    return self >= 0
  }

  @inlinable
  public var isStrictlyPositive: Bool {
    return self > 0
  }
  
  @inlinable
  public var isStrictlyNegative: Bool {
    return self < 0
  }

  @inlinable
  public var isFiniteNonZero: Bool {
    return isFinite && isNonZero
  }

  @inlinable
  public var isFiniteNonPositive: Bool {
    return isFinite && isNonPositive
  }
  
  @inlinable
  public var isFiniteNonNegative: Bool {
    return isFinite && isNonNegative
  }

  @inlinable
  public var isFiniteStrictlyPositive: Bool {
    return isFinite && isStrictlyPositive
  }
  
  @inlinable
  public var isFiniteStrictlyNegative: Bool {
    return isFinite && isStrictlyNegative
  }

}
