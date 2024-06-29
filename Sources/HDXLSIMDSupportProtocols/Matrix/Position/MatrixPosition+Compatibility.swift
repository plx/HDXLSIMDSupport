import Foundation
import simd

extension MatrixPosition {

  // ------------------------------------------------------------------------ //
  // MARK: Compatibility
  // ------------------------------------------------------------------------ //

  @inlinable
  internal func isCompatible(with shape: (Int, Int)) -> Bool {
    (0...shape.1).contains(rowIndex) && (0...shape.1).contains(columnIndex)
  }
  
  // ------------------------------------------------------------------------ //
  // MARK: (2, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 2x2 matrix.
  @inlinable
  public var isCompatibleWith2x2Matrices: Bool {
    isCompatible(with: (2, 2))
  }

  /// `true` iff the indicated position *exists* in a 2x3 matrix.
  @inlinable
  public var isCompatibleWith2x3Matrices: Bool {
    isCompatible(with: (2, 3))
  }

  /// `true` iff the indicated position *exists* in a 2x4 matrix.
  @inlinable
  public var isCompatibleWith2x4Matrices: Bool {
    isCompatible(with: (2, 4))
  }

  // ------------------------------------------------------------------------ //
  // MARK: (3, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 3x2 matrix.
  @inlinable
  public var isCompatibleWith3x2Matrices: Bool {
    isCompatible(with: (3, 2))
  }

  /// `true` iff the indicated position *exists* in a 3x3 matrix.
  @inlinable
  public var isCompatibleWith3x3Matrices: Bool {
    isCompatible(with: (3, 3))
  }

  /// `true` iff the indicated position *exists* in a 3x4 matrix.
  @inlinable
  public var isCompatibleWith3x4Matrices: Bool {
    isCompatible(with: (3, 4))
  }

  // ------------------------------------------------------------------------ //
  // MARK: (4, _) Compatibility
  // ------------------------------------------------------------------------ //

  /// `true` iff the indicated position *exists* in a 4x2 matrix.
  @inlinable
  public var isCompatibleWith4x2Matrices: Bool {
    isCompatible(with: (4, 2))
  }

  /// `true` iff the indicated position *exists* in a 4x3 matrix.
  @inlinable
  var isCompatibleWith4x3Matrices: Bool {
    isCompatible(with: (4, 3))
  }

  /// `true` iff the indicated position *exists* in a 4x4 matrix.
  @inlinable
  public var isCompatibleWith4x4Matrices: Bool {
    isCompatible(with: (4, 4))
  }
  
}
