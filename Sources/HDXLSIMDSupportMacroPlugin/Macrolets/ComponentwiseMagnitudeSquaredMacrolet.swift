//
//  ComponentwiseMagnitudeSquaredMacrolet.swift
//

import SwiftSyntax

/// `componentwiseMagnitudeSquared` — sum of squares of all entries.
///
/// At the native layer we emit `simd_length_squared(columns.c) + ...` because
/// that's what the simd toolkit gives us. At storage/wrapper layers we forward.
struct ComponentwiseMagnitudeSquaredMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      let expression = (0..<descriptor.columnCount)
        .map { "simd_length_squared(columns.\($0))" }
        .joined(separator: " + ")
      return [
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { \(raw: expression) }
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public var componentwiseMagnitudeSquared: Scalar {
          get { storage.componentwiseMagnitudeSquared }
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    return [
      """
      func test_componentwiseMagnitudeSquared() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateUnaryToScalarEquivalence(
          "componentwiseMagnitudeSquared",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper)) -> \(raw: scalar) in m.componentwiseMagnitudeSquared },
          native: { (m: \(raw: native)) -> \(raw: scalar) in
            m.linearizedScalars.reduce(0 as \(raw: scalar)) { $0 + $1 * $1 }
          }
        )
      }
      """
    ]
  }
}
