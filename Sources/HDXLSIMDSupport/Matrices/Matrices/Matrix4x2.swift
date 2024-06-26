import Foundation
import simd
import SwiftUI
import HDXLSIMDSupportProtocols
import HDXLSIMDSupportMacros

@frozen
@AddMatrixStorage
@StorageNumericAggregate
@StorageNativeSIMDRepresentable
@SwiftUIVectorArithmetic
public struct Matrix4x2<Scalar:ExtendedSIMDScalar>  :
  Matrix4x2Protocol,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{
  
  public typealias CompatibleMatrix4x4 = Matrix4x4<Scalar>
  public typealias CompatibleMatrix2x2 = Matrix2x2<Scalar>
  public typealias CompatibleMatrix2x3 = Matrix2x3<Scalar>
  public typealias CompatibleMatrix3x2 = Matrix3x2<Scalar>
  public typealias CompatibleMatrix2x4 = Matrix2x4<Scalar>
  public typealias CompatibleMatrix3x4 = Matrix3x4<Scalar>
  public typealias CompatibleMatrix4x3 = Matrix4x3<Scalar>
  
  public typealias Scalar = PassthroughValue.Scalar
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  
}

extension Matrix4x2: Sendable where Scalar.Matrix4x2Storage: Sendable { }
