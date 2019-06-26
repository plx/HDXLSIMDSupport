//
//  Passthrough+NativeSIMDRepresentable.swift
//

import Foundation
import simd
import HDXLCommonUtilities
//
//public extension Passthrough where PassthroughValue:NativeSIMDRepresentable {
//  
//  @inlinable
//  init() {
//    self.init(passthroughValue: PassthroughValue())
//  }
//  
//  @inlinable
//  var nativeSIMDRepresentation: PassthroughValue.NativeSIMDRepresentation {
//    get {
//      return self.passthroughValue.nativeSIMDRepresentation
//    }
//    set {
//      self.passthroughValue.nativeSIMDRepresentation = newValue
//    }
//  }
//  
//  @inlinable
//  init(nativeSIMDRepresentation: PassthroughValue.NativeSIMDRepresentation) {
//    self.init(
//      passthroughValue: PassthroughValue(
//        nativeSIMDRepresentation: nativeSIMDRepresentation
//      )
//    )
//  }
//  
//}
