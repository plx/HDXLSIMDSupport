//
//  SubscriptingMacrolet.swift
//

import SwiftSyntax

/// Emits the subscript suite required by MatrixProtocol:
///
///   - `[columnIndex:]` -> ColumnVector
///   - `[rowIndex:]` -> RowVector
///   - `[linearizedScalarIndex:]` -> Scalar
///   - `[columnIndex:rowIndex:]` -> Scalar
///   - `[position:]` -> Scalar
///
/// At the native layer, only `[columnIndex:]` is provided automatically by
/// the simd overlay (via direct `columns.0` / `columns.1` / ... access).
/// We emit the explicit form for every layer so the protocol witness is
/// always there, with a `switch` over `columnIndex`. For `[rowIndex:]` we
/// build a fresh `RowVector` from per-column entries.
struct SubscriptingMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    result.append(contentsOf: columnSubscript(in: context))
    result.append(contentsOf: rowSubscript(in: context))
    result.append(contentsOf: linearizedScalarSubscript(in: context))
    result.append(contentsOf: columnRowSubscript(in: context))
    result.append(contentsOf: positionSubscript(in: context))
    return result
  }

  // MARK: - subscript(columnIndex:)

  private func columnSubscript(in context: MatrixLayerContext) -> [DeclSyntax] {
    let getCases = (0..<descriptor.columnCount)
      .map { "case \($0): return columns.\($0)" }
      .joined(separator: "\n")
    let setCases = (0..<descriptor.columnCount)
      .map { "case \($0): columns.\($0) = newValue" }
      .joined(separator: "\n")
    let modifyCases = (0..<descriptor.columnCount)
      .map { "case \($0): yield &columns.\($0)" }
      .joined(separator: "\n")
    return [
      """
      @inlinable
      public subscript(columnIndex columnIndex: Int) -> ColumnVector {
        get {
          precondition(Self.columnIndexRange.contains(columnIndex))
          switch columnIndex {
          \(raw: getCases)
          default:
            fatalError("invalid column index \\(columnIndex)")
          }
        }
        set {
          precondition(Self.columnIndexRange.contains(columnIndex))
          switch columnIndex {
          \(raw: setCases)
          default:
            fatalError("invalid column index \\(columnIndex)")
          }
        }
        _modify {
          precondition(Self.columnIndexRange.contains(columnIndex))
          switch columnIndex {
          \(raw: modifyCases)
          default:
            fatalError("invalid column index \\(columnIndex)")
          }
        }
      }
      """
    ]
  }

  // MARK: - subscript(rowIndex:)

  private func rowSubscript(in context: MatrixLayerContext) -> [DeclSyntax] {
    let columnList = (0..<descriptor.columnCount).map { "columns.\($0)[rowIndex]" }.joined(separator: ",")
    let setAssignments = (0..<descriptor.columnCount)
      .map { "columns.\($0)[rowIndex] = newValue[\($0)]" }
      .joined(separator: "\n")
    return [
      """
      @inlinable
      public subscript(rowIndex rowIndex: Int) -> RowVector {
        get {
          precondition(Self.rowIndexRange.contains(rowIndex))
          return RowVector(\(raw: columnList))
        }
        set {
          precondition(Self.rowIndexRange.contains(rowIndex))
          \(raw: setAssignments)
        }
      }
      """
    ]
  }

  // MARK: - subscript(linearizedScalarIndex:)

  private func linearizedScalarSubscript(in context: MatrixLayerContext) -> [DeclSyntax] {
    return [
      """
      @inlinable
      public subscript(linearizedScalarIndex linearizedScalarIndex: Int) -> Scalar {
        get {
          precondition(Self.linearizedScalarIndexRange.contains(linearizedScalarIndex))
          let (columnIndex, rowIndex) = Self.columnRowIndex(forLinearizedScalarIndex: linearizedScalarIndex)
          return self[columnIndex: columnIndex, rowIndex: rowIndex]
        }
        set {
          precondition(Self.linearizedScalarIndexRange.contains(linearizedScalarIndex))
          let (columnIndex, rowIndex) = Self.columnRowIndex(forLinearizedScalarIndex: linearizedScalarIndex)
          self[columnIndex: columnIndex, rowIndex: rowIndex] = newValue
        }
      }
      """
    ]
  }

  // MARK: - subscript(columnIndex:rowIndex:)

  private func columnRowSubscript(in context: MatrixLayerContext) -> [DeclSyntax] {
    return [
      """
      @inlinable
      public subscript(columnIndex columnIndex: Int, rowIndex rowIndex: Int) -> Scalar {
        get {
          precondition(Self.columnIndexRange.contains(columnIndex))
          precondition(Self.rowIndexRange.contains(rowIndex))
          return self[columnIndex: columnIndex][rowIndex]
        }
        set {
          precondition(Self.columnIndexRange.contains(columnIndex))
          precondition(Self.rowIndexRange.contains(rowIndex))
          self[columnIndex: columnIndex][rowIndex] = newValue
        }
      }
      """
    ]
  }

  // MARK: - subscript(position:)

  private func positionSubscript(in context: MatrixLayerContext) -> [DeclSyntax] {
    return [
      """
      @inlinable
      public subscript(position position: MatrixPosition) -> Scalar {
        get {
          return self[columnIndex: position.columnIndex, rowIndex: position.rowIndex]
        }
        set {
          self[columnIndex: position.columnIndex, rowIndex: position.rowIndex] = newValue
        }
      }
      """
    ]
  }
}
