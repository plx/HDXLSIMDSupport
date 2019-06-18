//
//  NativeSIMDMatrixProtocols.swift
//

import Foundation
import simd

/// Artificial base tag for the native SIMD matrix types.
public protocol NativeSIMDMatrixProtocol : NativeSIMDProtocol
  where
  NativeSIMDScalar: SIMDScalar {
  
  associatedtype NativeSIMDColumnVector: SIMD
    where NativeSIMDColumnVector.Scalar == NativeSIMDScalar
  
  associatedtype NativeSIMDRowVector: SIMD
    where NativeSIMDRowVector.Scalar == NativeSIMDScalar
  
  associatedtype NativeSIMDDiagonalVector: SIMD
    where NativeSIMDDiagonalVector.Scalar == NativeSIMDScalar

  associatedtype NativeSIMDColumns
  associatedtype NativeSIMDRows
  
  init(diagonal: NativeSIMDDiagonalVector)
  init(columns: NativeSIMDColumns)
  
  init(_ columns: [NativeSIMDColumnVector])
  init(rows: [NativeSIMDRowVector])
  
}

public protocol NativeSIMDPreTransposableMatrixProtocol: NativeSIMDMatrixProtocol {
  
  associatedtype NativeSIMDTransposeMatrix: NativeSIMDPreTransposableMatrixProtocol
    where
    NativeSIMDTransposeMatrix.NativeSIMDScalar == NativeSIMDScalar,
    NativeSIMDTransposeMatrix.NativeSIMDColumnVector == NativeSIMDRowVector,
    NativeSIMDTransposeMatrix.NativeSIMDRowVector == NativeSIMDColumnVector,
    NativeSIMDTransposeMatrix.NativeSIMDColumns == NativeSIMDRows,
    NativeSIMDTransposeMatrix.NativeSIMDRows == NativeSIMDColumns
  
  var transposeMatrix: NativeSIMDTransposeMatrix {get }
  
}

public protocol NativeSIMDTransposableMatrixProtocol : NativeSIMDPreTransposableMatrixProtocol
  where
  NativeSIMDTransposeMatrix.NativeSIMDTransposeMatrix == Self {
  
}

public protocol NativeSIMDMatrix2xNProtocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDColumns == (NativeSIMDColumnVector,NativeSIMDColumnVector),
  NativeSIMDRowVector == SIMD2<NativeSIMDScalar> {
  
  init(
    _ columnOne: NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDColumnVector)
  
}

public protocol NativeSIMDMatrix3xNProtocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDColumns == (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector),
  NativeSIMDRowVector == SIMD3<NativeSIMDScalar> {
  
  init(
    _ columnOne: NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDColumnVector,
    _ columnThree: NativeSIMDColumnVector)
  
}

public protocol NativeSIMDMatrix4xNProtocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDColumns == (NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector,NativeSIMDColumnVector),
  NativeSIMDRowVector == SIMD4<NativeSIMDScalar> {
  
  init(
    _ columnOne: NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDColumnVector,
    _ columnThree: NativeSIMDColumnVector,
    _ columnFour: NativeSIMDColumnVector)
  
}

public protocol NativeSIMDMatrixNx2Protocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDRows == (NativeSIMDRowVector,NativeSIMDRowVector),
  NativeSIMDColumnVector == SIMD2<NativeSIMDScalar> {
  
}

public protocol NativeSIMDMatrixNx3Protocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDRows == (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector),
  NativeSIMDColumnVector == SIMD3<NativeSIMDScalar> {
  
}

public protocol NativeSIMDMatrixNx4Protocol: NativeSIMDMatrixProtocol
  where
  NativeSIMDRows == (NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector,NativeSIMDRowVector),
  NativeSIMDColumnVector == SIMD4<NativeSIMDScalar> {
  
}

public protocol NativeSIMDSquareMatrixProtocol : NativeSIMDTransposableMatrixProtocol
  where
  NativeSIMDColumnVector == NativeSIMDRowVector,
  NativeSIMDDiagonalVector == NativeSIMDColumnVector,
  NativeSIMDColumns == NativeSIMDRows,
  NativeSIMDTransposeMatrix == Self {
  
}

public protocol NativeSIMDNonSquareMatrixProtocol : NativeSIMDTransposableMatrixProtocol {
  
}

public protocol NativeSIMDMatrix2x2Protocol :
  NativeSIMDSquareMatrixProtocol,
  NativeSIMDMatrix2xNProtocol,
  NativeSIMDMatrixNx2Protocol {
  
}

public protocol NativeSIMDMatrix2x3Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix2xNProtocol,
  NativeSIMDMatrixNx3Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix3x2Protocol {
  
}

public protocol NativeSIMDMatrix2x4Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix2xNProtocol,
  NativeSIMDMatrixNx4Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix4x2Protocol {
  
}

public protocol NativeSIMDMatrix3x2Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix3xNProtocol,
  NativeSIMDMatrixNx2Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix2x3Protocol {
  
}

public protocol NativeSIMDMatrix3x3Protocol :
  NativeSIMDSquareMatrixProtocol,
  NativeSIMDMatrix3xNProtocol,
  NativeSIMDMatrixNx3Protocol {
  
  associatedtype NativeSIMDQuaternion: NativeSIMDQuaternionProtocol
    where
    NativeSIMDQuaternion.NativeSIMDScalar == NativeSIMDScalar
  
  init(quaternion: NativeSIMDQuaternion)

}

public protocol NativeSIMDMatrix3x4Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix3xNProtocol,
  NativeSIMDMatrixNx4Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix4x3Protocol {
  
}

public protocol NativeSIMDMatrix4x2Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix4xNProtocol,
  NativeSIMDMatrixNx2Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix2x4Protocol {
  
}

public protocol NativeSIMDMatrix4x3Protocol :
  NativeSIMDNonSquareMatrixProtocol,
  NativeSIMDMatrix4xNProtocol,
  NativeSIMDMatrixNx3Protocol
  where
  NativeSIMDTransposeMatrix:NativeSIMDMatrix3x4Protocol {
  
}

public protocol NativeSIMDMatrix4x4Protocol :
  NativeSIMDSquareMatrixProtocol,
  NativeSIMDMatrix4xNProtocol,
  NativeSIMDMatrixNx4Protocol {
  
  associatedtype NativeSIMDQuaternion: NativeSIMDQuaternionProtocol
    where
    NativeSIMDQuaternion.NativeSIMDScalar == NativeSIMDScalar
  
  init(quaternion: NativeSIMDQuaternion)
  
}
