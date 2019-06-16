//
//  SIMDMatrix3x3CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix4x2<Double>`.
public protocol SIMDMatrix3x3CapableProtocol {
  
  associatedtype SIMDMatrix3x3Storage: SIMDMatrix3x3StorageProtocol
    where SIMDMatrix3x3Storage.Scalar == Self
  
}
