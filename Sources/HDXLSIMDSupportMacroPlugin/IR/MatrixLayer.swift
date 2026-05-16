//
//  MatrixLayer.swift
//

/// The three layers at which matrix conformances live, in order of decreasing
/// concreteness:
///
/// - `.native`: the C-bridged `simd_floatNxM` types. Implementations dispatch
///   directly to native SIMD operators (`return self + other`, `self.inverse`,
///   etc.). These conformances are added in `extension simd_floatNxM`.
///
/// - `.storage`: hand-written struct (`FloatMatrix2x2Storage`, etc.) that wraps
///   exactly one stored value of the native type. Implementations forward to
///   the wrapped native value.
///
/// - `.wrapper`: the public generic `Matrix2x2<Scalar>` (etc.). Wraps exactly
///   one stored value of `Scalar.Matrix2x2Storage`. Forwards to the storage.
enum MatrixLayer: Equatable {
  case native
  case storage
  case wrapper
}

/// Context handed to every macrolet at expansion time. Captures which layer
/// we're emitting code for and the precomputed names for the *current* type
/// and the *wrapped* type (when applicable).
struct MatrixLayerContext {
  /// Which layer we're generating code for.
  let layer: MatrixLayer

  /// The matrix descriptor for this expansion.
  let descriptor: MatrixDescriptor

  /// Type name of the "self" type being conformed.
  ///
  /// - `.native`: `simd_float2x2` (concrete native)
  /// - `.storage`: `FloatMatrix2x2Storage` (concrete storage)
  /// - `.wrapper`: `Matrix2x2<Scalar>` (generic wrapper; the bare base name is
  ///   `Matrix2x2`, available via `bareSelfTypeName`)
  var selfTypeName: String {
    switch layer {
    case .native:  descriptor.nativeTypeName
    case .storage: descriptor.storageTypeName
    case .wrapper: "\(descriptor.wrapperTypeName)<Scalar>"
    }
  }

  /// Bare name of the "self" type without generic parameters, suitable for
  /// initializers like `Self(...)` or static references like `Matrix2x2.foo`.
  var bareSelfTypeName: String {
    switch layer {
    case .native:  descriptor.nativeTypeName
    case .storage: descriptor.storageTypeName
    case .wrapper: descriptor.wrapperTypeName
    }
  }

  /// Type name of the wrapped value, if there is one.
  ///
  /// - `.native`: nil (there is no wrapped layer below)
  /// - `.storage`: `simd_float2x2`
  /// - `.wrapper`: `Scalar.Matrix2x2Storage`
  var wrappedTypeName: String? {
    switch layer {
    case .native:  nil
    case .storage: descriptor.nativeTypeName
    case .wrapper: "Scalar.Matrix\(descriptor.shapeLabel)Storage"
    }
  }

  /// Compatible-shape type name (in the *same* layer + representation) for a
  /// hypothetical (rowCount, columnCount) pair. Returns nil if the shape is
  /// not supported (e.g. dimensions outside `2...4`).
  func selfCompatibleTypeName(rowCount: Int, columnCount: Int) -> String? {
    guard let other = descriptor.compatibleDescriptor(rowCount: rowCount, columnCount: columnCount) else {
      return nil
    }
    switch layer {
    case .native:  return other.nativeTypeName
    case .storage: return other.storageTypeName
    case .wrapper: return "\(other.wrapperTypeName)<Scalar>"
    }
  }

  /// Compatible-shape type name at the *wrapped* layer. Returns nil if there
  /// is no wrapped layer (native) or if the shape is unsupported.
  func wrappedCompatibleTypeName(rowCount: Int, columnCount: Int) -> String? {
    guard let other = descriptor.compatibleDescriptor(rowCount: rowCount, columnCount: columnCount) else {
      return nil
    }
    switch layer {
    case .native:  return nil
    case .storage: return other.nativeTypeName
    case .wrapper: return "Scalar.Matrix\(other.shapeLabel)Storage"
    }
  }

  /// Path that reaches the wrapped value from `self` (e.g. `self.storage`).
  /// nil for the `.native` layer.
  var wrappedAccessExpression: String? {
    switch layer {
    case .native:  nil
    case .storage: "storage"
    case .wrapper: "storage"
    }
  }

  /// Scalar type name as written in source.
  ///
  /// - `.native`, `.storage`: concrete (`Float`, `Double`, `Float16`)
  /// - `.wrapper`: the generic parameter `Scalar`
  var scalarTypeName: String {
    switch layer {
    case .native, .storage:
      return descriptor.representation.swiftScalarTypeName
    case .wrapper:
      return "Scalar"
    }
  }
}
