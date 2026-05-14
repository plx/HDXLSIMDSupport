//
//  simd_quath+QuaternionProtocol.swift
//

import Foundation
import simd

// As of macOS 26 the standard simd module provides `simd_quath` and the full
// suite of C-level operations (`simd_quaternion`, `simd_real`, `simd_imag`,
// `simd_normalize`, `simd_inverse`, `simd_conjugate`, `simd_dot`, `simd_mul`,
// `simd_act`, `simd_slerp`, `simd_slerp_longest`, `simd_bezier`,
// `simd_spline`), but does not yet bridge the Swift-side conveniences (the
// `init(ix:iy:iz:r:)`/`init(real:imag:)`/`init(angle:axis:)` initializers,
// the `.real`/`.imag`/`.angle`/`.axis`/`.length`/`.normalized`/`.inverse`/
// `.conjugate` accessors, or any operators) that exist for `simd_quatf` and
// `simd_quatd`. This conformance fills in those Swift-side conveniences by
// calling the C entry points directly.

extension simd_quath : QuaternionProtocol {

  // ------------------------------------------------------------------------ //
  // MARK: Compatible Types
  // ------------------------------------------------------------------------ //

  public typealias Scalar = Float16
  public typealias CompatibleMatrix3x3 = simd_half3x3
  public typealias CompatibleMatrix4x4 = simd_half4x4

  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //

  // already exists:
  // init()

