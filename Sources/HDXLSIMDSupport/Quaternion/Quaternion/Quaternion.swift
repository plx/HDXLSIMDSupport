//
//  Quaternion.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public struct Quaternion<Scalar:ExtendedSIMDScalar> :
  QuaternionProtocol,
  QuaternionOperatorSupportProtocol,
  Passthrough,
  NativeSIMDRepresentable,
  NumericAggregate,
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable {
  
  public typealias CompatibleMatrix3x3 = Matrix3x3<Scalar>
  public typealias CompatibleMatrix4x4 = Matrix4x4<Scalar>
  
  public typealias PassthroughValue = Scalar.QuaternionStorage
  public typealias NumericEntryRepresentation = PassthroughValue.NumericEntryRepresentation
  
  public typealias NativeSIMDRepresentation = PassthroughValue.PassthroughValue
  
  public var passthroughValue: PassthroughValue
  
  @inlinable
  public init(passthroughValue: PassthroughValue) {
    self.passthroughValue = passthroughValue
  }
  
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
      return "Quaternion: \(String(describing: self.nativeSIMDRepresentation))"
    }
  }
  
  @inlinable
  public var debugDescription: String {
    get {
      return "Quaternion<\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \(String(reflecting: self.nativeSIMDRepresentation)))"
    }
  }

}
