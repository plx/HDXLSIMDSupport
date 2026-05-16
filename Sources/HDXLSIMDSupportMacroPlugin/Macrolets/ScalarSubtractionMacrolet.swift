//
//  ScalarSubtractionMacrolet.swift
//

import SwiftSyntax

/// Subtracts a scalar from every entry.
struct ScalarSubtractionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let shifted = "(" +
        (0..<descriptor.columnCount).map { "columns.\($0) - scalar" }.joined(separator: ",")
        + ")"
      let formStmts = (0..<descriptor.columnCount)
        .map { "columns.\($0) -= scalar" }
        .joined(separator: "\n")
      return [
        """
        @inlinable
        public func subtracting(scalar: Scalar) -> Self {
          Self(columns: \(raw: shifted))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(ofScalar scalar: Scalar) {
          \(raw: formStmts)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func subtracting(scalar: Scalar) -> Self {
          Self(storage: storage.subtracting(scalar: scalar))
        }
        """,
        """
        @inlinable
        public mutating func formSubtraction(ofScalar scalar: Scalar) {
          storage.formSubtraction(ofScalar: scalar)
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
        func test_scalarSubtraction_widened() {
          let probes: [[[Float16]]] = \(raw: descriptor.probeMatricesArrayExpression)
          let scalars: [Float16] = \(raw: descriptor.probeScalarsArrayExpression)
          validateHalfThreeRowMatrixScalarViaFloatWidening(
            "subtracting(scalar:) (widened)",
            matrices: probes,
            scalars: scalars,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            halfOp: { (m: \(raw: halfWrapper), s: Float16) -> \(raw: halfWrapper) in m.subtracting(scalar: s) },
            floatOp: { (m: \(raw: floatWrapper), s: Float) -> \(raw: floatWrapper) in m.subtracting(scalar: s) }
          )
        }
        """
      ]
    }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let columnVector = descriptor.columnVectorTypeName
    let scalarColumnsTuple = "(" +
      Array(repeating: "sv", count: descriptor.columnCount).joined(separator: ", ") +
      ")"
    let nativeSubBody: String
    switch descriptor.representation {
    case .half:
      nativeSubBody = "simd_sub(m, \(native)(columns: \(scalarColumnsTuple)))"
    case .float, .double:
      nativeSubBody = "m - \(native)(columns: \(scalarColumnsTuple))"
    }
    return [
      """
      func test_scalarSubtraction() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let scalars: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateMatrixScalarEquivalence(
          "subtracting(scalar:)",
          matrices: probes,
          scalars: scalars,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper), s: \(raw: scalar)) -> \(raw: wrapper) in m.subtracting(scalar: s) },
          native: { (m: \(raw: native), s: \(raw: scalar)) -> \(raw: native) in
            let sv = \(raw: columnVector)(repeating: s)
            return \(raw: nativeSubBody)
          }
        )
      }
      """
    ]
  }
}
