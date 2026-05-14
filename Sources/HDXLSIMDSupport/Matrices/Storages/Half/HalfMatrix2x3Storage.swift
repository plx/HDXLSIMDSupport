//
//  HalfMatrix2x3Storage.swift
//

import Foundation
import simd

@frozen
public struct HalfMatrix2x3Storage :
  Matrix2x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix2x3OperatorSupportProtocol,
  Passthrough,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{

  public typealias CompatibleMatrix2x2 = HalfMatrix2x2Storage
  public typealias CompatibleMatrix3x3 = HalfMatrix3x3Storage
  public typealias CompatibleMatrix3x2 = HalfMatrix3x2Storage
  public typealias CompatibleMatrix2x4 = HalfMatrix2x4Storage
  public typealias CompatibleMatrix4x2 = HalfMatrix4x2Storage
  public typealias CompatibleMatrix3x4 = HalfMatrix3x4Storage
  public typealias CompatibleMatrix4x3 = HalfMatrix4x3Storage

  public typealias PassthroughValue = simd_half2x3
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation

  @usableFromInline
  internal static var typename: String {
    get {
      return "HalfMatrix2x3Storage"
    }
  }

  public var passthroughValue: PassthroughValue

  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }

  @inlinable
  public func hash(into hasher: inout Hasher) {
    columns.0.hash(into: &hasher)
    columns.1.hash(into: &hasher)
  }

  @inlinable
  public var description: String {
    get {
      return "\(type(of: self).typename): \(String(describing: passthroughValue))"
    }
  }

  @inlinable
  public var debugDescription: String {
    get {
      return "\(type(of: self).typename)(passthroughValue: \(String(reflecting: passthroughValue)))"
    }
  }

  public enum CodingKeys: String, CodingKey {

    case c0 = "c0"
    case c1 = "c1"

    @inlinable
    public var intValue: Int? {
      get {
        switch self {
        case .c0:
          return 0
        case .c1:
          return 1
        }
      }
    }

    @inlinable
    public init?(intValue: Int) {
      switch intValue {
      case 0:
        self = .c0
      case 1:
        self = .c1
      default:
        return nil
      }
    }

  }

  @inlinable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(columns.0, forKey: .c0)
    try container.encode(columns.1, forKey: .c1)
  }

  @inlinable
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let c0 = try container.decode(ColumnVector.self, forKey: .c0)
    let c1 = try container.decode(ColumnVector.self, forKey: .c1)
    self.init(
      passthroughValue: PassthroughValue(columns: (c0, c1))
    )
  }

}
