//
//  SIMD3+Blendable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMD3 - Blendable
// -------------------------------------------------------------------------- //

extension SIMD3 : Blendable where Scalar:BinaryFloatingPoint {
  
  public typealias BlendingWeight = Scalar
  
  @inlinable
  public init(
    byBlending first: SIMD3<Scalar>,
    weight firstWeight: BlendingWeight,
    with other: SIMD3<Scalar>,
    weight otherWeight: BlendingWeight) {
    self.init(first * firstWeight)
    self.addProduct(
      otherWeight,
      other
    )
  }
  
  @inlinable
  public init(
    byInterpolatingFrom start: SIMD3<Scalar>,
    towards limit: SIMD3<Scalar>,
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
    _ other: SIMD3<Scalar>,
    at weight: BlendingWeight) -> SIMD3<Scalar> {
    return self.addingProduct(
      other,
      weight
    )
  }
  
  @inlinable
  public func blended(
    at weight: BlendingWeight,
    with other: SIMD3<Scalar>,
    weight otherWeight: BlendingWeight) -> SIMD3<Scalar> {
    return (weight * self).addingProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public func interpolated(
    at distance: BlendingWeight,
    towards other: SIMD3<Scalar>) -> SIMD3<Scalar> {
    return ((1.0 - distance) * self).addingProduct(
      other,
      distance
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD3<Scalar> - InPlaceBlendable
// -------------------------------------------------------------------------- //

extension SIMD3 : InPlaceBlendable where Scalar:BinaryFloatingPoint {
  
  @inlinable
  public mutating func becomeBlend(
    of first: SIMD3<Scalar>,
    weight firstWeight: BlendingWeight,
    with other: SIMD3<Scalar>,
    weight otherWeight: BlendingWeight) {
    self = (first * firstWeight).addingProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public mutating func becomeInterpolation(
    from start: SIMD3<Scalar>,
    to limit: SIMD3<Scalar>,
    at distance: BlendingWeight) {
    self = ((1.0 - distance) * start).addingProduct(
      limit,
      distance
    )
  }
  
  @inlinable
  public mutating func formIncorporation(
    of other: SIMD3<Scalar>,
    weight otherWeight: BlendingWeight) {
    self.addProduct(
      other,
      otherWeight
    )
  }
  
  @inlinable
  public mutating func formBlend(
    at weight: BlendingWeight,
    of other: SIMD3<Scalar>,
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
    towards other: SIMD3<Scalar>) {
    self *= (1.0 - distance)
    self.addProduct(
      other,
      distance
    )
  }
  
}
