//
//  ValidationTestSupport.swift
//
//  Helpers for `validationTestDeclarations` emissions. Centralises the
//  probe-input construction and the per-representation native-operation
//  formula choice, so individual macrolets stay focused on their slice of
//  the API.
//

import SwiftSyntax

extension MatrixDescriptor {

  /// Wrapper type expression for use inside generated test source, e.g.
  /// `Matrix2x2<Float>`.
  var wrapperTypeInstantiation: String {
    "\(wrapperTypeName)<\(representation.swiftScalarTypeName)>"
  }

  /// `[[Scalar]]` value literals — small probe sweep used by every test.
  /// Builds an array of `rowCount × columnCount` 2D-arrays, varying the
  /// entries deterministically.
  var probeMatricesArrayExpression: String {
    let probesData: [[[Int]]] = [
      ProbeMatrixGenerator.zero(rows: rowCount, columns: columnCount),
      ProbeMatrixGenerator.identity(rows: rowCount, columns: columnCount),
      ProbeMatrixGenerator.incrementing(rows: rowCount, columns: columnCount, start: 1),
      ProbeMatrixGenerator.incrementing(rows: rowCount, columns: columnCount, start: -3),
      ProbeMatrixGenerator.repeating(rows: rowCount, columns: columnCount, value: 2),
      ProbeMatrixGenerator.alternating(rows: rowCount, columns: columnCount),
      ProbeMatrixGenerator.upperTriangular(rows: rowCount, columns: columnCount)
    ]
    let scalarType = representation.swiftScalarTypeName
    let probeLiterals = probesData.map { matrix -> String in
      let rows = matrix.map { row -> String in
        "[" + row.map { "\(scalarType)(\($0))" }.joined(separator: ", ") + "]"
      }
      return "[" + rows.joined(separator: ", ") + "]"
    }
    return "[\n      " + probeLiterals.joined(separator: ",\n      ") + "\n    ]"
  }

  /// Small probe scalar set used as scalar inputs to operations like
  /// `multiplied(by:)`. Concrete to the descriptor's representation.
  var probeScalarsArrayExpression: String {
    let scalarType = representation.swiftScalarTypeName
    let values = [-2, -1, 0, 1, 2]
    let elements = values.map { "\(scalarType)(\($0))" }.joined(separator: ", ")
    return "[" + elements + "]"
  }

  /// Per-representation L∞-distance tolerance used in generated tests.
  /// Half-precision is much less precise than Float/Double; the looser
  /// tolerance accounts for rounding from `simd_mul((-1), x)` etc.
  var defaultEpsilonLiteral: String {
    switch representation {
    case .half:   return "0.05"
    case .float:  return "0.0001"
    case .double: return "0.00000001"
    }
  }
}

/// Probe matrix construction helpers (Swift values, used at expansion-time
/// to lay out test inputs).
enum ProbeMatrixGenerator {

  static func zero(rows: Int, columns: Int) -> [[Int]] {
    Array(repeating: Array(repeating: 0, count: columns), count: rows)
  }

  static func identity(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { r in (0..<columns).map { c in r == c ? 1 : 0 } }
  }

  static func incrementing(rows: Int, columns: Int, start: Int) -> [[Int]] {
    var value = start
    return (0..<rows).map { _ in
      (0..<columns).map { _ -> Int in
        defer { value += 1 }
        return value
      }
    }
  }

  static func repeating(rows: Int, columns: Int, value: Int) -> [[Int]] {
    Array(repeating: Array(repeating: value, count: columns), count: rows)
  }

  static func alternating(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { r in (0..<columns).map { c in (r + c).isMultiple(of: 2) ? 1 : -1 } }
  }

  static func upperTriangular(rows: Int, columns: Int) -> [[Int]] {
    (0..<rows).map { r in (0..<columns).map { c in c >= r ? c - r + 1 : 0 } }
  }
}
