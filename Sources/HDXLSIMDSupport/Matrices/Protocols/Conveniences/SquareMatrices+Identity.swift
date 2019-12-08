//
//  SquareMatrices+Identity.swift
//  

import Foundation
import simd

// with a `SquareMatrixProtocol` this could be defined on that, instead of 3x
// as here, but...that caused me compile-time problems last time I tried it.

public extension Matrix2x2Protocol {
  
  @inlinable
  static var identity: Self {
    get {
      return Self(
        diagonal: DiagonalVector(
          repeating: 1.0
        )
      )
    }
  }
  
}

public extension Matrix3x3Protocol {

  @inlinable
  static var identity: Self {
    get {
      return Self(
        diagonal: DiagonalVector(
          repeating: 1.0
        )
      )
    }
  }

}

public extension Matrix4x4Protocol {
  
  @inlinable
  static var identity: Self {
    get {
      return Self(
        diagonal: DiagonalVector(
          repeating: 1.0
        )
      )
    }
  }
  
}
