import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add4x2CompatibleMatrices
@FourColumnNumericAggregate
@FourColumnNativeSIMDHashable
@FourColumnNativeSIMDCodable
public struct FloatMatrix4x2Storage :
  Matrix4x2Protocol,
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
