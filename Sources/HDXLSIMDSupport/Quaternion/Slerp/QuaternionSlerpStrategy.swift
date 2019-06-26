//
//  QuaternionSlerpStrategy.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - Equatable
// -------------------------------------------------------------------------- //

/// Enumeration of possible quaternion slerps: shortest, longest, or "don't care, do whatever".
///
/// Objective-C visible so e.g. it can be used directly in Objective-C visible "view-configuration" objects.
///
@objc(HDXLQuaternionSlerpStrategy)
public enum QuaternionSlerpStrategy : Int {
  
  /// Case for when you have no specific preference.
  case automatic = 0
  
  /// Case for when you explicitly-prefer the shortest arc.
  case shortest = 1
  
  /// Case for when you explicitly-prefer the longest arc.
  case longest = 2
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - Equatable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Equatable {
  
  @inlinable
  public static func ==(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

  @inlinable
  public static func !=(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - Comparable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Comparable {
  
  @inlinable
  public static func <(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

  @inlinable
  public static func >(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue > rhs.rawValue
  }

  @inlinable
  public static func <=(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue <= rhs.rawValue
  }

  @inlinable
  public static func >=(
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy) -> Bool {
    return lhs.rawValue >= rhs.rawValue
  }

}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - Hashable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Hashable {
  
  @inlinable
  public func hash(into hasher: inout Hasher) {
    self.rawValue.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    get {
      switch self {
      case .automatic:
        return ".automatic"
      case .shortest:
        return ".shortest"
      case .longest:
        return ".longest"
      }
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    get {
      switch self {
      case .automatic:
        return "QuaternionSlerpStrategy.automatic"
      case .shortest:
        return "QuaternionSlerpStrategy.shortest"
      case .longest:
        return "QuaternionSlerpStrategy.longest"
      }
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - Codable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Codable {
  
  @inlinable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
  
  @inlinable
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let rawValue = try container.decode(RawValue.self)
    guard let value = QuaternionSlerpStrategy(rawValue: rawValue) else {
      // TODO: use our own error
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: [],
          debugDescription: "Got invalid `rawValue` \(rawValue) for `QuaternionSlerpStrategy",
          underlyingError: nil
        )
      )
    }
    self = value
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: QuaternionSlerpStrategy - CaseIterable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : CaseIterable {
  
  public typealias AllCases = [QuaternionSlerpStrategy]
  
  public static var allCases: AllCases {
    get {
      return [
        .automatic,
        .shortest,
        .longest
      ]
    }
  }
  
}
