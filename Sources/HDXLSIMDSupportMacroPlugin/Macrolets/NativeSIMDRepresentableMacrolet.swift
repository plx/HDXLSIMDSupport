//
//  NativeSIMDRepresentableMacrolet.swift
//

import SwiftSyntax

/// `NativeSIMDRepresentable` conformance — only for the wrapper layer. The
/// wrapper reaches through TWO levels (`passthroughValue.storage`) to expose the raw
/// `simd_*` value.
///
/// At the passthroughValue layer we also emit `nativeSIMDRepresentation` as a synonym
/// for `passthroughValue`, so passthroughValue types can be used wherever a NativeSIMDRepresentable
/// is expected (test scaffolding leans on this).
struct NativeSIMDRepresentableMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // simd_floatNxM IS its own native representation; conformance via extension.
      return [
        """
        public typealias NativeSIMDRepresentation = Self
        """,
        """
        @inlinable
        public var nativeSIMDRepresentation: Self {
          get { self }
          set { self = newValue }
          _modify { yield &self }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: Self) {
          self = nativeSIMDRepresentation
        }
        """
      ]
    case .storage:
      return [
        """
        public typealias NativeSIMDRepresentation = \(raw: descriptor.nativeTypeName)
        """,
        """
        @inlinable
        public var nativeSIMDRepresentation: NativeSIMDRepresentation {
          get { passthroughValue }
          set { passthroughValue = newValue }
          _modify { yield &passthroughValue }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(passthroughValue: nativeSIMDRepresentation)
        }
        """
      ]
    case .wrapper:
      // During the migration, the underlying `Scalar.MatrixNxMStorage` may or
      // may not have a `NativeSIMDRepresentation` typealias yet — but it DOES
      // have a `PassthroughValue` (the existing Passthrough conformance), and
      // `PassthroughValue.PassthroughValue` is the native simd type. We reach
      // through the Passthrough chain so the wrapper works regardless of
      // which underlying storages have already been migrated.
      return [
        """
        public typealias NativeSIMDRepresentation = PassthroughValue.PassthroughValue
        """,
        """
        @inlinable
        public var nativeSIMDRepresentation: NativeSIMDRepresentation {
          get { passthroughValue.passthroughValue }
          set { passthroughValue.passthroughValue = newValue }
          _modify { yield &passthroughValue.passthroughValue }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(passthroughValue: PassthroughValue(passthroughValue: nativeSIMDRepresentation))
        }
        """
      ]
    }
  }
}
