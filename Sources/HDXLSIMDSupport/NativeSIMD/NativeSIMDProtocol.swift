//
//  NativeSIMDProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Artificial protocol used to tag the native SIMD types with their native SIMD scalar.
public protocol NativeSIMDProtocol {
  
  /// The type of scalar of-which the native SIMD type is comprised.
  associatedtype NativeSIMDScalar
  
}
