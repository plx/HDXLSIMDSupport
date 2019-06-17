//
//  NativeSIMDRepresentableProtocol.swift
//

import Foundation

public protocol NativeSIMDRepresentable {
  
  associatedtype NativeSIMDRepresentation: NativeSIMDProtocol
  typealias NativeSIMDScalar = NativeSIMDRepresentation.NativeSIMDScalar
  
  init(nativeSIMDRepresentation: NativeSIMDRepresentation)
  
}

public extension NativeSIMDRepresentable {
  
  @inlinable
  init() {
    self.init(nativeSIMDRepresentation: NativeSIMDRepresentation())
  }
  
}
