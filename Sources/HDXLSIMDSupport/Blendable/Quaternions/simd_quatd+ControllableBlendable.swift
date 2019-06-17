//
//  simd_quatd+ControllableBlendable.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: simd_quatd - Blendable
// -------------------------------------------------------------------------- //

extension simd_quatd : ControllableBlendable {
  
  public typealias BlendingWeight = NativeSIMDScalar
  public typealias Options = QuaternionBlendingStrategy
  public typealias Vector = SIMD4<NativeSIMDScalar>
  
  @inlinable
  public static var standardOptions: Options {
    get {
      return .shortestGeodesic
    }
  }
  
  @inlinable
  public init(
    byBlending first: simd_quatd,
    weight firstWeight: BlendingWeight,
    with other: simd_quatd,
    weight otherWeight: BlendingWeight,
    options: Options) {
    self.init(
      vector: Vector(
        byBlending: first.vector,
        weight: firstWeight,
        with: other.vector,
        weight: otherWeight
      )
    )
  }
  
  @inlinable
  public init(
    byInterpolatingFrom start: simd_quatd,
    towards limit: simd_quatd,
    at distance: BlendingWeight,
    options: Options) {
    switch options {
    case .linear:
      self.init(
        vector: Vector(
          byInterpolatingFrom: start.vector,
          towards: limit.vector,
          at: distance
        )
      )
    case .shortestGeodesic:
      self.init()
      self = simd_slerp(
        start,
        limit,
        distance
      )
    case .longestGeodesic:
      self.init()
      self = simd_slerp_longest(
        start,
        limit,
        distance
      )
    }
  }
  
  @inlinable
  public func incorporating(
    _ other: simd_quatd,
    at weight: BlendingWeight,
    options: Options) -> simd_quatd {
    return simd_quatd(
      vector: Vector(
        self.vector.incorporating(
          other.vector,
          at: weight
        )
      )
    )
  }
  
  @inlinable
  public func blended(
    at weight: BlendingWeight,
    with other: simd_quatd,
    weight otherWeight: BlendingWeight,
    options: Options) -> simd_quatd {
    return simd_quatd(
      vector: Vector(
        self.vector.blended(
          at: weight,
          with: other.vector,
          weight: otherWeight
        )
      )
    )
  }
  
  @inlinable
  public func interpolated(
    at distance: BlendingWeight,
    towards other: simd_quatd,
    options: Options) -> simd_quatd {
    switch options {
    case .linear:
      return simd_quatd(
        vector: self.vector.interpolated(
          at: distance,
          towards: other.vector
        )
      )
    case .shortestGeodesic:
      return simd_slerp(
        self,
        other,
        distance
      )
    case .longestGeodesic:
      return simd_slerp_longest(
        self,
        other,
        distance
      )
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: simd_quatd - InPlaceControllableBlendable
// -------------------------------------------------------------------------- //

extension simd_quatd : InPlaceControllableBlendable {
  
  @inlinable
  public mutating func becomeBlend(
    of first: simd_quatd,
    weight firstWeight: BlendingWeight,
    with other: simd_quatd,
    weight otherWeight: BlendingWeight,
    options: Options) {
    self.vector.becomeBlend(
      of: first.vector,
      weight: firstWeight,
      with: other.vector,
      weight: otherWeight
    )
  }
  
  @inlinable
  public mutating func becomeInterpolation(
    from start: simd_quatd,
    to limit: simd_quatd,
    at distance: BlendingWeight,
    options: Options) {
    switch options {
    case .linear:
      self.vector.becomeInterpolation(
        from: start.vector,
        to: limit.vector,
        at: distance
      )
    case .shortestGeodesic:
      self = simd_slerp(
        start,
        limit,
        distance
      )
    case .longestGeodesic:
      self = simd_slerp_longest(
        start,
        limit,
        distance
      )
    }
  }
  
  @inlinable
  public mutating func formIncorporation(
    of other: simd_quatd,
    weight otherWeight: BlendingWeight,
    options: Options) {
    self.vector.formIncorporation(
      of: other.vector,
      weight: otherWeight
    )
  }
  
  @inlinable
  public mutating func formBlend(
    at weight: BlendingWeight,
    of other: simd_quatd,
    weight otherWeight: BlendingWeight,
    options: Options) {
    self.vector.formBlend(
      at: weight,
      of: other.vector,
      weight: otherWeight
    )
  }
  
  @inlinable
  public mutating func formInterpolation(
    at distance: BlendingWeight,
    towards other: simd_quatd,
    options: Options) {
    switch options {
    case .linear:
      self.vector.formInterpolation(
        at: distance,
        towards: other.vector
      )
    case .shortestGeodesic:
      self = simd_slerp(
        self,
        other,
        distance
      )
    case .longestGeodesic:
      self = simd_slerp_longest(
        self,
        other,
        distance
      )
    }
  }
  
}

