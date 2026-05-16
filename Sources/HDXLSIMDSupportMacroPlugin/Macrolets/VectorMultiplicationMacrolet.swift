//
//  VectorMultiplicationMacrolet.swift
//

import SwiftSyntax

/// Matrix-vector multiplications:
///
///   - `multiplied(onLeftBy columnVector:) -> RowVector`  (≡ `columnVector * self`)
///   - `multiplied(onRightBy rowVector:) -> ColumnVector` (≡ `self * rowVector`)
///
/// Float/Double natives dispatch to the simd `*` overloads. Half natives have
/// no operator overloads on `simd_halfNxM`, so they use the C-level
/// `simd_mul(vec, mat)` / `simd_mul(mat, vec)` (vector-out, unaffected by
/// the half-3-row overlay bug). Storage/wrapper forwards.
struct VectorMultiplicationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        return [
          """
          @inlinable
          public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
            simd_mul(columnVector, self)
          }
          """,
          """
          @inlinable
          public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
            simd_mul(self, rowVector)
          }
          """
        ]
      }
      return [
        """
        @inlinable
        public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
          columnVector * self
        }
        """,
        """
        @inlinable
        public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
          self * rowVector
        }
        """
      ]
    case .storage, .wrapper:
      return [
        """
        @inlinable
        public func multiplied(onLeftBy columnVector: ColumnVector) -> RowVector {
          passthroughValue.multiplied(onLeftBy: columnVector)
        }
        """,
        """
        @inlinable
        public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
          passthroughValue.multiplied(onRightBy: rowVector)
        }
        """
      ]
    }
  }
}
