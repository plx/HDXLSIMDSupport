//
//  SIMDMatrix3x2CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix3x2<Double>`.
public protocol SIMDMatrix3x2CapableProtocol {
  
  associatedtype SIMDMatrix3x2Storage: SIMDMatrix3x2StorageProtocol
    where SIMDMatrix3x2Storage.Scalar == Self
  
}
