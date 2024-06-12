import Foundation
import simd
import SwiftUI

@frozen
public struct Matrix4x4<Scalar:ExtendedSIMDScalar>  :
  Matrix4x4Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x4OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic
{
  
  public typealias CompatibleQuaternion = Quaternion<Scalar>
  
  public typealias CompatibleMatrix2x4 = Matrix2x4<Scalar>
  public typealias CompatibleMatrix4x2 = Matrix4x2<Scalar>
  public typealias CompatibleMatrix3x4 = Matrix3x4<Scalar>
  public typealias CompatibleMatrix4x3 = Matrix4x3<Scalar>
  
  public typealias PassthroughValue = Scalar.Matrix4x4Storage
  public typealias RowVector = PassthroughValue.RowVector
  public typealias ColumnVector = PassthroughValue.ColumnVector
  public typealias DiagonalVector = PassthroughValue.DiagonalVector
  public typealias Rows = PassthroughValue.Rows
  public typealias Columns = PassthroughValue.Columns
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation

  public var passthroughValue: PassthroughValue
  
  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }
  
  public typealias NativeSIMDRepresentation = PassthroughValue.PassthroughValue
  
  @inlinable
  public var nativeSIMDRepresentation: NativeSIMDRepresentation {
    get {
      passthroughValue.passthroughValue
    }
    set {
      passthroughValue.passthroughValue = newValue
    }
  }
  
  @inlinable
  public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
    self.init(
      passthroughValue: PassthroughValue(
        passthroughValue: nativeSIMDRepresentation
      )
    )
  }

  @inlinable
  public static var zero: Matrix4x4<Scalar> {
    Matrix4x4<Scalar>()
  }
  
  @inlinable
  public var magnitudeSquared: Double {
    Double(componentwiseMagnitudeSquared)
  }
  
  @inlinable
  public mutating func scale(by factor: Double) {
    formMultiplication(
      by: Scalar(factor)
    )
  }

}

extension Matrix4x4: Sendable where Scalar.Matrix4x4Storage: Sendable { }
