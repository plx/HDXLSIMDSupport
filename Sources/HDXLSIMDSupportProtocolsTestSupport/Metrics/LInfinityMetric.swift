
package enum LInfinityDistanceMetric<Scalar> : DistanceMetric where Scalar: BinaryFloatingPoint {
  
  package static func calculateDistance(
    coordinates: some Collection<(Scalar, Scalar)>
  ) throws -> Scalar {
    guard !coordinates.isEmpty else {
      throw DistanceMetricError.emptyArguments("`coordinates` was empty!")
    }
    var maximumDistance: Scalar = 0.0
    for (lhsComponent, rhsComponent) in coordinates {
      try lhsComponent.confirmIsNumeric(name: "lhsComponent")
      try rhsComponent.confirmIsNumeric(name: "rhsComponent")
      maximumDistance = Swift.max(
        maximumDistance,
        abs(lhsComponent - rhsComponent)
      )
    }
    
    return maximumDistance
  }
  
}
