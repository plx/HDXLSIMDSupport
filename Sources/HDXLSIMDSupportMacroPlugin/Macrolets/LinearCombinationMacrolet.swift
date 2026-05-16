//
//  LinearCombinationMacrolet.swift
//

import SwiftSyntax

/// `linearCombination(of:weight:with:weight:)`. Half-3-row results use a
/// pure-Swift column-wise fallback rather than `simd_linear_combination`.
struct LinearCombinationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.usesColumnWiseSwiftFallback {
        let columnsTuple = "(" +
          (0..<descriptor.columnCount)
            .map { "first.columns.\($0) * firstWeight + other.columns.\($0) * otherWeight" }
            .joined(separator: ",")
          + ")"
        return [
          """
          @inlinable
          public static func linearCombination(
            of first: Self,
            weight firstWeight: Scalar,
            with other: Self,
            weight otherWeight: Scalar
          ) -> Self {
            Self(columns: \(raw: columnsTuple))
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public static func linearCombination(
          of first: Self,
          weight firstWeight: Scalar,
          with other: Self,
          weight otherWeight: Scalar
        ) -> Self {
          simd_linear_combination(firstWeight, first, otherWeight, other)
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public static func linearCombination(
          of first: Self,
          weight firstWeight: Scalar,
          with other: Self,
          weight otherWeight: Scalar
        ) -> Self {
          Self(
            storage: \(raw: wrapped).linearCombination(
              of: first.storage,
              weight: firstWeight,
              with: other.storage,
              weight: otherWeight
            )
          )
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
        func test_linearCombination_widened() {
          let probes: [[[Float16]]] = \(raw: descriptor.probeMatricesArrayExpression)
          let weights: [Float16] = \(raw: descriptor.probeScalarsArrayExpression)
          validateHalfThreeRowLinearCombinationViaFloatWidening(
            "linearCombination(of:weight:with:weight:) (widened)",
            firsts: probes,
            others: probes,
            firstWeights: weights,
            otherWeights: weights,
            epsilon: \(raw: descriptor.defaultEpsilonLiteral),
            halfOp: { (a: \(raw: halfWrapper), fw: Float16, b: \(raw: halfWrapper), ow: Float16) -> \(raw: halfWrapper) in
              \(raw: halfWrapper).linearCombination(of: a, weight: fw, with: b, weight: ow)
            },
            floatOp: { (a: \(raw: floatWrapper), fw: Float, b: \(raw: floatWrapper), ow: Float) -> \(raw: floatWrapper) in
              \(raw: floatWrapper).linearCombination(of: a, weight: fw, with: b, weight: ow)
            }
          )
        }
        """
      ]
    }
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    // Independent ground truth: rebuild as (firstWeight * first) + (otherWeight * other)
    // using the scalar-mul + matrix-add primitives. For half this means the simd C
    // bridge (simd_mul + simd_add); for float/double it's the overlay's operators.
    let nativeBody: String
    switch descriptor.representation {
    case .half:
      nativeBody = "simd_add(simd_mul(fw, a), simd_mul(ow, b))"
    case .float, .double:
      nativeBody = "(fw * a) + (ow * b)"
    }
    return [
      """
      func test_linearCombination() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let weights: [\(raw: scalar)] = \(raw: descriptor.probeScalarsArrayExpression)
        validateLinearCombinationEquivalence(
          "linearCombination(of:weight:with:weight:)",
          firsts: probes,
          others: probes,
          firstWeights: weights,
          otherWeights: weights,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          wrapped: { (a: \(raw: wrapper), fw: \(raw: scalar), b: \(raw: wrapper), ow: \(raw: scalar)) -> \(raw: wrapper) in
            \(raw: wrapper).linearCombination(of: a, weight: fw, with: b, weight: ow)
          },
          native: { (a: \(raw: native), fw: \(raw: scalar), b: \(raw: native), ow: \(raw: scalar)) -> \(raw: native) in
            \(raw: nativeBody)
          }
        )
      }
      """
    ]
  }
}
