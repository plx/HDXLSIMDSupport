//
//  NativeSIMDRepresentableMacrolet.swift
//

import SwiftSyntax

/// `NativeSIMDRepresentable` conformance — only for the wrapper layer. The
/// wrapper reaches through TWO levels (`storage.storage`) to expose the raw
/// `simd_*` value.
///
/// At the storage layer we also emit `nativeSIMDRepresentation` as a synonym
/// for `storage`, so storage types can be used wherever a NativeSIMDRepresentable
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
          get { storage }
          set { storage = newValue }
          _modify { yield &storage }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(storage: nativeSIMDRepresentation)
        }
        """
      ]
    case .wrapper:
      // Storage types conform to NativeSIMDRepresentable (per the
      // ExtendedSIMDScalar protocol constraint), so we can refer to
      // `Scalar.MatrixNxMStorage.NativeSIMDRepresentation` directly.
      let storageTypeRef = "Scalar.Matrix\(descriptor.shapeLabel)Storage"
      return [
        """
        public typealias NativeSIMDRepresentation = \(raw: storageTypeRef).NativeSIMDRepresentation
        """,
        """
        @inlinable
        public var nativeSIMDRepresentation: NativeSIMDRepresentation {
          get { storage.nativeSIMDRepresentation }
          set { storage.nativeSIMDRepresentation = newValue }
          _modify { yield &storage.nativeSIMDRepresentation }
        }
        """,
        """
        @inlinable
        public init(nativeSIMDRepresentation: NativeSIMDRepresentation) {
          self.init(storage: \(raw: storageTypeRef)(nativeSIMDRepresentation: nativeSIMDRepresentation))
        }
        """
      ]
    }
  }
}
