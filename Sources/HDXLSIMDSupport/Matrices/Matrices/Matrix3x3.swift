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
public struct Matrix3x3<Scalar:ExtendedSIMDScalar>  :
  Matrix3x3Protocol,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable
{
  
  public typealias CompatibleQuaternion = Quaternion<Scalar>
  
  public typealias CompatibleMatrix2x3 = Matrix2x3<Scalar>
  public typealias CompatibleMatrix3x2 = Matrix3x2<Scalar>
  public typealias CompatibleMatrix3x4 = Matrix3x4<Scalar>
  public typealias CompatibleMatrix4x3 = Matrix4x3<Scalar>
  
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  
}

extension Matrix3x3: Sendable where Scalar.Matrix3x3Storage: Sendable { }
