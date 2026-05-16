//
//  AddQuaternionConformanceMacros.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Native quaternion conformance macro (applied to `extension simd_quatf`,
/// `extension simd_quatd`, `extension simd_quath`).
public struct AddNativeQuaternionConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let descriptor = QuaternionDescriptor(representation: try MacroArgumentParser.representationArgument(node))
    let layerContext = QuaternionLayerContext(layer: .native, descriptor: descriptor)
    return QuaternionMacroletComposition.macrolets(for: descriptor, layer: .native)
      .flatMap { $0.implementationDeclarations(in: layerContext) }
  }
}

/// Storage quaternion conformance (applied to `FloatQuaternionStorage`, etc.).
public struct AddStorageQuaternionConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let descriptor = QuaternionDescriptor(representation: try MacroArgumentParser.representationArgument(node))
    let layerContext = QuaternionLayerContext(layer: .storage, descriptor: descriptor)
    return QuaternionMacroletComposition.macrolets(for: descriptor, layer: .storage)
      .flatMap { $0.implementationDeclarations(in: layerContext) }
  }
}

/// Wrapper quaternion conformance (applied to `Quaternion<Scalar>`).
public struct AddWrapperQuaternionConformanceMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    // `.float` is a stand-in; the wrapper layer never consults the
    // representation-specific name fields.
    let descriptor = QuaternionDescriptor(representation: .float)
    let layerContext = QuaternionLayerContext(layer: .wrapper, descriptor: descriptor)
    return QuaternionMacroletComposition.macrolets(for: descriptor, layer: .wrapper)
      .flatMap { $0.implementationDeclarations(in: layerContext) }
  }
}
