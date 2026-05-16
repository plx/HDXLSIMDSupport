//
//  StorageBackingMacrolet.swift
//

import SwiftSyntax

/// Emits the stored value + initializer that ties a wrapping layer to its
/// underlying value. During the migration we keep the *name* `passthroughValue`
/// so the generated types continue to satisfy the existing `Passthrough`
/// protocol (and so they can interoperate with not-yet-migrated types via
/// existing `Passthrough` extensions). Once all types are migrated, this
/// macrolet will be flipped over to emit `storage`/`init(storage:)` and
/// `Passthrough` will be demolished.
///
/// - Native layer: emits nothing (`simd_floatNxM` IS its own value).
/// - Storage / Wrapper: emits `typealias PassthroughValue`, the stored
///   `passthroughValue` property, and `init(passthroughValue:)`.
struct StorageBackingMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard let wrappedTypeName = context.wrappedTypeName else { return [] }
    return [
      "public typealias PassthroughValue = \(raw: wrappedTypeName)",
      """
      public var passthroughValue: PassthroughValue
      """,
      """
      @inlinable
      public init(passthroughValue: PassthroughValue) {
        self.passthroughValue = passthroughValue
      }
      """
    ]
  }
}
