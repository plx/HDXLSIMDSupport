//
//  NegationMacrolet.swift
//

import SwiftSyntax

/// Emits `negated() -> Self` and `formNegation()` plus the matching
/// validation test.
struct NegationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" + (0..<descriptor.columnCount).map { "-columns.\($0)" }.joined(separator: ",") + ")"
        let formStmts = (0..<descriptor.columnCount).map { "columns.\($0) = -columns.\($0)" }.joined(separator: "\n")
        return [
          """
          @inlinable
          public func negated() -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formNegation() {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func negated() -> Self { -self }
        """,
        """
        @inlinable
        public mutating func formNegation() { self = -self }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func negated() -> Self {
          Self(storage: storage.negated())
        }
        """,
        """
        @inlinable
        public mutating func formNegation() {
          storage.formNegation()
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    if descriptor.producesBuggyHalfThreeRow {
      let halfWrapper = descriptor.wrapperTypeInstantiation
      let floatWrapper = "Matrix\(descriptor.shapeLabel)<Float>"
      return [
        """
        func test_negation_widened() {
          let probes: [[[Float16]]] = \(raw: descriptor.probeMatricesArrayExpression)
          validateHalfThreeRowUnaryViaFloatWidening(
            "negation (widened)",
            probes: probes,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            halfOp: { (m: \(raw: halfWrapper)) -> \(raw: halfWrapper) in m.negated() },
            floatOp: { (m: \(raw: floatWrapper)) -> \(raw: floatWrapper) in m.negated() }
          )
        }
        """
      ]
    }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let nativeNegation: String
    switch descriptor.representation {
    case .half:
      nativeNegation = "simd_mul((-1) as \(descriptor.representation.swiftScalarTypeName), n)"
    case .float, .double:
      nativeNegation = "-n"
    }
    return [
      """
      func test_negation() {
        let probes: [[[\(raw: descriptor.representation.swiftScalarTypeName)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateUnaryEquivalence(
          "negation",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper)) -> \(raw: wrapper) in m.negated() },
          native: { (n: \(raw: native)) -> \(raw: native) in \(raw: nativeNegation) }
        )
      }
      """
    ]
  }
}
