//
//  SIMDMatrix4x4CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix4x4<Double>`.
public protocol SIMDMatrix4x4CapableProtocol {
  
  associatedtype SIMDMatrix4x4Storage: SIMDMatrix4x4StorageProtocol
    where SIMDMatrix4x4Storage.Scalar == Self
  
}
