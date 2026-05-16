//
//  AddMatrixConformanceTestsMacro.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Freestanding declaration macro that expands into top-level
/// `swift-testing` `@Test` functions for one specific (shape, representation)
/// combination of macro-generated matrix conformance. Each per-API macrolet
/// contributes its slice's test declarations via
/// `validationTestDeclarations(in:)`.
public struct GenerateMatrixConformanceTestsMacro: DeclarationMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let rowCount = try intArgument(of: node, label: "rowCount", allowed: 2...4)
    let columnCount = try intArgument(of: node, label: "columnCount", allowed: 2...4)
    let representation = try representationArgument(of: node)
    let descriptor = MatrixDescriptor(rowCount: rowCount, columnCount: columnCount, representation: representation)
    let layerContext = MatrixLayerContext(layer: .wrapper, descriptor: descriptor)
    let macrolets = MatrixMacroletComposition.macrolets(for: descriptor, layer: .wrapper)
    return macrolets.flatMap { $0.validationTestDeclarations(in: layerContext) }
  }
}

// MARK: - Freestanding argument helpers

private func intArgument(
  of node: some FreestandingMacroExpansionSyntax,
  label: String,
  allowed: ClosedRange<Int>
) throws -> Int {
  guard let expression = expressionArgument(of: node, label: label) else {
    throw MacroArgumentError.missingArgument(label: label)
  }
  guard let intLit = expression.as(IntegerLiteralExprSyntax.self),
        let value = Int(intLit.literal.text) else {
    throw MacroArgumentError.invalidArgument(label: label, reason: "expected integer literal, got `\(expression)`")
  }
  guard allowed.contains(value) else {
    throw MacroArgumentError.invalidArgument(label: label, reason: "value \(value) not in allowed range \(allowed)")
  }
  return value
}

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
