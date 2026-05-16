//
//  AddQuaternionConformanceTestsMacro.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Freestanding declaration macro that expands into XCTest test methods
/// validating the macro-generated quaternion conformance for a single
/// representation. Each per-API macrolet contributes its slice's test
/// declarations via `validationTestDeclarations(in:)`.
public struct GenerateQuaternionConformanceTestsMacro: DeclarationMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let representation = try representationArgument(of: node)
    let descriptor = QuaternionDescriptor(representation: representation)
    let layerContext = QuaternionLayerContext(layer: .wrapper, descriptor: descriptor)
    let macrolets = QuaternionMacroletComposition.macrolets(for: descriptor, layer: .wrapper)
    return macrolets.flatMap { $0.validationTestDeclarations(in: layerContext) }
  }
}

// MARK: - Freestanding argument helpers

private func representationArgument(of node: some FreestandingMacroExpansionSyntax) throws -> MatrixRepresentation {
  guard let expression = expressionArgument(of: node, label: "representation") else {
    throw MacroArgumentError.missingArgument(label: "representation")
  }
  guard let representation = MatrixRepresentation.parse(from: expression) else {
    throw MacroArgumentError.invalidArgument(
      label: "representation",
      reason: "expected `.half | .float | .double`, got `\(expression)`"
    )
  }
  return representation
}

private func expressionArgument(of node: some FreestandingMacroExpansionSyntax, label: String) -> ExprSyntax? {
  for argument in node.arguments where argument.label?.text == label {
    return argument.expression
  }
  return nil
}
