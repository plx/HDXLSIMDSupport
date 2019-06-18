//
//  Quaternion.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Quaternion - Definition
// -------------------------------------------------------------------------- //

public struct Quaternion<Scalar:QuaternionCapableProtocol> {
  
  public typealias Storage = Scalar.QuaternionStorage
  
  @usableFromInline
  internal var _storage: Storage
  
  @inlinable
  public var storage: Storage {
    get {
      return self._storage
    }
  }
  
  @usableFromInline
  internal init(storage: Storage) {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(storage.isFinite)
    defer { pedantic_assert(self.isValid) }
    // /////////////////////////////////////////////////////////////////////////
    self._storage = storage
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - Property-Exposure
// -------------------------------------------------------------------------- //



// -------------------------------------------------------------------------- //
// MARK: Quaternion - Validatable
// -------------------------------------------------------------------------- //

extension Quaternion : Validatable {
  
  @inlinable
  public var isValid: Bool {
    get {
      return self._storage.isFinite
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - Equatable
// -------------------------------------------------------------------------- //

extension Quaternion : Equatable {
  
  @inlinable
  public static func ==(
    lhs: Quaternion<Scalar>,
    rhs: Quaternion<Scalar>) -> Bool {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(lhs.isValid)
    pedantic_assert(rhs.isValid)
    // /////////////////////////////////////////////////////////////////////////
    return lhs._storage == rhs._storage
  }

  @inlinable
  public static func !=(
    lhs: Quaternion<Scalar>,
    rhs: Quaternion<Scalar>) -> Bool {
    // /////////////////////////////////////////////////////////////////////////
    pedantic_assert(lhs.isValid)
    pedantic_assert(rhs.isValid)
    // /////////////////////////////////////////////////////////////////////////
    return lhs._storage != rhs._storage
  }

}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - Hashable
// -------------------------------------------------------------------------- //

extension Quaternion : Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    self._storage.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension Quaternion : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      return "(imaginaryComponent: (\(self.x), \(self.y), \(self.z)), realComponent: \(self.realComponent))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension Quaternion : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Quaternion<\(String(reflecting: Scalar.self))>(storage: \(String(reflecting: self._storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - Codable
// -------------------------------------------------------------------------- //

extension Quaternion : Codable {
  
  // synthesized ok
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - ExpressibleByArrayLiteral
// -------------------------------------------------------------------------- //

extension Quaternion : ExpressibleByArrayLiteral {
  
  public typealias ArrayLiteralElement = Scalar
  
  /// Format: `[x, y, z, real]`.
  @inlinable
  public init(arrayLiteral elements: ArrayLiteralElement...) {
    guard
      elements.count == 4,
      elements.allSatisfy({$0.isFinite}) else {
      fatalError("Invalid array-literal for `Quaternion<\(String(reflecting: Scalar.self))>: \(String(reflecting: elements))")
    }
    self.init(
      storage: Storage(
        x: elements[0],
        y: elements[1],
        z: elements[2],
        real: elements[3]
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - NumericAggregate
// -------------------------------------------------------------------------- //

extension Quaternion : NumericAggregate {
  
  public typealias NumericEntryRepresentation = Scalar
  
  @inlinable
  public func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    return self._storage.allNumericEntriesSatisfy(
      predicate
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - NativeSIMDRepresentable
// -------------------------------------------------------------------------- //

extension Quaternion : NativeSIMDRepresentable {

  public typealias NativeSIMDRepresentation = Storage.NativeSIMDRepresentation
  public typealias NativeSIMDScalar = Scalar
  
  @inlinable
  public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
    self.init(
      storage: Storage(
        nativeSIMDRepresentation: nativeSIMDRepresentation
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: Quaternion - QuaternionMathProtocol
// -------------------------------------------------------------------------- //

extension Quaternion : QuaternionMathProtocol {
  
  public typealias Vector3 = Storage.Vector3
  
  /// The real (scalar) part of `self`.
  @inlinable
  public var realComponent: Scalar {
    get {
      return self._storage.realComponent
    }
    set {
      // ///////////////////////////////////////////////////////////////////////
      pedantic_assert(newValue.isFinite)
      pedantic_assert(self.isValid)
      defer { pedantic_assert(self.isValid) }
      // ///////////////////////////////////////////////////////////////////////
      self._storage.realComponent = newValue
    }
  }
  
  /// The imaginary (vector) part of `self`.
  @inlinable
  public var imaginaryComponent: Vector3 {
    get {
      return self._storage.imaginaryComponent
    }
    set {
      // ///////////////////////////////////////////////////////////////////////
      pedantic_assert(newValue.isFinite)
      pedantic_assert(self.isValid)
      defer { pedantic_assert(self.isValid) }
      // ///////////////////////////////////////////////////////////////////////
      self._storage.imaginaryComponent = newValue
    }
  }
  
  /// The angle (in radians) by which `self`'s action rotates.
  @inlinable
  public var angleInRadians: Scalar {
    get {
      return self._storage.angleInRadians
    }
  }
  
  /// The normalized axis about which `self`'s action rotates.
  @inlinable
  public var rotationAxis: Vector3 {
    get {
      return self._storage.rotationAxis
    }
  }
  
  /// The length of the quaternion interpreted as a 4d vector.
  @inlinable
  public var length: Scalar {
    get {
      return self._storage.length
    }
  }
  
  /// Applies the rotation represented by a unit quaternion to the vector and
  /// returns the result.
  @inlinable
  public func apply(to vector: Vector3) -> Vector3 {
    return self.storage.apply(to: vector)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Normalization
  // ------------------------------------------------------------------------ //
  
  /// Returns a unit quaternion obtained via `self/self.length`.
  ///
  /// - precondition: `self != .zero`
  ///
  @inlinable
  public func normalized() -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.normalized()
    )
  }
  
  /// In-place mutates `self` into a unit quaternion obtained via `self/self.length`.
  ///
  /// - precondition: `self != .zero`
  ///
  @inlinable
  public mutating func formNormalization() {
    self._storage.formNormalization()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Inversion
  // ------------------------------------------------------------------------ //
  
  /// Returns the inverse of `self`.
  ///
  /// - precondition: `self != .zero`
  ///
  @inlinable
  public func inverted() -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.inverted()
    )
  }
  
  /// In-place mutates `self` into its inverse.
  ///
  ///
  /// - precondition: `self != .zero`
  ///
  @inlinable
  public mutating func formInverse() {
    self._storage.formInverse()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Conjugation
  // ------------------------------------------------------------------------ //
  
  /// Returns the conjugate of `self`.
  @inlinable
  public func conjugated() -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.conjugated()
    )
  }
  
  /// In-place mutates `self` into its conjugate.
  @inlinable
  public mutating func formConjugate() {
    self._storage.formConjugate()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Negation
  // ------------------------------------------------------------------------ //
  
  /// Returns the negation of `self`.
  @inlinable
  public func negated() -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.negated()
    )
  }
  
  /// In-place mutates `self` into its negation.
  @inlinable
  public mutating func formNegation() {
    self._storage.formNegation()
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Addition
  // ------------------------------------------------------------------------ //
  
  /// Returns the sum of `self` and `other`.
  @inlinable
  public func adding(_ other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.adding(other._storage)
    )
  }
  
  /// In-place adds `other` into  `self`.
  @inlinable
  public mutating func formAddition(of other: Quaternion<Scalar>) {
    self._storage.formAddition(of: other._storage)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: FMA
  // ------------------------------------------------------------------------ //
  
  /// Returns the sum of `self` and `factor * other`.
  @inlinable
  public func adding(
    _ other: Quaternion<Scalar>,
    multipliedBy factor: Scalar) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.adding(
        other._storage,
        multipliedBy: factor
      )
    )
  }
  
  /// In-place adds `factor * other` into  `self`.
  @inlinable
  public mutating func formAddition(
    of other: Quaternion<Scalar>,
    multipliedBy factor: Scalar) {
    self._storage.formAddition(
      of: other._storage,
      multipliedBy: factor
    )
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Subtraction
  // ------------------------------------------------------------------------ //
  
  /// Returns the result of subtracting `other` from `self`.
  @inlinable
  public func subtracting(_ other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.subtracting(other._storage)
    )
  }
  
  /// In-place subtracts `other` from `self`.
  @inlinable
  public mutating func formSubtraction(of other: Quaternion<Scalar>) {
    self._storage.formSubtraction(of: other._storage)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` multiplied-by `factor`.
  @inlinable
  public func multiplied(by factor: Scalar) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.multiplied(by: factor)
    )
  }
  
  /// In-place multiplies `self` by `factor`.
  @inlinable
  public mutating func formMultiplication(by factor: Scalar) {
    self._storage.formMultiplication(by: factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Scalar Division
  // ------------------------------------------------------------------------ //
  
  /// Returns `self` divided-by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  @inlinable
  public func divided(by factor: Scalar) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.divided(by: factor)
    )
  }
  
  /// In-place divides`self` by `factor`.
  ///
  /// - precondition: `factor.isNonZero`
  ///
  @inlinable
  public mutating func formDivision(by factor: Scalar) {
    self._storage.formDivision(by: factor)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Multiplication
  // ------------------------------------------------------------------------ //
  
  /// Returns `self * other`.
  @inlinable
  public func multiplied(onRightBy other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.multiplied(
        onRightBy: other._storage
      )
    )
  }
  
  /// Returns `other * self`.
  @inlinable
  public func multiplied(onLeftBy other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.multiplied(
        onLeftBy: other._storage
      )
    )
  }
  
  /// In-place sets `self = self * other`.
  @inlinable
  public mutating func formMultiplication(onRightBy other: Quaternion<Scalar>) {
    self._storage.formMultiplication(onRightBy: other._storage)
  }
  
  /// In-place sets `self = other * self`.
  @inlinable
  public mutating func formMultiplication(onLeftBy other: Quaternion<Scalar>) {
    self._storage.formMultiplication(onLeftBy: other._storage)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Quaternion Division
  // ------------------------------------------------------------------------ //
  
  /// Returns `self * (1/other)`.
  @inlinable
  public func divided(onRightBy other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.divided(
        onRightBy: other._storage
      )
    )
  }
  
  /// Returns `(1/other) * self`.
  @inlinable
  public func divided(onLeftBy other: Quaternion<Scalar>) -> Quaternion<Scalar> {
    return Quaternion<Scalar>(
      storage: self._storage.divided(
        onLeftBy: other._storage
      )
    )
  }
  
  /// In-place sets `self = self * (1/other)`.
  @inlinable
  public mutating func formDivision(onRightBy other: Quaternion<Scalar>) {
    self._storage.formDivision(
      onRightBy: other._storage
    )
  }
  
  /// In-place sets `self = (1/other) * self`.
  @inlinable
  public mutating func formDivision(onLeftBy other: Quaternion<Scalar>) {
    self._storage.formDivision(
      onLeftBy: other._storage
    )
  }
  
}
