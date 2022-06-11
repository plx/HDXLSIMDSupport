//
//  SIMD3+WellKnownValues.swift
//

import Foundation
import simd

public extension SIMD3 where Scalar:BinaryFloatingPoint {
  
  /// The unit-length vector along the x-axis.
  @inlinable
  static var unitXVector: Self {
    get {
      return Self(
        1.0,
        0.0,
        0.0
      )
    }
  }

  /// The unit-length vector along the y-axis.
  @inlinable
  static var unitYVector: Self {
    get {
      return Self(
        0.0,
        1.0,
        0.0
      )
    }
  }

  /// The unit-length vector along the z-axis.
  @inlinable
  static var unitZVector: Self {
    get {
      return Self(
        0.0,
        0.0,
        1.0
      )
    }
  }

}
