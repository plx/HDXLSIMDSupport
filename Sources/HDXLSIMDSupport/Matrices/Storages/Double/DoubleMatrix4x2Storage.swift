import Foundation
import simd

@frozen
public struct DoubleMatrix4x2Storage :
  Matrix4x2Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x2OperatorSupportProtocol,
  Passthrough,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  Sendable
{
  
  public typealias CompatibleMatrix4x4 = DoubleMatrix4x4Storage
  public typealias CompatibleMatrix2x2 = DoubleMatrix2x2Storage
  public typealias CompatibleMatrix2x3 = DoubleMatrix2x3Storage
  public typealias CompatibleMatrix3x2 = DoubleMatrix3x2Storage
  public typealias CompatibleMatrix2x4 = DoubleMatrix2x4Storage
  public typealias CompatibleMatrix3x4 = DoubleMatrix3x4Storage
  public typealias CompatibleMatrix4x3 = DoubleMatrix4x3Storage

  public typealias PassthroughValue = simd_double4x2
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation

  // ------------------------------------------------------------------------ //
  // MARK: Typename
  // ------------------------------------------------------------------------ //
  
  @usableFromInline
  internal static var typename: String {
    "DoubleMatrix4x2Storage"
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Passthrough
  // ------------------------------------------------------------------------ //
  
  public var passthroughValue: PassthroughValue
  
  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: Hashable
  // ------------------------------------------------------------------------ //
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    columns.0.hash(into: &hasher)
    columns.1.hash(into: &hasher)
    columns.2.hash(into: &hasher)
    columns.3.hash(into: &hasher)
  }
    
  // ------------------------------------------------------------------------ //
  // MARK: Codable
  // ------------------------------------------------------------------------ //
  
  public enum CodingKeys: String, CodingKey {
    
    case c0 = "c0"
    case c1 = "c1"
    case c2 = "c2"
    case c3 = "c3"
    
    @inlinable
    public var intValue: Int? {
      switch self {
      case .c0:
        return 0
      case .c1:
        return 1
      case .c2:
        return 2
      case .c3:
        return 3
      }
    }
    
    @inlinable
    public init?(intValue: Int) {
      switch intValue {
      case 0:
        self = .c0
      case 1:
        self = .c1
      case 2:
        self = .c2
      case 3:
        self = .c3
      default:
        return nil
      }
    }
    
  }
  
  @inlinable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(
      columns.0,
      forKey: .c0
    )
    try container.encode(
      columns.1,
      forKey: .c1
    )
    try container.encode(
      columns.2,
      forKey: .c2
    )
    try container.encode(
      columns.3,
      forKey: .c3
    )
  }
  
  @inlinable
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let c0 = try container.decode(
      ColumnVector.self,
      forKey: .c0
    )
    let c1 = try container.decode(
      ColumnVector.self,
      forKey: .c1
    )
    let c2 = try container.decode(
      ColumnVector.self,
      forKey: .c2
    )
    let c3 = try container.decode(
      ColumnVector.self,
      forKey: .c3
    )
    self.init(
      passthroughValue: PassthroughValue(
        c0,
        c1,
        c2,
        c3
      )
    )
  }

}
