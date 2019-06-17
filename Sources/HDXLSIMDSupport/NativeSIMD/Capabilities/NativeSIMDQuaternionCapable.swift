//
//  NativeSIMDQuaternionCapable.swift
//

import Foundation

public protocol NativeSIMDQuaternionCapable : NativeSIMDMatrixCapable {
  
  associatedtype NativeSIMDQuaternion: NativeSIMDQuaternionProtocol
    where
    Self == NativeSIMDQuaternion.NativeSIMDScalar,
    Self.NativeSIMDMatrix3x3 == NativeSIMDQuaternion.NativeSIMDRotationMatrix3x3,
    Self.NativeSIMDMatrix4x4 == NativeSIMDQuaternion.NativeSIMDRotationMatrix4x4
  
}
