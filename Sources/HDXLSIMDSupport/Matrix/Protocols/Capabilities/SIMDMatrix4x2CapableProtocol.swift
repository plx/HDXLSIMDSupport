//
//  SIMDMatrix4x2CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix4x2<Double>`.
public protocol SIMDMatrix4x2CapableProtocol {
  
  associatedtype SIMDMatrix4x2Storage: SIMDMatrix4x2StorageProtocol
    where SIMDMatrix4x2Storage.Scalar == Self
  
}
