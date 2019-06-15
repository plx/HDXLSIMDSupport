//
//  SIMDMatrix2x2CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix2x2<Double>`.
public protocol SIMDMatrix2x2CapableProtocol {
  
  associatedtype SIMDMatrix2x2Storage: SIMDMatrix2x2StorageProtocol
    where SIMDMatrix2x2Storage.Scalar == Self
  
}
