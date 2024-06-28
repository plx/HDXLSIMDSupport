import Foundation

@usableFromInline
package enum SIMDAggregateScalar {
  
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
  @usableFromInline
  package typealias ID = Self
  
  @inlinable
  package var id: ID { self }
}

extension SIMDAggregateScalar: CustomStringConvertible {
  
  @inlinable
  package var description: String {
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
  
  @inlinable
  package var debugDescription: String {
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
  @inlinable
  package var simdInfixTypeName: String {
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
  @inlinable
  package var simdSuffixTypeCode: String {
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
  @inlinable
  package var nativeSIMDQuaternionTypeName: String {
    "simd_quat\(simdSuffixTypeCode)"
  }
  
  /// The full name of the quaternion-storage type for this scalar (e.g. `FloatQuaternionStorage`).
  @inlinable
  package var quaternionStorageTypeName: String {
    "\(swiftTypeName)QuaternionStorage"
  }
  
  /// This type's representation in Swift (e.g. `Float16` for `half`).
  @inlinable
  package var swiftTypeName: String {
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
  @usableFromInline
  package static let allCasesInExtractionSearchOrdering: [Self] = [
    .half,
    .float,
    .double
  ]
  
  @inlinable
  package static func extracting(
    fromSwiftTypeName swiftTypeName: String
  ) -> Self? {
    for candidate in allCasesInExtractionSearchOrdering
    where swiftTypeName.hasPrefix(candidate.swiftTypeName) {
      return candidate
    }
    return nil
  }
}
