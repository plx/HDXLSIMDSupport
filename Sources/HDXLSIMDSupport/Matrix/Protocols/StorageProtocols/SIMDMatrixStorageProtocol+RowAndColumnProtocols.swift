//
//  SIMDMatrixStorageProtocol+RowAndColumnProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix2xNStorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 2-column matrices.
public protocol SIMDMatrix2xNStorageProtocol : SIMDMatrixStorageProtocol
  where
  Columns == (ColumnVector,ColumnVector),
  RowVector == SIMD2<Scalar> {
  
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector)
  
}

// `ColumnVector:Hashable` should always be true in practice!
public extension SIMDMatrix2xNStorageProtocol where ColumnVector:Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    self.columns.0.hash(into: &hasher)
    self.columns.1.hash(into: &hasher)
  }
  
}

// `ColumnVector:NumericAggregate` and `ColumnVector.Scalar == NumericEntryRepresentation`
// should always be true in practice!
public extension SIMDMatrix2xNStorageProtocol
  where
  ColumnVector:NumericAggregate,
  ColumnVector.NumericEntryRepresentation == NumericEntryRepresentation {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix3xNStorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 3-column matrices.
public protocol SIMDMatrix3xNStorageProtocol : SIMDMatrixStorageProtocol
  where
  Columns == (ColumnVector,ColumnVector,ColumnVector),
  RowVector == SIMD3<Scalar> {
  
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector)
  
}

// `ColumnVector:Hashable` should always be true in practice!
public extension SIMDMatrix3xNStorageProtocol where ColumnVector:Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    self.columns.0.hash(into: &hasher)
    self.columns.1.hash(into: &hasher)
    self.columns.2.hash(into: &hasher)
  }
  
}

// `ColumnVector:NumericAggregate` and `ColumnVector.Scalar == NumericEntryRepresentation`
// should always be true in practice!
public extension SIMDMatrix3xNStorageProtocol
  where
  ColumnVector:NumericAggregate,
  ColumnVector.NumericEntryRepresentation == NumericEntryRepresentation {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrix4xNStorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 4-column matrices.
public protocol SIMDMatrix4xNStorageProtocol : SIMDMatrixStorageProtocol
  where
  Columns == (ColumnVector,ColumnVector,ColumnVector,ColumnVector),
  RowVector == SIMD4<Scalar> {
  
  init(
    _ columnOne: ColumnVector,
    _ columnTwo: ColumnVector,
    _ columnThree: ColumnVector,
    _ columnFour: ColumnVector)
  
}

// `ColumnVector:Hashable` should always be true in practice!
public extension SIMDMatrix4xNStorageProtocol where ColumnVector:Hashable {
  
  @inlinable
  func hash(into hasher: inout Hasher) {
    self.columns.0.hash(into: &hasher)
    self.columns.1.hash(into: &hasher)
    self.columns.2.hash(into: &hasher)
    self.columns.3.hash(into: &hasher)
  }
  
}

// `ColumnVector:NumericAggregate` and `ColumnVector.Scalar == NumericEntryRepresentation`
// should always be true in practice!
public extension SIMDMatrix4xNStorageProtocol
  where
  ColumnVector:NumericAggregate,
  ColumnVector.NumericEntryRepresentation == NumericEntryRepresentation {
  
  @inlinable
  func allNumericEntriesSatisfy(_ predicate: (NumericEntryRepresentation) -> Bool) -> Bool {
    guard
      self.columns.0.allNumericEntriesSatisfy(predicate),
      self.columns.1.allNumericEntriesSatisfy(predicate),
      self.columns.2.allNumericEntriesSatisfy(predicate),
      self.columns.3.allNumericEntriesSatisfy(predicate) else {
        return false
    }
    return true
  }
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx2StorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 2-row matrices.
public protocol SIMDMatrixNx2StorageProtocol : SIMDMatrixStorageProtocol
  where
  Rows == (RowVector,RowVector),
  ColumnVector == SIMD2<Scalar> {
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx3StorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 3-row matrices.
public protocol SIMDMatrixNx3StorageProtocol : SIMDMatrixStorageProtocol
  where
  Rows == (RowVector,RowVector,RowVector),
  ColumnVector == SIMD3<Scalar> {
  
}

// -------------------------------------------------------------------------- //
// MARK:  SIMDMatrixNx4StorageProtocol
// -------------------------------------------------------------------------- //

/// Protocol for 4-row matrices.
public protocol SIMDMatrixNx4StorageProtocol : SIMDMatrixStorageProtocol
  where
  Rows == (RowVector,RowVector,RowVector,RowVector),
  ColumnVector == SIMD4<Scalar> {
  
}

