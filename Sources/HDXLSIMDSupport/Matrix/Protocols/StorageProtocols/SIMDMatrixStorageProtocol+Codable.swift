//
//  SIMDMatrixStorageProtocol+Codable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public enum SIMDMatrixError : Error {
  
  case emptyContainer(Any.Type)
  case encodedValueCountMismatch(Any.Type, expected: Int, encoded: Int)
  
}

public extension SIMDMatrixStorageProtocol where Scalar:Codable {
  
  @inlinable
  func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    for scalar in self.linearizedScalarValues {
      try container.encode(scalar)
    }
  }
  
  @inlinable
  init(from decoder: Decoder) throws {
    var values = try decoder.unkeyedContainer()
    guard let valueCount = values.count else {
      throw SIMDMatrixError.emptyContainer(Self.self)
    }
    guard valueCount == Self.scalarCount else {
      throw SIMDMatrixError.encodedValueCountMismatch(
        Self.self,
        expected: Self.scalarCount,
        encoded: valueCount
      )
    }
    self.init()
    for scalarIndex in 0..<Self.scalarCount {
      self[scalarIndex: scalarIndex] = try values.decode(Scalar.self)
    }
  }
  
}
