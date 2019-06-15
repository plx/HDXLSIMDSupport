//
//  simd_quatf+QuaternionStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

extension simd_quatf : QuaternionStorageProtocol {
  public typealias QuaternionScalar = Float
  
  @inlinable
  public static func slerpedQuaternion(
    path: QuaternionSlerpType,
    from q0: simd_quatf,
    to q1: simd_quatf,
    at t: QuaternionScalar) -> simd_quatf {
    switch path {
    case .shortest:
      return simd_slerp(
        q0,
        q1, t
      )
    case .longest:
      return simd_slerp_longest(
        q0,
        q1, t
      )
    }
  }

  @inlinable
  public var angleInRadians: QuaternionScalar {
    get {
      return self.angle
    }
  }
  
  @inlinable
  public var rotationAxis: Vector3 {
    get {
      return self.axis
    }
  }
  
  @inlinable
  public func apply(to vector: Vector3) -> Vector3 {
    return self.act(vector)
  }
  
}

