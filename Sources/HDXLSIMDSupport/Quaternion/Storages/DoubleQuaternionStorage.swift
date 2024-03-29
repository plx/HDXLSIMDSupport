//
//  DoubleQuaternionStorage.swift
//

import Foundation
import simd

@frozen
public struct DoubleQuaternionStorage :
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  Passthrough,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{
  
  public typealias CompatibleMatrix3x3 = DoubleMatrix3x3Storage
  public typealias CompatibleMatrix4x4 = DoubleMatrix4x4Storage
  
  public typealias PassthroughValue = simd_quatd
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
      return "DoubleQuaternionStorage: \(String(describing: passthroughValue))"
    }
  }

  @inlinable
  public var debugDescription: String {
    get {
      return "DoubleQuaternionStorage(passthroughValue: \(String(reflecting: passthroughValue)))"
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

