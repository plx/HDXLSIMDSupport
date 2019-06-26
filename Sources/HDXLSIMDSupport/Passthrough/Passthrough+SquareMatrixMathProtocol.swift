//
//  Passthrough+SquareMatrixMathProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities
//
//public extension Passthrough where PassthroughValue: SquareMatrixMathProtocol {
//
//  @inlinable
//  var determinant: PassthroughValue.Scalar {
//    get {
//      return self.passthroughValue.determinant
//    }
//  }
//  
//  @inlinable
//  func inverted() -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.inverted()
//    )
//  }
//  
//  @inlinable
//  mutating func formInverse() {
//    self.passthroughValue.formInverse()
//  }
//  
//  @inlinable
//  func transposed() -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.transposed()
//    )
//  }
//  
//  @inlinable
//  mutating func formTranspose() {
//    self.passthroughValue.formTranspose()
//  }
//  
//  @inlinable
//  func multiplied(onRightBy rhs: Self) -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.multiplied(
//        onRightBy: rhs.passthroughValue
//      )
//    )
//  }
//  
//  @inlinable
//  func multiplied(onLeftBy lhs: Self) -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.multiplied(
//        onLeftBy: lhs.passthroughValue
//      )
//    )
//  }
//  
//  @inlinable
//  mutating func formMultiplication(onRightBy rhs: Self) {
//    self.passthroughValue.formMultiplication(
//      onRightBy: rhs.passthroughValue
//    )
//  }
//  
//  @inlinable
//  mutating func formMultiplication(onLeftBy lhs: Self) {
//    self.passthroughValue.formMultiplication(
//      onLeftBy: lhs.passthroughValue
//    )
//  }
//  
//  @inlinable
//  func divided(onRightBy rhs: Self) -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.divided(
//        onRightBy: rhs.passthroughValue
//      )
//    )
//  }
//
//  @inlinable
//  func divided(onLeftBy lhs: Self) -> Self {
//    return Self(
//      passthroughValue: self.passthroughValue.divided(
//        onLeftBy: lhs.passthroughValue
//      )
//    )
//  }
//  
//  @inlinable
//  mutating func formDivision(onRightBy rhs: Self) {
//    self.passthroughValue.formDivision(
//      onRightBy: rhs.passthroughValue
//    )
//  }
//  
//  @inlinable
//  mutating func formDivision(onLeftBy lhs: Self) {
//    self.passthroughValue.formDivision(
//      onLeftBy: lhs.passthroughValue
//    )
//  }
//  
//}
