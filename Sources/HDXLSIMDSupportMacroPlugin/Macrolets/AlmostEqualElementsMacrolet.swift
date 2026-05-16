//
//  AlmostEqualElementsMacrolet.swift
//

import SwiftSyntax

/// `hasAlmostEqualElements(to:absoluteTolerance:)` and the relative-tolerance
/// variant. Native bodies use `simd_almost_equal_elements` and
/// `simd_almost_equal_elements_relative`; storage/wrapper forward.
struct AlmostEqualElementsMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          absoluteTolerance tolerance: Scalar
        ) -> Bool {
          simd_almost_equal_elements(self, other, tolerance)
        }
        """,
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          relativeTolerance tolerance: Scalar
        ) -> Bool {
          simd_almost_equal_elements_relative(self, other, tolerance)
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          absoluteTolerance tolerance: Scalar
        ) -> Bool {
          storage.hasAlmostEqualElements(to: other.storage, absoluteTolerance: tolerance)
        }
        """,
        """
        @inlinable
        public func hasAlmostEqualElements(
          to other: Self,
          relativeTolerance tolerance: Scalar
        ) -> Bool {
          storage.hasAlmostEqualElements(to: other.storage, relativeTolerance: tolerance)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let toleranceLiterals: String
    switch descriptor.representation {
    case .half:   toleranceLiterals = "[Float16(0.01), Float16(0.5), Float16(2)]"
    case .float:  toleranceLiterals = "[Float(0.0001), Float(0.5), Float(2)]"
    case .double: toleranceLiterals = "[Double(0.00000001), Double(0.5), Double(2)]"
    }
    return [
      """
      func test_hasAlmostEqualElementsAbsolute() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let tolerances: [\(raw: scalar)] = \(raw: toleranceLiterals)
        validateBinaryToBoolEquivalence(
          "hasAlmostEqualElements(to:absoluteTolerance:)",
          lhses: probes,
          rhses: probes,
          tolerances: tolerances,
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), t: \(raw: scalar)) -> Bool in a.hasAlmostEqualElements(to: b, absoluteTolerance: t) },
          native: { (a: \(raw: native), b: \(raw: native), t: \(raw: scalar)) -> Bool in simd_almost_equal_elements(a, b, t) }
        )
      }
      """,
      """
      func test_hasAlmostEqualElementsRelative() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let tolerances: [\(raw: scalar)] = \(raw: toleranceLiterals)
        validateBinaryToBoolEquivalence(
          "hasAlmostEqualElements(to:relativeTolerance:)",
          lhses: probes,
          rhses: probes,
          tolerances: tolerances,
          wrapped: { (a: \(raw: wrapper), b: \(raw: wrapper), t: \(raw: scalar)) -> Bool in a.hasAlmostEqualElements(to: b, relativeTolerance: t) },
          native: { (a: \(raw: native), b: \(raw: native), t: \(raw: scalar)) -> Bool in simd_almost_equal_elements_relative(a, b, t) }
        )
      }
      """
    ]
  }
}
