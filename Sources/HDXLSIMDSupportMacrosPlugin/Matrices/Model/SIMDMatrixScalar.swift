import Foundation

public enum SIMDMatrixScalar {
  
  case double
  case float
  case half
  
}

extension SIMDMatrixScalar: Sendable { }
extension SIMDMatrixScalar: Equatable { }
extension SIMDMatrixScalar: Hashable { }
extension SIMDMatrixScalar: CaseIterable { }
extension SIMDMatrixScalar: Codable { }

extension SIMDMatrixScalar: Identifiable {
  public typealias ID = Self
  
  public var id: ID { self }
}

extension SIMDMatrixScalar: CustomStringConvertible {
  
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

extension SIMDMatrixScalar: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    switch self {
    case .double:
      "SIMDMatrixScalar.double"
    case .float:
      "SIMDMatrixScalar.float"
    case .half:
      "SIMDMatrixScalar.half"
    }
  }
  
}

extension SIMDMatrixScalar {
  
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

extension SIMDMatrixScalar {
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
