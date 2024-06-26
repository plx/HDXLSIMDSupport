import Foundation
import simd
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add4x4CompatibleMatrices
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
public struct FloatMatrix4x4Storage :
  Matrix4x4Protocol,
  Passthrough,
  NativeSIMDRepresentable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Sendable
{
  
  public typealias CompatibleQuaternion = FloatQuaternionStorage
  
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  
}
