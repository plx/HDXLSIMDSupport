//
//  Matrix2x3.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix2x3 - Definition
// -------------------------------------------------------------------------- //

/// Intended "public API" for 2x3 matrices.
///
/// - note: Only works as `Matrix2x3<Double>` and `Matrix2x3<Float>`, but can still *write* generic code against it.
///
public struct Matrix2x3<Scalar> :
  SIMDMatrix2x3Protocol
  where
  Scalar:SIMDMatrix2x3CapableProtocol,
  Scalar:SIMDMatrix3x2CapableProtocol {
  
  /// The representation used for validating logical attributes (e.g. to get `isFinite` and friends "for free").
  public typealias NumericEntryRepresentation = Scalar
  
  /// The type of a row vector.
  public typealias RowVector = SIMD2<Scalar>
  
  /// The type of a column vector.
  public typealias ColumnVector = SIMD3<Scalar>
  
  /// The type of the transpose.
  public typealias Transpose = Matrix3x2<Scalar>
  
  /// The type of the backing storage protocol.
  public typealias Storage = Scalar.SIMDMatrix2x3Storage
  
  /// The type used for array-literal construction.
  public typealias ArrayLiteralElement = Scalar
  
  /// Direct access to the underlying storage.
  ///
  /// - todo: *Consider* demoting that to a read-only public property. TBD.
  public var storage: Storage
  
  /// Directly-initializes self from `Storage`.
  ///
  /// - note: Would actually *prefer* this be internal-only, but such is not to be (lol).
  ///
  @inlinable
  public init(storage: Storage) {
    self.storage = storage
  }
  
  /// Utility used by our `description` default implementation.
  @inlinable
  public static var shortTypeName: String {
    get {
      return "Matrix2x3"
    }
  }
  
  /// Utility used by our `debugDescription` default implementation.
  @inlinable
  public static var completeTypeName: String {
    get {
      return "Matrix2x3<\(String(reflecting: Scalar.self))>"
    }
  }
  
  
}
