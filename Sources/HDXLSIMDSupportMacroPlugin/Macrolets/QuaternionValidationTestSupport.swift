//
//  QuaternionValidationTestSupport.swift
//
//  Helpers for `validationTestDeclarations` emissions on the quaternion
//  macrolets. Mirrors `ValidationTestSupport.swift` (matrix side).
//

import SwiftSyntax

extension QuaternionDescriptor {

  /// Wrapper-layer type instantiation as it appears in generated test source,
  /// e.g. `Quaternion<Float>`.
  var wrapperTypeInstantiation: String {
    "Quaternion<\(representation.swiftScalarTypeName)>"
  }

  /// Probe quaternions as a `[[Scalar]]` literal — each probe is `[i, j, k, real]`.
  var probeQuaternionsArrayExpression: String {
    arrayExpression(for: allProbes)
  }

  /// Probe quaternions excluding the zero quaternion. Used for operations that
  /// are undefined / numerically unstable at zero (inversion, normalization,
  /// division).
  var nonZeroProbeQuaternionsArrayExpression: String {
    arrayExpression(for: Array(allProbes.dropFirst()))
  }

  /// Scalar probes for scalar-mul / scalar-add etc.
  var probeScalarsArrayExpression: String {
    let scalarType = representation.swiftScalarTypeName
    let values: [Int] = [-2, -1, 0, 1, 2]
    return "[" + values.map { "\(scalarType)(\($0))" }.joined(separator: ", ") + "]"
  }

  /// Scalar probes excluding zero — used for scalar division.
  var nonZeroProbeScalarsArrayExpression: String {
    let scalarType = representation.swiftScalarTypeName
    let values: [Int] = [-2, -1, 1, 2]
    return "[" + values.map { "\(scalarType)(\($0))" }.joined(separator: ", ") + "]"
  }

  /// L∞-distance tolerance for tests where the operation preserves magnitudes
  /// (negation, conjugation, addition, subtraction, scalar mul, dot, mag²).
  var defaultEpsilonLiteral: String {
    switch representation {
    case .half:   return "0.05"
    case .float:  return "0.0001"
    case .double: return "0.00000001"
    }
  }

  /// Looser tolerance for tests that divide / invert / normalize. The inputs
  /// include awkward magnitudes (e.g. 1/30 in half) and round-trip through a
  /// reciprocal, so the tighter `defaultEpsilonLiteral` doesn't hold.
  var divisionEpsilonLiteral: String {
    switch representation {
    case .half:   return "0.2"
    case .float:  return "0.001"
    case .double: return "0.0000001"
    }
  }

  // MARK: - Probe data

  private var allProbes: [[Double]] {
    [
      [0, 0, 0, 0],
      [0, 0, 0, 1],
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0.5, 0.5, 0.5, 0.5],
      [1, 2, 3, 4],
      [-1, 0.5, -0.25, 2],
      [2, -1, 3, -0.5]
    ]
  }

  private func arrayExpression(for probes: [[Double]]) -> String {
    let scalarType = representation.swiftScalarTypeName
    let probeLiterals = probes.map { probe -> String in
      let entries = probe.map { value -> String in
        if value == value.rounded() {
          return "\(scalarType)(\(Int(value)))"
        }
        return "\(scalarType)(\(value))"
      }.joined(separator: ", ")
      return "[" + entries + "]"
    }
    return "[\n      " + probeLiterals.joined(separator: ",\n      ") + "\n    ]"
  }
}
