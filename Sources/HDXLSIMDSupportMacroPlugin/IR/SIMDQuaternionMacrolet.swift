//
//  SIMDQuaternionMacrolet.swift
//

import SwiftSyntax

/// Layer context for quaternion macrolets.
struct QuaternionLayerContext {
  let layer: MatrixLayer  // re-uses .native / .storage / .wrapper
  let descriptor: QuaternionDescriptor

  /// Type name of "self" inside generated source.
  var selfTypeName: String {
    switch layer {
    case .native:  descriptor.nativeTypeName
    case .storage: descriptor.storageTypeName
    case .wrapper: "Quaternion<Scalar>"
    }
  }

  /// Type name of the wrapped value (for storage / wrapper layers).
  var wrappedTypeName: String? {
    switch layer {
    case .native:  nil
    case .storage: descriptor.nativeTypeName
    case .wrapper: "Scalar.QuaternionStorage"
    }
  }

  /// Compatible 3x3 matrix type name in this layer.
  var compatibleMatrix3x3TypeName: String {
    switch layer {
    case .native:  descriptor.compatible3x3.nativeTypeName
    case .storage: descriptor.compatible3x3.storageTypeName
    case .wrapper: "Matrix3x3<Scalar>"
    }
  }

  /// Compatible 4x4 matrix type name in this layer.
  var compatibleMatrix4x4TypeName: String {
    switch layer {
    case .native:  descriptor.compatible4x4.nativeTypeName
    case .storage: descriptor.compatible4x4.storageTypeName
    case .wrapper: "Matrix4x4<Scalar>"
    }
  }

  /// Scalar type name: concrete for native/storage, generic `Scalar` for wrapper.
  var scalarTypeName: String {
    switch layer {
    case .native, .storage: return descriptor.representation.swiftScalarTypeName
    case .wrapper: return "Scalar"
    }
  }
}

/// One slice of quaternion API code-generation. Parallels `SIMDMatrixMacrolet`.
protocol SIMDQuaternionMacrolet {
  func implementationDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax]
  func validationTestDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax]
}

extension SIMDQuaternionMacrolet {
  func validationTestDeclarations(in context: QuaternionLayerContext) -> [DeclSyntax] { [] }
}
