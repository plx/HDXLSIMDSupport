import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

//@DebugDescription
@frozen
public struct DoubleQuaternionStorage :
  QuaternionProtocol,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  Sendable
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

