//
//  InitializationMacrolet.swift
//

import SwiftSyntax

/// Emits the initializer suite required by MatrixProtocol:
///
///   - `init()` — zero matrix
///   - `init(repeating: Scalar)` — every entry set to the scalar
///   - `init(diagonal: DiagonalVector)` — diagonal-set, zero elsewhere
///   - `init(columns:)` — from a packed-columns tuple
///   - `init(columnVectors: [ColumnVector])` — from an array of columns
///   - `init(rows:)` — from a packed-rows tuple
///   - `init(rowVectors: [RowVector])` — from an array of rows
///   - `init(linearizedScalars: [Scalar])` — from column-major scalar array
///   - `init(scalars: [[Scalar]])` — from an array-of-arrays (visual layout)
///
/// And the shape-specific positional initializer:
///
///   - `init(_ c0: ColumnVector, _ c1: ColumnVector, ...)` — columnCount-many
///     column-vector arguments.
///
/// Native conformances already have most of these from the simd overlay, but
/// the protocol requires `init(repeating:)` to fill every entry (not the
/// diagonal — see the merged half-precision PR) and `init(rowVectors:)` /
/// `init(linearizedScalars:)` / `init(scalars:)` need explicit emission.
///
/// Native overlay quirks:
/// - The bridged `init(_ scalar: Scalar)` is a diagonal initializer, NOT a
///   repeating initializer, so we always emit our own `init(repeating:)`.
/// - The bridged `init(_ columns0, _ columns1, ...)` is the positional
///   initializer; we don't need to redeclare it at the native layer.
struct InitializationMacrolet: SIMDMatrixMacrolet {
  let descriptor: MatrixDescriptor

  func implementationDeclarations(in context: MatrixLayerContext) -> [DeclSyntax] {
    var result: [DeclSyntax] = []
    result.append(contentsOf: defaultInit(in: context))
    result.append(contentsOf: repeatingInit(in: context))
    result.append(contentsOf: diagonalInit(in: context))
    result.append(contentsOf: columnsTupleInit(in: context))
    result.append(contentsOf: columnVectorsInit(in: context))
    result.append(contentsOf: rowsTupleInit(in: context))
    result.append(contentsOf: rowVectorsInit(in: context))
    result.append(contentsOf: linearizedScalarsInit(in: context))
    result.append(contentsOf: scalarsArrayOfArraysInit(in: context))
    result.append(contentsOf: positionalColumnsInit(in: context))
    return result
  }

  // MARK: - init()

