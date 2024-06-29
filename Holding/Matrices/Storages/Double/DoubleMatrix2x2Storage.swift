import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

//@DebugDescription
@frozen
@Add2x2CompatibleMatrices
@TwoColumnNativeSIMDHashable
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDCodable
public struct DoubleMatrix2x2Storage :
  Matrix2x2Protocol,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  Sendable
{
  
  //  public typealias CompatibleMatrix2x3 = DoubleMatrix2x3Storage
  //  public typealias CompatibleMatrix3x2 = DoubleMatrix3x2Storage
  //  public typealias CompatibleMatrix2x4 = DoubleMatrix2x4Storage
  //  public typealias CompatibleMatrix4x2 = DoubleMatrix4x2Storage
  //
  public typealias PassthroughValue = simd_double2x2
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  
  // ------------------------------------------------------------------------ //
  // MARK: Passthrough
  // ------------------------------------------------------------------------ //
  
  public var passthroughValue: PassthroughValue
  
  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }
  
}
