import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add2x2CompatibleMatrices
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDHashable
@TwoColumnNativeSIMDCodable
public struct FloatMatrix2x2Storage :
  Matrix2x2Protocol,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Sendable
{

  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  
}
