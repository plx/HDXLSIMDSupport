import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import Testing
import HDXLSIMDSupportProtocols

package enum ImplementationType {
  case namedMethods
  case symbolicOperators
  case simd_functions
}

package protocol MatrixDistanceMetric<Scalar, MatrixType> {
  associatedtype Scalar: ExtendedSIMDScalar
  associatedtype MatrixType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
  typealias NativeSIMDRepresention = MatrixType.NativeSIMDRepresentation
  
  static func distanceBetween(
    _ lhs: NativeSIMDRepresention,
    _ rhs: NativeSIMDRepresention
  ) -> Scalar

  static func distanceBetween(
    _ lhs: MatrixType,
    _ rhs: MatrixType
  ) -> Scalar

}

//package enum DistanceMetric {
//  
//  case l0
//  case l1
//  case lInfinity
//}
//
//package struct ValidationStrategy<Scalar> {
//  package var distanceMetric: DistanceMetric
//  package var tolerance: Scalar
//  
//  package init(distanceMetric: DistanceMetric, tolerance: Scalar) {
//    self.distanceMetric = distanceMetric
//    self.tolerance = tolerance
//  }
//}

package protocol SelfAwareExtendedSIMDScalar {
  static var simdAggregateScalar: SIMDAggregateScalar { get }
}

package protocol SIMDOperationProtocol<Scalar> {
  associatedtype Scalar: ExtendedSIMDScalar & SelfAwareExtendedSIMDScalar

  static var operationName: String { get }
  
}

package struct BinaryOperationExample<LHSType,RHSType,ResultType> {
  
  package var lhs: LHSType
  package var rhs: RHSType
  package var result: ResultType
  
}

//package protocol SIMDUnaryMatrixOperation<MatrixType,ResultType> : SIMDOperationProtocol
//{
//  associatedtype LHSType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
//  associatedtype RHSType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
//  associatedtype ResultType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
//  
//}
//


