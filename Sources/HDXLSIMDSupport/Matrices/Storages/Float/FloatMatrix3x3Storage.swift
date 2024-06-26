import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddNativeSIMDBacking
@Add3x3CompatibleMatrices
@ThreeColumnNumericAggregate
@ThreeColumnNativeSIMDHashable
@ThreeColumnNativeSIMDCodable
public struct FloatMatrix3x3Storage :
  Matrix3x3Protocol,
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
