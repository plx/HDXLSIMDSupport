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
          storage.multiplied(onLeftBy: columnVector)
        }
        """,
        """
        @inlinable
        public func multiplied(onRightBy rowVector: RowVector) -> ColumnVector {
          storage.multiplied(onRightBy: rowVector)
        }
        """
      ]
    }
  }

  func validationTestDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    let wrapper = descriptor.wrapperTypeInstantiation
    let native = descriptor.nativeTypeName
    let scalar = descriptor.representation.swiftScalarTypeName
    let columnVector = descriptor.columnVectorTypeName
    let rowVector = descriptor.rowVectorTypeName
    // For left-mul: columnVector (length=rowCount) * matrix → rowVector (length=columnCount)
    // For right-mul: matrix * rowVector (length=columnCount) → columnVector (length=rowCount)
    let leftNativeExpr: String
    let rightNativeExpr: String
    switch descriptor.representation {
    case .half:
      leftNativeExpr = "simd_mul(v, m)"
      rightNativeExpr = "simd_mul(m, v)"
    case .float, .double:
      leftNativeExpr = "v * m"
      rightNativeExpr = "m * v"
    }
    let leftBuildArgs = (0..<descriptor.rowCount).map { "v[\($0)]" }.joined(separator: ", ")
    let rightBuildArgs = (0..<descriptor.columnCount).map { "v[\($0)]" }.joined(separator: ", ")
    return [
      """
      func test_vectorLeftMultiplication() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let vectors: [[\(raw: scalar)]] = \(raw: descriptor.probeVectorsArrayExpression(length: descriptor.rowCount))
        validateMatrixVectorEquivalence(
          "multiplied(onLeftBy: \(raw: columnVector))",
          matrices: probes,
          vectors: vectors,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          buildInVec: { (v: [\(raw: scalar)]) -> \(raw: columnVector) in \(raw: columnVector)(\(raw: leftBuildArgs)) },
          wrapped: { (m: \(raw: wrapper), v: \(raw: columnVector)) -> \(raw: rowVector) in m.multiplied(onLeftBy: v) },
          native: { (m: \(raw: native), v: \(raw: columnVector)) -> \(raw: rowVector) in \(raw: leftNativeExpr) }
        )
      }
      """,
      """
      func test_vectorRightMultiplication() {
        let probes: [[[\(raw: scalar)]]] = \(raw: descriptor.probeMatricesArrayExpression)
        let vectors: [[\(raw: scalar)]] = \(raw: descriptor.probeVectorsArrayExpression(length: descriptor.columnCount))
        validateMatrixVectorEquivalence(
          "multiplied(onRightBy: \(raw: rowVector))",
          matrices: probes,
          vectors: vectors,
          epsilon: \(raw: descriptor.defaultEpsilonLiteral),
          buildInVec: { (v: [\(raw: scalar)]) -> \(raw: rowVector) in \(raw: rowVector)(\(raw: rightBuildArgs)) },
          wrapped: { (m: \(raw: wrapper), v: \(raw: rowVector)) -> \(raw: columnVector) in m.multiplied(onRightBy: v) },
          native: { (m: \(raw: native), v: \(raw: rowVector)) -> \(raw: columnVector) in \(raw: rightNativeExpr) }
        )
      }
      """
    ]
  }
}
