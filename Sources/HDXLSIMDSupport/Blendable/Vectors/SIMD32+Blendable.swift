//
//  SIMD32+Blendable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMD32 - Blendable
// -------------------------------------------------------------------------- //

extension SIMD32 : Blendable where Scalar:BinaryFloatingPoint {
  
  public typealias BlendingWeight = Scalar
  
  @inlinable
  public init(
    byBlending first: SIMD32<Scalar>,
    weight firstWeight: BlendingWeight,
    with other: SIMD32<Scalar>,
    weight otherWeight: BlendingWeight) {
    self.init(first * firstWeight)
    self.addProduct(
      otherWeight,
      other
    )
  }
  
  @inlinable
  public init(
    byInterpolatingFrom start: SIMD32<Scalar>,
    towards limit: SIMD32<Scalar>,
    at distance: BlendingWeight) {
    self.init(
      (1.0 - distance) * start
    )
    self.addProduct(
      distance,
      limit
    )
  }
  
  @inlinable
  public func incorporating(
    _ other: SIMD32<Scalar>,
    at weight: BlendingWeight) -> SIMD32<Scalar> {
    return self.addingProduct(
      other,
      weight
    )
  }
  
  @inlinable
  public func blended(
    at weight: BlendingWeight,
    with other: SIMD32<Scalar>,
    weight otherWeight: BlendingWeight) -> SIMD32<Scalar> {
    return (weight * self).addingProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public func interpolated(
    at distance: BlendingWeight,
    towards other: SIMD32<Scalar>) -> SIMD32<Scalar> {
    return ((1.0 - distance) * self).addingProduct(
      other,
      distance
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD32<Scalar> - InPlaceBlendable
// -------------------------------------------------------------------------- //

extension SIMD32 : InPlaceBlendable where Scalar:BinaryFloatingPoint {
  
  @inlinable
  public mutating func becomeBlend(
    of first: SIMD32<Scalar>,
    weight firstWeight: BlendingWeight,
    with other: SIMD32<Scalar>,
    weight otherWeight: BlendingWeight) {
    self = (first * firstWeight).addingProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public mutating func becomeInterpolation(
    from start: SIMD32<Scalar>,
    to limit: SIMD32<Scalar>,
    at distance: BlendingWeight) {
    self = ((1.0 - distance) * start).addingProduct(
      limit,
      distance
    )
  }
  
  @inlinable
  public mutating func formIncorporation(
    of other: SIMD32<Scalar>,
    weight otherWeight: BlendingWeight) {
    self.addProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public mutating func formBlend(
    at weight: BlendingWeight,
    of other: SIMD32<Scalar>,
    weight otherWeight: BlendingWeight) {
    self *= weight
    self.addProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public mutating func formInterpolation(
    at distance: BlendingWeight,
    towards other: SIMD32<Scalar>) {
    self *= (1.0 - distance)
    self.addProduct(
      other,
      distance
    )
  }
  
}
