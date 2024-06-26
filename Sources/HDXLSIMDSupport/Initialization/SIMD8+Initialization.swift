import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

extension SIMD8 where Scalar:BinaryInteger {
  
  /// Initialize to zero except for`a`.
  @inlinable
  public init(a: Scalar) {
    self.init(
      value: a,
      at: 0
    )
  }
  
  /// Initialize to zero except for`b`.
  @inlinable
  public init(b: Scalar) {
    self.init(
      value: b,
      at: 1
    )
  }
  
  /// Initialize to zero except for`c`.
  @inlinable
  public init(c: Scalar) {
    self.init(
      value: c,
      at: 2
    )
  }
  
  /// Initialize to zero except for`d`.
  @inlinable
  public init(d: Scalar) {
    self.init(
      value: d,
      at: 3
    )
  }
  
  /// Initialize to zero except for`e`.
  @inlinable
  public init(e: Scalar) {
    self.init(
      value: e,
      at: 4
    )
  }
  
  /// Initialize to zero except for`f`.
  @inlinable
  public init(f: Scalar) {
    self.init(
      value: f,
      at: 5
    )
  }
  
  /// Initialize to zero except for`g`.
  @inlinable
  public init(g: Scalar) {
    self.init(
      value: g,
      at: 6
    )
  }
  
  /// Initialize to zero except for`h`.
  @inlinable
  public init(h: Scalar) {
    self.init(
      value: h,
      at: 7
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMD8 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

extension SIMD8 where Scalar:BinaryFloatingPoint {
  
  /// Initialize to zero except for`a`.
  @inlinable
  public init(a: Scalar) {
    self.init(
      value: a,
      at: 0
    )
  }
  
  /// Initialize to zero except for`b`.
  @inlinable
  public init(b: Scalar) {
    self.init(
      value: b,
      at: 1
    )
  }
  
  /// Initialize to zero except for`c`.
  @inlinable
  public init(c: Scalar) {
    self.init(
      value: c,
      at: 2
    )
  }
  
  /// Initialize to zero except for`d`.
  @inlinable
  public init(d: Scalar) {
    self.init(
      value: d,
      at: 3
    )
  }
  
  /// Initialize to zero except for`e`.
  @inlinable
  public init(e: Scalar) {
    self.init(
      value: e,
      at: 4
    )
  }
  
  /// Initialize to zero except for`f`.
  @inlinable
  public init(f: Scalar) {
    self.init(
      value: f,
      at: 5
    )
  }
  
  /// Initialize to zero except for`g`.
  @inlinable
  public init(g: Scalar) {
    self.init(
      value: g,
      at: 6
    )
  }
  
  /// Initialize to zero except for`h`.
  @inlinable
  public init(h: Scalar) {
    self.init(
      value: h,
      at: 7
    )
  }
    
}
