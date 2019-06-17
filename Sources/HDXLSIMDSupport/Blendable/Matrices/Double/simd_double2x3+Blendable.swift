//
//  simd_double2x3+Blendable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: simd_double2x3 - Blendable
// -------------------------------------------------------------------------- //

extension simd_double2x3 : Blendable {
  
  public typealias BlendingWeight = NativeSIMDScalar
  
  @inlinable
  public init(
    byBlending first: simd_double2x3,
    weight firstWeight: BlendingWeight,
    with other: simd_double2x3,
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
    byInterpolatingFrom start: simd_double2x3,
    towards limit: simd_double2x3,
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
    _ other: simd_double2x3,
    at weight: BlendingWeight) -> simd_double2x3 {
    return self + (weight * other)
  }

  @inlinable
  public func blended(
    at weight: BlendingWeight,
    with other: simd_double2x3,
    weight otherWeight: BlendingWeight) -> simd_double2x3 {
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
    towards other: simd_double2x3) -> simd_double2x3 {
    return simd_linear_combination(
      (1.0 - distance),
      self,
      distance,
      other
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: simd_double2x3 - InPlaceBlendable
// -------------------------------------------------------------------------- //

extension simd_double2x3 : InPlaceBlendable {
  
  @inlinable
  public mutating func becomeBlend(
    of first: simd_double2x3,
    weight firstWeight: BlendingWeight,
    with other: simd_double2x3,
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
    from start: simd_double2x3,
    to limit: simd_double2x3,
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
    of other: simd_double2x3,
    weight otherWeight: BlendingWeight) {
    self += (otherWeight * other)
  }
  
  @inlinable
  public mutating func formBlend(
    at weight: BlendingWeight,
    of other: simd_double2x3,
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
    towards other: simd_double2x3) {
    self *= (1.0 - distance)
    self += (distance * other)
  }

}
