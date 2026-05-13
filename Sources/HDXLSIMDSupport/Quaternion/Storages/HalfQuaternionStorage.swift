//
//  HalfQuaternionStorage.swift
//

import Foundation
import simd

@frozen
public struct HalfQuaternionStorage :
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  Passthrough,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{

  public typealias CompatibleMatrix3x3 = HalfMatrix3x3Storage
  public typealias CompatibleMatrix4x4 = HalfMatrix4x4Storage

  public typealias PassthroughValue = simd_quath
  public typealias Scalar = PassthroughValue.Scalar
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation

  @usableFromInline
  internal typealias QVector = SIMD4<Scalar>

  public var passthroughValue: PassthroughValue

  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }

  @inlinable
  public func hash(into hasher: inout Hasher) {
    passthroughValue.vector.hash(into: &hasher)
  }

  @inlinable
  public var description: String {
    get {
      return "HalfQuaternionStorage: \(String(describing: passthroughValue))"
    }
  }

  @inlinable
  public var debugDescription: String {
    get {
      return "HalfQuaternionStorage(passthroughValue: \(String(reflecting: passthroughValue)))"
    }
  }

  @inlinable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(passthroughValue.vector)
  }

  @inlinable
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let vector = try container.decode(QVector.self)
    self.init(
      passthroughValue: PassthroughValue(vector: vector)
    )
  }

}
