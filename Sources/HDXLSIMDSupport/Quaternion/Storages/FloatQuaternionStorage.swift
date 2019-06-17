//
//  FloatQuaternionStorage.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - Definition
// -------------------------------------------------------------------------- //

public struct FloatQuaternionStorage {

  public typealias Scalar = Float

  public var storage: simd_quatf
  
  @usableFromInline
  internal init(storage: simd_quatf) {
    // /////////////////////////////////////////////////////////////////////////
    //pedantic_assert(storage.isFinite)
    // /////////////////////////////////////////////////////////////////////////
    self.storage = storage
  }
  
  @usableFromInline
  internal init(vector: Vector4) {
    self.init(
      storage: simd_quatf(vector: vector)
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - Support
// -------------------------------------------------------------------------- //

public extension FloatQuaternionStorage {
  
  @inlinable
  var isZero: Bool {
    get {
      return self.storage.vector == Vector4.zero
    }
  }

  @inlinable
  var isNonZero: Bool {
    get {
      return self.storage.vector != Vector4.zero
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - Equatable
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : Equatable {
  
  @inlinable
  public static func ==(
    lhs: FloatQuaternionStorage,
    rhs: FloatQuaternionStorage) -> Bool {
    return lhs.storage == rhs.storage
  }

  @inlinable
  public static func !=(
    lhs: FloatQuaternionStorage,
    rhs: FloatQuaternionStorage) -> Bool {
    return lhs.storage != rhs.storage
  }

}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - Hashable
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    self.storage.vector.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      return "FloatQuaternionStorage(storage: \(String(describing: self.storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      return "FloatQuaternionStorage(storage: \(String(reflecting: self.storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - Codable
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : Codable {
  
  @inlinable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.storage.vector)
  }
  
  @inlinable
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(vector: try container.decode(Vector4.self))
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - ExpressibleByArrayLiteral
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : ExpressibleByArrayLiteral {
  
  public typealias ArrayLiteralElement = Scalar
  
  /// Format: `[i, j, k, real]`.
  @inlinable
  public init(arrayLiteral elements: ArrayLiteralElement...) {
    guard elements.count == 4 else {
      fatalError("Invalid array-literal construction for FloatQuaternionStorage: \(elements))")
    }
    self.init(
      i: elements[0],
      j: elements[1],
      k: elements[2],
      real: elements[3]
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - QuaternionMathProtocol
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : QuaternionMathProtocol {
  
  @inlinable
  public var realComponent: Scalar {
    get {
      return self.storage.real
    }
    set {
      self.storage.real = newValue
    }
  }
  
  @inlinable
  public var imaginaryComponent: Vector3 {
    get {
      return self.storage.imag
    }
    set {
      self.storage.imag = newValue
    }
  }
  
  @inlinable
  public var angleInRadians: Scalar {
    get {
      return self.storage.angle
    }
  }
  
  @inlinable
  public var rotationAxis: Vector3 {
    get {
      return self.storage.axis
    }
  }
  
  @inlinable
  public var length: Scalar {
    get {
      return self.storage.length
    }
  }
  
  @inlinable
  public func apply(to vector: Vector3) -> Vector3 {
    return self.storage.act(vector)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func normalized() -> FloatQuaternionStorage {
    precondition(self.isNonZero)
    return FloatQuaternionStorage(
      storage: self.storage.normalized
    )
  }
  
  @inlinable
  public mutating func formNormalization() {
    precondition(self.isNonZero)
    self.storage = self.storage.normalized
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func inverted() -> FloatQuaternionStorage {
    precondition(self.isNonZero)
    return FloatQuaternionStorage(
      storage: self.storage.inverse
    )
  }
  
  @inlinable
  public mutating func formInverse() {
    precondition(self.isNonZero)
    self.storage = self.storage.inverse
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func conjugate() -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage.conjugate
    )
  }

  @inlinable
  public mutating func formConjugate() {
    self.storage = self.storage.conjugate
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func negated() -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: -self.storage
    )
  }
  
  @inlinable
  public mutating func formNegation() {
    self.storage = -self.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(_ other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage + other.storage
    )
  }
  
  @inlinable
  public mutating func formAddition(of other: FloatQuaternionStorage) {
    self.storage += other.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(
    _ other: FloatQuaternionStorage,
    multipliedBy factor: Scalar) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage + (other.storage * factor)
    )
  }
  
  @inlinable
  public mutating func formAddition(
    of other: FloatQuaternionStorage,
    multipliedBy factor: Scalar) {
    self.storage += (other.storage * factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(_ other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage - other.storage
    )
  }
  
  @inlinable
  public mutating func formSubtraction(of other: FloatQuaternionStorage) {
    self.storage -= other.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(by factor: Scalar) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage * factor
    )
  }
  
  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self.storage *= factor
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(by factor: Scalar) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage / factor
    )
  }
  
  @inlinable
  public mutating func formDivision(by factor: Scalar) {
    self.storage /= factor
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(onRightBy other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: self.storage * other.storage
    )
  }
  
  @inlinable
  public func multiplied(onLeftBy other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    return FloatQuaternionStorage(
      storage: other.storage * self.storage
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy other: FloatQuaternionStorage) {
    self.storage *= other.storage
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy other: FloatQuaternionStorage) {
    self.storage = other.storage * self.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(onRightBy other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    precondition(other.isNonZero)
    return FloatQuaternionStorage(
      storage: self.storage / other.storage
    )
  }
  
  @inlinable
  public func divided(onLeftBy other: FloatQuaternionStorage) -> FloatQuaternionStorage {
    precondition(other.isNonZero)
    return FloatQuaternionStorage(
      storage: other.storage.inverse * self.storage
    )
  }
  
  @inlinable
  public mutating func formDivision(onRightBy other: FloatQuaternionStorage) {
    precondition(other.isNonZero)
    self.storage /= other.storage
  }
  
  @inlinable
  public mutating func formDivision(onLeftBy other: FloatQuaternionStorage) {
    precondition(other.isNonZero)
    self.storage = other.storage.inverse * self.storage
  }

}


// -------------------------------------------------------------------------- //
// MARK: FloatQuaternionStorage - QuaternionStorageProtocol
// -------------------------------------------------------------------------- //

extension FloatQuaternionStorage : QuaternionStorageProtocol {
  
  public typealias NativeSIMDQuaternion = simd_quatf
  
  // ------------------------------------------------------------------------ //
  // MARK: Initialization
  // ------------------------------------------------------------------------ //
  
  /// The zero quaternion
  @inlinable
  public init() {
    self.init(
      storage: NativeSIMDQuaternion()
    )
  }
  
  @inlinable
  public init(nativeSIMDQuaternion quaternion: NativeSIMDQuaternion) {
    self.init(
      storage: quaternion
    )
  }
  
  @inlinable
  public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(
        ix: i,
        iy: j,
        iz: k,
        r: real
      )
    )
  }
  
  @inlinable
  public init(x: Scalar, y: Scalar, z: Scalar, real: Scalar) {
    self.init(
      i: x,
      j: y,
      k: z,
      real: real
    )
  }
  
  @inlinable
  public init(
    realComponent: Scalar,
    imaginaryComponent: Vector3) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(
        real: realComponent,
        imag: imaginaryComponent
      )
    )
  }
  
  @inlinable
  public init(
    angleInRadians angle: Scalar,
    rotationAxis axis: Vector3) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(
        angle: angle,
        axis: axis
      )
    )
  }
  
  @inlinable
  public init(
    rotating origin: Vector3,
    onto destination: Vector3) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(
        from: origin,
        to: destination
      )
    )
  }
  
  @inlinable
  public init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix3x3) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(rotationMatrix)
    )
  }
  
  @inlinable
  public init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix4x4) {
    self.init(
      nativeSIMDQuaternion: NativeSIMDQuaternion(rotationMatrix)
    )
  }

}

