import HDXLSIMDSupportProtocols

package protocol DistanceMetric<Scalar> {
  associatedtype Scalar
  
  
  static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar
}

enum DistanceMetricError : Error {
  
  case emptyArguments(String)
  case sizeMismatch(String)
  case nonNumericValue(String)
}

extension MatrixProtocol {
  
  var linearizedScalars: [Scalar] {
    Self.linearizedScalarIndexRange.map {
      self[linearizedScalarIndex: $0]
    }
  }
  
}

extension DistanceMetric {
    
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

package enum L1MatrixDistanceMetric<Scalar> : DistanceMetric where Scalar: BinaryFloatingPoint {
  
  package static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar {
    guard !coordinates.isEmpty else {
      throw DistanceMetricError.emptyArguments("`coordinates` was empty!")
    }
    var absoluteDistance:Scalar  = 0.0
    for (lhsComponent, rhsComponent) in coordinates {
      guard lhsComponent.isFinite && !lhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `lhsComponent` value: \(lhsComponent)")
      }
      guard rhsComponent.isFinite && !rhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `rhsComponent` value: \(rhsComponent)")
      }
      absoluteDistance += abs(lhsComponent - rhsComponent)
    }

    return absoluteDistance
  }

}

package enum L2MatrixDistanceMetric<Scalar> : DistanceMetric where Scalar: BinaryFloatingPoint {
  
  package static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar {
    guard !coordinates.isEmpty else {
      throw DistanceMetricError.emptyArguments("`coordinates` was empty!")
    }
    var squareDistance:Scalar = 0.0
    for (lhsComponent, rhsComponent) in coordinates {
      guard lhsComponent.isFinite && !lhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `lhsComponent` value: \(lhsComponent)")
      }
      guard rhsComponent.isFinite && !rhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `rhsComponent` value: \(rhsComponent)")
      }
      squareDistance += (lhsComponent - rhsComponent) * (lhsComponent - rhsComponent)
    }

    return squareDistance.squareRoot()
  }

}

package enum LInfinityDistanceMetric<Scalar> : DistanceMetric where Scalar: BinaryFloatingPoint {
  
  package static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar {
    guard !coordinates.isEmpty else {
      throw DistanceMetricError.emptyArguments("`coordinates` was empty!")
    }
    var maximumDistance:Scalar = 0.0
    for (lhsComponent, rhsComponent) in coordinates {
      guard lhsComponent.isFinite && !lhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `lhsComponent` value: \(lhsComponent)")
      }
      guard rhsComponent.isFinite && !rhsComponent.isNaN else {
        throw DistanceMetricError.nonNumericValue("Encountered non-numeric `rhsComponent` value: \(rhsComponent)")
      }
      maximumDistance = Swift.max(
        maximumDistance,
        abs(lhsComponent - rhsComponent)
      )
    }

    return maximumDistance
  }

}
