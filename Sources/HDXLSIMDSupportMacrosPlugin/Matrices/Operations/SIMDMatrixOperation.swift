import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import Testing
import HDXLSIMDSupportProtocols

package enum OperationStrategy {
  case namedMethods
  case symbolicOperators
  case simd_functions
}

package protocol SIMDMatrixOperationProtocol<Scalar, MatrixType> {
  associatedtype Scalar: ExtendedSIMDScalar
  associatedtype MatrixType: MatrixProtocol<Scalar>, NativeSIMDRepresentable

  typealias NativeSIMDRepresentation = MatrixType.NativeSIMDRepresentation
  typealias ValidationPair = MatrixWithNativeSIMDRepresentation<MatrixType>

  static var operationName: String { get }
  static var matrixTypeDescriptor: SIMDMatrixTypeDescriptor { get }
  
}

package struct MatrixWithNativeSIMDRepresentation<MatrixType>
where
MatrixType: MatrixProtocol,
MatrixType:NativeSIMDRepresentable
{
  package typealias Scalar = MatrixType.Scalar
  package typealias NativeSIMDRepresentation = MatrixType.NativeSIMDRepresentation
  
  package var matrix: MatrixType
  package var nativeSIMDRepresentation: NativeSIMDRepresentation

  package init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
    self.matrix = MatrixType(nativeSIMDRepresentation: nativeSIMDRepresentation)
    self.nativeSIMDRepresentation = matrix.nativeSIMDRepresentation
  }

  package init(matrix: MatrixType) {
    self.matrix = matrix
    self.nativeSIMDRepresentation = matrix.nativeSIMDRepresentation
  }
  
  package init(
    matrix: MatrixType,
    nativeSIMDRepresentation: NativeSIMDRepresentation
  ) {
    self.matrix = matrix
    self.nativeSIMDRepresentation = nativeSIMDRepresentation
  }
  
}

package protocol SIMDBinaryMatrixOperationProtocol<Scalar, MatrixType>: SIMDMatrixOperationProtocol {
  
  associatedtype LHSFailure: Error
  associatedtype ExampleLHSes: AsyncSequence<NativeSIMDRepresentation, LHSFailure>

  associatedtype RHSFailure: Error
  associatedtype ExampleRHSes: AsyncSequence<NativeSIMDRepresentation, RHSFailure>
  
  static var exampleLHSes: ExampleLHSes { get }
  static var exampleRHSes: ExampleRHSes { get }

  static func provideInPlaceImplementation(
    node: AttributeSyntax,
    declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext,
    strategy: OperationStrategy
  ) throws -> [DeclSyntax]

  static func applyOutOfPlace(
    lhs: ValidationPair,
    rhs: ValidationPair
  ) -> ValidationPair
  
  static func _verifyOutOfPlace(
    lhs: ValidationPair,
    rhs: ValidationPair,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws

  static func _verifyNativeSIMDEquivalence(
    lhses: some Collection<NativeSIMDRepresentation>,
    rhses: some Collection<NativeSIMDRepresentation>,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws

  static func _verifyNativeSIMDEquivalence(
    lhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    rhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) async throws

}


/*
 static func provideOutOfPlaceImplementation(
 node: AttributeSyntax,
 declaration: some DeclGroupSyntax,
 in context: some MacroExpansionContext,
 strategy: OperationStrategy
 ) throws -> [DeclSyntax]
 
 static func applyInPlace(
 lhs: inout ValidationPair,
 rhs: ValidationPair
 ) -> ValidationPair
 
 static func _verifyInPlace(
 lhs: ValidationPair,
 rhs: ValidationPair,
 function: StaticString,
 sourceLocation: Testing.SourceLocation
 ) throws
 
 */
extension SIMDBinaryMatrixOperationProtocol {
  
  package static func verifyNativeSIMDEquivalence(
    lhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    rhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) async throws {
    try await _verifyNativeSIMDEquivalence(
      lhses: lhses,
      rhses: rhses,
      function: function,
      sourceLocation: sourceLocation
    )
  }

  package static func verifyNativeSIMDEquivalence(
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) async throws {
    try await _verifyNativeSIMDEquivalence(
      lhses: exampleLHSes,
      rhses: exampleRHSes,
      function: function,
      sourceLocation: sourceLocation
    )
  }

}
