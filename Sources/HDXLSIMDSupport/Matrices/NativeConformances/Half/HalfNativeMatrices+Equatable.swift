//
//  HalfNativeMatrices+Equatable.swift
//

import Foundation
import simd

// `simd_floatNxM` and `simd_doubleNxM` are `Equatable` via the Swift overlay;
// the half-precision variants are not yet bridged that way as of macOS 26.
// The `Passthrough+Equatable` default in this package relies on
// `PassthroughValue: Equatable`, so we add explicit conformances here to keep
// the half-precision storages on the same shape as their Float/Double peers.
// If/when the Swift overlay starts bridging this itself, these can be removed.

extension simd_half2x2 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half2x2, rhs: simd_half2x2) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half2x3 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half2x3, rhs: simd_half2x3) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half2x4 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half2x4, rhs: simd_half2x4) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half3x2 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half3x2, rhs: simd_half3x2) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half3x3 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half3x3, rhs: simd_half3x3) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half3x4 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half3x4, rhs: simd_half3x4) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half4x2 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half4x2, rhs: simd_half4x2) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half4x3 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half4x3, rhs: simd_half4x3) -> Bool {
    return lhs.columns == rhs.columns
  }
}

extension simd_half4x4 : @retroactive Equatable {
  @inlinable
  public static func == (lhs: simd_half4x4, rhs: simd_half4x4) -> Bool {
    return lhs.columns == rhs.columns
  }
}