package protocol SIMDMatrixMatrixOperation<LHSType,RHSType,ResultType> : SIMDOperationProtocol
{
  associatedtype LHSType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
  associatedtype RHSType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
  associatedtype ResultType: MatrixProtocol<Scalar>, NativeSIMDRepresentable
  
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
  
  package var matrixSIMDRepresentation: NativeSIMDRepresentation {
    matrix.nativeSIMDRepresentation
  }

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
    strategy: ImplementationType
  ) throws -> [DeclSyntax]

  static func applyOutOfPlace(
    lhs: NativeSIMDRepresentation,
    rhs: NativeSIMDRepresentation,
    implementation: ImplementationType
  ) -> NativeSIMDRepresentation

  static func applyOutOfPlace(
    lhs: MatrixType,
    rhs: MatrixType,
    implementation: ImplementationType
  ) -> MatrixType

  static func _verifyOperation(
    lhs: NativeSIMDRepresentation,
    rhs: NativeSIMDRepresentation,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws

  static func _verifyOutOfPlace(
    lhs: NativeSIMDRepresentation,
    rhs: NativeSIMDRepresentation,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws

  static func _verifyNativeSIMDEquivalence(
    lhses: some Collection<NativeSIMDRepresentation>,
    rhses: some Collection<NativeSIMDRepresentation>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws

  static func _verifyNativeSIMDEquivalence(
    lhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    rhses: some AsyncSequence<NativeSIMDRepresentation, some Error>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
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

  
  static func applyOutOfPlace(
    lhs: ValidationPair,
    rhs: ValidationPair,
    implementation: ImplementationType
  ) -> ValidationPair {
    ValidationPair(
      matrix: applyOutOfPlace(
        lhs: lhs.matrix,
        rhs: rhs.matrix,
        implementation: implementation
      ),
      nativeSIMDRepresentation: applyOutOfPlace(
        lhs: lhs.nativeSIMDRepresentation,
        rhs: rhs.nativeSIMDRepresentation,
        implementation: implementation
      )
    )
  }

  package static func _verifyOutOfPlace(
    lhs: NativeSIMDRepresentation,
    rhs: NativeSIMDRepresentation,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws {
    let result = applyOutOfPlace(
      lhs: ValidationPair(nativeSIMDRepresentation: lhs),
      rhs: ValidationPair(nativeSIMDRepresentation: rhs),
      implementation: implementation
    )
    
    #expect(
      metric.distanceBetween(
        result.nativeSIMDRepresentation,
        result.matrixSIMDRepresentation
      ) < tolerance,
      """
      Found inconsistency for out-of-place applicatoin of binary operation: \(operationName).
      
      - `lhs`: \(String(reflecting: lhs))
      - `rhs`: \(String(reflecting: rhs))
      - `result.nativeSIMDRepresentation`: \(String(reflecting: result.nativeSIMDRepresentation))
      - `result.matrixSIMDRepresentation`: \(String(reflecting: result.matrixSIMDRepresentation))
      - `result.matrix`: \(String(reflecting: result.matrix))
      - `MatrixType(nativeSIMDRepresentation: lhs)`: \(String(reflecting: MatrixType(nativeSIMDRepresentation: lhs)))
      - `MatrixType(nativeSIMDRepresentation: rhs)`: \(String(reflecting: MatrixType(nativeSIMDRepresentation: rhs)))
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `column`: \(sourceLocation.column)
      """
    )
  }

  package static func verifyOutOfPlace(
    lhs: NativeSIMDRepresentation,
    rhs: NativeSIMDRepresentation,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) throws {
    try _verifyOutOfPlace(
      lhs: lhs,
      rhs: rhs,
      implementation: implementation,
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation
    )
  }

  package static func _verifyNativeSIMDEquivalence(
    lhses: @autoclosure () -> some AsyncSequence<NativeSIMDRepresentation, some Error>,
    rhses: @autoclosure () -> some AsyncSequence<NativeSIMDRepresentation, some Error>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) async throws {
    for try await lhs in lhses() {
      for try await rhs in rhses() {
        try _verifyOperation(
          lhs: lhs,
          rhs: rhs,
          implementation: implementation,
          metric: metric,
          tolerance: tolerance,
          function: function,
          sourceLocation: sourceLocation
        )
      }
    }
  }

  package static func _verifyNativeSIMDEquivalence(
    lhses: some Collection<NativeSIMDRepresentation>,
    rhses: some Collection<NativeSIMDRepresentation>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString,
    sourceLocation: Testing.SourceLocation
  ) throws {
    for  lhs in lhses {
      for rhs in rhses {
        try _verifyOperation(
          lhs: lhs,
          rhs: rhs,
          implementation: implementation,
          metric: metric,
          tolerance: tolerance,
          function: function,
          sourceLocation: sourceLocation
        )
      }
    }
  }

  package static func verifyNativeSIMDEquivalence(
    lhses: some Collection<NativeSIMDRepresentation>,
    rhses: some Collection<NativeSIMDRepresentation>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) throws {
    try _verifyNativeSIMDEquivalence(
      lhses: lhses,
      rhses: rhses,
      implementation: implementation,
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation
    )
  }

  package static func verifyNativeSIMDEquivalence(
    lhses: @autoclosure () -> some AsyncSequence<NativeSIMDRepresentation, some Error>,
    rhses: @autoclosure () -> some AsyncSequence<NativeSIMDRepresentation, some Error>,
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) async throws {
    try await _verifyNativeSIMDEquivalence(
      lhses: lhses(),
      rhses: rhses(),
      implementation: implementation,
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation
    )
  }

  package static func verifyNativeSIMDEquivalences(
    implementation: ImplementationType,
    metric: (some MatrixDistanceMetric<Scalar, MatrixType>).Type,
    tolerance: Scalar,
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) async throws {
    try await _verifyNativeSIMDEquivalence(
      lhses: exampleLHSes,
      rhses: exampleRHSes,
      implementation: implementation,
      metric: metric,
      tolerance: tolerance,
      function: function,
      sourceLocation: sourceLocation
    )
  }

}
