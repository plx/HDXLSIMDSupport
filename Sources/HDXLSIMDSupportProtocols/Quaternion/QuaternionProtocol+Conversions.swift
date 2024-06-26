import Foundation
import simd

extension QuaternionProtocol {
  
  @inlinable
  public static func truncating<T>(
    i: T,
    j: T,
    k: T,
    real: T
  ) -> Self where T: BinaryInteger {
    Self(
      i: Scalar(i),
      j: Scalar(j),
      k: Scalar(k),
      real: Scalar(real)
    )
  }
  
  @inlinable
  public static func exactly<T>(
    i: T,
    j: T,
    k: T,
    real: T
  ) -> Self? where T: BinaryInteger {
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
  public static func truncating<T>(
    i: T,
    j: T,
    k: T,
    real: T
  ) -> Self where T: BinaryFloatingPoint {
    Self(
      i: Scalar(i),
      j: Scalar(j),
      k: Scalar(k),
      real: Scalar(real)
    )
  }
  
  @inlinable
  public static func exactly<T>(
    i: T,
    j: T,
    k: T,
    real: T
  ) -> Self? where T: BinaryFloatingPoint {
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
  public init<T>(
    truncating other: some QuaternionProtocol<T>
  ) where T: SIMDScalar & BinaryFloatingPoint {
    self.init(
      i: Scalar(other.i),
      j: Scalar(other.j),
      k: Scalar(other.k),
      real: Scalar(other.realComponent)
    )
  }

  @inlinable
  public init?<T>(
    exactly other: some QuaternionProtocol<T>
  ) where T: SIMDScalar & BinaryFloatingPoint {
    guard
      let i = Scalar(exactly: other.i),
      let j = Scalar(exactly: other.j),
      let k = Scalar(exactly: other.k),
      let real = Scalar(exactly: other.realComponent)
    else {
      return nil
    }
    self.init(
      i: i,
      j: j,
      k: k,
      real: real
    )
  }

}
