//
//  AddMatrixConformanceMacros.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Attached member macro that expands into the conformance code for a
/// *native* matrix type (an `extension simd_floatNxM` etc.).
///
/// Expected invocation:
///
///     @AddNativeMatrixConformance(rowCount: 2, columnCount: 2, representation: .float)
///     extension simd_float2x2: Matrix2x2Protocol { }
public struct AddNativeMatrixConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let descriptor = try parseDescriptor(from: node)
    let layerContext = MatrixLayerContext(layer: .native, descriptor: descriptor)
    return composeMembers(in: layerContext)
  }
}

/// Attached member macro that expands into the conformance code for a
/// *storage* type (the per-(shape, representation) wrapper struct).
///
/// Expected invocation:
///
///     @AddStorageMatrixConformance(rowCount: 2, columnCount: 2, representation: .float)
///     internal struct FloatMatrix2x2Storage { }
public struct AddStorageMatrixConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let descriptor = try parseDescriptor(from: node)
    let layerContext = MatrixLayerContext(layer: .storage, descriptor: descriptor)
    return composeMembers(in: layerContext)
  }
}

/// Attached member macro that expands into the conformance code for the
/// public generic wrapper type (`Matrix2x2<Scalar>`).
///
/// Expected invocation:
///
///     @AddWrapperMatrixConformance(rowCount: 2, columnCount: 2)
///     public struct Matrix2x2<Scalar: ExtendedSIMDScalar> { }
///
/// Note: no `representation:` argument — the wrapper is generic. We use
/// `.float` as a stand-in inside the descriptor so type-name helpers that
/// don't apply to the wrapper layer never get consulted.
public struct AddWrapperMatrixConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let rowCount = try MacroArgumentParser.intArgument(node, label: "rowCount", allowed: 2...4)
    let columnCount = try MacroArgumentParser.intArgument(node, label: "columnCount", allowed: 2...4)
    // Use .float as a stand-in; the wrapper layer never uses representation-specific names.
    let descriptor = MatrixDescriptor(rowCount: rowCount, columnCount: columnCount, representation: .float)
    let layerContext = MatrixLayerContext(layer: .wrapper, descriptor: descriptor)
    return composeMembers(in: layerContext)
  }
}

// MARK: - Internal helpers

private func parseDescriptor(from attribute: AttributeSyntax) throws -> MatrixDescriptor {
  let rowCount = try MacroArgumentParser.intArgument(attribute, label: "rowCount", allowed: 2...4)
  let columnCount = try MacroArgumentParser.intArgument(attribute, label: "columnCount", allowed: 2...4)
  let representation = try MacroArgumentParser.representationArgument(attribute)
  return MatrixDescriptor(rowCount: rowCount, columnCount: columnCount, representation: representation)
}

private func composeMembers(in context: MatrixLayerContext) -> [DeclSyntax] {
  let macrolets = MatrixMacroletComposition.macrolets(for: context.descriptor, layer: context.layer)
  return macrolets.flatMap { $0.implementationDeclarations(in: context) }
}
