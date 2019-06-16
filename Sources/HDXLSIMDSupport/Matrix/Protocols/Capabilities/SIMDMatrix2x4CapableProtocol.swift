//
//  SIMDMatrix2x4CapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Semi-artificial protocol that exists we can (eventually!) write `Matrix2x4<Double>`.
public protocol SIMDMatrix2x4CapableProtocol {
  
  associatedtype SIMDMatrix2x4Storage: SIMDMatrix2x4StorageProtocol
    where SIMDMatrix2x4Storage.Scalar == Self
  
}
