//
//  SIMDMatrix3x4CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix3x4<Double>`.
public protocol SIMDMatrix3x4CapableProtocol {
  
  associatedtype SIMDMatrix3x4Storage: SIMDMatrix3x4StorageProtocol
    where SIMDMatrix3x4Storage.Scalar == Self
  
}
