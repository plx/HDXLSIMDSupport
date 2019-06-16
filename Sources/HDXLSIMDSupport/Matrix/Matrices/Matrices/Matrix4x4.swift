//
//  Matrix4x4.swift
//

import Foundation
import simd
import HDXLCommonUtilities

// -------------------------------------------------------------------------- //
// MARK: Matrix4x4 - Definition
// -------------------------------------------------------------------------- //

/// Intended "public API" for 4x4 matrices.
///
/// - note: Only works as `Matrix4x4<Double>` and `Matrix4x4<Float>`, but can still *write* generic code against it.
///
public struct Matrix4x4<Scalar:SIMDMatrix4x4CapableProtocol> : SIMDMatrix4x4Protocol {

  /// The representation used for validating logical attributes (e.g. to get `isFinite` and friends "for free").
  public typealias NumericEntryRepresentation = Scalar

  /// The type of a row vector.
  public typealias RowVector = SIMD4<Scalar>
  
  /// The type of a column vector.
  public typealias ColumnVector = SIMD4<Scalar>

  /// The type of the transpose.
  public typealias Transpose = Matrix4x4<Scalar>

  /// The type of the backing storage protocol.
  public typealias Storage = Scalar.SIMDMatrix4x4Storage
  
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
      return "Matrix4x4"
    }
  }
  
  /// Utility used by our `debugDescription` default implementation.
  @inlinable
  public static var completeTypeName: String {
    get {
      return "Matrix4x4<\(String(reflecting: Scalar.self))>"
    }
  }
  

}
