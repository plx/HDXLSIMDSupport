//
//  SIMDMatrixProtocol.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Definition
// -------------------------------------------------------------------------- //

/// Protocol for storage-backed SIMD matrices; exists to offer default implementations to conformers.
public protocol SIMDMatrixProtocol :
  Hashable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Codable,
  NumericAggregate,
  ExpressibleByArrayLiteral,
  MatrixMathProtocol {

  /// The underlying "storage" type that wraps some concrete SIMD matrix.
  associatedtype Storage: SIMDMatrixStorageProtocol
    where
    Storage.NumericEntryRepresentation == NumericEntryRepresentation,
    Storage.ArrayLiteralElement == ArrayLiteralElement,
    Storage.RowVector == RowVector,
    Storage.ColumnVector == ColumnVector,
    Storage.Scalar == Scalar
  
  // ------------------------------------------------------------------------ //
  // MARK: Exported Typealiases
  // ------------------------------------------------------------------------ //

  typealias ShorterAxisVector = Storage.ShorterAxisVector
  typealias LongerAxisVector = Storage.LongerAxisVector
  typealias DiagonalVector = Storage.DiagonalVector
  
  typealias Columns = Storage.Columns
  typealias Rows = Storage.Rows

  // ------------------------------------------------------------------------ //
  // MARK: Storage-Related Methods
  // ------------------------------------------------------------------------ //
  
  /// Construct from the underlying storage.
  init(storage: Storage)
  
  /// Access the underlying storage.
  var storage: Storage { get set }

  // ------------------------------------------------------------------------ //
  // MARK: Reflection-Related Methods
  // ------------------------------------------------------------------------ //

  /// The brief typename (e.g. `Matrix4x4`).
  static var shortTypeName: String { get }
  
  /// The complete typename (e.g. `Matrix4x4<Double>`).
  static var completeTypeName: String { get }
 
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - Common
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
    
  @inlinable
  subscript(scalarIndex scalarIndex: Int) -> Scalar {
    get {
      return self.storage[scalarIndex: scalarIndex]
    }
    set {
      self.storage[scalarIndex: scalarIndex] = newValue
    }
  }

  @inlinable
  subscript(columnIndex columnIndex: Int) -> ColumnVector {
    get {
      return self.storage[columnIndex: columnIndex]
    }
    set {
      self.storage[columnIndex: columnIndex] = newValue
    }
  }

  @inlinable
  subscript(
    columnIndex columnIndex: Int,
    rowIndex rowIndex: Int) -> Scalar {
    get {
      return self.storage[columnIndex: columnIndex, rowIndex: rowIndex]
    }
    set {
      self.storage[columnIndex: columnIndex, rowIndex: rowIndex] = newValue
    }
  }
  
  @inlinable
  init() {
    self.init(
      storage: Storage()
    )
  }
  
  @inlinable
  init(repeating scalar: Scalar) {
    self.init(
      storage: Storage(
        repeating: scalar
      )
    )
  }
  
  @inlinable
  init(diagonal: DiagonalVector) {
    self.init(
      storage: Storage(
        diagonal: diagonal
      )
    )
  }
  
  @inlinable
  init(columns: Columns) {
    self.init(
      storage: Storage(
        columns: columns
      )
    )
  }
  
  @inlinable
  init(rows: Rows) {
    self.init(
      storage: Storage(
        rows: rows
      )
    )
  }
  
  @inlinable
  init<S:Sequence>(scalars: S)
    where S.Element == Scalar {
      self.init(
        storage: Storage(
          scalars: scalars
        )
      )
  }

  @inlinable
  init<C:Collection>(scalars: C)
    where C.Element == Scalar {
      self.init(
        storage: Storage(
          scalars: scalars
        )
      )
  }
  
  @inlinable
  var columns: Columns {
    get {
      return self.storage.columns
    }
    set {
      self.storage.columns = newValue
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - Hashable
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol where Scalar:Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    self.storage.hash(into: &hasher)
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - CustomStringConvertible
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
  
  @inlinable
  var description: String {
    get {
      return "\(Self.shortTypeName): \(String(describing: self.storage))"
    }
  }

}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - CustomDebugStringConvertible
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
  
  @inlinable
  var debugDescription: String {
    get {
      return "\(Self.completeTypeName)(storage: \(String(reflecting: self.storage))"
    }
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - ExpressibleByArrayLiteral
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
  
  @inlinable
  init(arrayLiteral elements: ArrayLiteralElement...) {
    guard elements.count == Self.scalarCount else {
      fatalError("Invalid array-literal `elements` \(String(reflecting: elements)) for \(String(reflecting: Self.self))")
    }
    self.init(
      storage: Storage(
        scalars: elements
      )
    )
  }
  
}

// -------------------------------------------------------------------------- //
// MARK: SIMDMatrixProtocol - Default Implementations - NumericAggregate
// -------------------------------------------------------------------------- //

public extension SIMDMatrixProtocol {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    return self.storage.allNumericEntriesSatisfy(predicate)
  }
  
}
