import Foundation
import simd

// -------------------------------------------------------------------------- //
// MARK: SIMD16 - Initialization - BinaryInteger
// -------------------------------------------------------------------------- //

extension SIMD16 where Scalar:BinaryInteger {
  
  /// Initialize to zero except for`a`.
  @inlinable
  init(a: Scalar) {
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

  /// Initialize to zero except for`i`.
  @inlinable
  public init(i: Scalar) {
    self.init(
      value: i,
      at: 8
    )
  }
  
  /// Initialize to zero except for`j`.
  @inlinable
  public init(j: Scalar) {
    self.init(
      value: j,
      at: 9
    )
  }
  
  /// Initialize to zero except for`k`.
  @inlinable
  public init(k: Scalar) {
    self.init(
      value: k,
      at: 10
    )
  }
  
  /// Initialize to zero except for`l`.
  @inlinable
  public init(l: Scalar) {
    self.init(
      value: l,
      at: 11
    )
  }
  
  /// Initialize to zero except for`m`.
  @inlinable
  public init(m: Scalar) {
    self.init(
      value: m,
      at: 12
    )
  }
  
  /// Initialize to zero except for`n`.
  @inlinable
  public init(n: Scalar) {
    self.init(
      value: n,
      at: 13
    )
  }
  
  /// Initialize to zero except for`o`.
  @inlinable
  public init(o: Scalar) {
    self.init(
      value: o,
      at: 14
    )
  }
  
  /// Initialize to zero except for`p`.
  @inlinable
  public init(p: Scalar) {
    self.init(
      value: p,
      at: 15
    )
  }

}

// -------------------------------------------------------------------------- //
// MARK: SIMD16 - Initialization - BinaryFloatingPoint
// -------------------------------------------------------------------------- //

extension SIMD16 where Scalar:BinaryFloatingPoint {
  
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
  
  /// Initialize to zero except for`i`.
  @inlinable
  public init(i: Scalar) {
    self.init(
      value: i,
      at: 8
    )
  }
  
  /// Initialize to zero except for`j`.
  @inlinable
  public init(j: Scalar) {
    self.init(
      value: j,
      at: 9
    )
  }
  
  /// Initialize to zero except for`k`.
  @inlinable
  public init(k: Scalar) {
    self.init(
      value: k,
      at: 10
    )
  }
  
  /// Initialize to zero except for`l`.
  @inlinable
  public init(l: Scalar) {
    self.init(
      value: l,
      at: 11
    )
  }
  
  /// Initialize to zero except for`m`.
  @inlinable
  public init(m: Scalar) {
    self.init(
      value: m,
      at: 12
    )
  }
  
  /// Initialize to zero except for`n`.
  @inlinable
  public init(n: Scalar) {
    self.init(
      value: n,
      at: 13
    )
  }
  
  /// Initialize to zero except for`o`.
  @inlinable
  public init(o: Scalar) {
    self.init(
      value: o,
      at: 14
    )
  }
  
  /// Initialize to zero except for`p`.
  @inlinable
  public init(p: Scalar) {
    self.init(
      value: p,
      at: 15
    )
  }
  
}
