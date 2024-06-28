import Foundation
import simd

extension SIMD3 where Scalar:BinaryFloatingPoint {
  
  /// The unit-length vector along the x-axis.
  @inlinable
  public static var unitXVector: Self {
    Self(
      1.0,
      0.0,
      0.0
    )
  }

  /// The unit-length vector along the y-axis.
  @inlinable
  public static var unitYVector: Self {
    Self(
      0.0,
      1.0,
      0.0
    )
  }

  /// The unit-length vector along the z-axis.
  @inlinable
  public static var unitZVector: Self {
    Self(
      0.0,
      0.0,
      1.0
    )
  }

}
