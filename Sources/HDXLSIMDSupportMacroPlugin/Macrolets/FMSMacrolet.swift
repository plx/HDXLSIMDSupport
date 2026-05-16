//
//  FMSMacrolet.swift
//

import SwiftSyntax

/// Fused-multiply-subtract: `subtracting(_:multipliedBy:)` and the mutating variant.
///
/// Half-3-row results use column-wise pure-Swift fallback.
struct FMSMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount).map { "columns.\($0) - other.columns.\($0) * scalar" }
            .joined(separator: ",")
          + ")"
        let formStmts = (0..<descriptor.columnCount)
          .map { "columns.\($0) -= other.columns.\($0) * scalar" }
          .joined(separator: "\n")
        return [
          """
          @inlinable
          public func subtracting(_ other: Self, multipliedBy scalar: Scalar) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """,
          """
          @inlinable
          public mutating func formSubtraction(of other: Self, multipliedBy scalar: Scalar) {
            \(raw: formStmts)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func subtracting(_ other: Self, multipliedBy scalar: Scalar) -> Self {
          self - (other * scalar)
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self, multipliedBy scalar: Scalar) {
          self -= other * scalar
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func subtracting(_ other: Self, multipliedBy scalar: Scalar) -> Self {
          Self(storage: storage.subtracting(other.storage, multipliedBy: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(of other: Self, multipliedBy scalar: Scalar) {
          storage.formSubtraction(of: other.storage, multipliedBy: scalar)
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
        func test_fusedMultiplySubtract_widened() {
          let probes: [[[Float16]]] = \(raw: descriptor.probeMatricesArrayExpression)
          let scalars: [Float16] = \(raw: descriptor.probeScalarsArrayExpression)
          validateHalfThreeRowBinaryScalarViaFloatWidening(
            "subtracting(_:multipliedBy:) (widened)",
            lhses: probes,
            rhses: probes,
            scalars: scalars,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            halfOp: { (a: \(raw: halfWrapper), b: \(raw: halfWrapper), s: Float16) -> \(raw: halfWrapper) in a.subtracting(b, multipliedBy: s) },
            floatOp: { (a: \(raw: floatWrapper), b: \(raw: floatWrapper), s: Float) -> \(raw: floatWrapper) in a.subtracting(b, multipliedBy: s) }
          )
        }
        """
      ]
    }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeFMS: String
    switch descriptor.representation {
    case .half:  nativeFMS = "simd_sub(a, simd_mul(s, b))"
    case .float, .double: nativeFMS = "a - (b * s)"
    }
    return [
      """
      func test_fusedMultiplySubtract() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateMatrixMatrixScalarEquivalence(
          "subtracting(_:multipliedBy:)",
          lhses: probes,
          rhses: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in a.subtracting(b, multipliedBy: s) },
          native: { (a: \(raw: native), b: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in \(raw: nativeFMS) }
        )
      }
      """
    ]
  }
}
