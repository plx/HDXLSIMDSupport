//
//  SIMDMatrixCapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

/// Shorthand for "capable for all known SIMD matrix types".
public typealias SIMDMatrixCapableProtocol =
  SIMDMatrix2x2CapableProtocol
  &
  SIMDMatrix2x3CapableProtocol
  &
  SIMDMatrix2x4CapableProtocol
  &
  SIMDMatrix3x2CapableProtocol
  &
  SIMDMatrix3x3CapableProtocol
  &
  SIMDMatrix3x4CapableProtocol
  &
  SIMDMatrix4x2CapableProtocol
  &
  SIMDMatrix4x3CapableProtocol
  &
  SIMDMatrix4x4CapableProtocol
