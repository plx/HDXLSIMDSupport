//
//  ScalarAdditionMacrolet.swift
//

import SwiftSyntax

/// Adds a scalar to every entry: `adding(scalar:)` and `formAddition(ofScalar:)`.
///
/// - Native: builds a fresh column-tuple where each column is shifted by the
///   scalar (SIMD vectors support `vec + scalar`).
/// - Storage/Wrapper: forwards.
struct ScalarAdditionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let shiftedColumnsTuple = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) &+ scalar" }
          .joined(separator: ",")
        + ")"
      // SIMD doesn't have &+ for floating point — use plain `+`. Adjusting:
      let plus = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) + scalar" }
          .joined(separator: ",")
        + ")"
      _ = shiftedColumnsTuple
      let formStmts = (0..<descriptor.columnCount)
        .map { "columns.\($0) += scalar" }
        .joined(separator: "\n")
      return [
        """
        @inlinable
        public func adding(scalar: Scalar) -> Self {
          Self(columns: \(raw: plus))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(ofScalar scalar: Scalar) {
          \(raw: formStmts)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func adding(scalar: Scalar) -> Self {
          Self(storage: storage.adding(scalar: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formAddition(ofScalar scalar: Scalar) {
          storage.formAddition(ofScalar: scalar)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.producesBuggyHalfThreeRow { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let columnVector = descriptor.columnVectorTypeName
    let scalarColumnsTuple = "(" +
      Array(repeating: "sv", count: descriptor.columnCount).joined(separator: ", ") +
      ")"
    let nativeAddBody: String
    switch descriptor.representation {
    case .half:
      nativeAddBody = "simd_add(m, \(native)(columns: \(scalarColumnsTuple)))"
    case .float, .double:
      nativeAddBody = "m + \(native)(columns: \(scalarColumnsTuple))"
    }
    return [
      """
      func test_scalarAddition() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateMatrixScalarEquivalence(
          "adding(scalar:)",
          matrices: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in m.adding(scalar: s) },
          native: { (m: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in
            let sv = \(raw: columnVector)(repeating: s)
            return \(raw: nativeAddBody)
          }
        )
      }
      """
    ]
  }
}
