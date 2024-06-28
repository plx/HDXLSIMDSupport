
package enum L1DistanceMetric<Scalar> : DistanceMetric where Scalar: BinaryFloatingPoint {
  
  package static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar {
    guard !coordinates.isEmpty else {
      throw DistanceMetricError.emptyArguments("`coordinates` was empty!")
    }
    var absoluteDistance:Scalar  = 0.0
    for (lhsComponent, rhsComponent) in coordinates {
      try lhsComponent.confirmIsNumeric(name: "lhsComponent")
      try rhsComponent.confirmIsNumeric(name: "rhsComponent")
      absoluteDistance += abs(lhsComponent - rhsComponent)
    }
    
    return absoluteDistance
  }
  
}
