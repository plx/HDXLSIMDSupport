//
//  Matrix3x3.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public struct Matrix3x3<Scalar:ExtendedSIMDScalar>  :
  Matrix3x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix3x3OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable {
  
  public typealias CompatibleQuaternion = Quaternion<Scalar>
  
  public typealias CompatibleMatrix2x3 = Matrix2x3<Scalar>
  public typealias CompatibleMatrix3x2 = Matrix3x2<Scalar>
  public typealias CompatibleMatrix3x4 = Matrix3x4<Scalar>
  public typealias CompatibleMatrix4x3 = Matrix4x3<Scalar>
  
  public typealias PassthroughValue = Scalar.Matrix3x3Storage
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
      return self.passthroughValue.passthroughValue
    }
    set {
      self.passthroughValue.passthroughValue = newValue
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
  public var description: String {
    get {
      return "Matrix3x3: \(String(describing: self.nativeSIMDRepresentation))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Matrix3x3<\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \(String(reflecting: self.nativeSIMDRepresentation)))"
    }
  }
  
}