  private func defaultInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // simd_floatNxM already has init() that zero-fills.
      return []
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init() {
          self.init(passthroughValue: \(raw: wrapped)())
        }
        """
      ]
    }
  }

  // MARK: - init(repeating:)

  private func repeatingInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // The bridged init(_ scalar:) is diagonal, so we must build columns by hand.
      return [
        """
        @inlinable
        public init(repeating scalar: Scalar) {
          let column = ColumnVector(repeating: scalar)
          self.init(\(raw: repeatedColumns(name: "column")))
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(repeating scalar: Scalar) {
          self.init(passthroughValue: \(raw: wrapped)(repeating: scalar))
        }
        """
      ]
    }
  }

  // MARK: - init(diagonal:)

  private func diagonalInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        // simd_halfNxM doesn't expose init(diagonal:) via the overlay, so
        // we build it explicitly: zero columns with the appropriate diagonal
        // entry set on each.
        let rowCount = descriptor.rowCount
        let columnCount = descriptor.columnCount
        let diagonalLength = Swift.min(rowCount, columnCount)
        let columns = (0..<columnCount).map { c -> String in
          let entries = (0..<rowCount).map { r -> String in
            if c == r && c < diagonalLength {
              return "diagonal[\(c)]"
            }
            return "0"
          }
          return "ColumnVector(\(entries.joined(separator: ",")))"
        }
        let tuple = "(" + columns.joined(separator: ",") + ")"
        return [
          """
          @inlinable
          public init(diagonal: DiagonalVector) {
            self.init(columns: \(raw: tuple))
          }
          """
        ]
      }
      // simd_floatNxM / simd_doubleNxM already have init(diagonal:).
      return []
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(diagonal: DiagonalVector) {
          self.init(passthroughValue: \(raw: wrapped)(diagonal: diagonal))
        }
        """
      ]
    }
  }

  // MARK: - init(columns:)

  private func columnsTupleInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      // simd_floatNxM already has init(columns:); don't redeclare.
      return []
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(columns: Columns) {
          self.init(passthroughValue: \(raw: wrapped)(columns: columns))
        }
        """
      ]
    }
  }

  // MARK: - init(columnVectors:)

  private func columnVectorsInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    let columnsTupleConstruction = columnsTupleAccessExpression(arrayName: "columnVectors")
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public init(columnVectors: [ColumnVector]) {
          precondition(columnVectors.count == Self.columnCount)
          self.init(columns: \(raw: columnsTupleConstruction))
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(columnVectors: [ColumnVector]) {
          self.init(passthroughValue: \(raw: wrapped)(columnVectors: columnVectors))
        }
        """
      ]
    }
  }

  // MARK: - init(rows:)

  private func rowsTupleInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    let rowsArrayLiteral = "[" + (0..<descriptor.rowCount).map { "rows.\($0)" }.joined(separator: ",") + "]"
    return [
      """
      @inlinable
      public init(rows: Rows) {
        self.init(rowVectors: \(raw: rowsArrayLiteral))
      }
      """
    ]
  }

  // MARK: - init(rowVectors:)

  private func rowVectorsInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    // Build columns from the row-vector array: column c is
    //   ColumnVector(rowVectors[0][c], rowVectors[1][c], ..., rowVectors[rowCount-1][c])
    let columnConstructions = (0..<descriptor.columnCount).map { c -> String in
      let entries = (0..<descriptor.rowCount).map { r in "rowVectors[\(r)][\(c)]" }.joined(separator: ",")
      return "ColumnVector(\(entries))"
    }
    let columnsTupleLiteral = "(\(columnConstructions.joined(separator: ",")))"
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public init(rowVectors: [RowVector]) {
          precondition(rowVectors.count == Self.rowCount)
          self.init(columns: \(raw: columnsTupleLiteral))
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(rowVectors: [RowVector]) {
          self.init(passthroughValue: \(raw: wrapped)(rowVectors: rowVectors))
        }
        """
      ]
    }
  }

  // MARK: - init(linearizedScalars:)

  private func linearizedScalarsInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      return [
        """
        @inlinable
        public init(linearizedScalars: [Scalar]) {
          precondition(linearizedScalars.count == Self.scalarCount)
          self.init(columnVectors: Self.columnVectors(forLinearizedScalars: linearizedScalars))
        }
        """
      ]
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      return [
        """
        @inlinable
        public init(linearizedScalars: [Scalar]) {
          self.init(passthroughValue: \(raw: wrapped)(linearizedScalars: linearizedScalars))
        }
        """
      ]
    }
  }

  // MARK: - init(scalars: [[Scalar]])

  private func scalarsArrayOfArraysInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    // The input is rows-of-scalars: scalars[r][c] is row r, column c.
    let rowsArrayLiteral: String = {
      let parts = (0..<descriptor.rowCount).map { r -> String in
        let inner = (0..<descriptor.columnCount).map { c in "scalars[\(r)][\(c)]" }.joined(separator: ",")
        return "RowVector(\(inner))"
      }
      return "[" + parts.joined(separator: ",") + "]"
    }()
    return [
      """
      @inlinable
      public init(scalars: [[Scalar]]) {
        precondition(scalars.count == Self.rowCount)
        precondition(scalars.allSatisfy({ $0.count == Self.columnCount }))
        self.init(rowVectors: \(raw: rowsArrayLiteral))
      }
      """
    ]
  }

  // MARK: - init(_ c0:, _ c1:, ...) — positional column-vector initializer

  private func positionalColumnsInit(in context: MatrixLayerContext) -> [DeclSyntax] {
    switch context.layer {
    case .native:
      if descriptor.representation == .half {
        // simd_halfNxM doesn't expose the positional column-vector
        // initializer; emit our own that routes through init(columns:).
        let params = (0..<descriptor.columnCount)
          .map { "_ c\($0): ColumnVector" }
          .joined(separator: ", ")
        let tuple = "(" + (0..<descriptor.columnCount).map { "c\($0)" }.joined(separator: ",") + ")"
        return [
          """
          @inlinable
          public init(\(raw: params)) {
            self.init(columns: \(raw: tuple))
          }
          """
        ]
      }
      // simd_floatNxM / simd_doubleNxM already have positional column initializers.
      return []
    case .storage, .wrapper:
      guard let wrapped = context.wrappedTypeName else { return [] }
      let params = (0..<descriptor.columnCount)
        .map { "_ c\($0): ColumnVector" }
        .joined(separator: ", ")
      let args = (0..<descriptor.columnCount)
        .map { "c\($0)" }
        .joined(separator: ", ")
      return [
        """
        @inlinable
        public init(\(raw: params)) {
          self.init(passthroughValue: \(raw: wrapped)(\(raw: args)))
        }
        """
      ]
    }
  }

  // MARK: - Helpers

  /// `(column, column, ..., column)` with `columnCount` repetitions.
  private func repeatedColumns(name: String) -> String {
    let inner = Array(repeating: name, count: descriptor.columnCount).joined(separator: ",")
    return "columns: (\(inner))"
  }

  /// Build a `Columns` tuple from indexed access to an array, e.g.
  /// `(arr[0], arr[1])`. Used for `init(columnVectors:)`.
  private func columnsTupleAccessExpression(arrayName: String) -> String {
    let inner = (0..<descriptor.columnCount).map { "\(arrayName)[\($0)]" }.joined(separator: ",")
    return "(\(inner))"
  }
}
