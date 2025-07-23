import Foundation
import simd

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
// MARK: - Synthesized Conformances
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Sendable { }
extension QuaternionSlerpStrategy : Equatable { }
extension QuaternionSlerpStrategy : Hashable { }
extension QuaternionSlerpStrategy : Codable { }
extension QuaternionSlerpStrategy : CaseIterable { }

// -------------------------------------------------------------------------- //
// MARK: - Comparable
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : Comparable {
  
  @inlinable
  public static func < (
    lhs: QuaternionSlerpStrategy,
    rhs: QuaternionSlerpStrategy
  ) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

}

// -------------------------------------------------------------------------- //
// MARK: - CustomStringConvertible
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : CustomStringConvertible {
  
  @inlinable
  public var description: String {
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

// -------------------------------------------------------------------------- //
// MARK: - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

extension QuaternionSlerpStrategy : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
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
