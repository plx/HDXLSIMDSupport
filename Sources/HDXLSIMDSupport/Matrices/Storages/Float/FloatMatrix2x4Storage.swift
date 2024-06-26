import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add2x4CompatibleMatrices
@TwoColumnNumericAggregate
@TwoColumnNativeSIMDHashable
@TwoColumnNativeSIMDCodable
public struct FloatMatrix2x4Storage :
  Matrix2x4Protocol,
  Passthrough,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Sendable
{
  
  public typealias NativeSIMDRepresentation = simd_float2x4
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns

}
