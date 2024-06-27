import Foundation

public enum SIMDAggregateScalar {
  
  case double
  case float
  case half
  
}

extension SIMDAggregateScalar: Sendable { }
extension SIMDAggregateScalar: Equatable { }
extension SIMDAggregateScalar: Hashable { }
extension SIMDAggregateScalar: CaseIterable { }
extension SIMDAggregateScalar: Codable { }

extension SIMDAggregateScalar: Identifiable {
  public typealias ID = Self
  
  public var id: ID { self }
}

extension SIMDAggregateScalar: CustomStringConvertible {
  
  public var description: String {
    switch self {
    case .double:
      ".double"
    case .float:
      ".float"
    case .half:
      ".half"
    }
  }
  
}

extension SIMDAggregateScalar: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    switch self {
    case .double:
      "SIMDAggregateScalar.double"
    case .float:
      "SIMDAggregateScalar.float"
    case .half:
      "SIMDAggregateScalar.half"
    }
  }
  
}

extension SIMDAggregateScalar {
  
  /// This type's representation within longer simd types, e.g. the `float` within `simd_float4x4`.
  public var simdInfixTypeName: String {
    switch self {
    case .double:
      "double"
    case .float:
      "float"
    case .half:
      "half"
    }
  }

  /// This type's representation as a suffix (e.g. the `d` in `simd_quatd`).
  public var simdSuffixTypeCode: String {
    switch self {
    case .double:
      "d"
    case .float:
      "f"
    case .half:
      "h"
    }
  }
  
  /// This full name of this type's simd quaternion (e.g. `simd_quatd`).
  public var nativeSIMDQuaternionTypeName: String {
    "simd_quat\(simdSuffixTypeCode)"
  }
  
  /// The full name of the quaternion-storage type for this scalar (e.g. `FloatQuaternionStorage`).
  public var quaternionStorageTypeName: String {
    "\(swiftTypeName)QuaternionStorage"
  }
  
  /// This type's representation in Swift (e.g. `Float16` for `half`).
  public var swiftTypeName: String {
    switch self {
    case .double:
      "Double"
    case .float:
      "Float"
    case .half:
      "Float16"
    }
  }

}

extension SIMDAggregateScalar {
  internal static let allCasesInExtractionSearchOrdering: [Self] = [
    .half,
    .float,
    .double
  ]
  
  public static func extracting(
    fromSwiftTypeName swiftTypeName: String
  ) -> Self? {
    for candidate in allCasesInExtractionSearchOrdering
    where swiftTypeName.hasPrefix(candidate.swiftTypeName) {
      return candidate
    }
    return nil
  }
}
