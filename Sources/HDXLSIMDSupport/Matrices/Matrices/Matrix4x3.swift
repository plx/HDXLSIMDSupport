//
//  Matrix4x3.swift
//

import Foundation
import simd
import SwiftUI
import HDXLCommonUtilities

public struct Matrix4x3<Scalar:ExtendedSIMDScalar>  :
  Matrix4x3Protocol,
  MatrixOperatorSupportProtocol,
  Matrix4x3OperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  VectorArithmetic {
  
  public typealias CompatibleMatrix4x4 = Matrix4x4<Scalar>
  public typealias CompatibleMatrix3x3 = Matrix3x3<Scalar>
  public typealias CompatibleMatrix2x3 = Matrix2x3<Scalar>
  public typealias CompatibleMatrix3x2 = Matrix3x2<Scalar>
  public typealias CompatibleMatrix2x4 = Matrix2x4<Scalar>
  public typealias CompatibleMatrix4x2 = Matrix4x2<Scalar>
  public typealias CompatibleMatrix3x4 = Matrix3x4<Scalar>
  
  public typealias PassthroughValue = Scalar.Matrix4x3Storage
  public typealias Scalar = PassthroughValue.Scalar
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
      return "Matrix4x3: \(String(describing: self.nativeSIMDRepresentation))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Matrix4x3<\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \(String(reflecting: self.nativeSIMDRepresentation)))"
    }
  }
  
  @inlinable
  public static var zero: Matrix4x3<Scalar> {
    get {
      return Matrix4x3<Scalar>()
    }
  }
  
  @inlinable
  public var magnitudeSquared: Double {
    get {
      return Double(self.componentwiseMagnitudeSquared)
    }
  }
  
  @inlinable
  public mutating func scale(by factor: Double) {
    self.formMultiplication(
      by: Scalar(factor)
    )
  }

}
