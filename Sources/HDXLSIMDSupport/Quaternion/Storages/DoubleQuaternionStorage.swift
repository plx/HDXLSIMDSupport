//
//  DoubleQuaternionStorage.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - Definition
// -------------------------------------------------------------------------- //

public struct DoubleQuaternionStorage {
  
  public typealias Scalar = Double
  
  public var storage: simd_quatd
  
  @usableFromInline
  internal init(storage: simd_quatd) {
    // /////////////////////////////////////////////////////////////////////////
    //pedantic_assert(storage.isFinite)
    // /////////////////////////////////////////////////////////////////////////
    self.storage = storage
  }
  
  @usableFromInline
  internal init(vector: Vector4) {
    self.init(
      storage: simd_quatd(vector: vector)
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - Support
// -------------------------------------------------------------------------- //

public extension DoubleQuaternionStorage {
  
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
// MARK: DoubleQuaternionStorage - Equatable
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : Equatable {
  
  @inlinable
  public static func ==(
    lhs: DoubleQuaternionStorage,
    rhs: DoubleQuaternionStorage) -> Bool {
    return lhs.storage == rhs.storage
  }
  
  @inlinable
  public static func !=(
    lhs: DoubleQuaternionStorage,
    rhs: DoubleQuaternionStorage) -> Bool {
    return lhs.storage != rhs.storage
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - Hashable
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    self.storage.vector.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      return "DoubleQuaternionStorage(storage: \(String(describing: self.storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      return "DoubleQuaternionStorage(storage: \(String(reflecting: self.storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - Codable
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : Codable {
  
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
// MARK: DoubleQuaternionStorage - ExpressibleByArrayLiteral
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : ExpressibleByArrayLiteral {
  
  public typealias ArrayLiteralElement = Scalar
  
  /// Format: `[i, j, k, real]`.
  @inlinable
  public init(arrayLiteral elements: ArrayLiteralElement...) {
    guard elements.count == 4 else {
      fatalError("Invalid array-literal construction for DoubleQuaternionStorage: \(elements))")
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
// MARK: DoubleQuaternionStorage - NumericAggregate
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    return self.storage.allNumericEntriesSatisfy(
      predicate
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - NativeSIMDRepresentable
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : NativeSIMDRepresentable {
  
  public typealias NativeSIMDRepresentation = simd_quatd
  
  @inlinable
  public init(nativeSIMDRepresentation representation: NativeSIMDRepresentation) {
    self.init(
      storage: representation
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - QuaternionMathProtocol
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : QuaternionMathProtocol {
  
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
  public func normalized() -> DoubleQuaternionStorage {
    precondition(self.isNonZero)
    return DoubleQuaternionStorage(
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
  public func inverted() -> DoubleQuaternionStorage {
    precondition(self.isNonZero)
    return DoubleQuaternionStorage(
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
  public func conjugated() -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
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
  public func negated() -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
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
  public func adding(_ other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
      storage: self.storage + other.storage
    )
  }
  
  @inlinable
  public mutating func formAddition(of other: DoubleQuaternionStorage) {
    self.storage += other.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func adding(
    _ other: DoubleQuaternionStorage,
    multipliedBy factor: Scalar) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
      storage: self.storage + (other.storage * factor)
    )
  }
  
  @inlinable
  public mutating func formAddition(
    of other: DoubleQuaternionStorage,
    multipliedBy factor: Scalar) {
    self.storage += (other.storage * factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func subtracting(_ other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
      storage: self.storage - other.storage
    )
  }
  
  @inlinable
  public mutating func formSubtraction(of other: DoubleQuaternionStorage) {
    self.storage -= other.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func multiplied(by factor: Scalar) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
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
  public func divided(by factor: Scalar) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
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
  public func multiplied(onRightBy other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
      storage: self.storage * other.storage
    )
  }
  
  @inlinable
  public func multiplied(onLeftBy other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    return DoubleQuaternionStorage(
      storage: other.storage * self.storage
    )
  }
  
  @inlinable
  public mutating func formMultiplication(onRightBy other: DoubleQuaternionStorage) {
    self.storage *= other.storage
  }
  
  @inlinable
  public mutating func formMultiplication(onLeftBy other: DoubleQuaternionStorage) {
    self.storage = other.storage * self.storage
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func divided(onRightBy other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    precondition(other.isNonZero)
    return DoubleQuaternionStorage(
      storage: self.storage / other.storage
    )
  }
  
  @inlinable
  public func divided(onLeftBy other: DoubleQuaternionStorage) -> DoubleQuaternionStorage {
    precondition(other.isNonZero)
    return DoubleQuaternionStorage(
      storage: other.storage.inverse * self.storage
    )
  }
  
  @inlinable
  public mutating func formDivision(onRightBy other: DoubleQuaternionStorage) {
    precondition(other.isNonZero)
    self.storage /= other.storage
  }
  
  @inlinable
  public mutating func formDivision(onLeftBy other: DoubleQuaternionStorage) {
    precondition(other.isNonZero)
    self.storage = other.storage.inverse * self.storage
  }
  
}


// -------------------------------------------------------------------------- //
// MARK: DoubleQuaternionStorage - QuaternionStorageProtocol
// -------------------------------------------------------------------------- //

extension DoubleQuaternionStorage : QuaternionStorageProtocol {
  
  
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
  public init(i: Scalar, j: Scalar, k: Scalar, real: Scalar) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDQuaternion(
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
      nativeSIMDRepresentation: NativeSIMDQuaternion(
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
      nativeSIMDRepresentation: NativeSIMDQuaternion(
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
      nativeSIMDRepresentation: NativeSIMDQuaternion(
        from: origin,
        to: destination
      )
    )
  }
  
  @inlinable
  public init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix3x3) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDQuaternion(rotationMatrix)
    )
  }
  
  @inlinable
  public init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix4x4) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDQuaternion(rotationMatrix)
    )
  }
  
}

