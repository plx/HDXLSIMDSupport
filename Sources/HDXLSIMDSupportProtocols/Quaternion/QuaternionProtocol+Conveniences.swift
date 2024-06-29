import Foundation
import simd

extension QuaternionProtocol {

  /// The (multiplicative) identity quaternion.
  @inlinable
  public static var identity: Self { .one }
  
  /// The quaterion with real part 1, imaginary part 0.
  @inlinable
  public static var one: Self {
    Self(
      realComponent: 1,
      imaginaryComponent: .zero
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: `i`, `j`, and `j`
  // ------------------------------------------------------------------------ //
  
  /// The pure-`i` unit quaternion.
  @inlinable
  public static var I: Self {
    Self(
      realComponent: 0,
      imaginaryComponent: Vector3(1,0,0)
    )
  }

  /// The pure-`j` unit quaternion.
  @inlinable
  public static var J: Self {
    Self(
      realComponent: 0,
      imaginaryComponent: Vector3(0,1,0)
    )
  }

  /// The pure-`k` unit quaternion.
  @inlinable
  public static var K: Self {
    Self(
      realComponent: 0,
      imaginaryComponent: Vector3(0,0,1)
    )
  }

  // ------------------------------------------------------------------------ //
  // MARK: `x`, `y`, and `z`
  // ------------------------------------------------------------------------ //
  
  /// The pure-`x` unit quaternion; synonym for `.i`.
  @inlinable
  public static var X: Self { I }

  /// The pure-`y` unit quaternion; synonym for `.j`.
  @inlinable
  public static var Y: Self { J }

  /// The pure-`z` unit quaternion; synonym for `.k`.
  @inlinable
  public static var Z: Self { K }

}

