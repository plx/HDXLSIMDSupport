//
//  StorageBackingMacrolet.swift
//

import SwiftSyntax

/// Emits the stored value + initializer that ties a wrapping layer to its
/// underlying value. The wrapping/storage chain is:
/// `Matrix2x2<Scalar>` → `Scalar.Matrix2x2Storage` → `simd_float2x2`
/// (etc.), and the `Storage` typealias plus `init(storage:)` are how each
/// wrapping layer addresses the layer it wraps. Every other macrolet relies
/// on this naming to forward operations downward.
///
/// - Native layer: emits nothing (`simd_floatNxM` IS its own value).
/// - Storage / Wrapper: emits `typealias Storage`, the stored
///   `storage` property, and `init(storage:)`.
struct StorageBackingMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    guard let wrappedTypeName = context.wrappedTypeName else { return [] }
    return [
      "public typealias Storage = \(raw: wrappedTypeName)",
      """
      public var storage: Storage
      """,
      """
      @inlinable
      public init(storage: Storage) {
        self.storage = storage
      }
      """
    ]
  }
}
