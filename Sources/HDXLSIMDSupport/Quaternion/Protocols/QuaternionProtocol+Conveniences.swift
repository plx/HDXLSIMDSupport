//
//  QuaternionProtocol+Conveniences.swift
//

import Foundation
import simd

// I've tried to minimize the amount of utilities I add atop the core API,
// but I'm including in this extension a handful of things for which the absence
// has proven not mereely frustrating but outright painful.

extension QuaternionProtocol {

  /// The (multiplicative) identity quaternion.
  @inlinable
  public static var identity: Self {
    get {
      return .one
    }
  }
  
  /// The quaterion with real part 1, imaginary part 0.
  @inlinable
  public static var one: Self {
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
  public static var i: Self {
    get {
      return Self(
        realComponent: 0,
        imaginaryComponent: Vector3(1,0,0)
      )
    }
  }

  /// The pure-`j` unit quaternion.
  @inlinable
  public static var j: Self {
    get {
      return Self(
        realComponent: 0,
        imaginaryComponent: Vector3(0,1,0)
      )
    }
  }

  /// The pure-`k` unit quaternion.
  @inlinable
  public static var k: Self {
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
  public static var x: Self {
    get {
      return i
    }
  }

  /// The pure-`y` unit quaternion; synonym for `.j`.
  @inlinable
  public static var y: Self {
    get {
      return j
    }
  }

  /// The pure-`z` unit quaternion; synonym for `.k`.
  @inlinable
  public static var z: Self {
    get {
      return k
    }
  }

}

