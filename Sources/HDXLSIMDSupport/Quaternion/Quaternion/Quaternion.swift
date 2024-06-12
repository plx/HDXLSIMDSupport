//
//  Quaternion.swift
//

import Foundation
import simd
import SwiftUI

@frozen
public struct Quaternion<Scalar:ExtendedSIMDScalar> :
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{
  
  public typealias CompatibleMatrix3x3 = Matrix3x3<Scalar>
  public typealias CompatibleMatrix4x4 = Matrix4x4<Scalar>
  
  public typealias PassthroughValue = Scalar.QuaternionStorage
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation
  
  public typealias NativeSIMDRepresentation = PassthroughValue.PassthroughValue
  
  public var passthroughValue: PassthroughValue
  
  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }
  
  @inlinable
  public var nativeSIMDRepresentation: NativeSIMDRepresentation {
    get {
      return passthroughValue.passthroughValue
    }
    set {
      passthroughValue.passthroughValue = newValue
    }
  }
  
  @inlinable
  public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
    self.init(
      passthroughValue: PassthroughValue(
        passthroughValue: nativeSIMDRepresentation
      )
    )
  }

  @inlinable
  public var description: String {
    get {
      return "Quaternion: \(String(describing: nativeSIMDRepresentation))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Quaternion<\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \(String(reflecting: nativeSIMDRepresentation)))"
    }
  }

  @inlinable
  public static var zero: Quaternion<Scalar> {
    get {
      return Quaternion<Scalar>()
    }
  }
  
  @inlinable
  public var magnitudeSquared: Double {
    get {
      return Double(componentwiseMagnitudeSquared)
    }
  }
  
  @inlinable
  public mutating func scale(by factor: Double) {
    formMultiplication(
      by: Scalar(factor)
    )
  }

}

extension Quaternion: Sendable where Scalar.QuaternionStorage: Sendable { }
