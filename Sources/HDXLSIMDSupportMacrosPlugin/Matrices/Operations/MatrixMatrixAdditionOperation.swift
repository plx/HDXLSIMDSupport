import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics
import HDXLSIMDSupportProtocols

package enum DelegatedOperationTarget {
  case storage
  case nativeSIMDRepresentation
}

package enum OutOfPlaceOperationSyntax {
  case namedMethod
  case symbolicOperator
  case simdCFunction
}

package struct MatrixMatrixAdditionOperation<Scalar, MatrixType>
where
Scalar: ExtendedSIMDScalar,
MatrixType: MatrixProtocol<Scalar>
{
  
  package let matrixTypeDescriptor: SIMDMatrixTypeDescriptor
  package let matrixTypeArchetype: SIMDMatrixTypeNameArchetype
  package let matrixTier: SIMDMatrixTier
  
  package var scalarType: SIMDAggregateScalar {
    matrixTypeDescriptor.scalar
  }
  
  package var matrixShape: SIMDMatrixShape {
    matrixTypeDescriptor.shape
  }

  package init(
    matrixTypeDescriptor: SIMDMatrixTypeDescriptor,
    matrixTypeArchetype: SIMDMatrixTypeNameArchetype,
    matrixTier: SIMDMatrixTier
  ) {
    self.matrixTypeDescriptor = matrixTypeDescriptor
    self.matrixTypeArchetype = matrixTypeArchetype
    self.matrixTier = matrixTier
  }
  
}

extension MatrixMatrixAdditionOperation {
  
  static func outOfPlaceRepresentation(
    syntax: OutOfPlaceOperationSyntax,
    lhs: String,
    rhs: String
  ) -> String {
    switch syntax {
    case .namedMethod:
      "\(lhs).adding(\(rhs))"
    case .symbolicOperator:
      "\(lhs) + \(rhs)"
    case .simdCFunction:
      "simd_add(\(lhs), \(rhs))"
    }
  }
  
  package func testMethodName(
    forSemanticName semanticName: String
  ) -> String {
    "\(semanticName)_\(matrixTypeDescriptor.testMethodSuffix(forTier: matrixTier))"
  }
  
  package func provideOperationTestCases(
    node: AttributeSyntax,
    in context: some MacroExpansionContext,
    lhsProviders: some ExprSyntaxProtocol,
    rhsProviders: some ExprSyntaxProtocol,
    metric: some ExprSyntaxProtocol,
    tolerance: some ExprSyntaxProtocol,
    matrixOperationSyntax: OutOfPlaceOperationSyntax,
    nativeOperationSyntax: OutOfPlaceOperationSyntax
  ) throws -> [DeclSyntax] {
    
    let abstractOperation = Self.outOfPlaceRepresentation(
      syntax: matrixOperationSyntax,
      lhs: "X",
      rhs: "Y"
    )
    
    let matrixOperation = Self.outOfPlaceRepresentation(
      syntax: matrixOperationSyntax,
      lhs: "lhs",
      rhs: "rhs"
    )

    let nativeOperation = Self.outOfPlaceRepresentation(
      syntax: nativeOperationSyntax,
      lhs: "lhs",
      rhs: "rhs"
    )
    
    return [
      """
      @Test(
        "Out-of-place addition (\(raw: matrixShape.typeNameComponent))",
        arguments: \(lhsProviders), \(rhsProviders),
        @tags(
          .macroGenerated,
          .matrixAddition,
          .outOfPlace,
          .matrix\(raw: matrixShape.typeNameComponent)
        )
      )
      func \(raw: testMethodName(forSemanticName: "testOutOfPlaceAddition"))(
        lhsProvider: MatrixExampleProvider<MatrixType>,
        rhsProvider: MatrixExampleProvider<MatrixType>
      ) async throws {
        try await validateOutOfPlaceMatrixMatrixMatrixOperations(
          lhses: try lhsProvider.examples(),
          rhses: try rhsProvider.examples(),
          operation: "out-of-place addition (\(raw: matrixShape.typeNameComponent), `\(raw: abstractOperation)`)",
          metric: \(metric)
          tolerance: \(tolerance)
        ) { 
          (lhs, rhs) 
          in
          \(raw: matrixOperation)
        } nativeEquivalent: {
          (lhs, rhs)
          in
          \(raw: nativeOperation)
        } additionalValidation: {
          validationExample
          in
          try validateMatrixMatrixAdditionProperties(
            example: validationExample,
            tolerance: \(tolerance)
          )
        }
      }
      """,
      """
      @Test(
        "In-place addition cross-validation (\(raw: matrixShape.typeNameComponent))",
        arguments: \(lhsProviders), \(rhsProviders),
        @tags(
          .macroGenerated,
          .matrixAddition,
          .outOfPlace,
          .inPlace,
          .crossValidation,
          .matrix\(raw: matrixShape.typeNameComponent)
        )
      )
      func \(raw: testMethodName(forSemanticName: "testInPlaceAdditionWithOutOfPlaceAddition"))(
        lhsProvider: MatrixExampleProvider<MatrixType>,
        rhsProvider: MatrixExampleProvider<MatrixType>
      ) async throws {
        try await validateOutOfPlaceMatrixMatrixMatrixOperations(
          lhses: try lhsProvider.examples(),
          rhses: try rhsProvider.examples(),
          operation: "out-of-place addition (\(raw: matrixShape.typeNameComponent), `\(raw: abstractOperation)`)",
          metric: \(metric)
          tolerance: \(tolerance)
        ) {
          (lhs, rhs)
          in
          \(raw: matrixOperation)
        } nativeEquivalent: {
          (lhs, rhs)
          in
          \(raw: nativeOperation)
        } additionalValidation: {
          validationExample
          in
          try validateMatrixMatrixAdditionProperties(
            example: validationExample,
            tolerance: \(tolerance)
          )
        }
      }
      """,
    ]
  }

  
}

