//
//  Passthrough+QuaternionProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Passthrough + QuaternionProtocol - Matrix3x3
// -------------------------------------------------------------------------- //

public extension Passthrough
  where
  Self:QuaternionProtocol,
  PassthroughValue: QuaternionProtocol,
  Self.CompatibleMatrix3x3:Passthrough,
  Self.CompatibleMatrix3x3.PassthroughValue == PassthroughValue.CompatibleMatrix3x3 {
  
  @inlinable
  init(rotationMatrix matrix: CompatibleMatrix3x3) {
    self.init(
      passthroughValue: PassthroughValue(
        rotationMatrix: matrix.passthroughValue
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Passthrough + QuaternionProtocol - Matrix4x4
// -------------------------------------------------------------------------- //

public extension Passthrough
  where
  Self:QuaternionProtocol,
  PassthroughValue: QuaternionProtocol,
  Self.CompatibleMatrix4x4:Passthrough,
  Self.CompatibleMatrix4x4.PassthroughValue == PassthroughValue.CompatibleMatrix4x4 {
  
  @inlinable
  init(rotationMatrix matrix: CompatibleMatrix4x4) {
    self.init(
      passthroughValue: PassthroughValue(
        rotationMatrix: matrix.passthroughValue
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Passthrough + QuaternionProtocol
// -------------------------------------------------------------------------- //

public extension Passthrough where PassthroughValue:QuaternionProtocol {
  
  @inlinable
  init() {
    self.init(
      passthroughValue: PassthroughValue()
    )
  }
  
  @inlinable
  init(
    i: PassthroughValue.Scalar,
    j: PassthroughValue.Scalar,
    k: PassthroughValue.Scalar,
    real: PassthroughValue.Scalar) {
    self.init(
      passthroughValue: PassthroughValue(
        i: i,
        j: j,
        k: k,
        real: real
      )
    )
  }
  
  @inlinable
  init(
    x: PassthroughValue.Scalar,
    y: PassthroughValue.Scalar,
    z: PassthroughValue.Scalar,
    real: PassthroughValue.Scalar) {
    self.init(
      passthroughValue: PassthroughValue(
        x: x,
        y: y,
        z: z,
        real: real
      )
    )
  }
  
  @inlinable
  init(
    realComponent: PassthroughValue.Scalar,
    imaginaryComponent: PassthroughValue.Vector3) {
    self.init(
      passthroughValue: PassthroughValue(
        realComponent: realComponent,
        imaginaryComponent: imaginaryComponent
      )
    )
  }

  @inlinable
  init(
    angleInRadians angle: PassthroughValue.Scalar,
    rotationAxis axis: PassthroughValue.Vector3) {
    self.init(
      passthroughValue: PassthroughValue(
        angleInRadians: angle,
        rotationAxis: axis
      )
    )
  }
  
  @inlinable
  init(
    rotating origin: PassthroughValue.Vector3,
    onto destination: PassthroughValue.Vector3) {
    self.init(
      passthroughValue: PassthroughValue(
        rotating: origin,
        onto: destination
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Other Constructors
  // ------------------------------------------------------------------------ //
  
  @inlinable
  static func slerp(
    _ q0: Self,
    _ q1: Self,
    _ t: PassthroughValue.Scalar,
    strategy: QuaternionSlerpStrategy) -> Self {
    switch strategy {
    case .automatic:
      return self.slerpShortest(
        q0,
        q1,
        t
      )
    case .shortest:
      return self.slerpShortest(
        q0,
        q1,
        t
      )
    case .longest:
      return self.slerpLongest(
        q0,
        q1,
        t
      )
    }
  }
  
  @inlinable
  static func slerpShortest(
    _ q0: Self,
    _ q1: Self,
    _ t: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: PassthroughValue.slerpShortest(
        q0.passthroughValue,
        q1.passthroughValue,
        t
      )
    )
  }
  
  @inlinable
  static func slerpLongest(
    _ q0: Self,
    _ q1: Self,
    _ t: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: PassthroughValue.slerpLongest(
        q0.passthroughValue,
        q1.passthroughValue,
        t
      )
    )
  }
 
  @inlinable
  static func bezier(
    q0: Self,
    q1: Self,
    q2: Self,
    q3: Self,
    t: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: PassthroughValue.bezier(
        q0: q0.passthroughValue,
        q1: q1.passthroughValue,
        q2: q2.passthroughValue,
        q3: q3.passthroughValue,
        t: t
      )
    )
  }
  
  @inlinable
  static func spline(
    q0: Self,
    q1: Self,
    q2: Self,
    q3: Self,
    t: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: PassthroughValue.spline(
        q0: q0.passthroughValue,
        q1: q1.passthroughValue,
        q2: q2.passthroughValue,
        q3: q3.passthroughValue,
        t: t
      )
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Basic Properties
  // ------------------------------------------------------------------------ //
  
  @inlinable
  var realComponent: PassthroughValue.Scalar {
    get {
      return self.passthroughValue.realComponent
    }
    set {
      self.passthroughValue.realComponent = newValue
    }
  }
  
  @inlinable
  var imaginaryComponent: PassthroughValue.Vector3 {
    get {
      return self.passthroughValue.imaginaryComponent
    }
    set {
      self.passthroughValue.imaginaryComponent = newValue
    }
  }
  
  @inlinable
  var angleInRadians: PassthroughValue.Scalar {
    get {
      return self.passthroughValue.angleInRadians
    }
  }
  
  @inlinable
  var rotationAxis: PassthroughValue.Vector3 {
    get {
      return self.passthroughValue.rotationAxis
    }
  }
  
  @inlinable
  var length: PassthroughValue.Scalar {
    get {
      return self.passthroughValue.length
    }
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Applying to Vectors
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func apply(to vector: PassthroughValue.Vector3) -> PassthroughValue.Vector3 {
    return self.passthroughValue.apply(
      to: vector
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func normalized() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.normalized()
    )
  }
  
  @inlinable
  mutating func formNormalization() {
    self.passthroughValue.formNormalization()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func inverted() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.inverted()
    )
  }
  
  @inlinable
  mutating func formInverse() {
    self.passthroughValue.formInverse()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func conjugated() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.conjugated()
    )
  }
  
  @inlinable
  mutating func formConjugate() {
    self.passthroughValue.formConjugate()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func negated() -> Self {
    return Self(
      passthroughValue: self.passthroughValue.negated()
    )
  }
  
  @inlinable
  mutating func formNegation() {
    self.passthroughValue.formNegation()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func adding(_ other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.adding(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formAddition(of other: Self) {
    self.passthroughValue.formAddition(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func adding(
    _ other: Self,
    multipliedBy factor: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.adding(
        other.passthroughValue,
        multipliedBy: factor
      )
    )
  }
  
  @inlinable
  mutating func formAddition(
    of other: Self,
    multipliedBy factor: PassthroughValue.Scalar) {
    self.passthroughValue.formAddition(
      of: other.passthroughValue,
      multipliedBy: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func subtracting(_ other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.subtracting(
        other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formSubtraction(of other: Self) {
    self.passthroughValue.formSubtraction(
      of: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMS
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func subtracting(
    _ other: Self,
    multipliedBy factor: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.subtracting(
        other.passthroughValue,
        multipliedBy: factor
      )
    )
  }
  
  @inlinable
  mutating func formSubtraction(
    of other: Self,
    multipliedBy factor: PassthroughValue.Scalar) {
    self.passthroughValue.formSubtraction(
      of: other.passthroughValue,
      multipliedBy: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func multiplied(by factor: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        by: factor
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(by factor: PassthroughValue.Scalar) {
    self.passthroughValue.formMultiplication(
      by: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func divided(by factor: PassthroughValue.Scalar) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        by: factor
      )
    )
  }
  
  @inlinable
  mutating func formDivision(by factor: PassthroughValue.Scalar) {
    self.passthroughValue.formDivision(
      by: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func multiplied(onRightBy other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onRightBy: other.passthroughValue
      )
    )
  }
  
  @inlinable
  func multiplied(onLeftBy other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.multiplied(
        onLeftBy: other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formMultiplication(onRightBy other: Self) {
    self.passthroughValue.formMultiplication(
      onRightBy: other.passthroughValue
    )
  }
  
  @inlinable
  mutating func formMultiplication(onLeftBy other: Self) {
    self.passthroughValue.formMultiplication(
      onLeftBy: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  func divided(onRightBy other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        onRightBy: other.passthroughValue
      )
    )
  }
  
  @inlinable
  func divided(onLeftBy other: Self) -> Self {
    return Self(
      passthroughValue: self.passthroughValue.divided(
        onLeftBy: other.passthroughValue
      )
    )
  }
  
  @inlinable
  mutating func formDivision(onRightBy other: Self) {
    self.passthroughValue.formDivision(
      onRightBy: other.passthroughValue
    )
  }
  
  @inlinable
  mutating func formDivision(onLeftBy other: Self) {
    self.passthroughValue.formDivision(
      onLeftBy: other.passthroughValue
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Dot Product
  // ------------------------------------------------------------------------ //

  @inlinable
  func dotted(with other: Self) -> PassthroughValue.Scalar {
    return self.passthroughValue.dotted(
      with: other.passthroughValue
    )
  }
  
}

