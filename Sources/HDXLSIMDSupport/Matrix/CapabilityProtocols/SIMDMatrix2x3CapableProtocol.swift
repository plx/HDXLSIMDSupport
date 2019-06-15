//
//  SIMDMatrix2x3CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix2x3<Double>`.
public protocol SIMDMatrix2x3CapableProtocol {
  
  associatedtype SIMDMatrix2x3Storage: SIMDMatrix2x3StorageProtocol
    where SIMDMatrix2x3Storage.Scalar == Self
  
}
