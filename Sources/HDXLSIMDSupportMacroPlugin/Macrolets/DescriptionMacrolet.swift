//
//  DescriptionMacrolet.swift
//

import SwiftSyntax

/// CustomStringConvertible + CustomDebugStringConvertible. Native simd types
/// already have these, so we only emit them on storage / wrapper.
struct DescriptionMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return []
    case .storage:
      let typename = descriptor.storageTypeName
      return [
        """
        @inlinable
        public var description: String {
          get { "\(raw: typename): \\(String(describing: storage))" }
        }
        """,
        """
        @inlinable
        public var debugDescription: String {
          get { "\(raw: typename)(storage: \\(String(reflecting: storage)))" }
        }
        """
      ]
    case .wrapper:
      let typename = descriptor.wrapperTypeName
      return [
        """
        @inlinable
        public var description: String {
          get { "\(raw: typename): \\(String(describing: nativeSIMDRepresentation))" }
        }
        """,
        """
        @inlinable
        public var debugDescription: String {
          get { "\(raw: typename)<\\(String(reflecting: Scalar.self))>(nativeSIMDRepresentation: \\(String(reflecting: nativeSIMDRepresentation)))" }
        }
        """
      ]
    }
  }
}
