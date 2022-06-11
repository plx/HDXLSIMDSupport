//
//  QuaternionProtocol+Conveniences.swift
//

import Foundation
import simd

// I've tried to minimize the amount of utilities I add atop the core API,
// but I'm including in this extension a handful of things for which the absence
// has proven not mereely frustrating but outright painful.

public extension QuaternionProtocol {

  /// The (multiplicative) identity quaternion.
  @inlinable
  static var identity: Self {
    get {
      return .one
    }
  }
  
  /// The quaterion with real part 1, imaginary part 0.
  @inlinable
  static var one: Self {
    get {
      return Self(
        realComponent: 1,
        imaginaryComponent: .zero
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: `i`, `j`, and `j`
  // ------------------------------------------------------------------------ //
  
  /// The pure-`i` unit quaternion.
  @inlinable
  static var i: Self {
    get {
      return Self(
        realComponent: 0,
        imaginaryComponent: Vector3(1,0,0)
      )
    }
  }

  /// The pure-`j` unit quaternion.
  @inlinable
  static var j: Self {
    get {
      return Self(
        realComponent: 0,
        imaginaryComponent: Vector3(0,1,0)
      )
    }
  }

  /// The pure-`k` unit quaternion.
  @inlinable
  static var k: Self {
    get {
      return Self(
        realComponent: 0,
        imaginaryComponent: Vector3(0,0,1)
      )
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: `x`, `y`, and `z`
  // ------------------------------------------------------------------------ //
  
  /// The pure-`x` unit quaternion; synonym for `.i`.
  @inlinable
  static var x: Self {
    get {
      return i
    }
  }

  /// The pure-`y` unit quaternion; synonym for `.j`.
  @inlinable
  static var y: Self {
    get {
      return j
    }
  }

  /// The pure-`z` unit quaternion; synonym for `.k`.
  @inlinable
  static var z: Self {
    get {
      return k
    }
  }

}
