//
//  QuaternionStorageProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public protocol QuaternionStorageProtocol:
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  ExpressibleByArrayLiteral,
  QuaternionMathProtocol,
  NativeSIMDRepresentable,
  NumericAggregate
  where
  NativeSIMDRepresentation: NativeSIMDQuaternionProtocol,
  Scalar == NativeSIMDRepresentation.NativeSIMDScalar,
  Scalar == NumericEntryRepresentation {

  typealias NativeSIMDQuaternion = NativeSIMDRepresentation
  
  typealias Vector4 = SIMD4<Scalar>
  
  typealias NativeSIMDRotationMatrix3x3 = NativeSIMDQuaternion.NativeSIMDRotationMatrix3x3
  typealias NativeSIMDRotationMatrix4x4 = NativeSIMDQuaternion.NativeSIMDRotationMatrix4x4

  /// The zero quaternion
  init()	
  
  /// Directly-initialize
  init(nativeSIMDRepresentation representation: NativeSIMDRepresentation)
  
  /// Init with i,j,k, and real coefficients.
  init(i: Scalar, j: Scalar, k: Scalar, real: Scalar)
  
  /// Init with x,y,z and real coefficients.
  init(x: Scalar, y: Scalar, z: Scalar, real: Scalar)
  
  /// Construct a quaternion from real and imaginary parts.
  init(
    realComponent: Scalar,
    imaginaryComponent: Vector3)
  
  /// A quaternion whose action is a rotation by `angle` radians about `axis`.
  ///
  /// - Parameters:
  ///   - angle: The angle to rotate by measured in radians.
  ///   - axis: The axis to rotate around.
  init(
    angleInRadians angle: Scalar,
    rotationAxis axis: Vector3)
  
  /// A quaternion whose action rotates the vector `origin` onto the vector `destination`.
  init(
    rotating origin: Vector3,
    onto destination: Vector3)

  init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix3x3)
  init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix4x4)
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionStorageProtocol - Definition
// -------------------------------------------------------------------------- //

public extension QuaternionStorageProtocol {
  
  @inlinable
  init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix3x3) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDQuaternion(
        rotationMatrix: rotationMatrix
      )
    )
  }

  @inlinable
  init(nativeSIMDRotationMatrix rotationMatrix: NativeSIMDRotationMatrix4x4) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDQuaternion(
        rotationMatrix: rotationMatrix
      )
    )
  }

}
