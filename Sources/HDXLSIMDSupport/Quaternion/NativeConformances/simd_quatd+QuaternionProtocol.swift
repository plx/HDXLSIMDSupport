//
//  simd_quatd+QuaternionProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_quatd : QuaternionProtocol {
  
  // ------------------------------------------------------------------------ //
  // MARK: Compatible Types
  // ------------------------------------------------------------------------ //
  
  public typealias Scalar = Double
  public typealias CompatibleMatrix3x3 = simd_double3x3
  public typealias CompatibleMatrix4x4 = simd_double4x4
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  // already exists:
  // init()
  
  // we supply:
  @inlinable
  public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
    self.init(
      ix: i,
      iy: j,
      iz: k,
      r: real
    )
  }
  
  // we supply:
  @inlinable
  public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
    self.init(
      ix: x,
      iy: y,
      iz: z,
      r: real
    )
  }
  
  // we supply (rename):
  @inlinable
  public init(
    realComponent: Scalar,
    imaginaryComponent: Vector3) {
    self.init(
      real: realComponent,
      imag: imaginaryComponent
    )
  }
  
  // we supply (rename):
  @inlinable
  public init(
    angleInRadians angle: Scalar,
    rotationAxis axis: Vector3) {
    self.init(
      angle: angle,
      axis: axis
    )
  }
  
  // we supply (rename):
  @inlinable
  public init(
    rotating origin: Vector3,
    onto destination: Vector3) {
    self.init(
      from: origin,
      to: destination
    )
  }
  
  // we supply (rename):
  @inlinable
  public init(rotationMatrix matrix: CompatibleMatrix3x3) {
    self.init(matrix)
  }
  
  // we supply (rename):
  @inlinable
  public init(rotationMatrix matrix: CompatibleMatrix4x4) {
    self.init(matrix)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Other Constructors
  // ------------------------------------------------------------------------ //
  
  // we supply:
  @inlinable
  public static func slerp(
    _ q0: simd_quatd,
    _ q1: simd_quatd,
    _ t: Scalar,
    strategy: QuaternionSlerpStrategy) -> simd_quatd {
    switch strategy {
    case .automatic:
      return simd_quatd.slerpShortest(
        q0,
        q1,
        t
      )
    case .shortest:
      return simd_quatd.slerpShortest(
        q0,
        q1,
        t
      )
    case .longest:
      return simd_quatd.slerpLongest(
        q0,
        q1,
        t
      )
    }
  }
  
  // we supply:
  @inlinable
  public static func slerpShortest(
    _ q0: simd_quatd,
    _ q1: simd_quatd,
    _ t: Scalar) -> simd_quatd {
    return simd_slerp(
      q0,
      q1,
      t
    )
  }
  
  // we supply:
  @inlinable
  public static func slerpLongest(
    _ q0: simd_quatd,
    _ q1: simd_quatd,
    _ t: Scalar) -> simd_quatd {
    return simd_slerp_longest(
      q0,
      q1,
      t
    )
  }
  
  // we supply:
  @inlinable
  public static func bezier(
    q0: simd_quatd,
    q1: simd_quatd,
    q2: simd_quatd,
    q3: simd_quatd,
    t: Scalar) -> simd_quatd {
    return simd_bezier(
      q0,
      q1,
      q2,
      q3,
      t
    )
  }

  // we supply:
  @inlinable
  public static func spline(
    q0: simd_quatd,
    q1: simd_quatd,
    q2: simd_quatd,
    q3: simd_quatd,
    t: Scalar) -> simd_quatd {
    return simd_spline(
      q0,
      q1,
      q2,
      q3,
      t
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Basic Properties
  // ------------------------------------------------------------------------ //
  
  // we supply (rename):
  @inlinable
  public var realComponent: Scalar {
    get {
      return self.real
    }
    set {
      self.real = newValue
    }
  }
  
  // we supply (rename):
  @inlinable
  public var imaginaryComponent: Vector3 {
    get {
      return self.imag
    }
    set {
      self.imag = newValue
    }
  }
  
  // we supply (rename):
  @inlinable
  public var angleInRadians: Scalar {
    get {
      return self.angle
    }
  }
  
  // we supply (rename):
  @inlinable
  public var rotationAxis: Vector3 {
    get {
      return self.axis
    }
  }
  
  // already exists:
  // var length: Scalar { get }
  
  // ------------------------------------------------------------------------ //
  // MARK: Applying to Vectors
  // ------------------------------------------------------------------------ //
  
  // we supply (rename):
  @inlinable
  public func apply(to vector: Vector3) -> Vector3 {
    return self.act(vector)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func normalized() -> simd_quatd {
    return self.normalized
  }
  
  @inlinable
  public mutating func formNormalization() {
    self = self.normalized
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func inverted() -> simd_quatd {
    return self.inverse
  }
  
  @inlinable
  public mutating func formInverse() {
    self = self.inverse
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func conjugated() -> simd_quatd {
    return self.conjugate
  }
  
  @inlinable
  public mutating func formConjugate() {
    self = self.conjugate
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func negated() -> simd_quatd {
    return -self
  }
  
  @inlinable
  public mutating func formNegation() {
    self = -self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(_ other: simd_quatd) -> simd_quatd {
    return self + other
  }
  
  @inlinable
  public mutating func formAddition(of other: simd_quatd) {
    self += other
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(
    _ other: simd_quatd,
    multipliedBy factor: Scalar) -> simd_quatd {
    return self + (other * factor)
  }
  
  @inlinable
  public mutating func formAddition(
    of other: simd_quatd,
    multipliedBy factor: Scalar) {
    self += (other * factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(_ other: simd_quatd) -> simd_quatd {
    return self - other
  }
  
  @inlinable
  public mutating func formSubtraction(of other: simd_quatd) {
    self -= other
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(
    _ other: simd_quatd,
    multipliedBy factor: Scalar) -> simd_quatd {
    return self - (other * factor)
  }
  
  @inlinable
  public mutating func formSubtraction(
    of other: simd_quatd,
    multipliedBy factor: Scalar) {
    self -= (other * factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(by factor: Scalar) -> simd_quatd {
    return self * factor
  }
  
  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self *= factor
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(by factor: Scalar) -> simd_quatd {
    return self / factor
  }
  
  @inlinable
  public mutating func formDivision(by factor: Scalar) {
    self /= factor
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onRightBy other: simd_quatd) -> simd_quatd {
    return self * other
  }
  
  @inlinable
  public func multiplied(onLeftBy other: simd_quatd) -> simd_quatd {
    return other * self
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy other: simd_quatd) {
    self = self * other
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy other: simd_quatd) {
    self = other * self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(onRightBy other: simd_quatd) -> simd_quatd {
    return self / other
  }
  
  @inlinable
  public func divided(onLeftBy other: simd_quatd) -> simd_quatd {
    return other.inverse * self
  }
  
  @inlinable
  public mutating func formDivision(onRightBy other: simd_quatd) {
    self /= other
  }
  
  @inlinable
  public mutating func formDivision(onLeftBy other: simd_quatd) {
    self = other.inverse * self
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Dot Product
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func dotted(with other: simd_quatd) -> Scalar {
    return simd_dot(self, other)
  }
  
}
