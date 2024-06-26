import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add4x3CompatibleMatrices
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
public struct FloatMatrix4x3Storage :
  Matrix4x3Protocol,
  Passthrough,
  NativeSIMDRepresentable,
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
