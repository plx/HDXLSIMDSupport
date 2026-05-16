//
//  CompatibleMatricesMacrolet.swift
//

import SwiftSyntax

/// Emits the `CompatibleMatrixMxN` typealiases that a concrete `MatrixNxMProtocol`
/// requires. Which compat aliases are required depends on the shape:
///
/// - 2x2 needs: 2x3, 3x2, 2x4, 4x2
/// - 2x3 needs: 2x2, 3x3, 3x2, 2x4, 4x2, 3x4, 4x3
/// - 2x4 needs: 2x2, 4x4, 2x3, 4x2, 3x2, 3x4, 4x3
/// - 3x2 needs: 2x2, 3x3, 2x3, 2x4, 4x2, 3x4, 4x3
/// - 3x3 needs: 2x3, 3x2, 3x4, 4x3   (+ CompatibleQuaternion)
/// - 3x4 needs: 4x4, 3x3, 2x3, 3x2, 2x4, 4x2, 4x3
/// - 4x2 needs: 4x4, 2x2, 2x3, 3x2, 2x4, 3x4, 4x3
/// - 4x3 needs: 4x4, 3x3, 2x3, 3x2, 2x4, 4x2, 3x4
/// - 4x4 needs: 2x4, 4x2, 3x4, 4x3   (+ CompatibleQuaternion)
///
/// This mirrors what the existing `MatrixNxMProtocol` definitions require.
struct CompatibleMatricesMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    for (label, rowCount, columnCount) in requiredCompatibleShapes() {
      guard let typeName = context.selfCompatibleTypeName(rowCount: rowCount, columnCount: columnCount) else {
        continue
      }
      result.append("public typealias \(raw: label) = \(raw: typeName)")
    }
    // 3x3 and 4x4 need a CompatibleQuaternion alias. The quaternion type names
    // mirror the matrix-storage prefixing scheme:
    //   - .native  → simd_quat{ f | d } (and simd_quath)
    //   - .storage → {Float|Double|Half}QuaternionStorage
    //   - .wrapper → Quaternion<Scalar>
    if descriptor.isSquare && (descriptor.rowCount == 3 || descriptor.rowCount == 4) {
      result.append("public typealias CompatibleQuaternion = \(raw: quaternionTypeName(in: context))")
    }
    return result
  }

  /// Returns the (typealias label, rowCount, columnCount) triples appropriate
  /// for the current descriptor's shape, filtering out the descriptor's own
  /// shape (a matrix isn't its own "compatible-other-shape").
  private func requiredCompatibleShapes() -> [(label: String, rowCount: Int, columnCount: Int)] {
    var shapes: Set<Shape> = []
    let (rc, cc) = (descriptor.rowCount, descriptor.columnCount)

    // For square matrices we don't need most of the "general" cross-shape compat
    // typealiases — the existing protocols only declare the specific compats
    // that exist in the protocols' source. We mirror that exactly.
    switch (rc, cc) {
    case (2, 2):
      shapes = [.init(2, 3), .init(3, 2), .init(2, 4), .init(4, 2)]
    case (2, 3):
      shapes = [.init(2, 2), .init(3, 3), .init(3, 2), .init(2, 4), .init(4, 2), .init(3, 4), .init(4, 3)]
    case (2, 4):
      shapes = [.init(2, 2), .init(4, 4), .init(2, 3), .init(4, 2), .init(3, 2), .init(3, 4), .init(4, 3)]
    case (3, 2):
      shapes = [.init(2, 2), .init(3, 3), .init(2, 3), .init(2, 4), .init(4, 2), .init(3, 4), .init(4, 3)]
    case (3, 3):
      shapes = [.init(2, 3), .init(3, 2), .init(3, 4), .init(4, 3)]
    case (3, 4):
      shapes = [.init(4, 4), .init(3, 3), .init(2, 3), .init(3, 2), .init(2, 4), .init(4, 2), .init(4, 3)]
    case (4, 2):
      shapes = [.init(4, 4), .init(2, 2), .init(2, 3), .init(3, 2), .init(2, 4), .init(3, 4), .init(4, 3)]
    case (4, 3):
      shapes = [.init(4, 4), .init(3, 3), .init(2, 3), .init(3, 2), .init(2, 4), .init(4, 2), .init(3, 4)]
    case (4, 4):
      shapes = [.init(2, 4), .init(4, 2), .init(3, 4), .init(4, 3)]
    default:
      return []
    }
    let sortedShapes = shapes.sorted { (lhs, rhs) in
      if lhs.rowCount != rhs.rowCount { return lhs.rowCount < rhs.rowCount }
      return lhs.columnCount < rhs.columnCount
    }
    return sortedShapes.map { shape in
      (label: "CompatibleMatrix\(shape.columnCount)x\(shape.rowCount)",
       rowCount: shape.rowCount,
       columnCount: shape.columnCount)
    }
  }

  private struct Shape: Hashable {
    let rowCount: Int
    let columnCount: Int
    init(_ rowCount: Int, _ columnCount: Int) {
      self.rowCount = rowCount
      self.columnCount = columnCount
    }
  }

  private func quaternionTypeName(in context: MatrixLayerContext) -> String {
    switch context.layer {
    case .native:
      switch descriptor.representation {
      case .half:   return "simd_quath"
      case .float:  return "simd_quatf"
      case .double: return "simd_quatd"
      }
    case .storage:
      switch descriptor.representation {
      case .half:   return "HalfQuaternionStorage"
      case .float:  return "FloatQuaternionStorage"
      case .double: return "DoubleQuaternionStorage"
      }
    case .wrapper:
      return "Quaternion<Scalar>"
    }
  }
}