  @inlinable
  public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
    self = simd_quaternion(i, j, k, real)
  }

  @inlinable
  public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
    self = simd_quaternion(x, y, z, real)
  }

  @inlinable
  public init(
    realComponent: Scalar,
    imaginaryComponent: Vector3
  ) {
    self = simd_quaternion(
      SIMD4<Scalar>(
        imaginaryComponent.x,
        imaginaryComponent.y,
        imaginaryComponent.z,
        realComponent
      )
    )
  }

  @inlinable
  public init(
    angleInRadians angle: Scalar,
    rotationAxis axis: Vector3
  ) {
    self = simd_quaternion(angle, axis)
  }

  @inlinable
  public init(
    rotating origin: Vector3,
    onto destination: Vector3
  ) {
    self = simd_quaternion(origin, destination)
  }

  @inlinable
  public init(rotationMatrix matrix: CompatibleMatrix3x3) {
    self = simd_quaternion(matrix)
  }

  @inlinable
  public init(rotationMatrix matrix: CompatibleMatrix4x4) {
    self = simd_quaternion(matrix)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Other Constructors
  // ------------------------------------------------------------------------ //

  @inlinable
  public static func slerp(
    _ q0: simd_quath,
    _ q1: simd_quath,
    _ t: Scalar,
    strategy: QuaternionSlerpStrategy
  ) -> simd_quath {
    switch strategy {
    case .automatic:
      return simd_quath.slerpShortest(q0, q1, t)
    case .shortest:
      return simd_quath.slerpShortest(q0, q1, t)
    case .longest:
      return simd_quath.slerpLongest(q0, q1, t)
    }
  }

  @inlinable
  public static func slerpShortest(
    _ q0: simd_quath,
    _ q1: simd_quath,
    _ t: Scalar
  ) -> simd_quath {
    return simd_slerp(q0, q1, t)
  }

  @inlinable
  public static func slerpLongest(
    _ q0: simd_quath,
    _ q1: simd_quath,
    _ t: Scalar
  ) -> simd_quath {
    return simd_slerp_longest(q0, q1, t)
  }

  @inlinable
  public static func bezier(
    q0: simd_quath,
    q1: simd_quath,
    q2: simd_quath,
    q3: simd_quath,
    t: Scalar
  ) -> simd_quath {
    return simd_bezier(q0, q1, q2, q3, t)
  }

  @inlinable
  public static func spline(
    q0: simd_quath,
    q1: simd_quath,
    q2: simd_quath,
    q3: simd_quath,
    t: Scalar
  ) -> simd_quath {
    return simd_spline(q0, q1, q2, q3, t)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Basic Properties
  // ------------------------------------------------------------------------ //

  @inlinable
  public var realComponent: Scalar {
    get {
      return simd_real(self)
    }
    set {
      vector.w = newValue
    }
    _modify {
      yield &vector.w
    }
  }

  @inlinable
  public var imaginaryComponent: Vector3 {
    get {
      return simd_imag(self)
    }
    set {
      vector.x = newValue.x
      vector.y = newValue.y
      vector.z = newValue.z
    }
  }

  @inlinable
  public var angleInRadians: Scalar {
    get {
      return simd_angle(self)
    }
  }

  @inlinable
  public var rotationAxis: Vector3 {
    get {
      return simd_axis(self)
    }
  }

  @inlinable
  public var length: Scalar {
    get {
      return simd_length(self)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Applying to Vectors
  // ------------------------------------------------------------------------ //

  @inlinable
  public func apply(to vector: Vector3) -> Vector3 {
    return simd_act(self, vector)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //

  @inlinable
  public func normalized() -> simd_quath {
    return simd_normalize(self)
  }

  @inlinable
  public mutating func formNormalization() {
    self = simd_normalize(self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Norms
  // ------------------------------------------------------------------------ //

  @inlinable
  public var componentwiseMagnitudeSquared: Scalar {
    get {
      return simd_length_squared(vector)
    }
  }

  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //

  @inlinable
  public func inverted() -> simd_quath {
    return simd_inverse(self)
  }

  @inlinable
  public mutating func formInverse() {
    self = simd_inverse(self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //

  @inlinable
  public func conjugated() -> simd_quath {
    return simd_conjugate(self)
  }

  @inlinable
  public mutating func formConjugate() {
    self = simd_conjugate(self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //

  @inlinable
  public func negated() -> simd_quath {
    return simd_quath(vector: -vector)
  }

  @inlinable
  public mutating func formNegation() {
    vector = -vector
  }

  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(_ other: simd_quath) -> simd_quath {
    return simd_quath(vector: vector + other.vector)
  }

  @inlinable
  public mutating func formAddition(of other: simd_quath) {
    vector += other.vector
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //

  @inlinable
  public func adding(
    _ other: simd_quath,
    multipliedBy factor: Scalar
  ) -> simd_quath {
    return simd_quath(vector: vector + (other.vector * factor))
  }

  @inlinable
  public mutating func formAddition(
    of other: simd_quath,
    multipliedBy factor: Scalar
  ) {
    vector += (other.vector * factor)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(_ other: simd_quath) -> simd_quath {
    return simd_quath(vector: vector - other.vector)
  }

  @inlinable
  public mutating func formSubtraction(of other: simd_quath) {
    vector -= other.vector
  }

  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //

  @inlinable
  public func subtracting(
    _ other: simd_quath,
    multipliedBy factor: Scalar
  ) -> simd_quath {
    return simd_quath(vector: vector - (other.vector * factor))
  }

  @inlinable
  public mutating func formSubtraction(
    of other: simd_quath,
    multipliedBy factor: Scalar
  ) {
    vector -= (other.vector * factor)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(by factor: Scalar) -> simd_quath {
    return simd_mul(self, factor)
  }

  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self = simd_mul(self, factor)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(by factor: Scalar) -> simd_quath {
    return simd_quath(vector: vector / factor)
  }

  @inlinable
  public mutating func formDivision(by factor: Scalar) {
    vector /= factor
  }

  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //

  @inlinable
  public func multiplied(onRightBy other: simd_quath) -> simd_quath {
    return simd_mul(self, other)
  }

  @inlinable
  public func multiplied(onLeftBy other: simd_quath) -> simd_quath {
    return simd_mul(other, self)
  }

  @inlinable
  public mutating func formMultiplication(onRightBy other: simd_quath) {
    self = simd_mul(self, other)
  }

  @inlinable
  public mutating func formMultiplication(onLeftBy other: simd_quath) {
    self = simd_mul(other, self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //

  @inlinable
  public func divided(onRightBy other: simd_quath) -> simd_quath {
    return simd_mul(self, simd_inverse(other))
  }

  @inlinable
  public func divided(onLeftBy other: simd_quath) -> simd_quath {
    return simd_mul(simd_inverse(other), self)
  }

  @inlinable
  public mutating func formDivision(onRightBy other: simd_quath) {
    self = simd_mul(self, simd_inverse(other))
  }

  @inlinable
  public mutating func formDivision(onLeftBy other: simd_quath) {
    self = simd_mul(simd_inverse(other), self)
  }

  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Dot Product
  // ------------------------------------------------------------------------ //

  @inlinable
  public func dotted(with other: simd_quath) -> Scalar {
    return simd_dot(self, other)
  }

}
