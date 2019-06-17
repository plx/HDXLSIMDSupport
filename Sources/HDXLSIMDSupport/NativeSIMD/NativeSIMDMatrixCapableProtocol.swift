//
//  NativeSIMDMatrixCapableProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public protocol NativeSIMDMatrixCapable {
  
  associatedtype NativeSIMDMatrix2x2: NativeSIMDMatrix2x2Protocol
    where Self == NativeSIMDMatrix2x2.NativeSIMDScalar

  associatedtype NativeSIMDMatrix2x3: NativeSIMDMatrix2x3Protocol
    where Self == NativeSIMDMatrix2x3.NativeSIMDScalar

  associatedtype NativeSIMDMatrix2x4: NativeSIMDMatrix2x4Protocol
    where Self == NativeSIMDMatrix2x4.NativeSIMDScalar

  associatedtype NativeSIMDMatrix3x2: NativeSIMDMatrix3x2Protocol
    where Self == NativeSIMDMatrix3x2.NativeSIMDScalar
  
  associatedtype NativeSIMDMatrix3x3: NativeSIMDMatrix3x3Protocol
    where Self == NativeSIMDMatrix3x3.NativeSIMDScalar
  
  associatedtype NativeSIMDMatrix3x4: NativeSIMDMatrix3x4Protocol
    where Self == NativeSIMDMatrix3x4.NativeSIMDScalar

  associatedtype NativeSIMDMatrix4x2: NativeSIMDMatrix4x2Protocol
    where Self == NativeSIMDMatrix4x2.NativeSIMDScalar
  
  associatedtype NativeSIMDMatrix4x3: NativeSIMDMatrix4x3Protocol
    where Self == NativeSIMDMatrix4x3.NativeSIMDScalar
  
  associatedtype NativeSIMDMatrix4x4: NativeSIMDMatrix4x4Protocol
    where Self == NativeSIMDMatrix4x4.NativeSIMDScalar

}
