import HDXLSIMDSupportProtocols

extension MatrixProtocol {

  @inlinable
  internal var linearizedScalars: [Scalar] {
    Self.linearizedScalarIndexRange.map {
      self[linearizedScalarIndex: $0]
    }
  }
  
}
