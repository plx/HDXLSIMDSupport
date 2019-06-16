//
//  SIMDMatrix4x3CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix4x3<Double>`.
public protocol SIMDMatrix4x3CapableProtocol {
  
  associatedtype SIMDMatrix4x3Storage: SIMDMatrix4x3StorageProtocol
    where SIMDMatrix4x3Storage.Scalar == Self
  
}
