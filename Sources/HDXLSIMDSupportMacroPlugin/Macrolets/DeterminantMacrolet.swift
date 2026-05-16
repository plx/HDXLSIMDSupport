//
//  DeterminantMacrolet.swift
//

import SwiftSyntax

/// `determinant: Scalar` — only emitted for square matrices.
///
/// - Native: float/double simd matrices expose `self.determinant` via the
///   simd overlay. For half there's no overlay property, so we call the
///   C-level `simd_determinant(self)` which is a scalar output and
///   therefore unaffected by the half-3-row overlay bug.
/// - Storage/Wrapper: forwards.
struct DeterminantMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        return [
          """
          @inlinable
          public var determinant: Scalar {
            get { simd_determinant(self) }
          }
          """
        ]
      }
      return []
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public var determinant: Scalar {
          get { storage.determinant }
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard descriptor.isSquare else { return [] }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let nativeDet: String
    switch descriptor.representation {
    case .half:           nativeDet = "simd_determinant(m)"
    case .float, .double: nativeDet = "m.determinant"
    }
    return [
      """
      func test_determinant() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        validateUnaryToScalarEquivalence(
          "determinant",
          probes: probes,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (m: \(raw: wrapper)) -> \(raw: scalar) in m.determinant },
          native: { (m: \(raw: native)) -> \(raw: scalar) in \(raw: nativeDet) }
        )
      }
      """
    ]
  }
}
