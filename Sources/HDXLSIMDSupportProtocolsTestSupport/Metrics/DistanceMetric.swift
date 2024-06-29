import HDXLSIMDSupportProtocols

@usableFromInline
package enum DistanceMetricError : Error {
  
  case emptyArguments(String)
  case sizeMismatch(String)
  case nonNumericValue(String)
}

@usableFromInline
package protocol DistanceMetric<Scalar> {
  associatedtype Scalar
    
  static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar
}

extension DistanceMetric {
  
  @inlinable
  package static func _distance(
    from start: some Collection<Scalar>,
    to end: some Collection<Scalar>
  ) throws -> Scalar {
    guard !start.isEmpty || end.isEmpty else {
      throw DistanceMetricError.sizeMismatch("We consider empty coordinates an error: `start.isEmpty`: \(start.isEmpty), `end.isEmpty`: \(end.isEmpty)")
    }
    guard start.count == end.count else {
      throw DistanceMetricError.sizeMismatch("`start.count`: \(start.count) != `end.count`: \(end.count)")
    }
    
    return try calculateDistance(
      coordinates: Array(zip(start, end)) // <- fine b/c our sequences are small
    )
  }
  
  @inlinable
  package static func distance<MatrixType>(
    from start: MatrixType,
    to end: MatrixType
  ) throws -> Scalar where MatrixType: MatrixProtocol<Scalar> {
    try _distance(
      from: start.linearizedScalars,
      to: end.linearizedScalars
    )
  }
  
}

