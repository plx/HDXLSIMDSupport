//
//  MacroArgumentParsing.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Errors raised by the matrix macros when they can't parse their attribute
/// arguments. Re-thrown as Swift diagnostics by the macro expansion path.
enum MacroArgumentError: Error, CustomStringConvertible {
  case missingArgument(label: String)
  case invalidArgument(label: String, reason: String)
  case unsupportedDeclaration(reason: String)

  var description: String {
    switch self {
    case .missingArgument(let label):
      return "missing required argument: `\(label)`"
    case .invalidArgument(let label, let reason):
      return "invalid `\(label)` argument: \(reason)"
    case .unsupportedDeclaration(let reason):
      return "macro cannot be applied here: \(reason)"
    }
  }
}

/// Helpers for pulling arguments out of an `AttributeSyntax` like
/// `@AddNativeMatrixConformance(rowCount: 2, columnCount: 2, representation: .float)`.
enum MacroArgumentParser {

  /// Extract an integer-literal argument. Errors if missing, non-integer, or
  /// outside the supplied range.
  static func intArgument(
    _ attribute: AttributeSyntax,
    label: String,
    allowed: ClosedRange<Int>? = nil
  ) throws -> Int {
    guard let expression = expressionArgument(attribute, label: label) else {
      throw MacroArgumentError.missingArgument(label: label)
    }
    guard let intLit = expression.as(IntegerLiteralExprSyntax.self),
          let value = Int(intLit.literal.text) else {
      throw MacroArgumentError.invalidArgument(label: label, reason: "expected integer literal, got `\(expression)`")
    }
    if let allowed, !allowed.contains(value) {
      throw MacroArgumentError.invalidArgument(label: label, reason: "value \(value) not in allowed range \(allowed)")
    }
    return value
  }

  /// Extract a `MatrixRepresentation` argument (e.g. `.float`).
  static func representationArgument(
    _ attribute: AttributeSyntax,
    label: String = "representation"
  ) throws -> MatrixRepresentation {
    guard let expression = expressionArgument(attribute, label: label) else {
      throw MacroArgumentError.missingArgument(label: label)
    }
    guard let representation = MatrixRepresentation.parse(from: expression) else {
      throw MacroArgumentError.invalidArgument(
        label: label,
        reason: "expected one of `.half`, `.float`, `.double`; got `\(expression)`"
      )
    }
    return representation
  }

  /// Pull the expression out of a `LabeledExprSyntax` by label.
  static func expressionArgument(_ attribute: AttributeSyntax, label: String) -> ExprSyntax? {
    guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else { return nil }
    for argument in arguments where argument.label?.text == label {
      return argument.expression
    }
    return nil
  }
}
