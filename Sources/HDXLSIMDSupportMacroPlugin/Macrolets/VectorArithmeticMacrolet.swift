//
//  VectorArithmeticMacrolet.swift
//

import SwiftSyntax

/// `VectorArithmetic` conformance — wrapper-only.
///
/// SwiftUI's `VectorArithmetic` requires `static var zero`, `magnitudeSquared:
/// Double`, and `mutating func scale(by: Double)`. `AdditiveArithmetic`
/// requires `static func + / static func -`, which the operator-support
/// protocols cover.
struct VectorArithmeticMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard context.layer == .wrapper else { return [] }
    let typeName = descriptor.wrapperTypeName
    return [
      """
      @inlinable
      public static var zero: \(raw: typeName)<Scalar> {
        get { \(raw: typeName)<Scalar>() }
      }
      """,
      """
      @inlinable
      public var magnitudeSquared: Double {
        get { Double(componentwiseMagnitudeSquared) }
      }
      """,
      """
      @inlinable
      public mutating func scale(by factor: Double) {
        formMultiplication(by: Scalar(factor))
      }
      """
    ]
  }
}
