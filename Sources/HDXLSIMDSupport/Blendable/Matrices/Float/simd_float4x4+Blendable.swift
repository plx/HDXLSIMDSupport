//
//  simd_float4x4+Blendable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: simd_float4x4 - Blendable
// -------------------------------------------------------------------------- //

extension simd_float4x4 : Blendable {
  
  public typealias BlendingWeight = NativeSIMDScalar
  
  @inlinable
  public init(
    byBlending first: simd_float4x4,
    weight firstWeight: BlendingWeight,
    with other: simd_float4x4,
    weight otherWeight: BlendingWeight) {
    self.init()
    self = simd_linear_combination(
      firstWeight,
      first,
      otherWeight,
      other
    )
  }
  
  @inlinable
  public init(
    byInterpolatingFrom start: simd_float4x4,
    towards limit: simd_float4x4,
    at distance: BlendingWeight) {
    self.init()
    self = simd_linear_combination(
      (1.0 - distance),
      start,
      distance,
      limit
    )
  }
  
  @inlinable
  public func incorporating(
    _ other: simd_float4x4,
    at weight: BlendingWeight) -> simd_float4x4 {
    return self + (weight * other)
  }

  @inlinable
  public func blended(
    at weight: BlendingWeight,
    with other: simd_float4x4,
    weight otherWeight: BlendingWeight) -> simd_float4x4 {
    return simd_linear_combination(
      weight,
      self,
      otherWeight,
      other
    )
  }
  
  @inlinable
  public func interpolated(
    at distance: BlendingWeight,
    towards other: simd_float4x4) -> simd_float4x4 {
    return simd_linear_combination(
      (1.0 - distance),
      self,
      distance,
      other
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: simd_float4x4 - InPlaceBlendable
// -------------------------------------------------------------------------- //

extension simd_float4x4 : InPlaceBlendable {
  
  @inlinable
  public mutating func becomeBlend(
    of first: simd_float4x4,
    weight firstWeight: BlendingWeight,
    with other: simd_float4x4,
    weight otherWeight: BlendingWeight) {
    self = simd_linear_combination(
      firstWeight,
      first,
      otherWeight,
      other
    )
  }

  @inlinable
  public mutating func becomeInterpolation(
    from start: simd_float4x4,
    to limit: simd_float4x4,
    at distance: BlendingWeight) {
    self = simd_linear_combination(
      (1.0 - distance),
      start,
      distance,
      limit
    )
  }
  
  @inlinable
  public mutating func formIncorporation(
    of other: simd_float4x4,
    weight otherWeight: BlendingWeight) {
    self += (otherWeight * other)
  }
  
  @inlinable
  public mutating func formBlend(
    at weight: BlendingWeight,
    of other: simd_float4x4,
    weight otherWeight: BlendingWeight) {
    self = simd_linear_combination(
      weight,
      self,
      otherWeight,
      other
    )
  }

  @inlinable
  public mutating func formInterpolation(
    at distance: BlendingWeight,
    towards other: simd_float4x4) {
    self *= (1.0 - distance)
    self += (distance * other)
  }

}
