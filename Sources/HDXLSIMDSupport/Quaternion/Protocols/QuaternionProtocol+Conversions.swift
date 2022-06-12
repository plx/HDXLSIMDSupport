import Foundation

extension QuaternionProtocol {
  @inlinable
  public static func truncating<T>(i: T, j: T, k: T, real: T) -> Self where T: BinaryInteger {
    return Self(
      i: Scalar(i),
      j: Scalar(j),
      k: Scalar(k),
      real: Scalar(real)
    )
  }
  
  @inlinable
  public static func exactly<T>(i: T, j: T, k: T, real: T) -> Self? where T: BinaryInteger {
    guard
      let i = Scalar(exactly: i),
      let j = Scalar(exactly: j),
      let k = Scalar(exactly: k),
      let real = Scalar(exactly: real)
    else {
      return nil
    }
    return Self(
      i: i,
      j: j,
      k: k,
      real: real
    )
  }
  
  @inlinable
  public static func truncating<T>(i: T, j: T, k: T, real: T) -> Self where T: BinaryFloatingPoint {
    return Self(
      i: Scalar(i),
      j: Scalar(j),
      k: Scalar(k),
      real: Scalar(real)
    )
  }
  
  @inlinable
  public static func exactly<T>(i: T, j: T, k: T, real: T) -> Self? where T: BinaryFloatingPoint {
    guard
      let i = Scalar(exactly: i),
      let j = Scalar(exactly: j),
      let k = Scalar(exactly: k),
      let real = Scalar(exactly: real)
    else {
      return nil
    }
    return Self(
      i: i,
      j: j,
      k: k,
      real: real
    )
  }
}
