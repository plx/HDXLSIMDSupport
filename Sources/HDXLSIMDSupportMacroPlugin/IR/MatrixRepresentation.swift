//
//  MatrixRepresentation.swift
//

import SwiftSyntax

/// Which scalar precision a matrix uses. Determines the C-level type prefix
/// (`simd_halfNxM`, `simd_floatNxM`, `simd_doubleNxM`), the Swift `Scalar`
/// type, and the Swift storage type name (`HalfMatrixNxMStorage`, etc).
enum MatrixRepresentation: String, CaseIterable {
  case half
  case float
  case double

  /// Swift scalar type (`Float16`, `Float`, `Double`).
  var swiftScalarTypeName: String {
    switch self {
    case .half:   "Float16"
    case .float:  "Float"
    case .double: "Double"
    }
  }

  /// Storage-type name prefix (e.g. `Half` -> `HalfMatrix2x2Storage`).
  var storageTypeNamePrefix: String {
    switch self {
    case .half:   "Half"
    case .float:  "Float"
    case .double: "Double"
    }
  }

  /// C-bridged simd type prefix (`simd_half`, `simd_float`, `simd_double`).
  var simdTypePrefix: String {
    switch self {
    case .half:   "simd_half"
    case .float:  "simd_float"
    case .double: "simd_double"
    }
  }

  /// C-bridged simd vector prefix (`SIMD2<Float>` -> uses `Float` directly,
  /// but we expose this for completeness).
  var simdVectorScalarTypeName: String { swiftScalarTypeName }

  /// Parse the representation from a macro argument like `.float`.
  static func parse(from expression: ExprSyntax) -> MatrixRepresentation? {
    if let member = expression.as(MemberAccessExprSyntax.self) {
      let name = member.declName.baseName.text
      return MatrixRepresentation(rawValue: name)
    }
    return nil
  }
}
