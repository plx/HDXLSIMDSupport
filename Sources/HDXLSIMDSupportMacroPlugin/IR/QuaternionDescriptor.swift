//
//  QuaternionDescriptor.swift
//

import SwiftSyntax

/// IR for quaternion macro expansion. A quaternion is uniquely identified by
/// its scalar `representation` (.half / .float / .double); shape is fixed.
struct QuaternionDescriptor: Equatable {
  let representation: MatrixRepresentation

  /// C-bridged simd type name (`simd_quatf`, `simd_quatd`, `simd_quath`).
  var nativeTypeName: String {
    switch representation {
    case .half:   "simd_quath"
    case .float:  "simd_quatf"
    case .double: "simd_quatd"
    }
  }

  /// Storage type name (`FloatQuaternionStorage`, etc.).
  var storageTypeName: String {
    "\(representation.storageTypeNamePrefix)QuaternionStorage"
  }

  /// Compatible 3x3 matrix descriptor in the same representation.
  var compatible3x3: MatrixDescriptor {
    MatrixDescriptor(rowCount: 3, columnCount: 3, representation: representation)
  }

  /// Compatible 4x4 matrix descriptor in the same representation.
  var compatible4x4: MatrixDescriptor {
    MatrixDescriptor(rowCount: 4, columnCount: 4, representation: representation)
  }

  /// True iff this representation needs C-level `simd_*` calls rather than
  /// Swift overlay properties/operators. `simd_quath` has no operators or
  /// `.real`/`.imag`/`.angle`/`.axis`/`.length`/`.normalized`/`.inverse`/
  /// `.conjugate` accessors — only the C entry points exist.
  var requiresCSwiftCalls: Bool { representation == .half }
}
