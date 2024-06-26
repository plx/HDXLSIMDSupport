import Foundation
import simd

// with a `SquareMatrixProtocol` this could be defined on that, instead of 3x
// as here, but...that caused me compile-time problems last time I tried it.

extension Matrix2x2Protocol {
  
  @inlinable
  public static var identity: Self {
    Self(
      diagonal: DiagonalVector(
        repeating: 1.0
      )
    )
  }
  
}

extension Matrix3x3Protocol {

  @inlinable
  public static var identity: Self {
    Self(
      diagonal: DiagonalVector(
        repeating: 1.0
      )
    )
  }

}

extension Matrix4x4Protocol {
  
  @inlinable
  public static var identity: Self {
    Self(
      diagonal: DiagonalVector(
        repeating: 1.0
      )
    )
  }
  
}
