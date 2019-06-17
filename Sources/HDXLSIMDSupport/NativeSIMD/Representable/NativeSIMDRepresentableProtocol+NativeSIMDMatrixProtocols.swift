//
//  NativeSIMDRepresentableProtocol+NativeSIMDMatrixProtocols.swift
//

import Foundation
import simd
import HDXLCommonUtilities

public extension NativeSIMDRepresentable where NativeSIMDRepresentation:NativeSIMDMatrixProtocol {
  
  @inlinable
  init(diagonal: NativeSIMDRepresentation.NativeSIMDDiagonalVector) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        diagonal: diagonal
      )
    )
  }
  
  @inlinable
  init(columns: NativeSIMDRepresentation.NativeSIMDColumns) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        columns: columns
      )
    )
  }
  
  @inlinable
  init(columns: [NativeSIMDRepresentation.NativeSIMDColumnVector]) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        columns
      )
    )
  }
  
  @inlinable
  init(rows: [NativeSIMDRepresentation.NativeSIMDRowVector]) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        rows: rows
      )
    )
  }

  
}

public extension NativeSIMDRepresentable where NativeSIMDRepresentation:NativeSIMDMatrix2xNProtocol {
  
  @inlinable
  init(
    _ columnOne: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDRepresentation.NativeSIMDColumnVector) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        columnOne,
        columnTwo
      )
    )
  }
  
}

public extension NativeSIMDRepresentable where NativeSIMDRepresentation:NativeSIMDMatrix3xNProtocol {
  
  @inlinable
  init(
    _ columnOne: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnThree: NativeSIMDRepresentation.NativeSIMDColumnVector) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        columnOne,
        columnTwo,
        columnThree
      )
    )
  }
  
}

public extension NativeSIMDRepresentable where NativeSIMDRepresentation:NativeSIMDMatrix4xNProtocol {
  
  @inlinable
  init(
    _ columnOne: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnTwo: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnThree: NativeSIMDRepresentation.NativeSIMDColumnVector,
    _ columnFour:  NativeSIMDRepresentation.NativeSIMDColumnVector) {
    self.init(
      nativeSIMDRepresentation: NativeSIMDRepresentation(
        columnOne,
        columnTwo,
        columnThree,
        columnFour
      )
    )
  }
  
}


